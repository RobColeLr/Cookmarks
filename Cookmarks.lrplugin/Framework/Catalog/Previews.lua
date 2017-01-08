--[[
        Previews.lua
--]]

local Previews, dbg = Object:newClass{ className = 'Previews' } -- registered by default.



--- Constructor for extending class.
--
function Previews:newClass( t )
    return Object.newClass( self, t )
end



--- Constructor for new instance.
--
function Previews:new( t )
    local o = Object.new( self, t )
    o.cache = {}
    return o
end



-- private method to get image from instance cache if available.
function Previews:_getImageFromCache( id, level, freshness, time )
    if not self.cache[id] then
        app:logVerbose( "no images cached for id" )
        return nil
    end
    if freshness > 0 then -- assure freshness
        local cacheTime = self.cache[id].time
        if cacheTime == time then
            local image = self.cache[id][level]
            if image then
                app:logVerbose( "image is from cache" )
                return image
            else
                app:logVerbose( "images for id in cache do not include level" )
                return nil
            end
        elseif cacheTime < time then
            local dummy = self.cache[id][level]
            if dummy then
                app:logVerbose( "cached image is stale" )
                return nil
            else
                app:logVerbose( "stale images for id in cache do not include level" )
                return nil
            end
            return nil
        else
            app:error( "bad time" )
        end
    else
        local image = self.cache[id][level]
        if image then
            app:logVerbose( "image from cache, freshness unchecked" )
            return image
        else
            app:logVerbose( "images for id in cache do not include level - freshness unchecked" )
            return nil
        end
    end
end



-- private method to add image to instance cache for possible future use.
function Previews:_putImageInCache( id, level, image, time )
    if not self.cache[id] then
        self.cache[id] = { time=time }
    else
        self.cache[id].time = time
    end
    self.cache[id][level] = image
end



--[[ There's also (undocumented, ref:http://forums.adobe.com/message/3955788#3955788 (SDK forum)):
LrPhotoPictureView.makePhotoPictureView({
          width=400,
          height=400,
          photo=catalog:getTargetPhoto()
})
--]]



--- Get a preview image corresponding to specified photo, at the specified level, if possible.
--
--  @param photo (LrPhoto or table of param, required)     specified photo, or table of named parameters (recommended) - same as below including photo=lr-photo:
--  @param photoPath (string, optional)     photo-path if available, otherwise will be pulled from raw-metadata.
--  @param previewFile (string, default=unique-temp-path)     target path to store jpeg - if non-nil value passed and file is pre-existing, it will be overwritten.
--  @param prefLevel (number, required)      appx sizes + intended use:
--      <br>     1 - 80x60     small thumb
--      <br>     2 - 160x120   medium thumb
--      <br>     3 - 320x240   large thumb
--      <br>     4 - 640x480   small image
--      <br>     5 - 1280x960  medium image
--      <br>     6 - 2560x1920 large image
--      <br>     7 - 1:1       full-res
--  @param minLevel (number, default=1) minimum acceptable level.
--  @param freshness (number, default=1) 0 => whatever is handy; 1 => use dates to determine freshness (*** recommended ***); 2 => freshen regardless of dates.
--  @param icc (string, default='I') determines if icc profile management is desired, 'A' means assign, 'C' means convert, & 'I' or nil means ignore.
--  @param profile (string, default=nil) target profile, if icc is to be assigned or converted. 'sRGB', or 'AdobeRGB'.
--  @param meta (boolean, default=false) determines if metadata transfer is desired.
--  @param orient (boolean, default=false) determines if orientation should be corrected via image mogrification.
--  @param mogParam (string, optional) mogrify-compatible parameter string if desired, e.g. for resizing...
--  @param fmtMeta (table, optional) lightroom formatted metadata obtained en batch.
--
--  @usage file, errm, level = cat:getPreview{ photo=catalog:getTargetPhoto(), level=5 }
--  @usage file, errm, level = cat:getPreview( catalog:getTargetPhoto(), nil, nil, 5 )
--
--  @return image (Image, or nil) preview as image object representing requested preview.
--  @return errm (string, or nil) error message if unable to obtain requested preview (includes path(s)).
--  @return level (number, or nil) actual level read, which may be different than requested level if min-level passed in.
--
function Previews:getImage( photo, photoPath, previewFile, prefLevel, minLevel, freshness, icc, profile, meta, orient, mogParam, fmtMeta, ets, assureDir, dontOverwrite )
    if photo == nil then
        app:callingError( "no photo or named parameter table" )
    end
    if not photo.catalog then -- not lr-photo
        photoPath = photo.photoPath
        previewFile = photo.previewFile
        -- assert( photo.prefLevel, "no prefLevel in param table" )
        prefLevel = photo.prefLevel
        minLevel = photo.minLevel
        freshness = photo.freshness
        icc = photo.icc
        profile = photo.profile
        meta = photo.meta
        orient = photo.orient
        mogParam = photo.mogParam
        fmtMeta = photo.fmtMeta
        ets = photo.ets
        assureDir = photo.assureDir
        dontOverwrite = photo.dontOverwrite
        photo = photo.photo
        -- assert( photo and photo.catalog, "no lr-photo in param table" )
    end
    if prefLevel == nil then
        app:callingError( "no prefLevel" )
    end
    if minLevel == nil then
        app:callingError( "no minLevel" )
    end
    if prefLevel > 7 then
        app:logWarning( "Max prefLevel is 7" )
        prefLevel = 7
    end
    if minLevel > prefLevel then
        app:logWarning( "Min prefLevel can not exceed preferred prefLevel." )
        minLevel = prefLevel
    end
    if freshness == nil then
        freshness = 1
    elseif freshness ~= 0 and freshness ~= 1 and freshness ~= 2 then
        app:callingError( "bad freshness: ^1", freshness )
    end
    if photoPath == nil then
        photoPath = photo:getRawMetadata( 'path' )
    end
    app:logVerbose( "Getting preview image for ^1", photoPath )
    local previewTargetPath
    if previewFile == nil then -- handle virtual copy better? ###2 - perhaps I shoudn't even support getting previews for virtual copies,
        -- although its not a bad feature to have, user does not need to use it, but it may be reasonable thing to have sometimes(?)
        -- not sure if calling context is permitting it though - better try it...
        local isVirt = photo:getRawMetadata( 'isVirtualCopy' )
        assert( isVirt ~= nil, "what virt" )
        if isVirt then
            local copyName = photo:getFormattedMetadata( 'copyName' )
            local filename = LrPathUtils.leafName( photoPath )
            local base = LrPathUtils.removeExtension( filename )
            previewFilename = str:fmt( "^1(^2).lrPreview.jpg", base, copyName )
        else    
            previewFilename = LrPathUtils.leafName( photoPath )
        end
        previewTargetPath = LrPathUtils.child( LrPathUtils.getStandardFilePath( 'temp' ), previewFilename ) -- include extension, since there are separate previews for each file-type.
    else
        if fso:existsAsFile( previewFile ) then
            app:logVerbose( "preview path passed is to existing file to be overwritten" )
        end
        previewTargetPath = previewFile
    end
    if icc == nil or icc == 'A' then
        -- ok
    elseif icc == 'C' then
        if not str:is( profile ) then
            app:callingError( "need target profile" )
        end
    elseif icc == 'I' then
        icc = nil
    else
        app:callingError( "bad icc op: ^1", icc )
    end
        
    local imageId = cat:getLocalImageId( photo )
    
    local cp = catalog:getPath()
    local fn = LrPathUtils.leafName( cp )
    local n = LrPathUtils.removeExtension( fn )
    local cd = LrPathUtils.parent( cp )
    local pn = n .. " Previews.lrdata"
    local d = LrPathUtils.child( cd, pn )
    local pdb = LrPathUtils.child( d, 'previews.db' )
    assert( fso:existsAsFile( pdb ), "no preview database" )
    assert( gbl:getValue( 'sqlite' ), "Create global instance of sqlite external app in init module." )
    local param = '"' .. pdb .. '"'
    local targ = str:fmt( "select uuid, digest, orientation from ImageCacheEntry where imageId=^1", imageId )
    local sts, cmdOrMsg, dat = sqlite:executeCommand( param, { targ }, nil, 'del' )
    local uuid -- of preview
    local digest -- of preview
    local orientationCode -- of preview
    if sts then
        if str:is( dat ) then
            local c = str:split( dat, '|' )
            if #c >= 3 then
                -- good
                uuid = c[1]
                digest = c[2]
                orientationCode = c[3]
            else
                return nil, "bad split"
            end
        else
            return nil, "no content"
        end
    else
        return nil, cmdOrMsg
    end
    
    local previewSubdir = str:getFirstChar( uuid )
    local pDir = LrPathUtils.child( d, previewSubdir )
    if fso:existsAsDir( pDir ) then
        -- good
    else
        return nil, "preview letter dir does not exist: " .. pDir
    end
    previewSubdir = uuid:sub( 1, 4 )
    pDir = LrPathUtils.child( pDir, previewSubdir )
    if fso:existsAsDir( pDir ) then
        -- good
    else
        return nil, "preview 4-some dir does not exist: " .. pDir
    end
    local previewFilename = uuid .. '-' .. digest .. ".lrprev"
    
    local previewSourcePath = LrPathUtils.child( pDir, previewFilename )
    if fso:existsAsFile( previewSourcePath ) then
        app:logVerbose( "Found preview file at ^1", previewSourcePath )
    else
        return nil, str:fmt( "No preview file corresponding to ^1 at ^2", photoPath, previewSourcePath )
    end

    local attr = LrFileUtils.fileAttributes( previewSourcePath )
    if attr == nil then
        return nil, "no preview attrs"
    end
    local previewSourceTime = attr.fileModificationDate
    if previewSourceTime == nil then
        return nil, "no preview date on file"
    end
    local content
    -- this could be modified to return image data instead of file if need be.
    local function getImageFromPreviewContent()
        if content == nil then
            local status
            status, content = LrTasks.pcall( LrFileUtils.readFile, previewSourcePath )
            if status and content then
                app:logVerbose( "Read content from: ^1", previewSourcePath )    
            else
                return nil, str:fmt( "Unable to read preview source file at ^1, error message: ^2", previewSourcePath, content )
            end    
        end
        local p1, p2 = content:find( "level_" .. str:to( prefLevel ) )
        if p1 then
            local start = p2 + 2 -- jump over level_n\0
            local p3 = content:find( "AgHg", start )
            local stop
            if p3 then
                stop = start + p3 - 1
            else
                stop = content:len() - 1
            end
            local data = content:sub( start, stop ) .. string.char( 0xFF ) .. string.char( 0xD9 ) -- jpeg's are unterminated in preview pyramid - sometimes causes problems, sometimes not...
            if previewFile ~= nil then -- user passed file
                app:logVerbose( "Writing preview into user file: ^1", previewTargetPath )
            else
                -- rename file to include prefLevel.
                local base = LrPathUtils.removeExtension( previewTargetPath ) .. '_' .. prefLevel
                previewTargetPath = base .. ".jpg"
                app:logVerbose( "Writing preview into default-named file: ^1", previewTargetPath )
            end
            
            local image, errm = Image:new{ file=previewTargetPath, content=data, assureDir=assureDir, dontOverwrite=dontOverwrite }
            if image then
                app:logVerbose( "Wrote preview file: ^1", previewTargetPath )
                
                local sourceProfile
                -- profile is target-profile
                if icc or meta then
                    app:logVerbose( "querying 'Pyramid' table for profile, uuid: ^1, digest: ^2", uuid, digest )
                    local sql = str:fmt( "select colorProfile from Pyramid where uuid='^1' and digest='^2'", uuid, digest )
                    local status, message, content = sqlite:executeCommand( param, { sql }, nil, 'del' )
                    if status then
                        if str:is( content ) then
                            local spa = str:split( content, "\n" ) -- dangling \r\n's are removed as whitespace, I hope.
                            if #spa == 0 then
                                return nil, "Unexpected and unsupported color profile: " .. sourceProfile
                            else
                                local c = 0
                                for i, v in ipairs( spa ) do
                                    if str:is( v ) then
                                        c = c + 1
                                        sourceProfile = v
                                    end
                                end
                                if c == 0 then
                                    return nil, "Missing color profile"
                                elseif c == 1 then -- good
                                else
                                    return nil, "Ambiguous color profile: " .. content
                                end
                            end
                        else
                            return nil, "No content for icc profile."
                        end
                    else
                        return nil, message        
                    end
                end
                
                if meta then
                
                    -- do whatever is possible via exif-tool
                    local _profile
                    if icc == 'A'  then -- Assign
                        _profile = sourceProfile
                        app:logVerbose( "Doing icc profile assignment via exif-tool" )
                        icc = false 
                    else
                        app:logVerbose( "Not doing icc assignment via exif-tool" )
                    end
                    
                    image:transferMetadata( photo, photoPath, _profile, previewTargetPath, fmtMeta, ets ) -- do icc sourceProfile along with other metadata if called for.
                    
                end
                
                if icc then
                    app:logVerbose( "Doing icc: ^1, from '^2', to: '^3', ets: ^4", icc, sourceProfile, profile, str:to( ets ) )
                    LrTasks.yield() -- without this yield, transfer of metadata followed by conversion (using et-session) fails. ###1 not sure why.
                    image:addColorProfile( icc, sourceProfile, profile, ets )
                else
                    app:logVerbose( "Not doing icc assignment or conversion" )
                end
                
                if str:is( mogParam ) then
                    image:addMogParam( mogParam )
                end
                
                if orient then
                    image:addOrientation( orientationCode, ets )
                end

                -- no additional exiftool'n is yet supported ###3
                
                local s, m = image:commit( ets ) -- commit mogrification and exiftooleanization.
                
                if s then
                    -- good (see log below).
                    Debug.logn( "image commited" )
                else
                    return nil, m
                end
                
                self:_putImageInCache( imageId, prefLevel, image, previewSourceTime )
                app:logVerbose( "image is fresh from preview file" )
                return image
                
            else
                return nil, errm
            end
        else
            return nil -- no real error, just no preview at that prefLevel.
        end
    end
    
    -- as specified by id, prefLevel, & freshness
    local function getImage()
        if freshness < 2 then
            local image = self:_getImageFromCache( imageId, prefLevel, freshness, previewSourceTime )
            if image then
                return image
            end
        end
        return getImageFromPreviewContent()
    end
    
    app:logVerbose( "Fetching preview for ^1, freshness: ^2", photoPath, freshness )
    repeat
        app:logVerbose( "Contemplating prefLevel ^1", prefLevel )
        local image, errm = getImage() -- at prefLevel
        if image then
            return image, nil, prefLevel
        elseif errm then
            return nil, errm
        elseif prefLevel > minLevel then
            prefLevel = prefLevel - 1
        else
            return nil, str:fmt( "No preview for ^1 at a level between ^2 and ^3", photoPath, minLevel, prefLevel )
        end
    until prefLevel <= 0
    return nil, str:fmt( "Unable to obtain preview for ^1", photoPath )
end



return Previews

