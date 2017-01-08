--[[
        ExifTool.lua
        
        Initial motivation for this extended external-app class dedicated to exif-tool was
        the ability to support multiple simultaneous exif-tool sessions.
        
        Initial application was for preview-exporter which uses preview and image class objects.
        
        It is recommended to have one session per task / service, since if two async tasks
        shared the same session there would be interleaving of arguments...
        
        Examples:
        
            -- initiate persistent background service that uses exiftool.
            app:call( Service:new{ name="My Background Service", async=true, main=function( call )
                local ets = exifTool:openSession( call.name )
                for ever do efficiently
                    wait() -- for timer
                    ets:addArg( "-..." )
                    ets:addArg( "-..." )
                    ets:addTarget( path )
                    local result, errorMessage = ets:execute()
                    -- process result or error message.
                end
                exifTool:closeSession( ets )
            end } )

            -- initiate transient "foreground" service, not to interfere with persistent background service.            
            app:call( Service:new{ name="My Imaging Service", async=true, main=function( call )
                local ets = exifTool:openSession( call.name )
                for awhile do efficiently
                    ets:addArg( "-..." )
                    ets:addArg( "-..." )
                    ets:addTarget( path )
                    local result, errorMessage = ets:execute()
                    -- process result or error message.
                    yc = app:yield( yc )
                end
                exifTool:closeSession( ets )
            end } )
--]]


local ExifTool, dbg = ExternalApp:newClass{ className = 'ExifTool', register = true }



--- Constructor for extending class.
--
function ExifTool:newClass( t )
    return ExternalApp.newClass( self, t )
end



--- Constructor for new instance.
--
--  @usage pass pref-name, win-exe-name, or mac-pathed-name, if desired, else rely on defaults (but know what they are - see code).
--
function ExifTool:new( t )
    t = t or {}
    t.name = t.name or "ExifTool"
    t.prefName = t.prefName or 'exifToolApp' -- same pref-name for win & mac.
    t.winExeName = t.winExeName or "exiftool.exe" -- if included with plugin - may not be.
    t.macAppName = t.macAppName or "exiftool" -- if included with plugin, also: pre-requisite condition for mac-default-app-path to be used instead of mac-pathed-name, if present on system.
    t.winDefaultExePath = nil -- no default install dir for exiftool on Windows, I don't think (recommend including with plugin anyway).
    t.macDefaultAppPath = "/usr/bin/exiftool" -- @21/Jul/2012, this is the default location for exiftool on Mac. If present there, and not overridden via some other mechanism, use it as last resort, if present on system.
    t.winPathedName = nil -- pathed access to exiftool not supported.
    t.macPathedName = nil -- was t.macPathedName or 'exiftool' until 21/Jul/2012 (RDC) -- hope no plugin was depending on this - default install path should accomplish the same thing.
    local o = ExternalApp.new( self, t )
    o.reg = {} -- session registry
    return o
end



local Session = Object:newClass{ className = 'ExifToolSession', register = false } -- uses module dbg func.



--  Constructor for new instance.
--
function Session:_new( _name )
    local o = Object.new( self, { name=_name } )
    return o
end



--  Initialize newly created session for use.
--
function Session:_open( exe )
    local dir = LrPathUtils.getStandardFilePath( 'temp' ) -- at the moment cant imagine why standard temp dir wouldn't be perfectly appropriate.
    local iname = self.name .. "_exiftool-argbufile_"
    local oname = self.name .. "_exiftool-pipeout_"
    self.originalInputFile = LrPathUtils.child( dir, LrPathUtils.addExtension( iname, "txt" ) )
    local ifile = LrFileUtils.chooseUniqueFileName( self.originalInputFile ) -- don't overwrite an existing file.
    self.originalOutputFile = LrPathUtils.child( dir, LrPathUtils.addExtension( oname, "txt" ) )
    local ofile = LrFileUtils.chooseUniqueFileName( self.originalOutputFile ) -- don't overwrite an existing file.
    self.seq = 1
    app:logVerbose( "Exiftool session opening: ^1", self.name )
    local status, result = pcall( io.open, ifile, "wb" ) -- create for writing binary.
    if status then
        self.cmdfile = result
        app:call( Call:new{ name = "ExifTool command task", async=true, main=function( call )
            local s, m = app:executeCommand( exe, str:fmt( '-stay_open 1 -@ "^1"', ifile ), nil, ofile )
            if s then
                app:logVerbose( "Exiftool command returned from listening to '^1'", ifile )
            else
                app:logVerbose( "Exiftool session '^1' ended.", str:to( self.name ) ) -- with error: ^2", self.name, m ) - it always ends with an error - don't trip...
            end
        end, finale=function( call, status, message )
            if self.cmdfile ~= nil and fso:existsAsFile( ifile ) then
                pcall( self.cmdfile.close, self.cmdfile )
                LrFileUtils.delete( ifile )
            end
        end  } )
        app:logVerbose( "Exiftool command-task '^1' started with input argbufile '^2' and response output file: ^3", self.name, str:to( ifile ), str:to( ofile ) )
        app:call( Call:new{ name = "ExifTool response task", async=true, main=function( call )
        
            self.respfile = nil
            while not shutdown do -- checking for shutdown OK unless "reload on export" set.
                self.respfile = io.open( ofile, 'rb' )
                if self.respfile then
                    Debug.logn( "Got response file open." )
                    break
                else
                    LrTasks.sleep( .01 ) -- response file should be created rather quickly by exiftool.
                end
            end
        
            if self.respfile then
                local resp = ""
                local chunk = 0
                local index = 1
                while not shutdown and not self.closed do
    
                    --Debug.logn( "Polling for input" )
                    local s, x = self.respfile:read( 10000000 ) -- read up to 10MB, that oughta do it...
                    if s ~= nil then
                        --Debug.logn( "read", self.seq, s, x )
                        chunk = chunk + 1
                        resp = resp .. s
                        local readyStr = str:fmt( "{ready^1}", self.seq )
                        local p1, p2 = resp:find( readyStr, index ) -- not as efficient as it could be (normally response comes in one or two chunks,
                            -- so not too bad, but not the best coding... ###2
                        if p1 then
                            self.rsp = resp:sub( 1, p1 - 1 ) -- response doubles as task sync flag.
                            Debug.logn( "response finished: " .. self.rsp )
                            
                            resp = resp:sub( p2 + 1 ) -- "" -- Added 2/Jul/2012 6:46 so response returned does not keep growing: not sure how this ever worked before without it ###1.
                            -- but should be made optional or at least test others
                            
                        else
                            Debug.logn( str:fmt( "response not finished @chunk #^1: ^2", chunk, resp ) )
                            local len = resp:len()
                            local readyLen = readyStr:len()
                            if len > readyLen then
                                index = len - readyLen -- next time look again, but make sure to backtrack enough to ensure getting all of {ready1324567890,,.}, in case last read ended in the middle of it.
                            else
                                index = 1
                            end
                        end
                    else
                        --Debug.logn( "No read" )
                        --break
                    end
                    LrTasks.sleep( .01 )
    
                end
                
                if shutdown and not self.closed then
                    o:_close()
                elseif self.closed then
                    self.respfile:close()
                    LrFileUtils.delete( ofile )
                    -- LrShell.revealInShell( ofile )
                    self.respfile = nil
                end
                
            else
                Debug.logn( "No response file." )
            end
            
            
        end } )
        app:logVerbose( "Exiftool response task started '^1', response expected in file: ^2", self.name, ofile )
        app:log( "Exiftool session opened: ^1.", self.name )
    else
        app:error( "Exiftool Argbufile (^1) could not be opened for writing, error message: ^2", str:to( ifile ), str:to( result ) )
    end
end



--- Accumulate argument.
--
function Session:addArg( arg )
    if self.cmdfile then
        self.cmdfile:write( arg .. "\n" )
    end
end



--- Accumulate target.
--
function Session:addTarget( target )
    if self.cmdfile then
        self.cmdfile:write( target .. "\n" )
    end
end



--- Set target array.
--
function Session:setTargets( targets )
    for k, v in ipairs( targets ) do
        self:addTarget( v )
    end
end



--- Execute accumulated arguments.
--
--  @return response (string) exiftool response, or nil if none.
--  @return message (string) error message if no response.
--
function Session:execute( tmo )
    tmo = tmo or 30 -- hard to imagine an exifool command taking more than 30 seconds to execute.
    local tm = LrDate.currentTime()
    local msg
    self.rsp = nil
    if self.cmdfile then
        self.cmdfile:write( str:fmt( "-execute^1\n", self.seq ) )
        self.cmdfile:flush()
        local count = 1
        while self.rsp == nil do
            app:sleepUnlessShutdown( .01 * count ) -- 10 ms or more (most exif-tool ops take from 1 to a few ticks, although some take several ticks).
            if shutdown then -- OK to check shutdown as long as "reload each export" not checked.
                -- no msg = "shutdown"
                break
            end
            if LrDate.currentTime() - tm > tmo then
                msg = "exiftool execute response timeout"
                break
            else
                count = count + 1 
            end
        end
        self.seq = self.seq + 1
    --else
    end
    return self.rsp, msg
end



--  close session
--
function Session:_close()

    if self.cmdfile ~= nil then    
        self:addArg( "-stay_open" )
        self:addArg( "False" )
        self.cmdfile:close() -- just leave it there after closing, so exiftool can take its last shot.
        if self.originalInputFile and self.cmdfile ~= self.originalInputFile and LrFileUtils.exists( self.originalInputFile ) then -- and delete next time around.
            LrFileUtils.delete( self.originalInputFile )
        end
        if self.originalOutputFile and self.respfile ~= self.originalOutputFile and LrFileUtils.exists( self.originalOutputFile ) then -- and delete next time around.
            LrFileUtils.delete( self.originalOutputFile )
        end
        self.closed = true
        app:logVerbose( "ExifTool Session '^1' closed.", self.name )
    else
        app:log( "Previous exiftool session has closed." )
    end

end



--- Create a new exiftool execution session.
--
--  @param name (string, required) unique session name (e.g. service name).
--
--  @usage creates arg bufile in temp dir, and starts an exiftool task to listen to it (see -stay_open exiftool option).
--
function ExifTool:openSession( name )

    if not self.reg[name] then
        local sesn = Session:_new( name )
        sesn:_open( self.exe )
        self.reg[name] = sesn
        return sesn
    else
        error( "already open" )
    end

end



--- Closes (previously opened) exiftool session.
--
function ExifTool:closeSession( session )

    if not self.reg[session.name] then
        -- already closed
    else
        self.reg[session.name] = nil -- unregister
        session:_close() -- kill the session.
    end

end



-- ExifTool emulating a session:



--- Exiftool method to emulate exiftool session method of same name.
--
--  @param      arg         argument to add, typically of the form -tag=value, but can be anything. Will wrap with double-quotes, if not already wrapped.
--
--  @usage      so workers can use either a session or exiftool proper to do their jobs.
--  @usage      last argument added must be target file.
--
function ExifTool:addArg( arg )
    if self.args == nil then
        self.args = {}
    end
    if arg ~= nil then
        local splt = str:split( arg, "\n" )
        for i, v in ipairs( splt ) do
            if str:is( v ) then
                self.args[#self.args + 1] = ('"' .. v .. '"'):gsub( '""', '"' ) -- wrap with quotes, but not redundently.
            end
        end
    else
        Debug.logn( "nil arg - ignored." )
    end
end



--- Accumulate target.
--
function ExifTool:addTarget( target )
    if self.targs == nil then
        self.targs = {}
    end
    self.targs[#self.targs + 1] = target
end



--- Set target array.
--
function ExifTool:setTargets( targets )
    if self.targs == nil then
        self.targs = {}
    end
    for k, v in ipairs( targets ) do
        self.targs[#self.targs + 1] = v
    end
end



--- Exiftool method to emulate exiftool session method of same name.
--
--  @param      tmo         Timeout in seconds before to give up on execution response and return error code.
--
--  @usage      Emulation of session method, so workers can use either a session or exiftool proper to do their jobs.
--
--  @return     response (string or boolean) required.
--  @return     message (string) error message if applicable.
--
function ExifTool:execute( tmo )
    local resp, msg, respFile
    app:call( Call:new{ name="exiftool emul exec", main=function( call )
        if not tab:isEmpty( self.args ) then
            --local target = self.args[#self.args]:sub( 2, -2 )
            --self.args[#self.args] = nil
            -- local params = table.concat( self.args, " " )
            -- Debug.pause( params, target )
            respFile = LrFileUtils.chooseUniqueFileName( LrPathUtils.child( LrPathUtils.getStandardFilePath( 'temp' ), "etsExec" ) )
            local s, m = self:executeCommand( self.args, self.targs, respFile ) -- there may or may not be a response, depending on command, but response is expected by base class if response file handling is specified.
            -- Debug.pause( s, m, c )
            if s then
                if fso:existsAsFile( respFile ) then
                    resp, msg = fso:readFile( respFile )
                    --Debug.pause( resp, msg )
                    --return resp, msg
                else
                    --return true
                    resp = true -- calling context must know whether a real (string) response is warranted, or just a command ack.
                end
            else
                assert( m, "no m" )
                msg = m
            end
        else
            msg = "nothing to execute"    
        end
    end, finale=function( call, status, message )
        self.args = nil
        self.targs = nil
        if respFile ~= nil and fso:existsAsFile( respFile ) then
            LrFileUtils.delete( respFile )
        end
        if not status then
            resp = nil
            msg = message
        end
    end } )
    return resp, msg
end



return ExifTool
