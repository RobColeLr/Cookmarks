--[[
        Preference Manager
        
        Supports name preference sets that may or may not be supplemented by a preference config file.
--]]

local Preferences, dbg = Object:newClass{ className = 'Preferences' }



--- Constructor for extending class.
--
function Preferences:newClass( t )
    return Object.newClass( self, t )
end



--- Constructs a new preference manager.
--      
--  <p>Installation procedure is going to have to be smart enough to deal with pre-existing directory upgrade.</p>
--
--  <p>This object manages named preference sets. Exclude and you just have the reglar set of unnamed (un-prefixed) prefs...</p>
--
--  <p>Param Table In:<blockquote>
--          - name(id): set name. if missing, then default set.<br>
--          - file-essential boolean.</blockquote></p>
--                          
--  <p>Object Table Out:<blockquote>
--          - friendlyName: same as name/id except for default.<br>
--          - file (path)<br>
--          - prefs (name-val table)</blockquote></p>
--      
--  @param      t       input parameter table.
--
--  @usage              Subdirectory for supplemental files is 'Preferences' in plugin directory.
--  @usage              See app class pref methods for more info.
--
--  @return             Preference manager object.
--
function Preferences:new( t )

    local o = Object.new( self, t )
    
    o.file = nil -- path to most recently loaded preference backing file.
    o.filePrefs = nil -- return table read from preference backing file.
    o.prefDir = LrPathUtils.child( _PLUGIN.path, 'Preferences' )
    o.dfltFile = LrPathUtils.child( o.prefDir, 'Default.lua' )
    o.backing = fso:existsAsFile( o.dfltFile ) -- deleting default file is disallowed.
    if not o.backing then
        o.dfltFile = LrPathUtils.replaceExtension( o.dfltFile, 'txt' )
        o.backing = fso:existsAsFile( o.dfltFile ) -- deleting default file is disallowed.
    end
    if o.backing then
        dbg( "prefs are backed" )
    else
        dbg( "no backing for prefs" )
    end
    o.file = ''
    o.dfltProps = {}
    o.glblDfltProps = {}
    o.presetCache = {}
    o:registerPreset( 'Default', 1 )
    return o
end        


-- Private Preset class for external use (via object methods):

local Preset = Object:newClass{ className="PreferencePreset", register=false }

-- no need for new class method, since no way to create preset objects externally.
function Preset:new( t )
    local o = Object.new( self, t )
    assert( str:is( o.name ), "new preset needs name" )
    return o
end


function Preset:isBacked()
    return preset.backingData
end


function Preset:getPref( prefName )
    --assert( str:is( self.name ), "preset object needs name" )
    --Debug.pause( self.name )
    local prefValue = app.prefMgr:getPref( prefName, self.name )
    if prefValue ~= nil then
        return prefValue
    elseif self.backingData then
        return self.backingData[prefName]
    else
        return nil
    end
end


--- Save pref in backing file.
--
--  @usage Note: this is different than the pref-mgr version, since it's intended to set persistent prefs in backing file.<br>
--         If that's not what you want, then use the preference manager version, which is intended to set prefs in lr-prefs, thus masking the value in the backing file.
--
--  @return status - t/f
--  @return message - errm.
--
function Preset:savePrefInBackingFile( prefName, prefValue )
    local temp = app.prefMgr:getPref( prefName, self.name )
    if self.backingData then
        if prefValue ~= self.backingData[prefName] then
            self.backingData[prefName] = prefValue
            local t = "return {\n" .. luaText:serialize( self.backingData ) .. "\n}\n" -- -- Note: this will cause loss of all comments.
            local s, m = fso:writeFile( self.backingFile, t ) 
            if s then
                -- golden
                return true
            else
                -- app:logErr( "No could write pref file, so no persistence, errm: ^1", m )
                return false, m
            end    
        else
            -- value already set.
            return true -- from outside, already set is same as newly set.
        end
    else
        -- app:logErr( "No backing file for saving pref." )
        return false, "No backing file."
    end
end



--- Get object that represents settings associated with specified preset.
--
function Preferences:getPreset( presetName, reload )
    local preset = self.presetCache[presetName]
    if preset == nil then
        preset = Preset:new{ name=presetName }
        self.presetCache[presetName] = preset
    elseif not reload then
        return preset -- re-read backing file?
    end
    preset.backingFile = LrPathUtils.child( self.prefDir, LrPathUtils.addExtension( presetName, "txt" ) )
    if not fso:existsAsFile( preset.backingFile ) then
        preset.backingFile = LrPathUtils.replaceExtension( preset.backingFile, "lua" )
    end
    if fso:existsAsFile( preset.backingFile ) then
        local status, other = pcall( dofile, preset.backingFile )
        if status then
            app:logVerbose( "Got preset '^1', backed by file: ^2", presetName, preset.backingFile )
            preset.backingData = other
            return preset
        else
            app:logErr( "Preference preset ^1 backing file (^2) has an error, and so no values defined in backing file will be in effect, error message: ^3", presetName, backingFile, str:to( other ) )
            return nil
        end
    end
    return preset
end






--- Create a new named set, and load properties with initial values.
--
function Preferences:createPreset( props )
    local presetName = self:getPresetName()
    if presetName == 'Default' then
        error( "Check for default set is external." )
    end
    self:saveProps( props ) -- prop driven, non-nil props are saved in prefs - set on its way out.
    if self.backing then
        local file = LrPathUtils.child( self.prefDir, presetName .. ".lua" )
        if not fso:existsAsFile( file ) then
            file = LrPathUtils.replaceExtension( file, "txt" )
        end
        if not fso:existsAsFile( file ) then -- backing file is absent.
            if fso:existsAsFile( self.dfltFile ) then
                local s,m = fso:copyFile( self.dfltFile, file )
                if s then
                    self:loadPrefFile( file ) -- throws error if probs.
                    local answer = app:show{ confirm="Preference support file created for ^1 - edit now?",
                        subs = presetName,
                        buttons = { dia:btn( "Yes", 'ok' ), dia:btn( "No", 'cancel' ) },
                        -- presently no action-pref-key user must acknowlege / consider...
                    }
                        
                    if answer == 'ok' then
                        app:openFileInDefaultApp( self.file, true )
                    --else
                    end
                else
                    error( m )
                end
            else
                app:show{ error="Default preference file is missing: ^1", self.dfltFile }
            end
        else
            self:loadPrefFile( file ) -- throws error if probs.
            local answer = app:show{ info="^1 settings are backed by lua preference file: ^2 - edit now?",
                subs={ presetName, self.file },
                buttons={ dia:btn( "Edit Now", 'ok' ), dia:btn( "Not Now", 'cancel' ) },
                actionPrefKey="Edit advanced settings" }
            if answer == 'ok' then
                app:openFileInDefaultApp( file, true )
            elseif answer == 'cancel' then
                -- could conceivably make this memorable, but I think its good to have a reminder if backing is supported by this plugin - its not like
                -- the user will be creating presets every day...
            else
                error( "bad answer" )
            end
        end
    end
    self:loadProps( props )
end



--- Get preference preset name.
--
--  @param friendly (return "Un-named" instead of 'Default')
--
--  @return name if not nil, else 'Default'.
--
function Preferences:getPresetName()
    local presetName
    if prefs._global_presetName ~= nil then
        presetName = LrStringUtils.trimWhitespace( prefs._global_presetName ) -- I would have expected UI to trim but it does not.
    end
    if not str:is( presetName ) then
        prefs._global_presetName = 'Default' -- a little side effect, he-he: initializing global preset name when getting, if not init.
        return 'Default'
    else
        return presetName
    end
end



--- Switch to named or unamed preference set.
--
function Preferences:switchPreset( props )
    local presetName = self:getPresetName()
    if self.backing then
        local file
        file = LrPathUtils.child( self.prefDir, presetName .. ".lua" )
        if not fso:existsAsFile( file ) then
            file = LrPathUtils.replaceExtension( file, "txt" )
        end
        if not fso:existsAsFile( file ) then -- backing file is absent - note: we are switching to an already existing set,
            -- so if backing is supported, the file should be there.
            if presetName == 'Default' then
                error( 'Default preference support file has disappeared: ' .. str:to( self.dfltFile ) )
            end
            if dialog:isOk( str:format( "Preference file supporting '^1' settings has disappeared (^2) - create a new one?", presetName, file ) ) then
                if fso:existsAsFile( self.dfltFile ) then
                    local s,m = fso:copyFile( self.dfltFile, file )
                    if s then
                        local status, message = pcall( self.loadPrefFile, self, file )
                        if status then
                            if dialog:isOk( "Preferences support file created anew - edit now?" ) then
                                app:openFileInDefaultApp( self.file, true )
                            --else its user's responsibility to edit later, or not.
                            end
                        else
                            dialog:messageWithOptions( { error="Unable to load advanced settings from preference backing file, error message: ^1" }, message )
                        end
                    else
                        error( m ) -- not sure how this is being handled. ###4
                    end
                else
                    app:show{ error="Default preference file is missing: ^1", self.dfltFile }
                end
            else
                app:logWarning( "Best find that file (" .. file .. "), since preference support file is required for this plugin." )
            end
        else
            local status, message = pcall( self.loadPrefFile, self, file ) -- load props used to do this
            if status then
                app:logInfo( str:format( "Switched to pref set ^1 backed by ^2", presetName, file ) )
            else
                dialog:messageWithOptions( { error="Unable to load advanced settings from preference backing file, error message: ^1" }, message )
            end
        end
    else
        dbg( "No backing" )
    end
    if props then
        dbg("loading props for", presetName )
        self:loadProps( props )
    end
end



--- Determine if preference file backing is supported by this plugin.
--
function Preferences:isBackedByFile()
    return self.backing
end



--- Gets path to preference support file.
--
--  @return full path
--  @return filename
--
function Preferences:getPrefSupportFile()
    local presetName = self:getPresetName()
    local name
    if self.file and fso:existsAsFile( self.file ) then
        name = LrPathUtils.leafName( self.file )
    else
        name = presetName .. ".txt"
    end
    return self.file, name
end



--- Load preference "backing" file.
--
--  <p>Preferences not in lr-pref table, are looked for in preference backing file, if available.</p>
--
--  @param file     The path to the file.
--
--  @usage          Up until 5/Aug/2011 this used to log errors instead of throwing them - not good enough (errors in backers not being detected).<br>
--                  Now calling context must take care to handle thrown errors to handle more gracefully if necessary.
--
function Preferences:loadPrefFile( file )

    self.file = file
    self.filePrefs = nil
    
    local status, prefTbl = pcall( dofile, file )
    if status then
        if prefTbl then
            if type( prefTbl ) == 'table' then
                app:logInfo( "Using preference backing file: " .. self.file )
                self.filePrefs = prefTbl
            else
                error( "Preference backing file must return a table, not a " .. type( prefTbl ) ) -- error log changed to error thrown 5/Aug/2011 2:47
            end
        else
            error( "Preference backing file must return a table" ) -- -- error log changed to error thrown 5/Aug/2011 2:47
        end        
    else
        error( "Unable to load pref support file from '" .. self.file .. "', more: " .. str:to( prefTbl ) ) -- error log changed to error thrown 5/Aug/2011 2:47
    end
end



--  Translates a simple property name to its equivalent name-prefixed pref key,
--      
--  <p>If active name is null, then prop-name is pref-key - assures compatibility with no-preference module configuration.</p>
--
--  @param propName (string, required) name of preference.
--  @param presetName (string, default = current preset) name of preset.
--
--  @usage      Reminder: not public.
--
--  @return     key for pref index.
--
function Preferences:_getPrefKey( propName, presetName )
    if not presetName then
        presetName = self:getPresetName() -- get current preset name
    end
    return presetName .. '__' .. propName
end



--- Get global preference value.
--
--  @usage key is name prefixed by _global_ in the interest of keeping a clear separation,
--  <br>between managed preference globals and unmanaged, and also preset preferences.
--
--  @return the value - may be nil.
--
function Preferences:getGlobalPref( name )
    return prefs['_global_'..name]
end



--- Get actual preference key corresponding to managed global preference name.
--
--  @return key suitable for binding.
--
function Preferences:getGlobalKey( name )
    return '_global_' .. name
end



--- Set global preference value.
--
--  @param name (string, required) name of pref (actual key is a derivation).
--  @param val (any non-table value, default nil) simple value for pref, nil to clear.
--
--  @usage key is name prefixed by _global_ in the interest of keeping a clear separation,
--  <br>between managed preference globals and unmanaged, and also preset preferences.
--
function Preferences:setGlobalPref( name, val )
    if name == nil then
        return -- hopefully only happens when *all* prefs have been cleared.
    end
    prefs['_global_'..name] = val
end



--- Sets global preference based on property name.
--      
--  <p>Named or unamed.</p>
--
--  @param name (string, required) preference name.
--  @param value (any simple type, required) preference value.
--  @param presetName (string, default = current preset) preset name.
--
--  @usage      like all preference methods, this method is wrapped by app object - see App class for more info.
--
function Preferences:setPref( name, value, presetName )
    local key = self:_getPrefKey( name, presetName )
    if prefs[name] then
        dbg( "property being set to prefs already exists without prefix: ", name )
    end
    prefs[key] = value
end



--- Sets preference based on property name.
--      
--  <p>Named or unamed.</p>
--  <p>Is should not be necessary to init props to match here, provided props are loaded from prefs afterward.</p>
--      
--  @param name (string, required) preference name.
--  @param dflt (any simple type, required) preference default value.
--  @param presetName (string, default = current preset) preset name.
--  @param values (array, optional) initial "pointer" values for table prefs, in case not only value is important, but pointer to value is too (e.g. popup).
--
--  @usage      Like all preference methods, this method is wrapped by app object - see App class for more info.
--
function Preferences:initPref( name, dflt, presetName, values )
    local key = self:_getPrefKey( name, presetName )
    if prefs[key] == nil then
        prefs[key] = dflt -- so pref is not nil.
    elseif values then -- value saved needs to be linked to pointer to equivalent value in context env.
        local v = prefs[key]
        for i, v2 in ipairs( values ) do
            local value
            if v2.value then
                value = v2.value
            else
                value = v2
            end
            if tab:isEquivalent( v, value ) then
                prefs[key] = value
                v = nil
                break
            end
        end
        if v ~= nil then -- value not found
            prefs[key] = dflt
        end
    end
    if presetName == 'Default' then
        self.dfltProps[name] = dflt
    end
    if presetName == nil then
        self:initPref( name, dflt, 'Default', values ) -- and vice versa.
    end
end



--- Initialize global preference value.
--      
--  @usage      Like all preference methods, this method is wrapped by app object - see App class for more info.
--
function Preferences:initGlobalPref( name, dflt )
    local key = self:getGlobalKey( name )
    if prefs[key] == nil then
        prefs[key] = dflt
    end
    self.glblDfltProps[key] = dflt
end



--- Gets pref value corresponding to prop name.
--      
--  <p>Named or unamed.</p>
--
--  @param name (string, required) preference name.
--  @param presetName (string, default = current preset) preset name.
--
--  @usage      Like all preference methods, this method is wrapped by app object - see App class for more info.
--
function Preferences:getPref( propName, presetName )
    local prefKey = self:_getPrefKey( propName, presetName )
    local value = prefs[prefKey]
    if value ~= nil then
        dbg( "got value from prefs for prop named", propName, "value", value )
        return value
    end
    if not str:is( presetName ) or presetName == 'Default' then
        if self.filePrefs then -- file backed value.
            value = self.filePrefs[propName]
            dbg( "value from backer for prop named", propName, "is", value )
        else
            dbg( "no backer for prop named", propName )
        end
    else
        local preset = self:getPreset( presetName )
        if preset.backingData then
            value = preset.backingData[propName]
        end
    end
    return value
end



--- Get global preference pair iterator.
--
--  @param      sortFunc (boolean or function, default false) pass true for default name sort, or function for custom name sort.
--
--  @usage      for iterating global preferences, without having to wade through non-globals.
--
--  @return     iterator function that returns name, value pairs, in preferred name sort order.
--              <br>Note: the name returned is not a key. to translate to a key, call get-global-pref-key and pass the name.
-- 
function Preferences:getGlobalPrefPairs( sortFunc )

    local names = {}
    local values = {}
    assert( prefs.pairs, "no pref pairs" )
    for k, v in prefs:pairs() do
        if k:sub( 1, 8 ) == '_global_' then
            local name = k:sub( 9 )
            names[#names+1] = name
            values[name] = v
        end
    end
    
    if sortFunc ~= nil then
        if type( sortFunc ) == 'function' then
            table.sort( names, sortFunc )
        elseif sortFunc then
            table.sort( names )
        -- else dont sort
        end
    -- else dont sort
    end
    
    local index = 0
    return function()
        index = index + 1
        local name = names[index]
        return name, values[name]
    end
    
end



--- Load properties from preset.
--
--  <p>Default set is handled like any other: properties are loaded whether set is registered or not.</p>
--
--  @usage      Like all preference methods, this method is wrapped by app object - see App class for more info.
--
function Preferences:loadProps( props )
    dbg( "Loading props into ", props )
    local presetName = self:getPresetName()
    if prefs['preset__' .. presetName] == nil then
        dbg( "Loading properties from preset ", presetName )
    end
    local prefix = presetName .. '__' -- must match get-pref-key.
    local pos = prefix:len() + 1
    assert( prefs.pairs, "no pref pairs" )
    for k,v in prefs:pairs() do
        if str:isStartingWith( k, prefix ) then
            local propName = k:sub( pos )
            dbg( "load prop: ", str:format( "prop-name: ^1, val: ^2, from pref-key: ^3", propName, str:to( v ), k ) )
            props[propName] = v
            
            -- ###1 change handler considerations?
            
        else
            -- dbg( "skip load prop: ", k )
        end
    end
end



--- Register a preset.
--
--  <p>Typically called in init-prefs to register a preset to be subsequently initialized,
--  for when plugin is including built-in presets, in which case backing file if any,
--  is explicitly provided in 'Preferences' folder.</p>
--
--  @param presetName - Any name that can be used as part of a pref key.
--  @param presetNumber - Ordinal number defining sequence in plugin manager.
--
--  @usage Un-registering presets is done in the course of deleting a preset - no need for independent unreg method.
--
function Preferences:registerPreset( presetName, presetNumber )
    if presetNumber == nil and str:is( prefs['preset__' .. presetName] ) then
        return -- already registered.
    end
    if presetNumber == nil then
        if self.presetIndex == nil then
            self.presetIndex = 1
        else
            self.presetIndex = self.presetIndex + 1
        end
    else
        self.presetIndex = presetNumber
    end
    prefs["presetIndex__" .. presetName] = self.presetIndex
    prefs["preset__" .. presetName] = true
end



--- Save propertiesavings into named or unamed set.
--      
--  <p>If named, sets 'name-existing' indicator into prefs.</p>
--
--  @usage      Like all preference methods, this method is wrapped by app object - see App class for more info.
--
function Preferences:saveProps( props )
    assert( props ~= prefs, "props are prefs" )
    local presetName = self:getPresetName()
    if props and props.pairs then
        for k,v in props:pairs() do
            if k:find( '_global_' ) then
                dbg( 'global prop should not be saved' )
            else
                self:setPref( k, v )
            end
        end
    else
        app:logWarning( "Registering preset with no props, pairs: " .. (props.pairs or "nil") )
    end
    dbg( "registering saved preset: ", "preset__" .. presetName )
    self:registerPreset( presetName ) -- if not already registered.
    -- prefs["preset__" .. presetName] = true
end



--- Checks if specified named set exists - case insensitive: for checking if duplicate before adding.
--
--  @usage      @2010-11-22 - only called within pref mngr proper.
--
function Preferences:isPresetExisting( _setName )
    dbg( "checking if set exists: ", str:format( "nm: ^1, val: ^2", "preset__" .. _setName, str:to( prefs["preset__" .. _setName] ) ) )
    -- return prefs["preset__" .. setName] - this is case sensitive: especially not good if prefs are backed by case-insensitive file.
    local setName = LrStringUtils.lower( _setName )
    for k, v in prefs:pairs() do
        if str:isStartingWith( k, "preset__" ) then -- its a preset registration
            local name = k:sub( 9 )
            if str:is( name ) then
                name = LrStringUtils.lower( name )
                if name == setName then -- dup
                    return true
                end
            else
                app:logVerbose( "*** Shouldn't be blank prefs registered." )
            end
        end
    end
    return false
end



--- Delete active named set.
--      
--  @param      props       Properties to load from some other set (presently the default/un-named set) once present set is deleted.
--
--  @usage      Throws error if active set is unamed, so check first.
--
function Preferences:deletePreset( props )
    local presetName = self:getPresetName()
    local ok
    if presetName == 'Default' then
        ok = dialog:isOk( str:fmt( "Reset 'Default' settings to factory defaults?" ) )
    else
        if self.backing then
            ok = dialog:isOk( str:format( "Delete '^1' preset and all associated settings including the preset support file (plugin configuration file that contains advanced settings)?", presetName ) )
        else
            ok = dialog:isOk( str:format( "Delete '^1' preset and associated settings ?", presetName ) )
        end
    end
    if ok then
        self:_deletePreset( props ) -- name implied.
    end
end



--- Load defaults into properties.
--
--  @usage defaults come from init-pref calls.
--
function Preferences:loadDefaults( props )
    local presetName = self:getPresetName()
    local prefix = presetName .. '__'
    local pos = prefix:len() + 1
    assert( prefs.pairs, "no pref pairs" )
    for k,v in prefs:pairs() do
        if str:isStartingWith( k, prefix ) then
            local propName = k:sub( pos )
            local value = self.dfltProps[propName]
            dbg( "loading default: ", str:format( "prop-name: ^1, val: ^2, pref-key: ^3", propName, str:to( value ), k ) )
            prefs[k] = value
            props[propName] = value -- could just load-props afterward, but might as well get it while I'm here...
            -- ###1 change handler considerations? ###1
        elseif app:isVerbose() then
            dbg( "not loading default: ", k )
        end
    end
end



--- Load defaults into properties.
--
--  @usage defaults come from init-pref calls.
--
function Preferences:loadGlobalDefaults()
    local prefix = '_global_'
    local pos = prefix:len() + 1
    assert( prefs.pairs, "no pref pairs" )
    for k,v in prefs:pairs() do
        if str:isStartingWith( k, prefix ) then
            -- local propName = k:sub( pos )
            local value = self.glblDfltProps[k]
            -- dbg( "loading global default: ", str:format( "key: ^1, val: ^2", k, str:to( value ) ) )
            prefs[k] = value
            -- props[propName] = value -- could just load-props afterward, but might as well get it while I'm here...
            -- ###1 change handler considerations?
        elseif app:isVerbose() then
            dbg( "not loading global default: ", k )
        end
    end
end



--  Delete active named set.
--      
--  @param      props       Properties to load from some other set (presently the default/un-named set) once present set is deleted.
--
--  @usage      Throws error if active set is unamed, so check first.
--
function Preferences:_deletePreset( props )
    local presetName = self:getPresetName()
    local prefix = presetName .. '__'
    local pos = prefix:len() + 1
    assert( prefs.pairs, "no pref pairs" )
    for k,v in prefs:pairs() do
        if str:isStartingWith( k, prefix ) then
            local propName = k:sub( pos )
            dbg( "del: ", str:format( "prop-name: ^1, val: ^2", propName, str:to( v ) ) )
            if presetName == 'Default' then
                prefs[k] = self.dfltProps[propName]
            else
                prefs[k] = nil
            end
        else
            dbg( "not deleting: ", k )
        end
    end
    if presetName ~= 'Default' then
        local file = LrPathUtils.child( self.prefDir, presetName .. ".lua" )
        if fso:existsAsFile( file ) then
            local answer
            if app:isRelease() then
                answer = 'ok' -- approval was given previously.
            else -- in develop mode, best not to delete what may be the only copy of built-in preset support files.
                answer = app:show{ confirm="Are you sure you want to delete the preset support file?: ^1",
                    subs = file,
                    buttons = { dia:btn( "Yes", 'ok' ), dia:btn( "No", 'cancel' ) },
                }
            end
            if answer == 'ok' then
                local s,m = fso:moveToTrash( file )
                if s then
                    app:show{ info="Moved to trash or deleted: ^1", file }
                else
                    app:show{ error="Unable to delete file: ^1", file }
                end
            end
        end
        file = LrPathUtils.child( self.prefDir, presetName .. ".txt" )
        if fso:existsAsFile( file ) then
            local answer
            if app:isRelease() then
                answer = 'ok' -- approval was given previously.
            else -- in develop mode, best not to delete what may be the only copy of built-in preset support files.
                answer = app:show{ confirm="Are you sure you want to delete the preset support text file?: ^1",
                    subs = file,
                    buttons = { dia:btn( "Yes", 'ok' ), dia:btn( "No", 'cancel' ) },
                }
            end
            if answer == 'ok' then
                local s,m = fso:moveToTrash( file )
                if s then
                    app:show{ info="Moved to trash or deleted: ^1", file }
                else
                    app:show{ error="Unable to delete file: ^1", file }
                end
            end
        end
        dbg( "Unregistering preset: ", presetName )
        prefs["preset__" .. presetName] = nil
        prefs["presetIndex__" .. presetName] = nil
    end
    prefs._global_presetName = 'Default'
    self:loadProps( props )
    if presetName == 'Default' then
        app:show{ info="Default settings have been reset." }
    end
end



--  Return iterator that feeds k,v pairs back to the calling context sorted according to the specified sort function.
--      
--  @param           sortFunc       May be nil, in which case default sort order is employed (alphabetical).
--      
--  @return          Iterator function.
--
function Preferences:___________sortedPairs( sortFunc )
    local a = {}
    assert( prefs.pairs, "no pref pairs" )
    for k in prefs:pairs() do
        a[#a + 1] = k
    end
    table.sort( a, sortFunc )
    local i = 0
    return function()
        i = i + 1
        return a[i], prefs[a[i]]
    end
end



--- Gets list of saved (registered) presets.
--      
--  @return    Array of strings suitable for combo box.
--
function Preferences:getPresetNames()
    local ordered = false
    local sortFunc = function( p2, p1 )
        local reverse = false
        if p1 ~= nil and p2 ~= nil then
            local one = prefs['presetIndex__' .. p1]
            if one ~= nil then
                local two = prefs['presetIndex__' .. p2]
                if two ~= nil then
                    reverse = one < two
                    ordered = true
                else
                    reverse = false -- sort function prefers a false if there is anything iffy...
                end
            else
                reverse = false -- sort function prefers a false if there is anything iffy...
            end
        else
            reverse = false -- sort function prefers a false if there is anything iffy...
        end
        return reverse
    end
    local items = {}
    for k,v in prefs:pairs() do -- all prefs - unsorted.
        if str:isStartingWith( k, "preset__" ) then
            local set = k:sub( 9 )
            items[#items + 1] = set
        end
    end
    local newItems = tab:sortReverseCopy( items, sortFunc )
    if ordered then
        return newItems
    else
        table.sort( items ) -- sort original items alphabetically.
        for i, v in ipairs( items ) do
            prefs['presetIndex__' .. v] = i -- lock in the order for next time - new presets will have index assigned too.
        end
        return items
    end
end



return Preferences