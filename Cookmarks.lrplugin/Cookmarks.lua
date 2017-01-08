--[[
        Cookmarks.lua
--]]


local Cookmarks, dbg, dbgf = Object:newClass{ className = "Cookmarks", register = true }

Cookmarks.urlBase = str:fmt( "lightroom://^1/", _PLUGIN.id ) -- this is dictated by Lightroom, not me.


local presetCache
local prereqFuncs
local rawMeta
local fmtMeta
local wholeUrl -- whole url
local specs
local photos
local queue = Queue:new{ max = 10 }
local call -- url-handling service call.
local includePrefix
local settlingTimePerOp



--- Constructor for extending class.
--
function Cookmarks:newClass( t )
    return Object.newClass( self, t )
end



--- Constructor for new instance.
--
function Cookmarks:new( t )
    local o = Object.new( self, t )
    local presets = LrApplication.getDevelopPresetsForPlugin( _PLUGIN )
    for i, preset in ipairs( presets ) do
        LrFileUtils.delete( preset:getFile() )
    end
    self.ds = DevelopSettings:new()
    self.lookup = self.ds:getLookup()
    self.popupItems = {}
    self.popupItems[1] = self.ds:getPopupMenuItems( 1 ) -- legacy
    self.popupItems[2] = self.ds:getPopupMenuItems( 2 ) -- 2012.
    --Cookmarks.checkLookup()
    return o
end



function Cookmarks:_initPresetCache()
    local lrPresetFolders = LrApplication.developPresetFolders()
    presetCache = {}
    for i, fo in ipairs( lrPresetFolders ) do
        local ps = fo:getDevelopPresets()
        for j, p in ipairs( ps ) do
            presetCache[p:getName()] = p
        end
    end
    if tab:isEmpty( presetCache ) then
        app:logVerbose( "No presets found." )
    end
end


local prompted
function Cookmarks:_promptIfNotAlreadyPrompted()
    if prompted then return end
    prompted = true
    local answer
    if #photos > 0 then
        answer = app:show{ info="Adjust ^1?",
            subs = { str:plural( #photos, "photo", true ) },
            buttons = { dia:btn( "OK", 'ok' ) },
            actionPrefKey = "Adjust multiple photos",
        }
    else
        answer = app:show{ info="Adjust 1 photo?",
            buttons = { dia:btn( "OK", 'ok' ) },
            actionPrefKey = "Adjust one photo",
        }
    end
    if answer == 'ok' then
        return
    else
        call:cancel()
    end
end



function Cookmarks:_processHello( sectionName )
    app:show{ info="Hi there - ready when you are..." }
    return
end


function Cookmarks:_processAutoTone( sectionName, mult )
    self:_promptIfNotAlreadyPrompted()
    if call:isQuit() then
        return
    end
    local s, m = cat:update( 10, str:fmt( "Cookmark ^1", str:plural( #photos, "photo", true ) ), function( context, phase, t )
        assert( t.pass ~= nil, "no pass" )
        assert( t.pass ~= nil, "no phase" )
        local i1 = ( t.phase - 1 ) * 1000 + 1
        local i2 = math.min( t.phase * 1000, #photos )
        for i = i1, i2 do
            repeat
                local photo = photos[i]
                local shortName
                local longName
                if rawMeta[photo].isVirtualCopy then
                    shortName = str:fmt( "^1 (^2)", fmtMeta[photo].fileName, fmtMeta[photo].copyName )
                    longName = str:fmt( "^1 (^2)", rawMeta[photo].path, fmtMeta[photo].copyName )
                else
                    shortName = fmtMeta[photo].fileName
                    longName = rawMeta[photo].path
                end
                app:log( "Adjusting ^1", longName )
                call.scope:setCaption( shortName )
                if t.pass == 1 then
                    t.lookup[photo] = photo:getDevelopSettings() -- before.
                    local s, m = devSettings:adjustPhotos( { photo }, "Auto Tone", { AutoTone=true } )
                    if s then
                        -- good
                    else
                        app:logErr( m )
                        break
                    end
                    break
                end
                local dev1, dev2, dev3
                local count = 1
                dev1 = t.lookup[photo]
                repeat
                    dev2 = photo:getDevelopSettings()
                    if dev2.Blacks2012 > -101 then
                        app:logVerbose( "Autotoned settings settled after ^1 tries", count )
                        break
                    else
                        app:sleep( .1 )
                        count = count + 1
                    end
                until count > 60 -- 6 seconds.
                if mult ~= 1 then
                    if dev1.ProcessVersion == '6.6' or dev1.ProcessVersion == '6.7' then
                        dev3 = {}
                        if dev1.Blacks2012 > -101 and dev2.Blacks2012 > -101 then
                            dev3.Exposure2012 = dev1.Exposure2012 - (dev1.Exposure2012 - dev2.Exposure2012) * mult
                            dev3.Contrast2012 = dev1.Contrast2012 - (dev1.Contrast2012 - dev2.Contrast2012) * mult
                            dev3.Highlights2012 = dev1.Highlights2012 - (dev1.Highlights2012 - dev2.Highlights2012) * mult
                            dev3.Shadows2012 = dev1.Shadows2012 - (dev1.Shadows2012 - dev2.Shadows2012) * mult
                            dev3.Whites2012 = dev1.Whites2012 - (dev1.Whites2012 - dev2.Whites2012) * mult
                            dev3.Blacks2012 = dev1.Blacks2012 - (dev1.Blacks2012 - dev2.Blacks2012) * mult
                            --Debug.lognpp( dev1.Exposure2012, dev2.Exposure2012, dev3.Exposure2012 )
                            local chg = dev3.Exposure2012 ~= dev2.Exposure2012 or 
                                        dev3.Contrast2012 ~= dev2.Contrast2012 or
                                        dev3.Highlights2012 ~= dev2.Highlights2012 or
                                        dev3.Shadows2012 ~= dev2.Shadows2012 or
                                        dev3.Whites2012 ~= dev2.Whites2012 or
                                        dev3.Blacks2012 ~= dev2.Blacks2012
                            if chg then
                                local tidbit = mult == 1 and "" or str:fmtx( " x ^1", mult )
                                local s, m = devSettings:adjustPhotos( { photo }, str:fmtx( "Auto Tone^1", tidbit ), dev3 )
                                if s then
                                    app:log( "Photo Adjusted" )
                                else
                                    app:logErr( "Photo not adjusted, error message: ^1", m )
                                end
                            else
                                app:log( "Already auto-toned in full." )
                            end
                        else
                            app:logErr( "Photo not adjusted - settings wouldn't settle." )
                        end
                    else
                        app:logWarning( "Photo skipped - fractional auto-toning not supported for legacy PV." )
                    end
                else
                    -- nada
                end    
            until true
            if not call:isQuit() then
                call.scope:setPortionComplete( i, #photos )
            else
                return true
            end
        end
        if t.pass == 1 then
            if i2 < #photos then
                t.phase = t.phase + 1
            else
                t.pass = 2
                t.phase = 1
            end
            return false
        else
            if i2 < #photos then
                return false
            end
        end
    end, { pass = 1, phase=1, lookup={} } )
    local s = true
    if s then
        app:log( "Preset (^1) was successfully applied to ^1", str:plural( #photos, "photo", true ) ) 
    else
        app:logErr( m )
        Debug.showLogFile()
    end
end



-- name and value are just any ol' strings so far.
function Cookmarks:_accumProcess( name, value, mult )
    local baseName
    local adjType
    local numValue
    if name:sub( 1, 1 ) == 'i' then
        adjType = 'i' -- incremental
        baseName = name:sub( 2 )
    else
        adjType = 'a' -- absolute
        baseName = name
        mult = 1
    end
    local lookup = self.lookup[baseName]
    if lookup == nil then
        app:error( "Bad adjustment name: '^1', value: ^2", baseName, self:_unencode( str:to( value ) ) )
    end
    local dataType = lookup.dataType
    local valueTyped
    if dataType == 'string' then
        valueTyped = value
    elseif dataType == 'boolean' then
        valueTyped = bool:booleanFromString( value )
    elseif dataType == 'number' then
        valueTyped = num:numberFromString( value ) * mult
    else
        -- not doing tables
        app:error( "bad type" )
    end
    if valueTyped == nil then
        app:error( "bad value" )
    end
    -- assume pre-requisites are already satisfied.
    specs[baseName] = { adjType = adjType, name=baseName, value=valueTyped, lookup=lookup }
end



function Cookmarks:_evalPrereq( photo )
    for name, spec in pairs( specs ) do
        local lookup = spec.lookup
        local prereq = lookup.prereq
        if prereq ~= nil then
            local dev = photo:getDevelopSettings() -- not optimal to do this twice.
            if dev[prereq.name] == prereq.value then
                -- good to go
                app:logVerbose( "Pre-requisite already satisfied for ^1: ^2=^3", name, prereq.name, prereq.value )
            else
                local set = {}
                set[prereq.name] = prereq.value
                local name = str:fmt( "CM Prerequisite: ^1=^2", prereq.name, prereq.value )
                local preset = LrApplication.addDevelopPresetForPlugin( _PLUGIN, name, set ) -- let it auto-append a uniqueness id if need be.
                if preset then
                    --Debug.lognpp( set )
                    prereqFuncs[#prereqFuncs + 1] = function()
                        photo:applyDevelopPreset( preset, _PLUGIN )
                    end
                else
                    app:error( "No preset" )
                end
            end
        else
            -- Debug.logn( "No pre-req" )
        end
    end
end



-- Unescape string in URL.
-- Note: I have had such bad luck with general purpose unescapers that I just don't use them - generally *way* too aggressive: do more harm than good.
-- If you find a character sequence not being unescaped properly, then add it here and let me (Rob Cole) know.
-- Firefox does NOT unescape dots, parends, forward-slashes, backslashes.
function Cookmarks:_unencode( s )
    s = s:gsub( "%%20", " " ) -- Firefox escapes space characters.
    if s:find( "%%" ) then
        app:logVerbose( "Percent sign found in url string - possibly needs to be unescaped - edit _unescape method in Cookmarks.lua source file to add sequences to be unescaped." )
    end
    return s
end



function Cookmarks:_applyAdjToPhoto( secName, photo )
    local old = photo:getDevelopSettings()
    local new = {}
    local pv = old.ProcessVersion
    local current = false
    if pv == nil then
        app:error( "no process version" )
    elseif pv == "6.7" then
        current = true
        Debug.lognpp( "6.7", old )
    elseif pv == "6.6" then
        current = true
        Debug.lognpp( "6.6", old )
    elseif pv == "5.7" then
        Debug.lognpp( "5.7", old )
    elseif pv == "5.0" then
        Debug.lognpp( "5.0", old )
    else
        app:error( "not supp: ^1", pv  )
    end
    local newValue
    local lookup
    local constraints
    local legacy
    local friendly = "" -- adjustment settings string for edit-history
    local preset
    local plugin
    for name, spec in pairs( specs ) do
        lookup = spec.lookup
        constraints = lookup.constraints
        if lookup.legacy and current then
            app:error( "Legacy adjustment: ^1", name )
        end
        if lookup.dataType == 'number' then
            if spec.adjType == 'a' then
                newValue = spec.value -- abs
                friendly = friendly .. str:fmt( "^1=^2,", name, spec.value )
            else -- 'i'
                if old[name] ~= nil then
                    newValue = old[name] + spec.value -- rel
                    if spec.value < 0 then
                        friendly = friendly .. str:fmt( "-^1(^2),", name, -spec.value )
                    elseif spec.value > 0 then
                        friendly = friendly .. str:fmt( "+^1(^2),", name, spec.value )
                    end
                else
                    Debug.lognpp( old )
                    app:error( "Nil: ^1", name )
                end
            end
            if constraints then
                if constraints.min then
                    if newValue < constraints.min then
                        newValue = constraints.min
                    elseif newValue > constraints.max then
                        newValue = constraints.max
                    else
                        --
                    end
                else
                    local ok = false
                    for i, v in ipairs( constraints ) do
                        if v == spec.value then
                            ok = true
                            break
                        end
                    end
                    if not ok then
                        app:error( "bad value" )
                    end
                    newValue = spec.value
                end
            else
                -- anything goes.
                newValue = spec.value
            end
        elseif spec.lookup.dataType == 'string' then
            if constraints then
                local ok = false
                for i, v in ipairs( constraints ) do
                    if v == spec.value then
                        ok = true
                        break
                    end
                end
                if not ok then
                    app:error( "bad value" )
                end
            else
                -- no constraints
            end
            local value = self:_unencode( spec.value )
            friendly = friendly .. str:fmt( "^1=^2,", name, value )
            newValue = value
        elseif spec.lookup.dataType == 'boolean' then
            friendly = friendly .. str:fmt( "^1=^2,", name, tostring( spec.value ) )
            newValue = spec.value -- value is already typed.
        else
            --newValue = value -- error ###1
            app:error( "pgm err" ) -- never happens since data-types pre-checked.
        end
        if newValue ~= nil then
            new[name] = newValue
        else
            app:error( "no value" )
        end
    end
    if friendly ~= "" then
        friendly = friendly:sub( 1, friendly:len() - 1 )
        local name
        if includePrefix ~= nil then
            if type( includePrefix ) == 'boolean' then
                if includePrefix then
                    local dt = LrDate.currentTime()
                    local yyyy, mm, dd, hh, mmt, ss, dow  = LrDate.timestampToComponents( dt )
                    if str:is( secName ) then
                        friendly = secName
                    end
                    name = string.format( "%4s-%02s-%02s %02s:%02s:%02s %s", yyyy, mm, dd, hh, mmt, ss, friendly )
                else
                    if str:is( secName ) then
                        name = secName -- discard computed name in favor of specified name.
                    else
                        name = friendly
                    end
                end
            else
                name = includePrefix( secName, friendly ) -- get-name
            end
        else
            if str:is( secName ) then
                name = secName -- discard computed name in favor of specified name.
            else
                name = friendly
            end
        end
        local nameLen = name:len()
        if nameLen > 123 then -- error if name too long - not sure exact limit, but this seems like a reasonable cut-off.
            name = name:sub( 1, 120 ) .. "..."
        end
        preset = LrApplication.addDevelopPresetForPlugin( _PLUGIN, name, new )
        if preset then
            -- Debug.lognpp( name, new )
            photo:applyDevelopPreset( preset, _PLUGIN )
        else
            Debug.lognpp( name, new )
            app:error( "No preset" )
        end
    else
        app:logWarning( "No adjustments to apply." )
    end
end



-- dev-preset-name is already unencoded and unescaped.
function Cookmarks:_processPreset( sectionName, devPresetName )
    self:_promptIfNotAlreadyPrompted()
    if call:isQuit() then
        return
    end
    -- prereq is hardcoded - preset must exist.
    self:_initPresetCache() -- assure up2date.
    local devPreset = presetCache[devPresetName]
    if devPreset then
        Debug.logn( str:fmt( "Preset (^1) found in: ^2", devPresetName, devPreset:getParent():getName() ) )
    else
        app:error( "No preset named '^1'", devPresetName )
    end
    local s, m = cat:update( 10, str:fmt( "Cookmark ^1", str:plural( #photos, "photo", true ) ), function( context, phase )
        local i1 = ( phase - 1 ) * 1000 + 1
        local i2 = math.min( phase * 1000, #photos )
        for i = i1, i2 do
            local photo = photos[i]
            local photoName
            if rawMeta[photo].isVirtualCopy then
                photoName = str:fmt( "^1 (^2)", fmtMeta[photo].fileName, fmtMeta[photo].copyName )
            else
                photoName = fmtMeta[photo].fileName
            end
            call.scope:setCaption( photoName )
            photo:applyDevelopPreset( devPreset )
            if not call:isQuit() then
                call.scope:setPortionComplete( i, #photos )
            else
                return true
            end
        end
        if i2 < #photos then
            return false
        end
    end )
    if s then
        app:log( "Preset (^1) was successfully applied to ^1", str:plural( #photos, "photo", true ) ) 
    else
        app:logErr( m )
        Debug.showLogFile()
    end
end



-- process adjustment section
function Cookmarks:_processAdj( sectionName, adjSection, mult )

    local parts = str:split( adjSection, "&" ) -- always returns an array, with _url as first element, if no seperator.
    for i, v in ipairs( parts ) do
        repeat
            if not str:is( v ) then
                break
            end
            local nv = str:split( v, '=' )
            local name, value
            if #nv == 1 then
                app:logVerbose( "Name without value: ^1", nv[1] )
                break
            elseif #nv == 2 then
                name = nv[1]
                value = nv[2]
            else
                app:logVerbose( "Ambiguous value for name: ^1", nv[1] )
                break
            end
            if not str:is( name ) then
                app:logVerbose( "Name is missing" )
                break
            end
            if not str:is( value ) then
                app:logVerbose( "Value is missing for name: ^1", name )
                break
            end
            --Debug.logn( name, value )
            self:_accumProcess( name, value, mult ) -- cancel or abort if something offensive found.
        until true
    end
    if not tab:isEmpty( specs ) then
        app:log( "Got adjustment specs" )
        
        self:_promptIfNotAlreadyPrompted()
        if call:isQuit() then
            return
        end
        
    else
        app:logErr( "No adjustment specs" )
        return
    end
    
    prereqFuncs = {}
    for i, photo in ipairs( photos ) do
        self:_evalPrereq( photo ) -- adds pre-req funcs.
    end
    
    local s, m = true
    if #prereqFuncs > 0 then
        s, m = cat:update( 10, str:fmt( "Cookmark pre-requisites ^1", str:plural( #photos, "photo", true ) ), function( context, phase )
            for i, func in ipairs( prereqFuncs ) do
                func()
            end
        end )
        if s then
            local time = math.min( #prereqFuncs * settlingTimePerOp, 30 ) -- sleep x seconds for each pre-requisite function executed, up to a total potential max of 30 seconds.
                -- ###2 (there's probably a better way).
            call.scope:setCaption( "Waiting for pre-requisites to settle..." )
            app:sleep( time )
        else
            app:error( "Prerequiste adjustment failed, error message: ^1", m )
        end
    end
    if s then
        s, m = cat:update( 10, str:fmt( "Cookmark ^1", str:plural( #photos, "photo", true ) ), function( context, phase )
            local i1 = ( phase - 1 ) * 1000 + 1
            local i2 = math.min( phase * 1000, #photos )
            for i = i1, i2 do
                local photo = photos[i]
                local name
                if rawMeta[photo].isVirtualCopy then
                    name = str:fmt( "^1 (^2)", fmtMeta[photo].fileName, fmtMeta[photo].copyName )
                else
                    name = fmtMeta[photo].fileName
                end
                call.scope:setCaption( name )
                self:_applyAdjToPhoto( sectionName, photo ) -- assume prereqs are satisfied.
                if not call:isQuit() then
                    call.scope:setPortionComplete( i, #photos )
                else
                    return true
                end
            end
            if i2 < #photos then
                return false
            end
        end )
    end
    if s then
        app:log( "Applied adjustments" )
    else
        app:logErr( m )
        Debug.showLogFile()
    end
end



-- Note: ? is replaced by /
function Cookmarks:urlHandler( _url, _mult )
    local s, m = queue:put{ url=_url, mult=_mult }
    if s then
        app:log( "URL as received: ^1", _url )
    else
        app:show{ warning="Queue full - please wait a moment, then try again." }
        return
    end
    if queue:getCount() == 1 then -- q-count was previously zero.
        prompted = false
        app:call( Service:new{ name="Cookmarks URL Handler", async=true, guard=App.guardVocal, main=function( service )
            call = service
            call.scope = LrProgressScope{
                title = "Cookmarks",
                caption = "Please wait...",
                functionContext = service.context,
            }
            photos = cat:getSelectedPhotos() -- make sure all queued commands are done to the same set of photos.
            rawMeta = catalog:batchGetRawMetadata( photos, { 'path', 'uuid', 'isVirtualCopy' } )
            fmtMeta = catalog:batchGetFormattedMetadata( photos, { 'copyName', 'fileName' } )
            includePrefix = app:getPref( 'includeCookmarksPrefix' )
            settlingTimePerOp = app:getPref( 'settlingTimePerOp' )
            while queue:getCount() > 0 do
                local wholeUrl
                app:call( Call:new{ name="Handle URL", main=function( _call )
                    local qItem = queue:get()
                    local qMult = qItem.mult or 1
                    wholeUrl = qItem.url
                    specs = {}
                    Debug.logn( wholeUrl )
                    local urlRemainder = wholeUrl:sub( Cookmarks.urlBase:len() + 1 ) -- skip 'lightroom://com.robcole.lightroom.Cookmarks/'
                    local sections
                    if str:is( urlRemainder ) then
                    
                        local prepFunc = function(a) return a end -- no need to trim.
                        sections = str:splitEscape( urlRemainder, "/", prepFunc ) -- but do support escaped (doubled up) delimiters.
                        
                        if #sections == 0 then
                            app:error( "No sections" ) -- I don't thinkg this is possible.
                        else
                            Debug.lognpp( sections )
                            --return
                        end
                    else
                        sections = { "" } -- process as a single blank section.
                    end
                    local index = 1
                    local sectionName = "" -- no name by default (just use adjustment values summary or preset name).
                    local mult = 1
                    while index <= #sections and not call:isQuit() do
                        local aim = sections[index]
                        index = index + 1
                        if aim == 'Hello' then
                            app:log( "Hello" )
                            self:_processHello( sectionName ) -- no params
                        elseif aim == 'Name' then
                            sectionName = self:_unencode( sections[index] )
                            index = index + 1
                            app:log( "Name: ^1", sectionName )
                        elseif aim == 'Mult' or aim == 'Multiplier' then
                            local multStr = sections[index]
                            app:log( "Multiplier: ^1", multStr )
                            mult = num:numberFromString( multStr )
                            index = index + 1
                            if mult == nil then
                                app:logErr( "Bad multiplier - reverting to '1'" )
                                mult = 1
                            end
                        elseif aim == 'Adj' or aim == 'DevAdjust' then
                            local adj = sections[index] -- values are unescaped, not names, for efficiency.
                            app:log( "Adjustments: ^1", adj )
                            index = index + 1
                            self:_processAdj( sectionName, adj, mult)
                        elseif aim == 'Preset' then
                            local presetName = self:_unencode( sections[index] ) -- :gsub( "//", "/" ) ) -- unescape slashes allowed in preset names. this is documented.
                            app:log( "Preset: ^1", presetName )
                            index = index + 1
                            self:_processPreset( sectionName, presetName )
                        elseif aim == 'AutoTone' then
                            self:_processAutoTone( sectionName, mult )
                        
                        -- *** elseif aim = '{add-new-sections-here}' then

                        elseif str:is( aim ) then -- default un-named section is assumed to be adjustments.
                            app:log( "Anonymous Adjustments: ^1", aim )
                            self:_processAdj( sectionName, aim, mult * qMult ) -- url mult value can also be multiplied by UI mult.
                        else
                            app:log( "Anonymous Hello" )
                            self:_processHello( sectionName ) -- process empty sections same as 'Hello'.
                        end
                    end
                end, finale = function( _call )
                    
                    if _call.status then
                        app:logVerbose( "Processing of url (^1) completed without an uncaught error.", wholeUrl )
                    else
                        app:logErr( "Error processing url: '^1', error message: ^2", wholeUrl, _call.message )
                    end
                    
                end } )
            end -- while
        end, finale = function( service )
            
            --Debug.showLogFile()
            if service.status then
                if queue:getCount() ~= 0 then
                    app:logWarning( "Service completed without error, but URL queue was not emptied, ^1 remaining.", queue:getCount() )
                end
            end
            queue:clear()
            
        end } )
    end
end



-- URL generator form
function Cookmarks:cookmark( pvCode )

    app:call( Service:new{ name="Cookmark", async=true, guard=App.guardVocal, main=function( call )
    
        local props = LrBinding.makePropertyTable( call.context )
        props.itemKey = self.popupItems[pvCode][1].value
        props.multiplier = 1
        props.rel = true
        props.relEna = false
        props.addEna = false
        props.cookmark = Cookmarks.urlBase
        props.valueKey = ""
        local presetFlag = false
        
        local function add()
            if not str:is( props.cookmark ) then
                props.cookmark = Cookmarks.urlBase
                presetFlag = false
            end
            local item = props.itemKey
            if item.friendly == 'Preset' then
                local name = props.valueKey
                if str:is( name ) then
                    props.cookmark = str:fmt( "^1Preset/^2", Cookmarks.urlBase, name )
                    presetFlag = true
                else
                    app:show{ warning="Enter a valid preset name." }
                end
                return
            end
            local lookup = self.lookup[item.id]
            if lookup then
                local constraints = lookup.constraints
                local value
                if lookup.dataType == 'number' then
                    value = num:numberFromString( props.valueKey )
                    if value ~= nil then
                        if constraints then
                            if value >= constraints.min and value <= constraints.max then
                                -- good
                            else
                                app:show{ warning="Value should be between ^1 and ^2", constraints.min, constraints.max }
                                value = nil
                            end
                        end
                    else
                        app:show{ warning="Value should be number" }
                    end
                elseif lookup.dataType == 'string' then
                    value = props.valueKey
                    if str:is( value ) then
                        if constraints then
                            local ok = false
                            for i, c in ipairs( constraints ) do
                                if c == value then
                                    ok = true
                                    break
                                end
                            end
                            if ok then
                            else
                                local mustBe = table.concat( constraints, ", " )
                                app:show{ warning="^1 must be one of '^2'", value.friendly, mustBe }
                                value = nil
                            end
                        end
                    else
                        app:show{ warning="Value should not be blank." }
                        value = nil
                    end
                elseif lookup.dataType == 'boolean' then
                    value = bool:booleanFromString( props.valueKey )
                    if value ~= nil then
                        value = tostring( value )
                    else
                        app:show{ warning="Value should be 'true' or 'false' (without the apostrophes)" }
                    end
                end
                if value ~= nil then
                    local name
                    if lookup.dataType == 'number' and props.rel then
                        name = 'i' .. item.id
                    else
                        name = item.id
                    end
                    if props.cookmark == Cookmarks.urlBase or presetFlag then
                        props.cookmark = str:fmt( "^1^2=^3", Cookmarks.urlBase, name, value )
                    else
                        props.cookmark = str:fmt( "^1&^2=^3", props.cookmark, name, value )
                    end
                    presetFlag = false
                end
            else
                props.cookmark = Cookmarks.urlBase
            end
        end
        
        local function chg( id, p, k, v )
            app:call( Call:new{ name="chg", main=function( call )
                assert( k == 'itemKey', "oops - watch out...!" )
                if v.id ~= nil then
                    if v.id ~= 'preset' then
                        if v.dataType == 'number' then
                            props.relEna = true
                        else
                            props.relEna = false
                        end
                        props.addEna = true
                    else
                        props.relEna = false
                        props.addEna = true
                    end
                else
                    props.relEna = false
                    props.addEna = false
                    --Debug.pause( v )
                end
            end } )
        end
        view:setObserver( props, 'itemKey', Cookmarks, chg )
        
        local items = self.popupItems[pvCode]
        items[#items + 1] = { separator=true }
        items[#items + 1] = { title="Preset", value={ id='preset', friendly="Preset" } }
        
        local args = {}
        
        args.title = "Cookmark"
        
        local mainItems = { spacing=vf:dialog_spacing() }
        mainItems[#mainItems + 1] =
            vf:row {
                vf:static_text {
                    title = str:fmt( "Cookmark URL Generator" ),
                    tooltip = str:fmt( "Cookmark URL prefix is: '^1'", Cookmarks.urlBase ),
                },
            }
        mainItems[#mainItems + 1] =
            vf:row {
                vf:static_text {
                    title = "Select an item:",
                },
                vf:popup_menu {
                    items = items,
                    bind_to_object = props,
                    value = bind 'itemKey',
                    -- immediate = true, - used to be combo-box (hopefully user will not need to enter custom text).
                    width_in_chars = 25,
                },
                vf:spacer {
                    width = 5,
                },
                vf:static_text {
                    title = "Enter a value:",
                },
                vf:edit_field {
                    bind_to_object = props,
                    value = bind 'valueKey',
                    width_in_chars = 20,
                },
                vf:spacer {
                    width = 5,
                },
                vf:checkbox {
                    bind_to_object = props,
                    title = 'Relative',
                    value = bind 'rel',
                    enabled = bind 'relEna',
                },
                vf:spacer {
                    width = 5,
                },
                vf:push_button {
                    bind_to_object = props,
                    title = 'Add',
                    action = function( button )
                        app:call( Call:new{ name="add", main=function( call )
                            add()
                        end } )
                    end,
                    enabled = bind 'addEna',
                },
            }
        mainItems[#mainItems + 1] =
            vf:row {
                vf:static_text {
                    title = "Copy the following cookmark to the clipboard and use as bookmark \"location\" (URL).",
                },
            }
        mainItems[#mainItems + 1] =
            vf:row {
                vf:edit_field {
                    bind_to_object = props,
                    value = bind 'cookmark',
                    width_in_chars = 80,
                    height_in_lines = 3,
                },
            }
        local accItems = {}
        accItems[#accItems + 1] =
            vf:row { spacing = vf:label_spacing(), bind_to_object = props,
                vf:push_button {
                    title = "Reset URL",
                    action = function( button )
                        props.cookmark = Cookmarks.urlBase
                        presetFlag = false
                    end,
                },
                vf:spacer {
                    width = 20,
                },
                vf:push_button {
                    title = "Try It",
                    action = function( button )
                        local url = props.cookmark
                        if url == Cookmarks.urlBase then -- unedited
                            app:show{ warning="Add something to URL first." }
                        else
                            -- assert( props.multiplier ~= nil, "no mult" )
                            self:urlHandler( url, props.multiplier )
                        end
                    end,
                },
                vf:static_text {
                    title = 'X',
                },
                vf:edit_field {
                    
                    value = bind 'multiplier',
                    width_in_chars = 2,
                    precision = 0,
                    min = -9,
                    max = 9,
                },
                vf:spacer {
                    width = 10,
                },
                vf:static_text {
                    title = "Click 'Add' after selecting an item and entering a value",
                }
            }
            
        
        args.contents = vf:view( mainItems )
        args.accessoryView = vf:view( accItems )
        
        local answer
        repeat
            answer = LrDialogs.presentModalDialog( args )
            
            if answer == 'cancel' then
                props:removeObserver( 'itemKey', Cookmarks ) -- otherwise errors cause the change handler to fire endlessly...
                call:cancel()
                break
            elseif answer == 'ok' then
            
                break
                
            else
            
                -- ???
                
            end
            
        until false
        
    end, finale = function( call )
    
    end } )

end


return Cookmarks