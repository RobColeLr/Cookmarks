--[[
        Catalog.lua
--]]

local Catalog, dbg, dbgf = Object:newClass{ className = 'Catalog' }



--- Constructor for extending class.
--
function Catalog:newClass( t )
    return Object.newClass( self, t )
end



--- Constructor for new instance.
--
function Catalog:new( t )
    local o = Object.new( self, t )
    return o
end



--- Get lr folder for photo
--
function Catalog:getFolder( photo, photoPath )
    if not photoPath then
        photoPath = photo:getRawMetadata( 'path' )
    end
    local parent = LrPathUtils.parent( photoPath )
    local folder = catalog:getFolderByPath( parent )
    return folder
end



--- Refresh display of recently changed photo (externally changed).
--
function Catalog:refreshDisplay( photo, photoPath )
    if not photoPath then
        photoPath = photo:getRawMetadata( 'path' )
    end
    local p = catalog:getTargetPhoto()
    if p then
        if p:getRawMetadata( 'path' ) == photoPath then -- preview just updated is selected.
            local ps = catalog:getTargetPhotos()
            if #ps > 1 then 
                for k, v in ipairs( ps ) do
                    if v ~= p then
                        catalog:setSelectedPhotos( v, ps ) -- do not call framework version: task yield not necessary, and results in a hitch.
                        catalog:setSelectedPhotos( p, ps )
                        return true
                    end
                end
            else
                local folder = cat:getFolder( photo, photoPath )
                if folder then
                    local ps = folder:getPhotos()
                    if #ps > 0 then
                        for k, v in ipairs( ps ) do
                            if v ~= p then
                                catalog:setSelectedPhotos( v, ps ) -- do not call framework version: task yield not necessary, and results in a hitch.
                                catalog:setSelectedPhotos( p, { p } )
                                return true
                            end
                        end
                    end
                end                    
            end
        else
            local ps = cat:getSelectedPhotos()
            catalog:setSelectedPhotos( photo, ps )
            return true
        end
    else
        catalog:setSelectedPhotos( photo, { photo } )
        return true -- note: not definitive unless source is being currently viewed.
    end
    return false
end



--- Catalog access wrapper that distinquishes catalog contention errors from target function errors.
--
--  @deprecated         use with-retries method instead.
--
--  @param              tryCount        Number of tries before giving up, at a half second per try (average).
--  @param              func            Catalog with-do function.
--  @param              catalog             The lr-catalog object.
--  @param              p1              First parameter which may be a function, an action name, or a param table.
--  @param              p2              Second parameter which will be a function or nil.
--      
--  @usage              Returns immediately upon target function error. 
--  @usage              The purpose of this function is so multiple concurrent tasks can access the catalog in succession without error.
--                          
--  @return             status (boolean):    true iff target function executed without error.
--  @return             other:    function return value, or error message.
--
function Catalog:withDo( tryCount, func, catalog, p1, p2, ... )
    while( true ) do
        for i = 1, tryCount do
            local sts, qual = LrTasks.pcall( func, catalog, p1, p2, ... )
            if sts then
                return true, qual
            elseif str:is( qual ) then
                local found = qual:find( "LrCatalog:with", 1, true ) or 0 -- return position or zero, instead of position or nil.
                if found == 1 then -- problem reported by with-catalog-do method.
                    local found2 = qual:find( "already inside", 15, true ) -- Lr2&3
                    if found2 == nil then
                        found2 = qual:find( "was blocked", 15, true ) -- Lr4b
                    end
                    if found2 then
                        -- problem is due to catalog access contention.
                        Debug.logn( 'catalog contention:', str:to( qual ) )
                        LrTasks.sleep( math.random( .1, 1 ) ) -- sleep for a half-second or so, then try again.
                    else
                        return false, qual
                    end
                else
                    return false, qual
                end
            else
                return false, 'Unknown error occurred accessing catalog.'
            end
        end
    	local action = app:show{ warning="Unable to access catalog.", buttons={ dia:btn( "Keep Trying", 'ok' ), dia:btn( "Give Up", 'cancel' ) } }
    	if action == 'ok' then
    		-- keep trying
    	elseif action=='cancel' then
    		-- assert( action == 'cancel', "unexpected error action: " .. str:to( action )  )
    		return false, "Gave up trying to access catalog."
    	else
    	    app:logError( "Invalid button" )
    	    return false, "Gave up trying to access catalog (invalid button)."
    	end
    end
    return false, str:format( "Unable to access catalog." )
end



--- Catalog access wrapper that distinquishes catalog contention errors from target function errors.
--
--  @deprecated         Recommend update and/or update-private method instead.
--
--  @param              tryCount        Number of tries before giving up, at a half second per try (average).
--  @param              func            Catalog with-do function.
--  @param              p1              First parameter which may be a function, an action name, or a param table.
--  @param              p2              Second parameter which will be a function or nil.
--      
--  @usage              Same as with-do method, except relies on global lr catalog.
--  @usage              Returns immediately upon target function error. 
--  @usage              The purpose of this function is so multiple concurrent tasks can access the catalog in succession without error.
--                          
--  @return             status (boolean):    true iff target function executed without error.
--  @return             other:    function return value, or error message.
--
function Catalog:withRetries( tryCount, func, p1, p2, ... )
    assert( _G.catalog ~= nil, "no catalog" )
    if type( tryCount ) == 'table' then
        func = tryCount.func
        p1 = tryCount.p1
        p2 = tryCount.p2
        tryCount = tryCount.tryCount
    end
    while( true ) do
        for i = 1, tryCount do
            local sts, qual = LrTasks.pcall( func, catalog, p1, p2, ... )
            if sts then
                return true, qual
            elseif str:is( qual ) then
                local found = qual:find( "LrCatalog:with", 1, true ) or 0 -- return position or zero, instead of position or nil.
                if found == 1 then -- problem reported by with-catalog-do method.
                    local found2 = qual:find( "already inside", 15, true )
                    if found2 == nil then
                        found2 = qual:find( "was blocked", 15, true ) -- Lr4b
                    end
                    if found2 then
                        -- problem is due to catalog access contention.
                        Debug.logn( 'catalog contention:', str:to( qual ) )
                        LrTasks.sleep( math.random( .1, 1 ) ) -- sleep for a half-second or so, then try again.
                    else
                        return false, qual
                    end
                else
                    return false, qual
                end
            else
                return false, 'Unknown error occurred accessing catalog.'
            end
        end
        if tryCount == 1 then
            return false, "Only tried once, but could not access catalog."
        end
    	local action = app:show{ warning="Unable to access catalog.", buttons={ dia:btn( "Keep Trying", 'ok' ), dia:btn( "Give Up", 'cancel' ) } }
    	if action == 'ok' then
    		-- keep trying
    	elseif action=='cancel' then
    		-- assert( action == 'cancel', "unexpected error action: " .. str:to( action )  )
    		return false, "Gave up trying to access catalog."
    	else
    	    app:logError( "Invalid button" )
    	    return false, "Gave up trying to access catalog (invalid button)."
    	end
    end
    return false, str:format( "Unable to access catalog." )
end



--[=[ private method:
function Catalog:_isAccessContention( qual )
    local found = qual:find( "LrCatalog:with", 1, true ) or 0 -- return position or zero, instead of position or nil.
    if found == 1 then -- problem reported by with-catalog-do method.
        local found2 = qual:find( "already inside", 15, true )
        if found2 == nil then
            found2 = qual:find( "was blocked", 15, true ) -- Lr4b
        end
        if found2 then
            -- problem is due to catalog access contention.
            Debug.logn( 'catalog contention:', str:to( qual ) )
            return true
        else
            return false
        end
    else
        return false
    end
end
--]=]



-- private method:
function Catalog:_update( catFunc, tmo, name, func, ... )
    local t = { ... }
    tmo = tmo or 0
    local tmoTbl = { timeout = tmo }
    --local maxTries = math.max( math.ceil( tmo * 2 ), 1 ) -- compute in case of reload in loop below.
    --local tries = maxTries -- tries remaining.
    local sts, msg
    local phase = 1
    local function _func( context )
        sts, msg = func( context, phase, unpack( t ) ) -- hint: return sts=false with no message to continue next phase.
        if sts == nil then -- protection from inadvertent infinite recursion, and for backward compatibility with previous with-do wrappers.
            sts = true
        end
    end
    local maxPhases = 10000000 -- ten million max, for sanity.
    repeat
        local s, other
        if name then
            s, other = LrTasks.pcall( catFunc, catalog, name, _func, tmoTbl ) -- yield within if need be.
        else
            s, other = LrTasks.pcall( catFunc, catalog, _func, tmoTbl ) -- ditto.
        end
        if s then -- no error thrown.
            if str:is( other ) then -- nil pre-translated to true above.
                if other == 'executed' then -- access granted, and update function executed sans error.
                    if sts then
                        return true -- all done.
                    elseif str:is( msg ) then -- update function did not throw error, but has reported an issue.
                        return false, "Unable to complete catalog update - " .. msg
                    else
                        -- continue
                        phase = phase + 1
                        -- loop
                    end
                elseif other == 'aborted' then -- Access not granted within alloted time.
                    if tmo <= 1 then -- probably could just check for zero, but probably doesn't matter either...
                        return false, "Catalog unavailable."
                    else
                       	local action = app:show{ warning="Unable to access catalog.", buttons={ dia:btn( "Keep Trying", 'ok' ), dia:btn( "Give Up", 'cancel' ) } }
                    	if action == 'ok' then
                    		-- keep trying
                    		-- tries = maxTries -- reload try count-down.
                    	elseif action=='cancel' then
                    		-- assert( action == 'cancel', "unexpected error action: " .. str:to( action )  )
                    		return false, "Gave up trying to access catalog."
                    	else
                    	    app:logError( "Invalid button" ) -- "never" happens.
                    	    return false, "Gave up trying to access catalog (invalid button)."
                    	end
                    end
                elseif other == 'queued' then -- this should definitely not happen, given current programming.
                    return false, "Unexpected value (queued) returned by Lightroom catalog access method."
                else
                    return false, "Invalid value returned by Lightroom catalog access method: " .. other
                end
            else
                return false, "No value returned by Lightroom catalog access method."
            end
        else -- by Lr4 definition, it's a function error.
            return nil, "Catalog access function error: " .. str:to( other )
        end
    until phase >= maxPhases
    return nil, "Program failure"
end



--- Wrapper for named/undoable catalog:withWriteAccessDo method - divide to conquor func.
--
--  @param tmo (number) max seconds to get in.
--  @param name (string) undo title.
--  @param func (function) divided catalog writing function( context, phase, ... ): returns sts, msg = true when done; false if to be continued; nil, error message if trouble.
--  @param ... (any) additional parameters passed to func.
--
--  @usage example:<br>
--           local function catUpdate( context, phase )<br>
--               local i1 = ( phase - 1 ) * 1000 + 1
--               local i2 = math.min( phase * 1000, #photos )<br>
--               for i = i1, i2 do<br>
--                   -- do something to photos[i]<br>
--                   -- if trouble, return nil, msg.<br>
--               end<br>
--               if i2 == #photos then<br>
--                   return true -- done, no errors.<br>
--               else<br>
--                   return false -- continue, no errors.<br>
--               end<br>
--           end<br>
--           local sts, msg = cat:update( 10, "Test", catUpdate )<br>
--           if sts then<br>
--               -- log successful message.<br>
--           else<br>
--               -- print error message...<br>
--           end<br>
--
function Catalog:update( tmo, name, func, ... )
    return self:_update( catalog.withWriteAccessDo, tmo, name, func, ... )
end



--- Wrapper for un-named catalog:withPrivateWriteAccessDo method - divide to conquor func.
--
--
--  @param tmo (number) max seconds to get in.
--  @param func (function) divided catalog writing function: returns sts, msg = true when done; false if to be continued; nil, error message if trouble.
--  @param ... (any) passed to func.
--
function Catalog:updatePrivate( tmo, func, ... )
    return self:_update( catalog.withPrivateWriteAccessDo, tmo, nil, func, ... ) -- no name.
end



--- select one photo, de-select all others - confirm selection.
--
--  @usage      For when photo is likely to be in filmstrip, otherwise use assure-photo-is-selected instead.
--
--  @return     status (boolean, required) true => specified photo is only photo selected - confirmed.
--  @return     message (string or nil) qualification of failure.
--
function Catalog:selectOnePhoto( photo )
    local try = 1
    while try <= 3 do -- retries are based on hope for luck - no real problem being fixed by this...
        catalog:setSelectedPhotos( photo, { photo } )
        if catalog:getTargetPhoto() == photo then
            return true
        else
            LrTasks.sleep( .1 )
            try = try + 1
        end
    end
    local p = photo:getRawMetadata( 'path' )
    local isBuried = cat:isBuriedInStack( photo )
    if isBuried then
        return false, str:fmt( "Unable to select photo (^1) after ^2 tries, probably because its buried in a stack.", p, try - 1 )
    else
        return false, str:fmt( "Unable to select ^1 after ^2 tries", p, try - 1 ) -- not sure why...
    end
end



--- Get photo set from seed photos.
--
--  @param      seedPhotos (table, required) An array of photos, often obtained from some catalog source.
--
--  @usage      To get top photos, and those underneath too...
--  @usage      Very inefficient if there are lots of expanded stacks, and all underneath are already included in seed photos.
--
--  @return     photoSet (table, never nil) keys are photos, values are true.
--
function Catalog:getPhotoSetFromSeedPhotos( seedPhotos )
    local photoSet = {}
    for i, photo in ipairs( seedPhotos ) do
        if not photoSet[photo] then
            if photo:getRawMetadata( 'isInStackInFolder' ) then -- and photo:getRawMetadata( 'topOfStackInFolderContainingPhoto' ) then - do not require top of stack, since photo may be in opposite orientation in collection.
                local allPhotos = photo:getRawMetadata( 'stackInFolderMembers' )
                for _, p in ipairs( allPhotos ) do
                    photoSet[p] = true
                end
            else
                photoSet[photo] = true
            end
        -- else it, and all it's other stack members in folder are already accounted for.
        end
    end
    -- return tab:createArrayFromSet( photoSet ) - this can be done externally if need be.
    return photoSet
end



--- Get selected photos.
--
--  @usage Use instead of getTargetPhotos if you don't want the entire filmstrip to be returned when nothing is selected.
--
--  @return empty table if none selected - never returns nil.
--
function Catalog:getSelectedPhotos()
    local photo = catalog:getTargetPhoto()
    if not photo then -- nothing selected
        return {} -- target nothing...
    else
        return catalog:getTargetPhotos() -- would target whole filmstrip if nothing selected.
    end
end



-- Unwrapped internal function for assuring sources (folders) are selected.
-- returns most-selected-photo, new photos array, which is guaranteed to include most-sel-photo. or false, msg.
function Catalog:_assureSources( photo, photos, metaCache )
    --local sourceSelectSettlingTime = app:getPref( 'sourceSelectSettlingTime' ) or 1 -- one second is reliable for me, but may not be for everyone.
    --assert( type( sourceSelectSettlingTime ) == 'number', "sourceSelectSettlingTime should be number" )
    local _photo -- most selected photo - may have to change, if source not selectable.
    local _photos = {}
    local origSources = catalog:getActiveSources()
    local sourceSet = {}
    local sel = {}
    local flg
    for i, __photo in ipairs( photos ) do
        repeat
            local path = lrMeta:getRawMetadata( __photo, 'path', metaCache, true ) -- accept uncached, if need be.
            local parent = LrPathUtils.parent( path )
            local lrFolder = catalog:getFolderByPath( parent )
            if lrFolder then
                if sourceSet[lrFolder] then
                    --Debug.logn( "Folder already active:", lrFolder:getName() )
                else
                    sourceSet[lrFolder] = true
                end
            else
                app:logWarning( "Parent folder not in catalog, so photo can not be selected: ^1", path )
                break
            end
            if __photo == photo then
                _photo = __photo
            end
            _photos[#_photos + 1] = __photo
        until true
    end
    if not _photo then
        _photo = photo
        _photos[#_photos + 1] = _photo
    end
    local sources = tab:createArrayFromSet( sourceSet )
    if #sources > 0 then
        if tab:isEquiv( sources, origSources ) then --, function( s1, s2 ) return s1 == s2 end ) then - default test is equality.
            dbgf( "No active source change" )
            return _photo, _photos
        else
            --dbgf( "Setting ^1 active sources, ^2 seconds settling time.", #sources, sourceSelectSettlingTime )
            dbgf( "Setting ^1 active sources.", #sources )
            
            local s, m = cat:setActiveSources( sources )
            --catalog:setActiveSources( sources )
            --LrTasks.sleep( sourceSelectSettlingTime ) -- needs at least a moment to settle. Additional settling time must be accomplished upon return.
            if s then
                return _photo, _photos
            else
                return false, m
            end
        end
    else
        Debug.pause( "no sources" ) -- this should "never" happen.
        return false, "No folder sources found corresponding to photos to be selected."
    end
    app:error( "how here?" )
end



--- Same as LrCatalog method, *except* verifies specified photos are actually selected.
--
--  @param photo (LrPhoto, required) most selected.
--  @param photos (array of LrPhotos, required) the rest, which must include most selected, unless assureSources is true.
--  @param assureFolders (boolean, default=false) pass true to add photo to photos, if need be, and assure requisite sources are selected too - must be folders.
--  @param metaCache (Cache, default=nil) pass a metadata cache to boost performance, if desired: must be populated with raw metadata for 'path' key, or it won't be worth anything.
--
--  @usage Catalog photo selection may not take until processor is given up for Lightroom to do its thing.<br>
--         If you must be certain selection has settled before continuing with processing, call<br>
--         this method instead.
--  @usage  Do not call this method, unless you know the photos are all in active sources, or if all from folders, set assure-sources.
--          Presently, there is no method for assuring multiple selected photos from diverse (possibly not active) sources.
--
--  @return status (boolean) true iff specified selection validated.
--  @return message (string) error message if status is false.
--
function Catalog:setSelectedPhotos( photo, photos, assureFolders, metaCache )
    local _photos
    local _photo
    local viewFilterTable
    if assureFolders then
        _photo, _photos = self:_assureSources( photo, photos, metaCache )
        if _photo then
            app:logVerbose( "Assured folder sources." )
        else
            return false, _photos -- _photos is errm in this case.
        end
    else
        -- Debug.pause( "not assuring sources" )
        _photos = photos
        _photo = photo
    end
    local try = 1
    local function valid() -- not robust
        local ps = catalog:getTargetPhotos()
        if #ps == #_photos then
            -- I could check each and every photo but no guarantee arrays are ordered the same,
            -- and an exhaustive check could be very time consuming.
            if catalog:getTargetPhoto() == _photo then -- at least check most-sel photo.
                return true
            else
                Debug.logn( str:to( catalog:getTargetPhoto() ), str:to( _photo ) )
                Debug.logn( "target photo mismatch" )
                return false
            end
        else
            Debug.logn( "target photos count mismatch" )
            return false
        end
    end
    repeat
        catalog:setSelectedPhotos( _photo, _photos )
        if try == 1 then
            LrTasks.yield() -- necessary for Lightroom to do its thing.
        elseif try < 20 then
            if try == 10 then
                app:log( "Clearing lib filter to improve odds of being able to select specified photos." )
                viewFilterTable = catalog:getCurrentViewFilter()
                cat:clearViewFilter( true ) -- no-yield.
            end
            LrTasks.sleep( .1 ) -- "yield".
        else
            break -- throw in the towel...
        end
        if valid() then
            return true
        end
        try = try + 1
    until false
    local s, m = false, "Unable to select specified photos, not sure why..."
    local bm = catalog:batchGetRawMetadata( _photos, { 'isInStackInFolder', 'stackPositionInFolder', 'stackInFolderIsCollapsed' } )
    for i, p in ipairs( _photos ) do
        if cat:isBuriedInStack( p, bm ) then
            s, m = false, str:fmt( "Unable to select specified photos because at least one of them is buried in a stack (e.g. ^1)", p:getRawMetadata( 'path' ) )
            break
            -- could provide better error message by factoring in active source considerations, but outcome would be the same...
        end
    end
    if viewFilterTable then
        app:log( "Restoring previous view filter, since unable to select photos anyway..." )
        catalog:setViewFilter( viewFilterTable )
    end
    return s, m
end
Catalog.selectPhotos = Catalog.setSelectedPhotos -- synonym. function Catalog:selectPhotos( photo, photos )
    


--- Save metadata for one photo.
--
--  @param              photo - single photo object to save metadata for.
--  @param              photoPath - photo path.
--  @param              targ - path to file containing xmp.
--  @param              call - if a scope in here it will be used for captioning.
--
--  @usage              Windows + Mac (its the *read* metadata that's not supported on mac).
--  @usage              If you've just done something that needs settling before save, call sleep(e.g. .1) before this method to increase odds for success on first try.
--  @usage              Library mode is not necessary to save single photo metadata.
--  @usage              *** Side-effect of single photo selection - be sure to save previous multi-photo selection to restore afterward if necessary.
--  @usage              Will cause metadata conflict flag if xmp is read-only, so make read-write before calling, if desired.
--  @usage              Uses keystroke emission to do the job.
--
--  @return             true iff metadata saved.
--  @return             error message if metadata not saved.
--
function Catalog:savePhotoMetadata( photo, photoPath, targ, call, noVal )

    local mode = app:getPref( 'saveMetadataMode' )
    if mode == 'manual' then
        return self:saveMetadata( { photo }, true, false, true, call ) -- manual mode is same for single photo as multi-photo, validation is up to user...
    end
    -- otherwise, auto is default mode - proceed...

    if photo == nil then
        app:callingError( "need photo" )
    end

    if photoPath == nil then
        photoPath = photo:getRawMetadata( 'path' )
    end
    
    local isVirt = photo:getRawMetadata( 'isVirtualCopy' )
    if isVirt then
        return false, "Can't save metadata of virtual copy"
    end
    
    if targ == nil then
        local fmt = photo:getRawMetadata( 'fileFormat' )
        if fmt == 'RAW' then -- raw not dng. Beware, if you don't want to save metadata for cooked nefs (which are considered "raw")..., then check before calling.
            targ = LrPathUtils.replaceExtension( photoPath, "xmp" )
        elseif fmt == 'VIDEO' then
            return false, "Can't save metadata of video"
        else
            targ = photoPath
        end
    end
    if fso:existsAsFile( targ ) then
        if not LrFileUtils.isWritable( targ ) then
            if targ ~= photoPath then
                local photoName = LrPathUtils.leafName( photoPath )
                return false, str:fmtx( "Unable to save metadata for '^1' because '^2' is not writable.", photoName, targ )
            else
                return false, str:fmtx( "Unable to save metadata for '^1' because it's not writable.", photoPath )
            end
        -- else nada
        end
    else
        if targ ~= photoPath then
            local targName = LrPathUtils.leafName( targ )
            app:logVerbose( "Saving metadata of '^1', to '^2' which does not yet exist.", photoPath, targName )
        else
            return false, str:fmtx( "'^1' does not exist.", photoPath )
        end
    end

    local done = false -- cancel flag
    
    -- Side effect: selection of single photo to be saved.
    -- local s, m = cat:selectOnePhoto( photo ) - commented out 13/Sep/2011 16:47
    local s = cat:assurePhotoIsSelected( photo, photoPath ) -- added 13/Sep/2011 16:47
    if s then
        app:logVerbose( "Photo selected for metadata save: ^1", photoPath )
    else
        return false, str:fmt( "Unable to select photo for metadata save (see log file for details), path: ^1", str:to( photoPath ) )
            -- no way it'll work if cant select it.
    end
    
    local time, time2, tries
    local m
    if call and call.scope then
        call.scope:setCaption( str:fmt( "Waiting for 'Save Metadata' confirmation..." ) ) -- only visible after the save metadata operation is complete.
        -- calling context needs to put something else up upon return if desired.
    end
    tries = 1
    local code = app:getPref( 'saveMetadataKeyChar' ) or 's'
    repeat
        local keys
        if WIN_ENV then
            time = LrDate.currentTime() -- windows file times are high-precision and haven't needed a fudge factor so far. ###2 watch for metadata timeout on Windows too.
            keys = str:fmt( "{Ctrl Down}^1{Ctrl Up}", code )
            s, m = app:sendWinAhkKeys( keys ) -- Save metadata - for one photo: seems reliable enough so not using the catalog function which includes a prompt.
        else -- MAC_ENV
            time = math.floor( LrDate.currentTime() ) -- file-attrs seem to be nearest second on Mac - make sure this does not appear to be in the future.
            keys = str:fmt( "Cmd-^1", code )
            s, m = app:sendMacEncKeys( keys )
        end
        if s then
            app:logVerbose( "Issued keystroke command '^1' to save metadata for ^2", keys, photoPath ) -- just log final results in normal case.
        else
            return false, str:fmt( "Unable to save metadata for ^1 because ^2", photoPath, m )
        end
        time2 = LrFileUtils.fileAttributes( targ ).fileModificationDate
        local count = 10 -- give a second or so for the metadata save to settle, in case Lr is constipated on this machine, or some other process is interfering temporarily...
        while count > 0 and (time2 == nil or time2 < time) do
            LrTasks.sleep( .1 )
            count = count - 1
            time2 = LrFileUtils.fileAttributes( targ ).fileModificationDate
        end
        if time2 ~= nil and time2 >= time then
            app:logVerbose( "^1 metadata save validated.", photoPath )
            return true
        elseif time2 == nil then
            if tries == 1 then
                app:log( "*** Unable to save metadata for ^1 because save validation timed out, unable to get time of xmp file: ^2.", photoPath, targ )
            elseif tries == 2 then
                app:logWarn( "Unable to save metadata for ^1 because save validation timed out, unable to get time of xmp file: ^2.", photoPath, targ )
            -- else return value will be logged as error if user gives up.
            end
        else -- got time2 but hasn't advanced.
            if tries == 1 then -- first time is considered "normal" (although not optimal).
                app:log( "*** Unable to save metadata for ^1 because save validation timed out, xmp file (^2) time: ^3, save metadata command time: ^4.", photoPath, targ, time2, time )
            elseif tries == 2 then -- second time it should have taken.
                app:logWarn( "Unable to save metadata for ^1 because save validation timed out, xmp file (^2) time: ^3, save metadata command time: ^4.", photoPath, targ, time2, time )
            -- else return value will be logged as error if user gives up.
            end
        end
        if tries >= 3 then -- after 3rd and subsequent tries, involve the user.
            if noVal then
                return true -- pretend like it worked, even thought it didn't in the hope that it's a "pseudo" problem (there will still be the warning logged).
            end
            repeat
                local answer = app:show{ warning="Unable to save metadata for ^1 - try again?",
                    buttons={ dia:btn( "Yes", 'ok' ), dia:btn( "Give Me a Moment", 'other' ) },
                    subs=photoPath }
                if answer == 'ok' then
                    break
                    -- go again
                elseif answer == 'other' then
                    app:sleepUnlessShutdown( 3 )
                elseif answer == 'cancel' then
                    done = true -- can't cancel the call because it may be the background process call, and there is nothing to un-cancel it.
                        -- not only that, but call param is optional, and sometimes is not passed.
                    break -- quit
                else
                    app:error( "bad answer" )
                end
            until done or shutdown
        end
        if not done then
            tries = tries + 1
        -- else exit loop below.
        end
    until done or shutdown
    if time2 == nil then
        return false, str:fmt( "Unable to save metadata for ^1 because save validation timed out, unable to get time of xmp file: ^2.", photoPath, targ )
    else
        return false, str:fmt( "Unable to save metadata for ^1 because save validation timed out, xmp file (^2) time: ^3, save metadata command time: ^4.", photoPath, targ, time2, time )
    end
    
end



--- Save metadata for selected photos.
--
--  @param              photos - photos to save metadata for, or nil to do all target photos.
--  @param              preSelect - true to have specified photos selected before saving metadata, false if you are certain they are already selected.
--  @param              restoreSelect - true to have previously photo selections restored before returning.
--  @param              service - if a scope in here it will be used for captioning.
--
--  @usage              Windows + Mac (its the *read* metadata that's not supported on mac).
--  @usage              Switch to grid mode first if desired, and select target photos first if possible.
--  @usage              Cause metadata conflict for photos that are set to read-only, so make read-write before calling, if desired.
--  @usage              Uses keystroke emission to do the job.
--  @usage              User will be prompted to first make sure the "Overwrite Settings" prompt will no longer appear.
--
--  @return             true iff metadata saved.
--  @return             error message if metadata save.
--
function Catalog:saveMetadata( photos, preSelect, restoreSelect, alreadyInGridMode, service )

    if photos == nil then
        app:callingError( "photos must not be nil" )
    end
    
    if #photos < 1 then
        app:callingError( "photo count can not be zero" )
    end

    local selPhotos = self:saveSelPhotos()

    if preSelect then
        local photoToBe
        if selPhotos.mostSelPhoto then
            for i, photo in ipairs( photos ) do
                if photo == selPhotos.mostSelPhoto then
                    photoToBe = photo
                    break
                end
            end
        end
        if not photoToBe then
            photoToBe = photos[1]
        end
        local s, m = cat:setSelectedPhotos( photoToBe, photos ) -- make sure the photos to have their metadata saved are the ones selected.
        if s then
            app:logVerbose( "Photos selected for metadata save." )
        else
            return false, str:fmt( "Unable to select photos for metadata save, error message: ^1", m )
        end
    end

    local status = false
    local message = "unknown"

    -- auto & manual modes:
    if not alreadyInGridMode then    
        app:sendKeys( 'g' ) -- attempt to put in grid mode, but dont prompt.
    end

    -- mode dependent behavior:
    local mode = app:getPref( 'saveMetadataMode' ) or 'auto'
    local code = app:getPref( 'saveMetadataKeyChar' ) or 's'
    if mode == 'auto' then -- default mode is auto.

        if service and service.scope then
            service.scope:setCaption( str:fmt( "Waiting for 'Save Metadata' button click..." ) ) -- only visible after the save metadata operation is complete.
        end
        -- Note: this prompt is optional, but the confirmation prompt is not:
        local m = {}
        m[#m + 1] = "Metadata must be saved to ensure this operation is successful."
        m[#m + 1] = "After you click 'Save Metadata', you should see an extra \"Operation\" pop up in the upper left corner of Lightroom's main window - be looking for it... (if no other operations are in progress, it will say 'Saving Metadata')"
        m[#m + 1] = "If you are in grid mode, and there are no other dialog boxes open, then click 'Save Metadata' to begin. If there are other Lightroom/plugin dialog boxes open, the click 'Let Me Close Dialogs' and do so (close them). If you are not in grid mode, or cant get the dialog boxes to stay closed, then you must click 'Cancel', and try again after remedying..."
        m[#m + 1] = "Click 'Save Metadata' when ready."
        m = table.concat( m, '\n\n' )
    
        local answer
        repeat
            answer = app:show{ info=m,
                buttons={ dia:btn( "Save Metadata", 'ok' ), dia:btn( "Let Me Close Dialogs", 'other', false ) },
                actionPrefKey="Save metadata"
            }
            if answer == 'other' then
                LrTasks.sleep( 3 )
            elseif answer == 'cancel' then
                return false, "User canceled."
            else
                break
            end
        until false
        repeat
            if answer == 'ok' then
                if service and service.scope then
                    service.scope:setCaption( str:fmt( "Waiting for 'Save Metadata' confirmation..." ) ) -- only visible after the save metadata operation is complete.
                end
                if WIN_ENV then
                    local keys = str:fmt( "{Ctrl Down}^1{Ctrl Up}", code )
                    status, message = app:sendWinAhkKeys( keys ) -- include post keystroke yield.
                else
                    local keys = str:fmt( "Cmd-^1", code )
                    status, message = app:sendMacEncKeys( keys )
                end
                if status then
                    --
                else
                    break
                end
                --local m = "Has the 'Save Metadata' operation completed?\n \nYou can tell by the upper left-hand corner of the main Lightroom window: the 'Save Metadata' operation that was started there will disappear when the operation has completed."
                local m = "Wait for the 'Save Metadata' operation to complete, then click 'Save Metadata is Complete'.\n \nYou can tell when its complete by looking in the upper left-hand corner of the main Lightroom window: it will say \"Waiting for 'Save Metadata' confirmation...\" when the operation has completed."
                local answer2 = app:show{ info=m, buttons={ dia:btn( "Save Metadata is Complete", 'ok' ), dia:btn( "Save Metadata Never Started", 'other' ) } }
                if answer2 == 'ok' then -- yes
                    status = true
                elseif answer2 == 'cancel' then -- no
                    status, message = false, "Apparently, metadata was not saved - most often caused by dialog box interference. Try to eliminate interfereing dialog boxes, then attempt again..."
                elseif answer2 == 'other' then -- dunno
                    status, message = nil, "Metadata must be saved. Hint: to tell if it gets saved, watch the progress indicator in the upper left-hand corner of the main Lightroom window."
                end
            elseif not answer or answer == 'cancel' then -- answer is coming back false for cancel - doc says cancel => nil for prompt-for-action-with-do-not-show...
                -- 'cancel' is returned by other lr-dialog methods, so test for it left in here as cheap insurance / reminder...
                status, message = nil, "User canceled."
            else
                error( "invalid answer: " .. str:to( answer ) )
            end
        until true
        
    else -- assume manual metadata save mode.
        if service and service.scope then
            service.scope:setCaption( str:fmt( "Saving metadata using manual mode" ) ) -- only visible after the save metadata operation is complete.
        end
        local m = {}
        local otherButton = 'ok'
        local otherButtonText = "Let Me Save Metadata Manually"
        local buttons = { dia:btn( otherButtonText, otherButton, false ) }
        local actionPrefKey = nil
        m[#m + 1] = "Metadata must be saved to ensure this operation is successful."
        m[#m + 1] = "Manual mode is being used, which means in a moment, you will have to press ^1 to save metadata manually."
        m[#m + 1] = "After clicking the '^2' button below, press '^1' on your keyboard to save metadata."
        m = table.concat( m, '\n\n' )
        local subs = { app:getCtrlKeySeq( code ), otherButtonText }
    
        local delayTime = app:getPref( 'delayForManualMetadataSaveBox' ) or 2
        local answer
        repeat
            answer = app:show{ info=m,
                subs = subs,
                buttons=buttons,
                actionPrefKey=actionPrefKey,
            }
            -- actionPrefKey = "Save Metadata (Manually) confirmation" - seems like both prompts are required. ###3 I could conceivably have a "no-validate" parameter,
            -- for when this method isn't critical, but presently only change-manager is using manual mode, and it is critical.
            if answer == otherButton then
                app:sleep( delayTime )
                if shutdown then return false, "shutdown" end
                m = {}
                m[#m + 1] = "Verify Lightroom initiated and completed saving metadata."
                m[#m + 1] = "You can tell Lightroom initiated saving of metadata by looking at the progress area on left side of the top panel where progress bars are displayed - another operation gets started with a progress bar."
                m[#m + 1] = "Once complete, the progress bar associated with the metadata save operation will disappear."
                m[#m + 1] = "Wait until Lightroom has completed saving metadata, then click '^3' to proceed. If the metadata save operation never started, or you are uncertain whether it completed, click '^2' then try pressing '^1' again."
                m = table.concat( m, '\n\n' )
                subs = { app:getCtrlKeySeq( code ), otherButtonText, "Metadata Has Been Saved" }
                otherButton = 'other'
                buttons = { dia:btn( "Metadata Has Been Saved", 'ok' ), dia:btn( otherButtonText, otherButton, false ) }
            elseif answer == 'ok' then
                status, message = true, nil
                break
            elseif answer == 'cancel' then
                status, message = false, "Metadata save was canceled by user."
                break
            end
        until false
        
    end
    
    if restoreSelect then
        cat:restoreSelPhotos( selPhotos )
    end
    return status, message

end



-- private function to support metadata reading on mac or other systems requiring manual mode.
function Catalog:_readMetadataManual( service, manualSubtitle )
    manualSubtitle = manualSubtitle or str:fmt( "^1 needs metadata to be read", app:getAppName() ) -- assure at least minimal prompt text for window, in case generic prompt is OK.
    local delay = app:getPref( 'timeRequiredToReadMetadataOnMac' ) or 7 -- misnomer but still applicable for windows boxes that use manual read mode.
    local otherButton = str:fmt( "Dismiss Dialog Box for ^1 Seconds", delay )
    local okButton = "Metadata Has Been Read"
    if delay < 3 then
        delay = 3
    elseif delay > 30 then
        delay = 30
    end
    
    local take = 1
    
    repeat
        local subtitle = manualSubtitle
        local main = {}
        local prompt
        local buttons
        if take == 1 then
            subtitle = manualSubtitle
            prompt = "You need to use Lightroom's Metadata Menu and select 'Read Metadata From File' now."
            main[#main + 1] = vf:spacer { height = 10 }
            main[#main + 1] =
                vf:row {
                    vf:static_text {
                        title = prompt,
                    },
                }
            main[#main + 1] = vf:spacer { height = 20 }
            main[#main + 1] =
                vf:row {
                    vf:static_text {
                        title = str:fmt( "Click '^1' when you're ready...", otherButton ),
                    },
                }
            buttons = { dia:btn( otherButton, 'ok' ) }
        else
            if take > 2 then -- on take 2, just the message & button changes suffice.
                subtitle = manualSubtitle .. " - take " .. ( take - 1 ) -- let "take" mean number of retries *after* 2nd take dialog box first displayed.
            else
                subtitle = manualSubtitle
            end
            prompt = "Mission accomplished? If not, you need to use Lightroom's Metadata Menu and select 'Read Metadata From File' now."
            main[#main + 1] = vf:spacer { height = 10 }
            main[#main + 1] =
                vf:row {
                    vf:static_text {
                        title = prompt,
                    },
                }
            main[#main + 1] = vf:spacer { height = 20 }
            main[#main + 1] =
                vf:row {
                    vf:static_text {
                        title = str:fmt( "Click '^1' when mission accomplished, or click '^2' again to retry.", okButton, otherButton ),
                    },
                }
            buttons = { dia:btn( otherButton, 'other' ), dia:btn( okButton, 'ok' ), }
        end
        local answer = app:show{ confirm = "^1",
            subs = { subtitle },
            viewItems = main,
            buttons = buttons,
        }
        if take == 1 then
            if answer == 'ok' then
                answer = 'other'
            end
        end
        if answer == 'ok' then
            return true
        elseif answer == 'other' then
            app:sleepUnlessShutdown( delay )
            if shutdown then
                service:cancel()
                return false, "shutdown"
            end
            take = take + 1
        else
            service:cancel()
            return false, "User canceled."
        end
    until false
end



--- Read metadata for one photo.
--
--  @param              photo - single photo object to read metadata for.
--  @param              photoPath - photo path.
--  @param              alreadyInLibraryModule - true iff library module has been assured before calling.
--  @param              service - if a scope in here it will be used for captioning.
--
--  @usage              Not reliable in a loop without user prompting in between (or maybe lengthy delays).
--  @usage              Switch to grid mode first if necessary.
--  @usage              *** Side-effect of single photo selection - be sure to read previous multi-photo selection to restore afterward if necessary.
--  @usage              Ignores photos that are set to read-only, so make read-write before calling, if desired.
--  @usage              Uses keystroke emission to do the job.
--  @usage              Will not work on virtual copy (returns error message), so check before calling.
--
--  @return             true iff metadata read
--  @return             error message if metadata not read.
--
function Catalog:readPhotoMetadata( photo, photoPath, alreadyInLibraryModule, service, manualSubtitle )

    if not str:is( photoPath ) then
        photoPath = photo:getRawMetadata( 'path' )
    end

    local mode = app:getPref( 'readMetadataMode' ) or (WIN_ENV and 'auto') or (MAC_ENV and 'manual')
    local keySeq = app:getPref( 'readMetadataKeySeq' ) or (WIN_ENV and 'mr') -- no default on Mac.
    
    if mode == 'manual' then
        app:show{ info="I have some good news and some bad news.\n \nThe bad news is that Lightroom's \"Read Metadata\" function is not supported (programmatically) on Macs and some non-English Windows computers.\n \nThe good news is that you can do it for ^1. Its a little tricky because you have to click a button to dismiss the dialog box for a moment, then invoke the function yourself, then click another button to confirm - detailed instructions will be provided.",
            subs = { app:getAppName() },
            actionPrefKey = "Manual requirements for reading Lr metadata",
        }
    end
   
    -- Side effect: selection of single photo to be read.
    -- local s, m = cat:selectOnePhoto( photo ) - commented out 13/Sep/2011 16:47
    local s = cat:assurePhotoIsSelected( photo, photoPath ) -- added 13/Sep/2011 16:47
    if s then
        app:logVerbose( "Photo selected for metadata read: ^1", photoPath )
    else
        --return false, str:fmt( "Unable to select photo for metadata read, error message: ^1", m ) -- m includes path.
            -- no way it'll work if cant select it.
        return false, str:fmt( "Unable to select photo for metadata read (see log file for details), path: ^1", str:to( photoPath ) )
            -- no way it'll work if cant select it.
    end
    
    local time
    if service and service.scope then
        service.scope:setCaption( str:fmt( "Waiting for 'Read Metadata' confirmation..." ) ) -- only visible after the save metadata operation is complete.
    end
    
    -- must be as sure as possible we're in library module, view mode does not matter.
    if mode == 'auto' and not alreadyInLibraryModule then
        local s, m = gui:switchModule( 1, true )
        if s then
            app:logVerbose( "Issued command to switch to library module for ^1", photoPath ) -- just log final results in normal case.
        else
            return false, str:fmt( "Unable to switch to library module for ^1 because ^2", photoPath, m )
        end
    end
    time = LrDate.currentTime() -- windows file times are high-precision and haven't needed a fudge factor so far.
    if mode == 'auto' then
    
        local s, m = app:sendWinAhkKeys( str:fmt( "{Alt Down}^1{Alt Up}", keySeq ) ) -- Read metadata - for one photo: seems reliable enough so not using the catalog function which includes a prompt.
        if s then
            app:logVerbose( "Issued command to read metadata for ^1", photoPath ) -- just log final results in normal case.
        else
            return false, str:fmt( "Unable to read metadata for ^1 because ^2", photoPath, m )
        end
    else
        local s, m = self:_readMetadataManual( service, manualSubtitle )
        if s then
            app:logVerbose( "User confirmed that metadata for '^1' has been read.", photoPath ) -- just log final results in normal case.
        else
            return false, str:fmt( "Unable to read metadata for '^1' - ^2", photoPath, m )
        end
    end
    
    -- fall-through => one photo selected in library, and command issued to read metadata.
    
    local time2 = photo:getRawMetadata( 'lastEditTime' )
    local count = 50 -- give 5 seconds or so for the metadata read to settle, in case Lr is constipated on this machine, or some other process is interfering temporarily...
    while count > 0 and (time2 ~= nil and time2 < time) do -- see if possible to not have a fudge factor here. ###2
        LrTasks.sleep( .1 )
        count = count - 1
        time2 = photo:getRawMetadata( 'lastEditTime' )
    end
    if time2 ~= nil and time2 >= time then
        return true
    elseif time2 == nil then
        return false, str:fmt( "Unable to read metadata for ^1 because read validation timed out (never got a read on last-edit-time).", photoPath )
    else
        local isVirt = photo:getRawMetadata( 'isVirtualCopy' ) -- this is deferred for efficient performance in the normal case.
        if isVirt then
            local copyName = photo:getFormattedMetadata( 'copyName' ) -- this is deferred for efficient performance in the normal case.
            return false, str:fmt( "Unable to read metadata for ^1 (^2) because its a virtual copy", photoPath, copyName )
        else
            return false, str:fmt( "Unable to read metadata for ^1 because read validation timed out (last-edit-time never updated).", photoPath )
        end
    end
end



--  Read metadata for selected photos.
--
--  @param              photos - photos to save metadata for, or nil to do all target photos.
--  @param              preSelect - true to have specified photos selected before reading metadata, false if you are certain they are already selected.
--  @param              restoreSelect - true to have previously photo selections restored before returning.
--  @param              service - if a scope in here it will be used for captioning.
--
--  @usage              Until 9/Dec/2011 was only supported on Windows platform - works now in rough fashion on Mac (relies on user action).
--  @usage              Switch to grid mode first if desired, and pre-select target photos.
--  @usage              Uses keystroke emission to do the job.
--  @usage              Includes optional user pre-prompt (before issuing read-metadata keys), and mandatory user post-prompt (to confirm metadata read).
--
--  @return             true iff metadata saved.
--  @return             error message if metadata not read.
--
function Catalog:readMetadata( photos, preSelect, restoreSelect, alreadyInGridMode, service )

    if not photos then
        error( "read-metadata requires photos" )
    end
    
    if #photos < 1 then
        error( "check photo count before calling read-metadata" )
    end
    
    local mode = app:getPref( 'readMetadataMode' ) or (WIN_ENV and 'auto') or (MAC_ENV and 'manual')
    local keySeq = app:getPref( 'readMetadataKeySeq' ) or (WIN_ENV and 'mr') -- no default on Mac - shouldn't be used.
    
    local selPhotos = self:saveSelPhotos()

    if preSelect then
        local photoToBe
        if selPhotos.mostSelPhoto then
            for i, photo in ipairs( photos ) do
                if photo == selPhotos.mostSelPhoto then
                    photoToBe = photo
                    break
                end
            end
        end
        if not photoToBe then
            photoToBe = photos[1]
        end
        local s, m = cat:setSelectedPhotos( photoToBe, photos ) -- make sure the photos to have their metadata read are the ones selected.
        if s then
            app:logVerbose( "Photos selected for metadata read." )
        else
            return false, str:fmt( "Unable to select photos for metadata read, error message: ^1", m )
        end
    end

    
    local status = false
    local message = "unknown"
    
    if not alreadyInGridMode then
        app:sendKeys( 'g' ) -- confirmation requested below.
    end
    
    if service and service.scope then
        service.scope:setCaption( str:fmt( "Waiting for 'Read Metadata' button click..." ) ) -- not seen if optional prompt is bypassed (confirmation is not optional and scope will be updated at that point).
    end

    local m = {}
    m[#m + 1] = "Metadata must be read to ensure this operation is successful."
    m[#m + 1] = "After you click 'Read Metadata', you should see an extra \"Operation\" pop up in the upper left corner of Lightroom's main window - be looking for it... (if no other operations are in progress, it will say 'Reading Metadata')"
    m[#m + 1] = "If you are in grid mode, and there are no other dialog boxes open, then click 'Read Metadata' to begin. If there are other Lightroom/plugin dialog boxes open, then click 'Let Me Close Dialogs' and then do so (close them).  If you are not in grid mode, or you cant get dialogs to stay closed, then you must click 'Cancel', and retry again after remedying..."
    m[#m + 1] = "Click 'Read Metadata' when ready."
    m = table.concat( m, '\n\n' )
    
    local answer
    repeat
        answer = app:show{ info=m, actionPrefKey="Read metadata", buttons={ dia:btn( 'Read Metadata', 'ok' ), dia:btn( "Let Me Close Dialogs", 'other', false ) } }
        if answer == 'other' then
            LrTasks.sleep( 3 )
        else
            break
        end
    until false
    repeat
        if answer == 'ok' then
            if service and service.scope then
                service.scope:setCaption( str:fmt( "Waiting for 'Read Metadata' confirmation..." ) ) -- only visible after the save metadata operation is complete.
            end
            if mode == 'auto' then
                status, message = app:sendWinAhkKeys( str:fmt( "{Alt Down}^1{Alt Up}", keySeq ) ) -- makes photo look changed again.
                if status then
                    -- enough messages already logged...
                end
            else
                status, message = self:_readMetadataManual( service ) -- ideally the read confirmation would be built in to this method, to avoid double-prompting in the Mac case. ###3
                if status then
                    app:log( "Metadata read - initiated by user." )
                end
            end
            if not status then
                break
            end
            local m = "Wait for the 'Read Metadata' operation to complete, then click 'Read Metadata is Complete'.\n \nYou can tell when its complete by looking in the upper left-hand corner of the main Lightroom window: it will say \"Waiting for 'Read Metadata' confirmation...\" when the operation is complete."
            local answer = app:show{ info=m,
                buttons={ dia:btn( "Read Metadata is Complete", 'ok' ), dia:btn( "Read Metadata Never Started", 'other' ) }
            }
            if answer == 'ok' then -- yes
                status = true
            elseif answer == 'cancel' then -- no
                status, message = false, "Apparently, metadata was not read - most often caused by dialog box interference. Try to eliminate dialog boxes, then attempt again..."
            elseif answer == 'other' then -- dunno
                status, message = nil, "Metadata must be read. Hint: to tell if it gets read, watch the progress indicator in the upper left-hand corner of the main Lightroom window."
            end
        elseif answer == 'cancel' then
            status, message = nil, "User canceled."
        else
            error( "invalid answer: " .. answer )
        end
    until true
    
    if restoreSelect then -- not restored upon program failure.
        cat:restoreSelPhotos( selPhotos )
    end
    return status, message    

end



--- Save selected photos for restoral later.
--
--  @usage     call if photo selection will be changed temporarily by plugin.
--             <br>- restore in cleanup handler.
--
--  @return    black box to pass to restoral function.
--
function Catalog:saveSelPhotos()
    -- return { mostSelPhoto = catalog:getTargetPhoto(), selPhotos = catalog:getTargetPhotos() }
    return { mostSelPhoto = catalog:getTargetPhoto(), selectedPhotos = self:getSelectedPhotos(), sources=catalog:getActiveSources(), filterTable=catalog:getCurrentViewFilter() } -- ignore filter name,
        -- since it can't be restored - restoral by name depends on uuid...
end



--- Restore previously saved photo selection.
--
--  @usage     call in cleanup handler if photo selection was changed temporarily by plugin.
--  @usage     cant deselect photos, so if nothing was selected in filmstrip before restoral, then restoral will just be a no-op.
--
function Catalog:restoreSelPhotos( selPhotos )
    if selPhotos then
        if selPhotos.sources and #selPhotos.sources > 0 then
            catalog:setActiveSources( selPhotos.sources ) -- restore original sources
            local sources = catalog:getActiveSources()
            if #sources == #selPhotos.sources then
                app:logVerbose( "Active sources restored, should be: " )
                for i, src in ipairs( selPhotos.sources ) do
                    app:logVerbose( src:getName() )
                end
            else -- some sources were dropped, probably took folders over collections, probably need the opposite.
                app:logWarning( "Unable to restore all active sources." )
                local newSources = {}
                local fldrs = {}
                local colls = {}
                local misc = {}
                for i, src in ipairs( selPhotos.sources ) do
                    app:logVerbose( src:getName() )
                    local typ = src:type()
                    if typ == 'LrFolder' then
                        fldrs[#fldrs + 1] = src
                    elseif typ == 'LrCollection' then
                        colls[#colls + 1] = src
                    else
                        misc[#misc + 1] = src
                    end
                end
                if #colls > 0 then
                    catalog:setActiveSources( colls )
                    local srcs = catalog:getActiveSources()
                    if #srcs == #colls then
                        if #fldrs > 0 then
                            app:logVerbose( "Folders were dropped." )
                        end
                        if #misc > 0 then
                            app:logVerbose( "Other sources were dropped." )
                        end
                        app:logVerbose( "Collections only are now selected." )
                    else
                        app:logWarning( "Not all previous collection sources could be restored." )
                    end
                else
                    app:logVerbose( "no collections to favor..." )
                end
            end
        end
        if selPhotos.selectedPhotos and #selPhotos.selectedPhotos > 0 then
            assert( selPhotos.mostSelPhoto, "sel photos without most-sel" )
            catalog:setSelectedPhotos( selPhotos.mostSelPhoto, selPhotos.selectedPhotos ) -- restore remaining selected photos.
            -- not sure what to do if original photos can not be restored, so...
        end
        if selPhotos.filterTable then
            catalog:setViewFilter( selPhotos.filterTable ) -- restore table values, even if same as before - table may have been recreated with same values,
                -- so its either blind restore, or element-by-element compare...
            app:logVerbose( "Previous lib filter table restored." )
        else
            app:logVerbose( "No previous lib filter table to restore." )
        end
    end
end



--- Make specified photo most selected, without changing other selections if possible.
--
--  @usage      photo source must already be active, or this won't work.
--
--  @return status
--  @return message
--
function Catalog:selectPhoto( photo )
    local selPhotos = cat:getSelectedPhotos()
    local incl = false
    for i, _photo in ipairs( selPhotos ) do
        if _photo == photo then
            incl = true
            break
        end
    end
    if not incl then
        selPhotos[ #selPhotos + 1 ] = photo
    end
    return cat:setSelectedPhotos( photo, selPhotos  )
end



--- Determine if specified photo is buried in collapsed stack in folder of origin.
--
function Catalog:isBuriedInStack( photo, bm )
    local isStacked = self:getRawMetadata( photo, 'isInStackInFolder', bm ) 
    if not isStacked then
        return false
    end
    -- photo in stack.
    local stackPos = self:getRawMetadata( photo, 'stackPositionInFolder', bm )
    if stackPos == 1 then -- top of stack
        return false
    end
    -- photo in stack, not at top
    local collapsed = self:getRawMetadata( photo, 'stackInFolderIsCollapsed', bm )
    return collapsed -- buried if collapsed.
end



--- Set active sources, and verify all were properly set.
--
--  @return status
--  @return error-message
--
function Catalog:setActiveSources( sources )
    local try = 1
    local sts, msg
    repeat
        sts, msg = true, "Unable to make all specified sources active."
        local lookup = {}
        catalog:setActiveSources( sources ) -- restore original sources
        local asources = catalog:getActiveSources()
        if #asources == #sources then
            for i, src in ipairs( asources ) do
                lookup[src] = true
            end
            app:logVerbose( "Active sources set to: " )
            for i, src in ipairs( sources ) do
                if not lookup[src] then
                    sts, msg = false, "Source not settable: " .. src:getName()
                    break
                end
                app:logVerbose( src:getName() )
            end
        else -- some sources were dropped, probably took folders over collections, probably need the opposite.
            --app:logWarning( "Unable to restore all active sources." )
            sts = false
        end
        if sts then
            return true
        else
            try = try + 1
            if try <= 3 then
                LrTasks.sleep( .1 )
            else
                break
            end
        end
    until false
    return false, msg
end



--- Clears view filter so all photos will be showing.
--
--  @param  noYield (boolean, default false) if true, will return immediately, but be forewarned: this function probably needs some "settling" time.
--    <br>  if false, this method may yield or sleep as this method deems appropriate.
--
--  @usage  Dunno how to control global lock who-de-kai.
--
function Catalog:clearViewFilter( noYield )
    catalog:setViewFilter{ -- equivalent of 'None'.
        columnBrowserActive = false, -- metadata
        filtersActive = false, -- attributes
        searchStringActive = false, -- text
    }
    if not noYield then
        LrTasks.sleep( .1 ) -- needs a moment to settle in. dunno if yield sufficient, but sleep seems safer. ###2
    end
end



--- Make specified photo the only photo selected, whether source is active or not.
--
--  @usage      present implementation satisfies by adding folder to source.<br>
--
--  @return     status, but NOT error message - logs stuff as it goes...
--
function Catalog:assurePhotoIsSelected( photo, photoPath )
    if photoPath and not photo then
        photo = catalog:findPhotoByPath( photoPath )
    elseif photo and not photoPath then
        photoPath = photo:getRawMetadata( 'path' )
    end
    if photo then
        
        catalog:setSelectedPhotos( photo, { photo } )
        if catalog:getTargetPhoto() ~= photo then -- photo not selected (not visible or not in filmstrip).
            local folderPath = LrPathUtils.parent( photoPath )
            local lrFolder = catalog:getFolderByPath( folderPath )
            local found = false
            if lrFolder then
            
                -- Note: No way to assure photo is selected, unless source becomes exclusive.
                
                local s, m = catalog:setActiveSources{ lrFolder } -- Note: calling context must restore active sources if need be.
                if s then                    
                    app:logVerbose( "Set lr-folder as active source: ^1", folderPath )
                else
                    return false -- can't assure photo selected if can't assure source is set.
                end
                catalog:setSelectedPhotos( photo, { photo } )
    			if catalog:getTargetPhoto() ~= photo then -- photo not selected (not visible or not in filmstrip).
    				app:logVerbose( "Unable to select photo (^1) in newly set source folder (^2)", photoPath, lrFolder:getName() ) -- got this error once even though it was selected.
    			    -- may be due to stackage or lib filter.
    			else
    				app:logInfo( "Photo in newly selected source now selected: " .. photoPath )
    				return true
    			end
    			
            else
                -- app:logWarning( "Unable to select photo." ) -- could just be buried in stack.
            end
        else -- selected properly already.
            app:logVerbose( "Photo already selected: ^1", photoPath )
            return true
        end
    else
        app:logWarning( "No photo for path: " .. photoPath )
        return false
    end
    -- fall-through => not able to select existing photo.
    local isStacked = photo:getRawMetadata( 'isInStackInFolder' )
    if isStacked then
        local stackPos = photo:getRawMetadata( 'stackPositionInFolder' )
        if stackPos == 1 then
            app:logVerbose( "Unable to select photo that is top of stack: " .. photoPath )
        else
            local collapsed = photo:getRawMetadata( 'stackInFolderIsCollapsed' )
            if collapsed then
                app:logWarning( "Photo can not be selected when buried in collapsed stack: " .. photoPath )
                return false -- impossible to select, despite lib filter setting.
            else
                app:logVerbose( "Unable to select stacked photo despite not being collapsed in folder of origin: " .. photoPath ) -- may still be due to lib filter.
            end
        end
    else
        app:logVerbose( "Unable to select photo that is not in a stack: " .. photoPath )
    end
    -- fall-through => unable to select photo not buried in stack, try for lib-filtering next.
    self:clearViewFilter()
    -- Note: filter should be restored externally after selected photo processed, when appropriate.
    catalog:setSelectedPhotos( photo, { photo } )
	if catalog:getTargetPhoto() ~= photo then -- photo not selected (not visible or not in filmstrip).
		app:logWarning( "Unable to select photo (^1) even without lib filter", photoPath )
		return false
	else
		app:log( "Photo selected by lifting the lib filter: ^1", photoPath )
		return true
	end
end



--- Set catalog metadata property if not already.
--
--  @param      name (string, required) property name
--  @param      value (string | date | number | boolean, required) property value
--
--  @usage      *** This is for setting catalog properties, NOT for setting photo properties (use metadata-manager for that).
--  @usage      Will wrap with async task if need be (in which case BEWARE: returns are always nil, and property is not guaranteed).<br>
--              This mode appropriate for calling from plugin init module only.
--  @usage      Will wrap with catalog access if need be.
--  @usage      Reminder: you can only set for current plugin - you can read for any plugin if you have its ID.
--  @usage      No errors are thrown - see status and error message for results.
--  @usage      *** property whose name is photo-uuid is reserved for background task.
--
--  @return     nothing. throws error if problem.
--
function Catalog:setPropertyForPlugin( name, value, validate )

    if self.catKey == nil then
        self.catKey = str:pathToPropForPluginKey( catalog:getPath() )
    end
    local prefName = self.catKey .. "_" .. name
    -- local sts, errm = LrTasks.pcall( app.setGlobalPref, app, prefName, value ) -- ###2 what error might there be?
    app:setGlobalPref( prefName, value ) -- no sense in trapping an error when all you're going to do is re-throw it anyway.
    if validate then -- cheap insurance for critical parameters.
        local _value = app:getGlobalPref( prefName )
        if _value == value then
            -- good
        else
            app:error( "Unable to set catalog property for plugin, name: '^1', value: '^2'" .. str:to( name ), str:to( value ) )
        end
    -- else nuthin'...
    end
    return true -- to satisfy some straggling plugins that are still checking return code.

end



--- Get catalog metadata property.
--
--  @param      name (string, required) property name
--
--  @usage      Gets property for plugin tied to catalog.
--  @usage      Present implementation uses Lightroom preferences and never fails.
--
--  @return     value (any) or nil.
--
function Catalog:getPropertyForPlugin( name )

    if self.catKey == nil then
        self.catKey = str:pathToPropForPluginKey( catalog:getPath() )
    end
    local prefName = self.catKey .. "_" .. name
    return app:getGlobalPref( prefName )

end



--- Get photo name or path which includes copy name when appropriate.
--
--  @param photo (LrPhoto, required) photo
--  @param fullPath (boolean, default = false) true for full-path, else filename only as base.
--  @param rawMeta (table, optional) batched raw metadata, or metadata cache.
--  @param fmtMeta (table, optional) batched fmt metadata, or nil (cache may include formatted metadata).
--
function Catalog:getPhotoName( photo, fullPath, rawMeta, fmtMeta )

    local isVirt -- boolean
    if rawMeta and rawMeta[photo] then
        isVirt = rawMeta[photo].isVirtualCopy
    end
    if isVirt == nil then
        isVirt = photo:getRawMetadata( 'isVirtualCopy' )
    end
    local photoName = ( rawMeta and rawMeta[photo] and rawMeta[photo].path ) or photo:getRawMetadata( 'path' )
    if fullPath then
        -- continue
    else
        photoName = LrPathUtils.leafName( photoName ) -- dunno if fmt-meta file-name is better, but it seems I always have the path so...
    end
    if isVirt then
        local copyName = fmtMeta and fmtMeta[photo] and fmtMeta[photo].copyName or photo:getFormattedMetadata( 'copyName' )
        photoName = str:fmt( "^1 (^2)", photoName, copyName )
    else
        -- continue
    end
    return photoName

end



--- Get photo name or path which includes copy name when appropriate.
--
--  @param photo (LrPhoto, required) photo
--  @param fullPath (boolean, default = false) true for full-path, else filename only as base.
--  @param metaCache (Cache, optional) Metadata cache.
--
function Catalog:getPhotoNameDisp( photo, fullPath, metaCache )

    local isVirt = lrMeta:getRawMetadata( photo, 'isVirtualCopy', metaCache, true ) -- accept uncached.
    local photoName = lrMeta:getRawMetadata( photo, 'path', metaCache, true ) -- ditto.
    if fullPath then
        -- continue
    else
        photoName = LrPathUtils.leafName( photoName ) -- dunno if fmt-meta file-name is better, but it seems I always have the path so...
    end
    if isVirt then
        local copyName = lrMeta:getFormattedMetadata( photo, 'copyName', metaCache, true )
        photoName = str:fmt( "^1 (^2)", photoName, copyName )
    else
        -- continue
    end
    return photoName

end



--- Creates a virtual copy of one photo.
--
--  @param      photo (LrPhoto, default nil) Photo object to create virtual copy of, or nil to create copy of most selected photo.
--  @param      prompt (boolean, default false) Pass true to prompt user about this stuff, or false to let 'er rip and take yer chances (definitive status will be returned).
--
--  @usage      Use to create virtual copies until Lr4 ;-}
--  @usage      Must be called from asynchronous task.
--  @usage      No errors are thrown - check return values for status, and error message if applicable.
--  @usage      Can be used to create multiple copies, by calling in a loop - but is very inefficient for doing multiples like that.<br>
--              if you want multiples, you should code a new method that selects all photos you want copied, then issues the Ctrl/Cmd-'<br>
--              And for robustness, the routine should check for existence of all copies before returning with thumbs up.
--  @usage      Its up to calling context to assure Lightroom is in library or develop modules before calling.
--  @usage      Hint: calling context can restore selected photos upon return, or whatever...
--
--  @return     photo-copy (lr-photo) if virtual copy successfully created.
--  @return     error-message (string) if unable to create virtual copy, nil if user canceled.
--
function Catalog:createVirtualCopy( photo, prompt )
    local photoCopy, msg
    app:call( Call:new{ name="Create Virtual Copy", async=false, main=function( call )
        repeat
            if not photo then
                photo = catalog:getTargetPhoto()
            end
            if not photo then
                error( "No photo to create virtual copy of." )
            end
            local masterPhoto
            local photoPath = photo:getRawMetadata( 'path' )
            local isVirtualCopy = photo:getRawMetadata( 'isVirtualCopy' )
            local copyName = photo:getFormattedMetadata( 'copyName' )
            if isVirtualCopy then
                masterPhoto = photo:getRawMetadata( 'masterPhoto' )
                photoPath = photoPath .. " (" .. copyName .. ")"
            else
                masterPhoto = photo
            end
            
            local copies = masterPhoto:getRawMetadata( 'virtualCopies' )
            local lookup = {}
            for i, copy in ipairs( copies ) do
                lookup[copy] = true
            end

            -- local s, m = cat:selectOnePhoto( photo ) -- no big penalty if its already selected...
            -- highly unlikely this part will fail since it was selected to begin with, but cheap insurance...
            local s = cat:assurePhotoIsSelected( photo, photoPath ) -- can never be to sure...
            if s then
                app:logVerbose( "Photo selected for virtual copy creation: ^1", photoPath )
            else
                --return false, str:fmt( "Unable to select photo for virtual copy creation, error message: ^1", m ) -- m includes path.
                    -- no way it'll work if cant select it.
                return false, str:fmt( "Unable to select photo for virtual copy creation (see log file for details), path: ^1", photoPath )
                    -- no way it'll work if cant select it.
            end
            
            if prompt then
                repeat
                    local answer = app:show{
                        info = "^1 is about to attempt creation of a virtual copy of ^2\n\nFor this to work, there must not be any dialog boxes open in Lightroom, and focus must not be in any Lightroom text field.\n\nClick 'OK' to proceed, and check the 'Don\'t show again' box to suppress prompt in the future, or click 'Give Me a Moment' to hide this dialog box temporarily so you can clear the way, or click 'Cancel' to abort.",
                        subs = { app:getAppName(), photoPath },
                        buttons = { dia:btn( "OK", 'ok' ), dia:btn( "Give Me a Moment", 'other', false ) },
                        actionPrefKey="Create virtual copy" }
                    if answer == 'ok' then
                        break
                    elseif answer == 'other' then
                        app:sleepUnlessShutdown( 5 ) -- 5 seconds seems about right.
                    elseif answer == 'cancel' then
                        call:cancel() -- note: this only cancels this wrapper not calling wrapper.
                        photoCopy, msg = nil, nil
                        return
                    else
                        error( "bad answer: " .. str:to( answer ) )
                    end
                until false
            end
            local count = masterPhoto:getRawMetadata( 'countVirtualCopies' )
            local m
            if WIN_ENV then
                s, m = app:sendWinAhkKeys( "{Ctrl Down}'{Ctrl Up}" ) -- include post keystroke yield.
            else
                s, m = app:sendMacEncKeys( "Cmd-'" )
            end
            if not s then
                photoCopy, msg = nil, m
                return
            end
            local newCount = masterPhoto:getRawMetadata( 'countVirtualCopies' )
            local iters = 20
            while newCount <= count and iters > 0 and not shutdown do
                LrTasks.sleep( .1 )
                iters = iters - 1
                newCount = masterPhoto:getRawMetadata( 'countVirtualCopies' )
            end
            local sts = newCount > count
            if sts then
                local newCopies = masterPhoto:getRawMetadata( 'virtualCopies' )
                for i, photo in ipairs( newCopies ) do
                    if not lookup[photo] then
                        photoCopy = photo
                        break
                    end
                end
                if not photoCopy then
                    msg = "Virtual copy created, but it can't be found."
                end
            else
                msg = "Unable to create virtual copy of " .. photoPath .. " for unknown reason (hint: Lightroom should have been in (or gone to) Library or Develop module when the attempt was made)."
            end
        until true
    end, finale=function( call, status, message )
        if not status then
            msg = message
        end
    end } )
    return photoCopy, msg
end



function Catalog:isMetadataColumnActive( metaIds, filter )
    filter = filter or catalog:getCurrentViewFilter()
    if filter.columnBrowserActive then -- metadata filtering enabled.
        -- set false if metadata is on list, since must accrue from sources in this case.
        for _, item in ipairs( metaIds ) do
            -- if item matches, then clear exclude-if-filtered.
            for i, t in ipairs( filter.columnBrowserDesc ) do
                local name = LrPathUtils.extension( t.criteria )
                if name == item then
                    if t.criteria:find( _PLUGIN.id ) then
                        --Debug.logn( "metadata match", item, name )
                        return true
                    else
                        --Debug.logn( "dup name", t.criteria )
                    end
                else
                    --Debug.logn( item, name )
                end
            end
        end
    end
end



--- Get list complete list of photos in selected sources, unless buried in stack (optional).
--
--  @usage Beware: this function *may* not be perfect e.g. may not work if sources are special Lr collections, and not sure about how reliable is the assume-subfolders field, nor ignore-if-buried - you have been warned.
--
--  @return      array of photos - may be empty, but never nil (should not throw any errors).
--
function Catalog:getSourcePhotos( assumeSubfoldersToo, ignoreIfBuried, metaIds )
    if assumeSubfoldersToo == nil then
        assumeSubfoldersToo = true -- ###3 departure from get-filmstrip-photos.
    end
    if ignoreIfBuried == nil then
        ignoreIfBuried = true
    end
    local excludeIfFiltered
    if metaIds ~= nil then
        excludeIfFiltered = not self:isMetadataColumnActive( metaIds )
    else
        excludeIfFiltered = true
    end
    if excludeIfFiltered then
        local photo = catalog:getTargetPhoto()
        local photos = catalog:getTargetPhotos()
        if photo == nil or #photos == 1 then
            app:logVerbose( "Returning multiple selected or all photos visible in filmstrip" )
            return catalog:getMultipleSelectedOrAllPhotos()
        else -- proceed
       
        end
    else
        -- proceed to accrue photos from source arrays.
    end
    app:logVerbose( "Accrueing photos from sources." )
    
    local sources = catalog:getActiveSources()
    if sources == nil or #sources == 0 then
        return {}, excludeIfFiltered
    end
    local photoDict = {} -- lookup
    local filmstrip = {} -- array
    local function addToDict( photos )
        local bm
        if ignoreIfBuried then
            bm = catalog:batchGetRawMetadata( photos, { 'isInStackInFolder', 'stackPositionInFolder', 'stackInFolderIsCollapsed' } )
        end
        for i, photo in ipairs( photos ) do
            if ignoreIfBuried then
                local isBuried = cat:isBuriedInStack( photo, bm )
                if isBuried then
                    --
                else
                    photoDict[photo] = true
                end
            else
                photoDict[photo] = true
            end
        end
    end
    local function getPhotosFromSource( source )
        if source.getPhotos then
            local photos = source:getPhotos( assumeSubfoldersToo ) -- not confident in this method yet, see get-filmstrip-photos. ###3
            addToDict( photos ) -- assure no duplication, in case overlapping sources.
            return
        elseif source.getChildren then
            local children = source:getChildren()
            for i, child in ipairs( children ) do
                getPhotosFromSource( child )
            end
        elseif source.type then
            app:logWarning( "Unrecognized source type: " .. source:type() )
        else
            app:logWarning( "Unrecognized source: " .. str:to( source ) )
        end
    end
    local sources = catalog:getActiveSources()
    for i, source in ipairs( sources ) do
        getPhotosFromSource( source )                            
    end    
    for k, v in pairs( photoDict ) do
        filmstrip[#filmstrip + 1] = k
    end
    return filmstrip, excludeIfFiltered
end



--- Get list of photos in filmstrip.
--
--  @usage this function *may* not be perfect, and may return photos even if excluded by lib filter or buried in stack.
--      <br>    presently its working perfectly, but I don't trust it, and neither should you!?
--      <br>    *** originally: function Catalog:getFilmstripPhotos( assumeSubfoldersToo, bottomFeedersToo )
--
--  @return      array of photos - may be empty, but never nil (should not throw any errors).
--
function Catalog:getFilmstripPhotos( assumeSubfoldersToo, ignoreIfBuried, excludeSource )
    local subfolders
    if assumeSubfoldersToo == nil then
        -- subfolders = false -- nil means true otherwise.
        subfolders = true -- nil means true otherwise. - true is not a bad default though.
    end
    if ignoreIfBuried == nil then
        ignoreIfBuried = true
    end
    local targetPhoto = catalog:getTargetPhoto()
    if targetPhoto == nil and not excludeSource then
        return catalog:getTargetPhotos()
    end
    local sources = catalog:getActiveSources()
    if sources == nil or #sources == 0 then
        return {}
    end
    local photoDict = {} -- lookup
    local filmstrip = {} -- array
    local function addToDict( photos )
        local bm
        if ignoreIfBuried then
            bm = catalog:batchGetRawMetadata( photos, { 'isInStackInFolder', 'stackPositionInFolder', 'stackInFolderIsCollapsed' } )
        end
        for i, photo in ipairs( photos ) do
            if ignoreIfBuried then
                local isBuried = cat:isBuriedInStack( photo, bm )
                if isBuried then
                    --
                else
                    photoDict[photo] = true
                end
            else
                photoDict[photo] = true
            end
        end
    end
    local function getPhotosFromSource( source )
        if source.getPhotos then
            local photos = source:getPhotos( subfolders ) -- reminder: nil parameter behaves as true, not false.
            --local photos = source:getPhotos() -- At the moment, this function is doing exactly what I want: returning the photos as they contribute to filmstrip,
            -- and excluding bottom feeders - its ignoring the "include-children" parameter. I could have sworn it was previously attending to said parameter as documented.
            -- Although I'm glad it is behaving as it is, I fear problems that go away by themselves will return by themselves. ###3 - good for now I guess...
            addToDict( photos ) -- assure no duplication, in case overlapping sources.
            return
        elseif source.getChildren then
            local children = source:getChildren()
            for i, child in ipairs( children ) do
                getPhotosFromSource( child )
            end
        elseif source.type then
            app:logWarning( "Unrecognized source type: " .. source:type() )
        else
            app:logWarning( "Unrecognized source: " .. str:to( source ) )
        end
    end
    local sources = catalog:getActiveSources()
    -- local sc = 0
    for i, source in ipairs( sources ) do
        -- sc = sc + 1
        if excludeSource and source == excludeSource then
            -- Debug.logn( "excluding " .. source:getName() )
        else
            -- Debug.logn( "not excluding " .. source:getName() )
            getPhotosFromSource( source )                            
        end
    end    
    for k, v in pairs( photoDict ) do
        filmstrip[#filmstrip + 1] = k
    end
    return filmstrip
end




--- Assures collections are created in plugin set.
--
--  @param names (array of strings, required) sub-collection names to be created in plugin collection set.
--  @param tries (number, default = 20) maximum number of catalog access attempts before giving up.
--  @param doNotRemoveDevSuffixFromPluginName (boolean, default = false) pass 'true' if you want to keep the ' (Dev)' suffix in the development version of the collection set.
--
--  @usage NOT be called from a with-write-access-gate.
--
--  @return collection or throws error trying.
--
function Catalog:assurePluginCollections( names, tries, doNotRemoveDevSuffixFromPluginName )
    local specs = {}
    if type( names ) == 'string' then
        -- specs = { name=names } -- was until 24/May/2012 1:05
        specs = { { name=names } } -- this must be better(?)
    elseif type( names[1] ) == 'string' then
        for i, v in ipairs( names ) do
            specs[#specs + 1] = { name=v }
        end
    else
        specs = names -- specs: name, searchDesc (so type is 'smart' )
    end
    local pluginName = app:getPluginName()
    if not doNotRemoveDevSuffixFromPluginName then
        if str:isEndingWith( pluginName, " (Dev)" ) then -- remove dev identification suffix if present - documented in plugin generator default pref backer file. ###4
            pluginName = pluginName:sub( 1, pluginName:len() - 6 )
        end
    end
    local colls = {}
    local set
    local function assure( context, phase )
        if phase == 1 then
            set = catalog:createCollectionSet( pluginName, nil, true ) -- nil => at root, true => return existing.
            if set then
                if #specs == 1 and not str:is( specs[1].name ) then
                    colls[1] = set -- cheating...
                    return true
                else
                    app:logVerbose( "Plugin collection set is created" )
                    return false -- not done yet: continue with next phase.
                end
            else
                app:error( "Unable to create plugin collection set - unknown error." )
            end
        elseif phase == 2 then
            for i, spec in ipairs( specs ) do
                local name = spec.name
                assert( name, "no name" )
                local searchDesc = spec.searchDesc
                local collection
                if not searchDesc then
                    collection = catalog:createCollection( name, set, true )
                else
                    assert( type( searchDesc ) == 'table', "search-desc should be table" )
                    collection = catalog:createSmartCollection( name, searchDesc, set, true )
                end
                if collection then
                    app:logVerbose( "Plugin collection is created: ^1", name )
                    colls[#colls + 1] = collection
                else
                    app:error( "Unable to create plugin collection - unknown error." )
                end
            end
            return true -- same as returning nil.
        else
            app:error( "outa phases" )
        end
    end
    app:log( "Assuring plugin collections for ^1", app:getPluginName() ) 
    local s, m = self:update( tries or 20, "Create plugin collections", assure )
    if s then
        if #colls == 1 and colls[1] == set then
            app:log( "Assured plugin collection set, but no collections created yet." )
        else
            app:log( "Created ^1", str:plural( #specs, "plugin collection", true ) )
        end
    else
        app:error( m )
    end
    return unpack( colls )
end



--- Assures collection is created in plugin set.
--
--  @param name (string, required) the collection name.
--
--  @usage Must NOT be called from a with-write-access-gate.
--
--  @return collection or throws error trying.
--
function Catalog:assurePluginCollection( name, tries )
    local coll = self:assurePluginCollections( { name }, tries )
    return coll
end



--- Assures collection set is created for plugin.
--
--  @usage Must NOT be called from a with-write-access-gate.
--
--  @return collection or throws error trying.
--
function Catalog:assurePluginCollectionSet( tries )
    local set = self:assurePluginCollections( {{}}, tries )
    return set
end



--- Similar in purpose to lr-catalog method of same name, except takes virtual copy status into consideration.
--
--  @usage And one day it will not be case sensitive.
--
function Catalog:findPhotoByPath( file, copyName, rawMeta, fmtMeta )
    local realPhoto = catalog:findPhotoByPath( file ) -- ###2 - not robust: should be retrofitted with logic from tree-sync or photooey web-photos.
    if not str:is( copyName ) then
        return realPhoto
    elseif not realPhoto then
        return false
    end
    -- get virtual copy
    local vCopies = self:getRawMetadata( realPhoto, 'virtualCopies', rawMeta )
    if (vCopies ~= nil) and #vCopies > 0 then
        for i, vCopy in ipairs( vCopies ) do
            local cName = self:getFormattedMetadata( vCopy, 'copyName', fmtMeta )
            if cName == copyName then
                return vCopy
            end
        end
    end
    return nil
end
Catalog.isFileInCatalog = Catalog.findPhotoByPath -- synonym.



--- Get raw metadata, preferrable from that read in batch mode, else from photo directly.
--
--  @param photo (lr-photo, required) the photo.
--  @param name (string, required) raw metadata item name.
--  @param rawMeta (table, optional) raw metadata table read using batch mode.
--
function Catalog:getRawMetadata( photo, name, rawMeta )
    local data
    if rawMeta ~= nil then
        data = rawMeta[photo]
        if data ~= nil then
            return data[name]
        else -- could try for metadata in lr-photo object in this case, but there would be a performance penalty.
            return nil
        end
    else
        return photo:getRawMetadata( name )
    end
end
        
        
            
--- Get formatted metadata, preferrable from that read in batch mode, else from photo directly.
--
--  @param photo (lr-photo, required) the photo.
--  @param name (string, required) raw metadata item name.
--  @param fmtMeta (table, optional) formatted metadata table read using batch mode.
--
function Catalog:getFormattedMetadata( photo, name, fmtMeta )
    local data
    if fmtMeta ~= nil then
        data = fmtMeta[photo]
        if data ~= nil then
            return data[name]
        else
            return nil
        end
    else
        return photo:getFormattedMetadata( name )
    end
end



--- Set collection photos.
--
--  @param coll (lr-collection object, required)
--  @param photos (array of lr-photos, required) may be empty, but may not be nil.
--
--  @return nil - throws error if problem.
--
function Catalog:setCollectionPhotos( coll, photos, tmo )

    if coll ~= nil and coll.type ~= nil and type( coll.type ) == 'function' and coll:type() == 'LrCollection' then
        --
    else
        app:callingError( "Not lr-collection object: ^1", str:to( coll ) )
    end
    if photos ~= nil and type( photos ) == 'table' then
        -- Its OK to pass an empty array of photos (equivalent to clearing a collection), but check before calling if it doesn't make sense.
    else
        app:callingError( "Not array of photos: ^1", str:to( photos ) )
    end
    local name = coll:getName()
    --[[ *** old-style:
    local s, m = cat:withRetries( 20, catalog.withWriteAccessDo, str:fmt( "Removing photos from ^1", name ), function( context )
        coll:removeAllPhotos()
    end )
    if s then
        if #photos > 0 then
            s, m = cat:withRetries( 20, catalog.withWriteAccessDo, str:fmt( "Adding photos to ^1", name), function( context )
                coll:addPhotos( photos )
            end )
        end
    end
    --]]
    -- new style:
    -- ###1 getting errors now (28/Jul/2012 0:39), dunno why.
    local s, m = self:update( tmo or 20, "Setting Collection Photos", function( context, phase )
        if phase == 1 then
            coll:removeAllPhotos()
            return false -- not done yet: continue with next phase.
        elseif phase == 2 then
            coll:addPhotos( photos )
            return true -- done (same as returning nil).
        else
            app:error( "Bad phase" )
        end
    end )
    if not s then
        error( m )
    end
end
       


--- Get local image id for photo.
--
--  @param photo the photo
--
--  @return imageId (string) local database id corresponding to photo, or nil if problem.
--  @return message (string) error message if problem, else nil.
--
function Catalog:getLocalImageId( photo )
    local imageId
    local s = tostring( photo ) -- THIS IS WHAT ALLOWS IT TO WORK DESPITE LOCKED DATABASE (id is output by to-string method).
    local p1, p2 = s:find( 'id "' )
    if p1 then
        s = s:sub( p2 + 1 )
        p1, p2 = s:find( '" )' )
        if p1 then
            imageId = s:sub( 1, p1-1 )
        end
    end
    if str:is( imageId ) then
        -- app:logVerbose( "Image ID: ^1", imageId )
        return imageId
    else
        return nil, "bad id"
    end
end        
            


--- Get a photo, any photo.
function Catalog:getAnyPhoto()
    return catalog:getTargetPhoto() or catalog:getTargetPhotos()[1] or catalog:getAllPhotos()[1]
end



--- Get directory containing catalog (just a tiny convenience/reminder function).
--
function Catalog:getCatDir()
    return LrPathUtils.parent( catalog:getPath() )
end
Catalog.getCatalogDir = Catalog.getCatDir -- medium version synonym.
Catalog.getCatalogDirectory = Catalog.getCatDir -- long version synonym.



--  Get xmp status (on-hold: locked photos always appear "changed" relative to xmp due to lockage metadata).
--
--  @return status (number) nil if virtual copy, 0 if last-edit-time same as, 1 if photo edited since xmp file saved, -1 if xmp changed since photo edited.
--[[
function Catalog:getXmpStatus( photo, rawMeta )
    local fileFormat
    local isVirtual
    if rawMeta then
        fileFormat = rawMeta[photo].fileFormat
        isVirtual = rawMeta[photo].isVirtual
    else
        fileFormat = photo:getRawMetadata( 'fileFormat' )
        isVirtual = photo:getRawMetadata( 'isVirtual' )
    end
    if isVirtual then return
        return nil
end
--]]



return Catalog

