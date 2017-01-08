--[[
        DngConverter.lua
        
        Initial motivation for this extended external-app class dedicated to exif-tool was
        the ability to support multiple simultaneous exif-tool sessions.
        
        Initial application was for preview-exporter which uses preview and image class objects.
        
        It is recommended to have one session per task / service, since if two async tasks
        shared the same session there would be interleaving of arguments...
        
        Examples:

            * local dc=DngConverter()
            * dc:convert{ photo=photo, ###1 }        
--]]


local DngConverter, dbg, dbgf = ExternalApp:newClass{ className = 'DngConverter', register = true }



--- Constructor for extending class.
--
function DngConverter:newClass( t )
    return ExternalApp.newClass( self, t )
end



--- Constructor for new instance.
--
--  @usage pass pref-name, win-exe-name, or mac-pathed-name, if desired, else rely on defaults (but know what they are - see code).
--
function DngConverter:new( t )
    t = t or {}
    t.name = t.name or "Adobe DNG Converter"
    t.prefName = t.prefName or 'dngConverterApp' -- same pref-name for win & mac.
    t.winExeName = t.winExeName or "Adobe DNG Converter.exe" -- if included with plugin - may not be.
    t.macAppName = t.macAppName or "Adobe DNG Converter" -- if included with plugin, also: pre-requisite condition for mac-default-app-path to be used instead of mac-pathed-name, if present on system.
    t.winDefaultExePath = "C:\\Program Files (x86)\\Adobe\\Adobe DNG Converter.exe" -- only valid for 64-bit windows, but who's executing Lr4 on 32-bit OS these days?
    t.macDefaultAppPath = "/Applications/Adobe DNG Converter.app/Contents/MacOS/Adobe DNG Converter"
    t.winPathedName = nil -- pathed access to converter not supported on Windows.
    t.macPathedName = nil -- "Adobe DNG Converter" -- I think this works, but best to force user to enter a path if not installed in default location, that way it can be checked.
    local o = ExternalApp.new( self, t )
    return o
end



--- Initialization to be executed before converting a photo, or before a loop doing multiple photos.
--
--  @return status (boolean) true iff good to go.
--  @return message (string) qualification if status no go.
--
function DngConverter:initForRun()
    return self:isUsable()
end



--- Exiftool method to emulate exiftool session method of same name.
--
--  @param      photo         First parameter is lr-photo, or may be named parameter table, with members:
--                            * photo (lr-photo, required) photo to be converted
--                            * dngPath (string, default=same as source, 'cept dng ext) path for converted dng.
--                            * addlOptions (string, optional) additional converter command parameters, if desired.
--                            * metadataCache (Cache, optional) if passed, include raw metadata for 'path'.
--
--  @usage      Will overwrite existing dng, if need be, so pre-check before calling if this is not acceptable.
--
--  @return     dngPath (string) path to converted dng, if created.
--  @return     message (string) error message if applicable.
--  @return     content (string) content of app response, if any.
--
function DngConverter:convertPhoto( photo, dngPath, addlOptions, metadataCache )
    if photo == nil then
        app:error( "photo must be lr-photo or named param table" )
    end
    if type( photo ) == 'table' then
        if not photo.catalog then -- photos is named param table.
            dngPath = photo.dngPath
            addlOptions = photo.addlOptions
            photo = photo.photo
        else
            -- photo is lr-photo.
        end
    else
        app:error( "photo param must be lr-photo or param table." )
    end
    assert( photo ~= nil, "no photo" )
    assert( photo.catalog, "bad photo" )
    -- local dngParms = '-cr5.4 -dng1.3 -p0 -d "' .. self.profileDir ..  '" -o "' .. self.dngFilename .. '"'
    local photoPath = lrMeta:getRawMetadata( photo, 'path', metadataCache, true ) -- accept uncached.
    if not str:is( dngPath ) then
        dngPath = LrPathUtils.replaceExtension( photoPath, "dng" )
        if photoPath == dngPath then
            app:error( "Can't convert dng to dng at same path: ^1", dngPath )
        else
            app:logVerbose( "Converting to dng via default path: ^1", dngPath )
        end
    else
        local ext = LrStringUtils.lower( LrPathUtils.extension( dngPath ) )
        if ext == 'dng' then
            if photoPath == dngPath then
                app:error( "Can't convert dng to dng at same path: ^1", dngPath )
            else
                app:logVerbose( "Converting to dng at caller specified path: ^1", dngPath )
            end
        else
            app:error( "Extension must be 'DNG' or 'dng', not ^1", str:to( ext ) )
        end
    end    
    local dngFilename = LrPathUtils.leafName( dngPath )
    local outputDir = LrPathUtils.parent( dngPath )
    if fso:existsAsFile( dngPath ) then
        local s, m = LrTasks.pcall( fso.deleteFileConfirm, fso, dngPath )
        if s then
            dbgf( "Pre-existing dng deleted: ^1", dngPath )
        else
            return nil, m
        end
    else
        dbgf( "DNG not pre-existing (prior to conversion): ^1", dngPath )
    end
    addlOptions = addlOptions or  "-cr7.1 -dng1.3 -p0" -- Note: camera raw version is necessary to avoid UI, however dng version is not - but I don't feel comfortable creating 1.4 dngs until new options are documented ###1.
    local options = str:fmtx( '^1 -d "^2" -o "^3"', addlOptions, outputDir, dngFilename )
    dbgf( "DNG being converted according to options: ^1", options )
    local s, m, c = self:executeCommand( options, { photoPath } ) -- there may or may not be a response, depending on command, but response is expected by base class if response file handling is specified.
    if s then
        if fso:existsAsFile( dngPath ) then
            return dngPath, m, c
        else
            return nil, "DNG output file not found, expected: " .. dngPath, c
        end
    else
        return nil, m, c
    end
end



return DngConverter
