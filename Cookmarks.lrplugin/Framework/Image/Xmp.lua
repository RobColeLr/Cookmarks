--[[
        Xmp.lua
--]]


local Xmp, dbg = Object:newClass{ className = "Xmp", register = true }



--- Constructor for extending class.
--
function Xmp:newClass( t )
    return Object.newClass( self, t )
end



--- Constructor for new instance.
--
--  @return      new image instance, or nil.
--  @return      error message if no new instance.
--
function Xmp:new( t )
    local o = Object.new( self, t )
    return o
end



--- Determine if xmp file has changed significantly, relative to another.
--
--  @usage              both files must exist.
--
--  @return status      ( boolean, always returned ) true => changed, false => unchanged, nil => see message returned for qualification.
--  @return message     ( string, if status = nil or false ) indicates reason.
--
function Xmp:isChanged( xmpFile1, xmpFile2, fudgeFactorInSeconds )

    if fudgeFactorInSeconds == nil then
        fudgeFactorInSeconds = 2
    end

    local t1 = fso:getFileModificationDate( xmpFile1 )
    local t2
    if t1 then
        t2 = fso:getFileModificationDate( xmpFile2 )
        if t2 then
            if t1 > (t2 + fudgeFactorInSeconds) or t2 > (t1 + fudgeFactorInSeconds) then
                -- proceed, to check content.
            else
                return false, "xmp file has not been modified"
            end
        else
            return nil, "file not found: " .. str:to( xmpFile2 )
        end
    else
        return nil, "file not found: " .. str:to( xmpFile1 )
    end
    
    local c1, m1 = fso:readFile( xmpFile1 )
    if str:is( c1 ) then
        -- reminder: raws have elements, rgbs have attributes
        c1 = c1:gsub( 'MetadataDate.-\n', "" )
        local c2, m2 = fso:readFile( xmpFile2 )
        if str:is( c2 ) then
            c2 = c2:gsub( 'MetadataDate.-\n', "" )
            if c1 ~= c2 then
                return true
            else
                return false, str:fmt( "source xmp modification date is ^1 (^2), and destination is ^3 (^4), but there are no significant content changes", t1, LrDate.timeToUserFormat( t1, "%Y-%m-%d %H:%M:%S" ), t2, LrDate.timeToUserFormat( t2, "%Y-%m-%d %H:%M:%S" ) )
            end
        else
            return nil, "No content in file: " .. xmpFile2
        end
    else
        return nil, "No content in file: " .. xmpFile1
    end
        
end



--- Get xmp file: depends on lrMeta, and metaCache recommended.
--
--  @returns    path (string, or nil) nil if xmp-path not supported.
--  @returns    other (boolean, string, or nil) true if path is sidecar, string if path is nil, nil if path is source file.
--
function Xmp:getXmpFile( photo, metaCache )
    assert( photo, "no photo" )
    assert( metaCache, "no cache" )
    local isVirt = lrMeta:getRawMetadata( photo, 'isVirtualCopy', metaCache, true ) -- accept un-cached.
    assert( isVirt ~= nil, "virt?" )
    if isVirt then
        return false, "No xmp file for virtual copy"
    end
    local fmt = lrMeta:getRawMetadata( photo, 'fileFormat', metaCache )
    local path = lrMeta:getRawMetadata( photo, 'path', metaCache )
    assert( str:is( path ), "no path" )
    if fmt == 'RAW' then
        return LrPathUtils.replaceExtension( path, "xmp" ), true
    elseif fmt == 'VIDEO' then
        return nil, "No xmp for videos"
    else
        return path
    end
end



return Xmp