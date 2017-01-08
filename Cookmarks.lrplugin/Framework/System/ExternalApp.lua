--[[
        ExternalApp.lua
        
        Base class for external application objects, like exif-tool, image-magick, and sqlite.
        
        This class and/or its derived children hopefully handle cross-platform issues as much as possible.
--]]


local ExternalApp, dbg = Object:newClass{ className = 'ExternalApp', register = true }



--- Constructor for extending class.
--
function ExternalApp:newClass( t )
    return Object.newClass( self, t )
end



--- Constructor for new instance.
--
--  @param t initialization table, with optional named elements:<br>
--           - prefName: to get exe/app name/path from local/global prefs (takes precedence over all else, if set).<br>
--           - winExeName: name of windows exe file in plugin folder (will be used if present in plugin, and not overridden by pref).<br>
--           - macAppName: name of mac command-line executable file in plugin folder (will be used if present in plugin, and not overridden by pref).<br>
--           - winDefaultExePath - absolute path to executable, by default, on Windows (only used if nothing better so far...).<br>
--           - macDefaultAppPath - absolute path to executable, by default, on Mac (only used if nothing better so far...).<br>
--           - *** deprecated - winPathedName: name of windows exe file expected to be in environment path (only used if nothing better so far...).<br>
--           - *** deprecated - macPathedName: name of mac command-line executable expected to be registered ala Mac OS (only used if nothing better so far...).<br>
--           *** pathed names are not recommended unless it's the only way, since there is no way to verify that they are actually configured in pathed env as specified.
--
--  @usage An error is thrown if at least something hasn't been found for executable.
--  @usage Depends on initialized prefs.
--
function ExternalApp:new( t )
    local o = Object.new( self, t )
    -- exe name initialized by pref or global pref, if not blank.
    if o.prefName ~= nil then -- have a different name for pref that may be found as global? ###3
        o.exe = app:getPref( o.prefName )
        if not str:is( o.exe ) then
            o.exe = app:getGlobalPref( o.prefName )
        end
    end
    o.name = o.name or "External application"
    -- check for proper value, and do best to rectify, and/or notify:
    o:processExeChange( o.exe )
    return o
end



--- If exe file changes, this needs to be called, so plugin does not have to be reloaded to start using the new setting.
--
--  @param  value   from pref or edited property, else nil or blank.
--
--  @usage          global or local pref is not nor cleared by this method - that must be done externally to persist.
--
function ExternalApp:processExeChange( value )
    self.exe = value -- may be undone below.
    if str:is( self.exe ) then -- value from non-blank pref or property.
        if LrPathUtils.isAbsolute( self.exe ) then
            if LrFileUtils.exists( self.exe ) then
                app:log( "^1 exists.", self.exe ) -- handled below too.
            else
                app:log( "^1 does not exist.", self.exe ) -- handled below too.
                self.exe = nil                        
            end
        else
            -- fingers crossed...
        end
    else -- either pref not specified, or value from pref is nil or blank.
        if WIN_ENV then
            if self.winExeName ~= nil then -- windows executable filename, may be included with plugin.
                self.exe = LrPathUtils.child( _PLUGIN.path, self.winExeName )
                if fso:existsAsFile( self.exe ) then
                    -- use plugin exe if not overridden by pref, and included with plugin, period.
                    app:log( "Found ^1 built-in with plugin.", self.name )
                else
                    self.exe = nil
                end
            end
            if not str:is( self.exe ) then
                self.exe = self.winDefaultExePath -- may be nil or blank.
                if str:is( self.exe) and fso:existsAsFile( self.exe ) then
                    -- use default if specified by caller, and present on system.
                    app:log( "Found exe in default location: ^1", self.exe )
                else
                    self.exe = nil
                end
            end
            if not str:is( self.exe ) then
                self.exe = self.winPathedName
                if str:is( self.exe ) then
                    app:log( "Hoping pathed exe will work: ^1", self.exe )
                else
                    self.exe = nil
                end
            end
        else
            if self.macAppName ~= nil then -- mac executable filename, may be included with plugin.
                self.exe = LrPathUtils.child( _PLUGIN.path, self.macAppName )
                if fso:existsAsFile( self.exe ) then
                    app:log( "Found ^1 built-in with plugin.", self.name )
                else
                    self.exe = nil
                end
            end
            if not str:is( self.exe ) then
                self.exe = self.macDefaultAppPath
                if str:is( self.exe) and fso:existsAsFile( self.exe ) then
                    app:log( "Found exe in default location: ^1", self.exe )
                else
                    self.exe = nil
                end
            end
            if not str:is( self.exe ) then
                self.exe = self.macPathedName
                if str:is( self.exe ) then
                    app:log( "Hoping pathed app will work: ^1", self.exe )
                else
                    self.exe = nil
                end
            end
        end
    end
    if not str:is( self.exe ) then -- exe not initialized to a usable or potentially usable value.
        if str:is( self.prefName ) then
            if self.optional then
                if type( self.optional ) == 'string' then -- optional but requires user to read a message.
                    app:show{ info=self.optional,
                        actionPrefKey = str:fmt( "^1 is optional", self.name ),
                    }
                else
                    app:log( "No ^1 executable has been configured.", self.name )
                end
            else
                app:show{ warning="^1 does not exist. ^2 is not configured correctly. You must configure it in plugin manager for this plugin to work correctly.",
                    subs = { value, self.name },
                }
            end
        else
            app:error( "^1 executable is missing. This plugin will not work correctly without it.", self.name ) -- make sure prefs are initialized first, and this should be OK,
            -- I mean if an app isn't included with a plugin, then its path/spec had better be a pref or global pref, right?
        end
    end
end



--- Determine if application is configured for use.
--
--  @return status (boolean, required) true => seems usable; false => definitely not.
--  @return message (string, optional) - returns qualifying string, may also return qualification when status is true, if exe is relative and hence can't be validated.
--
function ExternalApp:isUsable()
    if str:is( self.exe ) then
        if LrPathUtils.isRelative( self.exe ) then
            return true, "can not verify " .. self.exe -- no way to check a relative
        else
            if LrFileUtils.exists( self.exe ) then
                return true
            else
                return false, self.exe .. " does not exist."
            end
        end
    else
        return false, "No executable is configured."
    end
end



--- execute external application via command-line.
--
--  @param params (string, default="") command-line parameters, if any.
--  @param targets (table(array), default={}) list of command-line targets, usually paths.
--  @param outPipe (outPipe, default=nil) optional output file (piped via '>'), if nil temp file will be used for output filename if warranted by out-handling.
--  @param outHandling (string, default=nil) optional output handling, 'del' or 'get' are popular choices - see app-execute-command for details.
--
function ExternalApp:executeCommand( params, targets, outPipe, outHandling )

    if self.exe then
        local s, m, c = app:executeCommand( self.exe, params, targets, outPipe, outHandling )
        --Debug.pause( s, m, c )
        return s, m, c
    else
        app:error( "no exe" ) -- this must be filled in, if not during new object construction, sometime during init.
    end

end



return ExternalApp