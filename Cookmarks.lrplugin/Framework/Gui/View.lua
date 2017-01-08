--[[
        View.lua
--]]

local View, dbg = Object:newClass{ className = 'View' }



--- Constructor for extending class.
--
function View:newClass( t )
    return Object.newClass( self, t )
end



--- Constructor for new instance.
--
function View:new( t )
    local o = Object.new( self, t )
    return o
end



--- Get a view representing a path, with a browse button.
--
--  <p>Not yet implemented.</p>
--
--  @return 2-item view (row).
--
function View:pathWithBrowseButton( params, items, props, name )
end



--- Get a view implementing mult-selection combo box.
--
--  <p>Not yet implemented.</p>
--
function View:mutliSelectComboBox( param, props, name )
--[[
    local value = props[name]
    local arr = str:split( value, ',' )
    local editField = vf:edit_field {
        value = bind( name ),
    }
    local comboBox = vf:combo_box {
        value = bind{ key='dontcare', transform = function( value, fromModel )
            if fromModel then
                props[name
    }
--]]
end



--- Observe ftp setting property changes. ### deprecated.
--
--  @deprecated
--
--  @param object (table, required) must include 'observeFtpPropertyChanges' table with a named member set to boolean 'true' for each property to be observed.
--  @param props (property-table, required) ftp-settings.
--  @param ftpSettingsName (string, required) name of ftp-settings property.
--  @param checkSetting (function( ftpProps, name, prev, value ), optional) can be used to check the values being set, and return true for 'OK' or false and a warning message if not.
--
--  @usage Call when starting dialog box containing ftp settings.
--  @usage This function was designed to be used in conjunction with<br>
--         the framework object's version of ftp-query-for-password-if-needed, since it will look<br>
--         in the encrypted store for the password saved by this function.
--
function View:observeFtpPropertyChanges( object, props, ftpSettingsName, checkSetting )
    app:call( Call:new{ name="handle password storage", async=true, guard=App.guardSilent, main=function( call )
   
--[[ Typical FTP Settings:
    path = "/testfolder", 
    protocol = "ftp", 
    storePassword = true, 
    password = "dsf", 
    passive = "normal", 
    title = "Untitled FTP", 
    username = "fb159e0f", 
    port = 21, 
    server = "ftp.imemine.com"}
--]]    
        assert( object ~= nil, "no object" )
        if object.observeFtpPropertyChanges == nil then
            -- this case provided so caller can have benefit of password encryption without necessarily observing/checking for legal values.
            object.observeFtpPropertyChanges = { password=true }
        else
            assert( type( object.observeFtpPropertyChanges ) == 'table', "property specs should be table" )
        end
        assert( props[ftpSettingsName] ~= nil, "no ftp settings in props" )
        assert( props[ftpSettingsName].server ~= nil, "no server specified in ftp settings" )
        assert( props[ftpSettingsName].username ~= nil, "username must be specified in ftp settings." )
        assert( props[ftpSettingsName].storePassword ~= nil, "bad props for password storage" )
        
        local saved = tab:copy( props[ftpSettingsName] ) -- make a shallow copy of ftp properties.
        
        -- note password property is cleared when first editing via popup.
        repeat
            if object.observeFtpPropertyChanges['path'] ~= nil then break end
            if object.observeFtpPropertyChanges['protocol'] ~= nil then break end
            if object.observeFtpPropertyChanges['storePassword'] ~= nil then break end
            if object.observeFtpPropertyChanges['password'] ~= nil then break end
            if object.observeFtpPropertyChanges['passive'] ~= nil then break end
            if object.observeFtpPropertyChanges['title'] ~= nil then break end
            if object.observeFtpPropertyChanges['username'] ~= nil then break end
            if object.observeFtpPropertyChanges['port'] ~= nil then break end
            if object.observeFtpPropertyChanges['server'] ~= nil then break end
            app:callingError( "No ftp properties to observe" )
        until true

        if checkSetting == nil then
            checkSetting = function( ftpProps, name, prev, value )
                return true -- , value - second return obsolete.
            end
        end
        
        local function processChange( name, prevValue, newValue )
        
            local sts, msg = checkSetting( props[ftpSettingsName], name, prevValue, newValue )
            if sts then
                -- setting approved.
            else
                -- props[ftpSettingsName] = prevValue - this does not do any good, since its after the fact -
                    -- lightroom zeros everything out upon entry, then re-populates upon 'OK' button, at which time,
                    -- the ftp properties are locked in.
                if str:is( msg ) then
                    app:show{ warning=msg }
                -- else ignore setting change without complaint.
                end
                return
            end

            if name == 'password' then            

                local pswd = newValue -- convenience var
                -- Note: unlike the other properties, password property is cleared when ftp settings dialog box is opened, and
                -- then set when user closes the form.
                if prevValue ~= nil and pswd == nil then
                    return
                end
                if pswd == nil then
                    pswd = ""
                end
                
                local chars = pswd:len()
                local charsUi
                if app:isVerbose() then
                    charsUi = str:fmt( " (^1 character) ", chars )
                else
                    charsUi = " "
                end
                local key = str:fmt( "^1_^2_ftp", props[ftpSettingsName].server, props[ftpSettingsName].username ) -- update for sftp support. ###3 must match ftp module.
                local unc = LrPasswords.retrieve( key )

                if unc ~= pswd then
                    local answer
                    if chars > 0 then
                        if str:is( unc ) then
                            answer = app:show{ info="Overwrite password in encrypted store with newly entered^3value (for future ftp to '^1' as '^2')? It is recommended to do so, instead of saving a preset with ftp password in plain text.",
                                subs = { props[ftpSettingsName].server, props[ftpSettingsName].username, charsUi },
                                buttons = { dia:btn( "Yes - use encrypted store", 'ok' ), dia:btn( "No - use preset instead", 'other', false ), }, --  dia:btn( "No", 'cancel' ) },
                                actionPrefKey = "Save password in encrypted store",
                            }
                        elseif props[ftpSettingsName].storePassword then
                            answer = 'ok' -- taking the liberty here - if never been stored in encrypted store, and user is entering a password and is presently willing to store unencrypted...
                        else
                            answer = app:show{ info="Save^3password in encrypted store (for future ftp to '^1' as '^2')? It is recommended to do so, instead of saving a preset with ftp password in plain text.",
                                subs = { props[ftpSettingsName].server, props[ftpSettingsName].username, charsUi },
                                buttons = { dia:btn( "Yes", 'ok' ), dia:btn( "No", 'cancel', false ) },
                                actionPrefKey = "Save password in encrypted store",
                            }
                        end
                    else
                        if str:is( unc ) then
                            local ans = app:show{ info="Clear encrypted password too? - not recommended, unless it is your intention to eliminate all password storage and enter the password each time.",
                                buttons = { dia:btn( "Yes", 'ok' ), dia:btn( "No", 'cancel', false ) },
                                actionPrefKey = "Clear blankened password in encrypted store",
                            }
                            if ans == 'ok' then
                                answer = 'other'
                            else
                                app:logVerbose( "User elected not to clear blankened password in encrypted store." )
                                return
                            end
                        else
                            app:logVerbose( "Don't trip - user will be prompted for password on demand and have option to save encrypted or not." )
                            app:show{ info="No passwords will be stored - you will be prompted each time.",
                                actionPrefKey = "No password stored - prompt instead",
                            }
                            return
                        end
                    end
                    if answer == 'ok' then
                        assert( pswd:len() > 0, "unexpected blank password" )
                        LrPasswords.store( key, pswd )
                        assert( LrPasswords.retrieve( key ) == pswd, "no crypt upd" ) -- will not work if pswd is nil.
                        app:logVerbose( "Entered password saved in encrypted storage." )
                        app:show{ info="Entered password^1has been saved in encrypted storage. If password has already been saved as plain text in a preset, now would be a good time to go blanken it (or uncheck 'Store password in preset') and then update the preset.",
                            subs = charsUi,
                            actionPrefKey = "Entered password saved in encrypted storage",
                        }
                    elseif answer == 'other' then
                        LrPasswords.store( key, "" )
                        assert( not str:is( LrPasswords.retrieve( key ) ), "no crypt clr" )
                        app:logVerbose( "Password that was in encrypted storage has been removed." )
                        app:show{ info="Password that was in encrypted storage has been removed.",
                            actionPrefKey = "Password that was in encrypted storage has been removed",
                        }
                    elseif answer == 'cancel' then
                        app:logVerbose( "User elected not to store password in encrypted store." )
                    else
                        app:error( "bad answer" )
                    end                        
                else
                    app:logVerbose( "Password is already in encrypted store." )
                end    

            end -- password
            
            -- protocol is handled via check function.
            
        end
        
        while not shutdown and object.observeFtpPropertyChanges do

            LrTasks.sleep( .1 ) -- its possible (has happened) that watcher gets cleared while sleeping
            
            if object.observeFtpPropertyChanges ~= nil then
                for k, v in pairs( object.observeFtpPropertyChanges ) do
                    local newValue = props[ftpSettingsName][k]
                    if newValue ~= saved[k] then
                        processChange( k, saved[k], newValue )
                        saved[k] = newValue
                    end
                end
            end
            
        end -- while
        
    end, finale=function( call, status, message )
        if not status then
            app:show{ error=message }
        end
    end } )
end



--- Discontinue observation of ftp setting changes. deprecated.
--
--  @deprecated
--
--  @usage This must be called when dialog box is ended.
--
function View:unobserveFtpPropertyChanges( object )
    object.observeFtpPropertyChanges = nil
end



--- Get view items for ftp settings as an array of two arrays containing view items, suitable for a two-row display.
--
--  @param object (table, required) Serves as ID for set-observer. May contain ftpPropertyMap member table with elements:<br>
--         * server = { propName='ftpServer', validationMethodName='checkFtpSetting' },<br>
--         * ... ditto for other ftp-settings, and<br>
--         * remoteDirPathForFtpUploadTest = { propName='customUploadDir', validationMethodName='checkUploadDir' },<br>
--         Note: validation method(s) of object take name, value as param and return sts, msg.
--  @param props (LrObservableTable, required) properties passed to start-dialog box...
--  @param enabledBinding (binding table, optional) if passed, all fields enabling will be contingent upon specified binding.
--
--  @usage starts task to watch for property changes, so you must call end-ftp-settings-view in end-dialog method.
--  @usage So far, it only works for display directly in plugin manager dialog or export/publish dialog.
--  @usage If you want a different physical arrangement..., you can massage the returned items and re-package...
--  @usage To use:<br>
--         local vi = view:getFtpSettingsViewItems( ftpSettings, props, "getPrefBinding" ) -- bind using app--get-pref-binding method.<br>
--         local view = vf:view{ vf:row( vi[1] ), vf:row( vi[2] ) } -- or<br>
--         <br>
--         local vi = view:getFtpSettingsViewItems( ftpSettings, props ) -- default props binding<br>
--         local view = vf:view{ vf:row( vi[1] ), vf:row( vi[2] ) }
--
--  @return defaultView (LrView) default ftp view.
--  @return viewItems (2-D array of view-items, 1st-D is "row", 2nd-D has 3 view items for the "row") in case you want to massage before creating custom view.
--
function View:startFtpSettingsView( object, props, enabledBinding )

--[[
    Example FTP Settings:
    ---------------------
        path = "/testfolder", 
        protocol = "ftp", 
        storePassword = true, -- don't care
        password = "dsf", 
        passive = "normal", 
        title = "Untitled FTP", -- don't care.
        username = "fb159e0f", 
        port = 21, 
        server = "ftp.imemine.com"

    Example FTP Property Map Setup:
    -------------------------------
    self.ftpPropertyMap = {
        server = { propName='ftpServer', validationMethodName='checkFtpSetting' },
        ...
    }
--]]    

    if object == nil then
        app:callingError( "Need object." )
    end
    if type( object  ) ~= 'table' then
        app:callingError( "Object must be table." )
    end
    -- property name map ( defaults to same name as ftp-settings table ).
    local map = {
        server = object.ftpPropertyMap and object.ftpPropertyMap.server and object.ftpPropertyMap.server.propName or 'server',
        username = object.ftpPropertyMap and object.ftpPropertyMap.username and object.ftpPropertyMap.username.propName or 'username',
        password = object.ftpPropertyMap and object.ftpPropertyMap.password and object.ftpPropertyMap.password.propName or 'password',
        protocol = object.ftpPropertyMap and object.ftpPropertyMap.protocol and object.ftpPropertyMap.protocol.propName or 'protocol',
        port = object.ftpPropertyMap and object.ftpPropertyMap.port and object.ftpPropertyMap.port.propName or 'port',
        passive = object.ftpPropertyMap and object.ftpPropertyMap.passive and object.ftpPropertyMap.passive.propName or 'passive',
        path = object.ftpPropertyMap and object.ftpPropertyMap.path and object.ftpPropertyMap.path.propName or 'path',
        remoteDirPathForFtpUploadTest = object.ftpPropertyMap and object.ftpPropertyMap.remoteDirPathForFtpUploadTest and object.ftpPropertyMap.remoteDirPathForFtpUploadTest.propName or 'remoteDirPathForFtpUploadTest',
    }
    -- setting validation methods ( may be nil )
    local validationMethodNames = {
        [map.server] = object.ftpPropertyMap and object.ftpPropertyMap.server and object.ftpPropertyMap.server.validationMethodName,
        [map.username] = object.ftpPropertyMap and object.ftpPropertyMap.username and object.ftpPropertyMap.username.validationMethodName,
        [map.password] = object.ftpPropertyMap and object.ftpPropertyMap.password and object.ftpPropertyMap.password.validationMethodName,
        [map.protocol] = object.ftpPropertyMap and object.ftpPropertyMap.protocol and object.ftpPropertyMap.protocol.validationMethodName,
        [map.port] = object.ftpPropertyMap and object.ftpPropertyMap.port and object.ftpPropertyMap.port.validationMethodName,
        [map.passive] = object.ftpPropertyMap and object.ftpPropertyMap.passive and object.ftpPropertyMap.passive.validationMethodName,
        [map.path] = object.ftpPropertyMap and object.ftpPropertyMap.path and object.ftpPropertyMap.path.validationMethodName,
        [map.path] = object.ftpPropertyMap and object.ftpPropertyMap.path and object.ftpPropertyMap.path.validationMethodName,
        [map.remoteDirPathForFtpUploadTest] = object.ftpPropertyMap and object.ftpPropertyMap.remoteDirPathForFtpUploadTest and object.ftpPropertyMap.remoteDirPathForFtpUploadTest.validationMethodName,
    }
    
    -- reminder: so far, this only works on export/plugin-manager dialog boxes.
	local ftpPresetPopup = LrFtp.makeFtpPresetPopup { 
		factory = vf,
	    properties = props,
	    valueBinding = 'ftpSettingsBuf', -- for internal use only - hardcoding should be fine.
	    itemsBinding = 'ftpItems',       -- not sure how this works anyway... ###4
	    width_in_chars = 30; -- determines data-1 width.
	    width = share '_data_1',
	    tooltip = "FTP Presets - select or edit..., but remember to click 'Use Preset' afterward.",
	    enabled = enabledBinding,
	}
	
	-- compute password-encrypted property:
    local key = str:fmt( "^1_^2_ftp", props[map.server], props[map.username] ) -- , props[map.protocol] ) - I assume the same password would be used whether ftp or sftp.
    local unc = LrPasswords.retrieve( key ) -- encrypted password, unencoded.
    if str:is( unc ) then
  	    props.passwordEncrypted = true
  	else
  	    props.passwordEncrypted = false
  	end
	
	local function encryptPassword()

        local key = str:fmt( "^1_^2_ftp", props[map.server], props[map.username] ) -- , props[map.protocol] ) - I assume the same password would be used whether ftp or sftp.
        local unc = LrPasswords.retrieve( key ) -- encrypted password, unencoded.
        local note = "Note: A chain is only as strong as it's weakest link - consider blankening the password in your FTP preset(s) too..."
        
        local pswd = props[map.password]
        if not str:is( pswd ) then
            if str:is( unc ) then
                local answer = app:show{ confirm="Password to be encrypted is blank, but already encrypted password is not.\n\nDo you want to clear encrypted password?",
                    buttons = { dia:btn( "Yes", 'ok' ) },
                }
                if answer == 'ok' then
                    LrPasswords.store( key, "" ) -- perhaps should store nil, but dunno if that actually clears it ###1.
                else
                    --return
                end
            else
                app:show{ warning="Can't encrypt a blank password." }
                --return
            end
        elseif unc == pswd then
            props[map.password] = ""
            app:show{ warning="That password was already in encrypted storage - still is: no problem...\n\n^1", note }
        else
            local encrypt = false
            if str:is( unc ) and unc ~= pswd then
                local answer = app:show{ confirm="Overwrite password in encrypted store (for logging in to ^1 as ^2)?",
                    subs = { props[map.server], props[map.username] },
                    buttons = { dia:btn( "Yes", 'ok' ) },
                }
                if answer == 'ok' then
                    encrypt = true
                end
            else
                encrypt = true
            end
            if encrypt then
                LrPasswords.store( key, pswd ) -- note: the scope of this is current plugin only.
                props[map.password] = ""
                app:show{ info="Password moved to encrypted store - it will be used for logging in to ^1 as ^2, unless a non-blank password is entered to override it.\n\n^3",
                    subs = { props[map.server], props[map.username], note },
                }
            -- else nuthin'
            end
        end
        
        local unc2 = LrPasswords.retrieve( key ) -- encrypted password, unencoded.
        if str:is( unc2 ) then
      	    props.passwordEncrypted = true
      	else
      	    props.passwordEncrypted = false
      	end

	end
	
    local r = {}
    r[#r + 1] =
        {
            vf:static_text {
                title = "FTP Settings:",
                width = share '_label_1',
            },
            vf:static_text {
                title = "Select Preset, then click 'Use Preset',\nor enter info directly in the fields below.",
                height_in_lines = 2,
                width = share '_data_1',
	            enabled = enabledBinding,
            },
            vf:spacer{ width=1 },
        }
    r[#r + 1] =
        {
            vf:static_text {
                title = "Presets",
                width = share '_label_1',
            },
            ftpPresetPopup,
            vf:push_button {
                title = 'Use Preset',
                tooltip = "Copy settings from FTP preset to fields below.",
	            enabled = enabledBinding,
                action = function( button )
                    app:call( Call:new{ name=button.title, async=true, main=function( call )
                        -- Debug.pause( props.ftpSettingsBuf.passive )
                        if str:is( props[map.server] ) or str:is( props[map.path] ) or str:is( props[map.username] ) then -- check if anything there to worry about...
                            local answer = app:show{ confirm="Overwrite FTP settings with those of selected preset?",
                                buttons = { dia:btn( "OK", 'ok' ) },
                                actionPrefKey = "Use Preset confirmation",
                            }
                            if answer ~= 'ok' then
                                return
                            end
                        end
                        -- Note: without the yield, the changed property handler only runs for the first assignment.
                        -- I'm guessing that's because of the silent recursion guarding, but that's not been verified.
                        -- The silent recursion guarding was added, I *think*, so that changes to properties/prefs made within
                        -- the change handler itself would not result in infinite recursion, or at least not result in double (immediate) recursion interference.
                        -- This may be the source of other bugs in this or other plugins. ###1
                        -- Another solution I've employed elsewhere is just to set the property and the preference both, but that assumes nothing else should
                        -- be done by an observer, which may very well not be true in this case (it's been designed with change-callback handler for values validation...).
                        -- Now that I think about it, the check for get-pref in the change handlers could also be the source of a bug or two - hmmmmm... - not sure what to do about it at the moment.
                        props[map.server] = props.ftpSettingsBuf.server
                        LrTasks.yield()
                        props[map.username] = props.ftpSettingsBuf.username
                        LrTasks.yield()
                        props[map.password] = props.ftpSettingsBuf.password -- may be blanked out, so be sure to query...
                        LrTasks.yield()
                        props[map.protocol] = props.ftpSettingsBuf.protocol
                        LrTasks.yield()
                        props[map.port] = props.ftpSettingsBuf.port
                        LrTasks.yield()
                        props[map.path] = props.ftpSettingsBuf.path
                        LrTasks.yield()
                        props[map.passive] = props.ftpSettingsBuf.passive
                        LrTasks.yield()
                        -- Do not do this: - there is a race condition between the following code and the asynchronous change handler.
                        -- -assert( app:getPref( map.server ) == props[map.server], "Server change not propagated to pref" )
                        -- -assert( app:getPref( map.username ) == props[map.username], "Username change not propagated to pref" ) -- fails here without the yield in between server and username prop set.
                        -- -assert( app:getPref( map.path ) == props[map.path], "Server Path change not propagated to pref" )
                        -- etc.
                        app:show{ info="Values from FTP preset have been copied to this form for use. You can use as is, or edit values in this form.",
                            actionPrefKey = "Use FTP Preset confirmation.",
                        }
                    end } )
                end,
            }
        }
    r[#r + 1] =
        {
            vf:static_text {
                title = "Server",
                width = share '_label_1',
            },
            vf:edit_field {
                bind_to_object = props,
                width = share '_data_1',
                value = bind( map.server ),
                tooltip = "Often something like: ftp.myserver.com or may be same as web server (www.myserver.com). IP address instead of name OK too.",
	            enabled = enabledBinding,
            },
            vf:static_text {
                title = "FTP server host name, or IP",
            },
        }
    r[#r + 1] =
        {
            vf:static_text {
                title = "Server Path",
                width = share '_label_1',
            },
            vf:edit_field {
                bind_to_object = props,
                width = share '_data_1',
                value = bind( map.path ),
                tooltip = "If this starts with a slash, it will be \"absolute\" (root) path. Otherwise, it is relative to server default directory. Trailing slash is a \"don't care\".",
	            enabled = enabledBinding,
            },
            vf:static_text {
                title = "Base directory for file transfers.",
            },
        }
    r[#r + 1] =
        {
            vf:static_text {
                title = "Username",
                width = share '_label_1',
            },
            vf:edit_field {
                bind_to_object = props,
                width = share '_data_1',
                value = bind( map.username ),
                tooltip = "Username for FTP login as provided to you by your FTP service provider.",
	            enabled = enabledBinding,
            },
            vf:static_text {
                title = "Username for FTP login",
            },
        }
    r[#r + 1] =
        {
            vf:static_text {
                title = "Password",
                width = share '_label_1',
            },
            vf:password_field {
                bind_to_object = props,
                width = share '_data_1',
                value = bind( map.password ),            
                tooltip = "Password associated with username for FTP login, as provided to you by your FTP service provider, unless you've changed it. If blank, password will come from encrypted store, or you will be prompted.",
	            enabled = enabledBinding,
            },
            vf:push_button {
                title = "Encrypt",
                tooltip = "Encrypt and store password associated with this server & user, in a safe place, and blanken here.",
                action = function( button )
                    app:call( Call:new{ name=button.title, async=true, guard=App.guardVocal, main=function( call )
                        encryptPassword()                
                    end } )
                end,                
	            enabled = enabledBinding,
            },
            vf:static_text {
                title = "Password is encrypted",
                visible = bind( 'passwordEncrypted' ),
            },
        }
    r[#r + 1] =
        {
            vf:static_text {
                title = "Protocol",
                width = share '_label_1',
            },
            vf:popup_menu {
                bind_to_object = props,
                width = share '_data_1',
                value = bind( map.protocol ),            
                items = { { title='FTP', value='ftp'}, {title='SFTP',value='sftp'} },
                tooltip = "Try FTP if you don't know any better, SFTP if offered by your service provider and/or required.",
	            enabled = enabledBinding,
            },
            vf:static_text {
                title = "FTP is the norm, SFTP if required.",
            },
        }
    r[#r + 1] =
        {
            vf:static_text {
                title = "Port",
                width = share '_label_1',
            },
            vf:edit_field {
                bind_to_object = props,
                width = share '_data_1',
                value = bind( map.port ),            
                min = 0,
                max = 65535,
                precision = 0,
                tooltip = "FTP service providers rarely use non-standard ports, but double-check port number if you can't transfer files.",
	            enabled = enabledBinding,
            },
            vf:static_text {
                title = "Usually 21 for FTP, 22 for SFTP.",
            },
        }
    r[#r + 1] =
        {
            vf:static_text {
                title = "Passive",
                width = share '_label_1',
            },
            vf:popup_menu {
                bind_to_object = props,
                width = share '_data_1',
                value = bind( map.passive ),            
                items = { { title='Normal', value='normal'}, {title='Not Passive',value='none'}, {title="Enhanced",value="enhanced"} },
                tooltip = "Leave at 'Normal' unless not working, or as instructed by your FTP service provider.",
	            enabled = enabledBinding,
            },
            vf:static_text {
                title = "Connection/transfer mode.",
            },
        }
    local omitFileUploadTest = app:getPref( 'omitFileUploadTest' )
    local testButtonTooltip
    if not omitFileUploadTest then
        testButtonTooltip = "'Test FTP Settings' tests basic internet connectivity and FTP login, plus a temp-file upload test too - to be sure everything is OK."
        r[#r + 1] =
            {
                vf:static_text {
                    title = "Remote Dir Path:\n(for Upload Test)",
                    height_in_lines = 2,
                    width = share '_label_1',
                },
                vf:edit_field {
                    value = bind( map.remoteDirPathForFtpUploadTest ),
                    width = share '_data_1',
                    tooltip = "Leave this field blank to test upload to base directory on server, or enter directory sub-path (relative to base directory). Note: trailing slash is a \"don't care\", but this should *not* include a filename!",
	                enabled = enabledBinding,
                },
            }
    else
        testButtonTooltip = "'Test FTP Settings' tests basic internet connectivity and FTP login."
        r[#r + 1] =
            {
                vf:spacer {
                    width = share '_label_1',
                },
                vf:spacer {
                    width = share '_data_1',
                },
            }
    end
    local a = r[#r]
    a[#a + 1] =
        vf:push_button {
            title = "Test FTP Settings",
            tooltip = testButtonTooltip,
	        enabled = enabledBinding,
            action = function( button )
                app:call( Call:new{ name=button.title, async=true, guard=App.guardVocal, main=function( call )
                    local answer
                    if omitFileUploadTest then
                        answer = app:show{ confirm="Proceed to test basic internet connectivity and FTP login?",
                            buttons = { dia:btn( "OK", 'ok' ) },
                            actionPrefKey = "FTP test confirmation",
                        }
                    else
                        answer = app:show{ confirm="Proceed to test basic internet connectivity, FTP login, and test/temp-file upload?",
                            buttons = { dia:btn( "OK", 'ok' ) },
                            actionPrefKey = "FTP test (including upload) confirmation",
                        }
                    end
                    if answer ~= 'ok' then return end
                    local settings = {
                        server = props[map.server],
                        username = props[map.username],
                        password = props[map.password],
                        path = props[map.path],
                        protocol = props[map.protocol],
                        port = props[map.port],
                        passive = props[map.passive],
                    }
                    if not str:is( settings.server ) then
                        app:show{ warning="'Server' can not be blank." }
                        --call:cancel()
                        return
                    end
                    if not str:is( settings.username ) then
                        app:show{ warning="'Username' can not be blank." }
                        --call:cancel()
                        return
                    end
                    if not str:is( settings.path ) then
                        local answer = app:show{ confirm="'Server Path' is blank - not technically forbidden, but rarely correct - continue?",
                            buttons = { dia:btn( "Continue", 'ok' ) },
                            actionPrefKey = "Server path is blank warning.",
                        }
                        if answer ~= 'ok' then
                            --call:cancel()
                            return
                        end
                    end
                    if not str:is( settings.protocol ) then
                        app:show{ warning="'Server Protocol' can not be blank." }
                        --call:cancel()
                        return
                    end
                    if settings.port == nil then
                        app:show{ warning="'Port' can not be blank." }
                        --call:cancel()
                        return
                    end
                    
                    local ftpSubPath = props[map.remoteDirPathForFtpUploadTest]
                    
                    call.scope = LrDialogs.showModalProgressDialog {
                        title = str:fmt( "^1 - ^2", app:getAppName(), call.name ),
                        caption = "Please wait...",
                        cannotCancel = true,
                        functionContext = call.context,
                    }
                    
                    local ftp = Ftp:new{ ftpSettings=settings, autoNegotiate=true }
                    local ok = ftp:queryForPasswordIfNeeded()
                    if not ok then
                        app:logError( "No password." )
                        --call:cancel()
                        return
                    end
                    if not str:is( settings.password ) then
                        app:error( "'Password' can not be blank." )
                    end

                    local s, m = ftp:connect() -- Checks for dir existence at root.
                    if s then
                        app:log( "Connected to '^1' as '^2'.", settings.server, settings.username )
                    else
                        app:show{ warning="Unable to connect to '^1' as '^2' - ^3.\n\nCould mean server, username, or password is bad, but could also mean server path is bad: '^4' - consider browsing for the server path (start by selecting 'Edit' on 'Presets' \"drop-down\" menu), but remember to click 'Use Preset' afterward. Note: if server path starts with '/' it's absolute, otherwise it's relative to server default dir.\n\nIf you can't get this right, contact your FTP service provider. If still no go - consult plugin provider.", settings.server, settings.username, str:to( m ), settings.path }
                        --call:cancel()
                        return
                    end
                    if not omitFileUploadTest then
                        s, m = ftp:calibrateClock( LrPathUtils.getStandardFilePath( 'temp' ), ftpSubPath ) -- clock calibration is required for getting directory contents which is required for validating upload.
                        if s then
                            if str:is( props[map.password] ) then
                                call.scope:done()
                                LrTasks.yield() -- not sure if this is useful.
                                app:show{ info = "Test file uploaded and remote clock calibrated - FTP settings are OK - consider encrypting password now." }
                            else
                                call.scope:done()
                                LrTasks.yield() -- not sure if this is useful.
                                app:show{ info = "Test file uploaded and remote clock calibrated - FTP settings are OK." }
                            end
                        else
                            app:show{ warning="Basic connectivity is OK, but unable to upload test file for remote clock calibration (which is required for validating uploads) - ^1. Server: '^2', Username: '^3'. Server Path '^4' or Remote Dir Path '^5' may not be valid.",
                                subs = { str:to( m ), settings.server, settings.username, settings.path, ftpSubPath or "" },
                            }
                        end
                    else
                        call.scope:done()
                        LrTasks.yield() -- not sure if this is useful.
                        app:show{ info="Basic internet connectivity and FTP login are OK. Note: this does not necessarily mean file transfers will succeed, since they also depend on server path and other settings." }
                    end
                    
                end } )
            end
        }


        --   P R O P E R T Y   W A T C H I N G 

        assert( object ~= nil, "no object" )
        if object.ftpPropertiesToObserve == nil then
            -- this case provided so caller can have benefit of password encryption without necessarily observing/checking for legal values.
            -- object.ftpPropertiesToObserve = { password = true }
            object.ftpPropertiesToObserve = {} -- no longer need to observe password changes.
        else
            assert( type( object.ftpPropertiesToObserve ) == 'table', "property specs should be table (a 'set')" )
        end
        
        local saved = {
            [map.server] = props[map.server],
            [map.username] = props[map.username],
            [map.password] = props[map.password], -- may be blanked out, so be sure to query...
            [map.protocol] = props[map.protocol],
            [map.port] = props[map.port],
            [map.path] = props[map.path],
            [map.passive] = props[map.passive],
            [map.remoteDirPathForFtpUploadTest] = props[map.remoteDirPathForFtpUploadTest]
        }
        
        local function processChange( id, props, name, value )
            app:call( Call:new{ name="Process Change", async=false, guard=App.guardSilent, main=function( call )
        
                if name == map.remoteDirPathForFtpUploadTest then
                    props[name] = Ftp.formatSubPath( value, true ) -- true => trailing slash OK.
                    value = props[name]
                end
            
                local validationMethodName = validationMethodNames[name]
                
                local sts, msg
                if validationMethodName then
                    sts, msg = object[validationMethodName]( object, name, value )
                else
                    sts = true
                end
            
                if sts then
                    -- setting approved - good: all done.
                    saved[name] = props[name]
                else
                    props[name] = saved[name] -- won't trigger a change, due to recustion guard, which is OK, because in essence, it hasn't "changed", so much as it's being put back to where it was.
                    if str:is( msg ) then
                        app:show{ warning=msg }
                    -- else nuthin;
                    end
                end
            end } )
        end
        
        view:setObserver( props, map.remoteDirPathForFtpUploadTest, object, processChange )
        for propName, methodName in pairs( validationMethodNames ) do
            if methodName then
                if object[methodName] ~= nil then
                    if type( object[methodName] ) == 'function' then
                        view:setObserver( props, propName, object, processChange )
                    else
                        app:callingError( "Bad validation method: ^1 - type: ^2", k, type( object[methodName] ) )
                    end
                else
                    app:callingError( "Bad validation method name: ^1", methodName )
                end
            else
                assert( methodName == false, "invalid method name" )
            end
        end

    -- create default view        
    local ftpViewItems = {}
    for i, v in ipairs( r ) do
        ftpViewItems[#ftpViewItems + 1] = vf:row( v )
    end
    local ftpView = vf:view( ftpViewItems )
        
    return ftpView, r
end



--- Get catalog-photo view in a scroller.
--
--  @param args (table) containing:<br>
--             - photos (array, required) photos to view. <br>
--             - fmtMetaSpecs (array, optional) formatted metadata keys to accompany thumbnails. <br>
--             - fmtMeta (array, optional) formatted metadata to accompany thumbnails. <br>
--             - clickBack (function, optional) callback function for clickage. <br>
--             - viewWidth <br>
--             - viewHeight <br>
--             - thumbWidth <br>
--             - thumbHeight <br>
--
function View:getThumbnailsView( args )
    local photos = args.photos or args[1].getRawMetadata and args
    local fmtMetaSpecs = args.fmtMetaSpecs or { 'fileName' }
    local fmtMeta
    local frame_width
    if #fmtMetaSpecs > 0 then
        fmtMeta = args.fmtMeta or catalog:batchGetFormattedMetadata( photos, fmtMetaSpecs )
        frame_width = args.frame_width or 1
    else
        fmtMeta = {}
        frame_width = args.frame_width -- or 0, the default.
    end
    local frame_width = args.frame_width or ( #fmtMetaSpecs > 0 ) and 1 or 0
    local lookup = {}
    local clickBack = function( viewObject )
        app:call( Call:new{ name="Clickback", async=true, guard=App.guardSilent, main=function( call )
            if args.clickBack then
                args.clickBack( viewObject.photo, viewObject ) -- 2nd param usually ignored, but just in case...
            else
                local photo = viewObject.photo
                if photo then
                    Debug.pause( "You clicked", photo:getFormattedMetadata( 'fileName' ) )
                else
                    Debug.pause( "?" )
                end
            end
        end } )
    end
    local vw = args.viewWidth or 800
    local vh = args.viewHeight or 400
    local iw = args.thumbWidth or 200 -- happens to match Adobe default, but it seems like a good number to me too...
    local ih = args.thumbHeight or iw
    local nColumns = args.nColumns or math.max( math.floor( vw / ( iw + 3 ) ), 1 )
    local vi = { width = vw, height = vh }
    local index = 1
    while index <= #photos do
        local col = {}
        for ci = 1, nColumns do
            if index > #photos then
                break
            end
            local photo = photos[index]
            index = index + 1
            col[#col + 1] =
                vf:catalog_photo {
                    photo = photo,
                    width = iw,
                    height = ih,
                    frame_width = frame_width,
                    frame_color = args.frame_color, -- LrColor( 50, 50, 50 ),
                    background_color = args.background_color, -- LrColor( 100, 100, 100 ),
                    mouse_down = clickBack,
                }
            if #fmtMetaSpecs and fmtMeta[photo] then
                local text = {}
                for _, spec in ipairs( fmtMetaSpecs ) do
                    if str:is( fmtMeta[photo][spec] ) then
                        text[#text + 1] = fmtMeta[photo][spec]
                    end
                end
                local nLines = #text
                col[#col] = vf:view {
                    col[#col],
                    vf:static_text {
                        title = table.concat( text, "\n" ),
                        height_in_lines = nLines,
                    }
                }
            end
        end
        if #col then
            vi[#vi + 1] = vf:spacer{ height = args.spacerHeight or 10 }
            vi[#vi + 1] = vf:row( col )
        end
    end
    local v = vf:scrolled_view( vi )
    return v, vi
end



--- Add observer, without having duplicate.
--
function View:setObserver( props, name, id, handler )
    props:removeObserver( name, id )
    props:addObserver( name, id, handler )
end



return View
