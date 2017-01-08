--[[================================================================================
        Lightroom/Lightroom
        
        Supplements LrApplication namespace (Lightroom from an app point of view, as opposed to a plugin point of view...).
================================================================================--]]


local Lightroom = Object:newClass{ className="Lightroom", register=false }



--- Constructor for extending class.
--
function Lightroom:newClass( t )
    return Object.newClass( self, t )
end



--- Constructor for new instance.
--
function Lightroom:new( t )
    local o = Object.new( self, t )
    return o
end



--- Restarts lightroom with current or specified catalog.
--
--  @param catPath (string, default = current catalog) path to catalog to restart with.
--  @param noPrompt (boolean, default = false) set true for no prompting, otherwise user will be prompted prior to restart, if prompt not permanently dismissed that is.
--
--  @usage depends on 'lrApp' pref or global-pref for exe-path in windows environment - if not there, user will be prompted for exe file.
--
function Lightroom:restart( catPath, noPrompt )
    local s, m = app:call( Call:new{ name="Restarting Lightroom", async=false, main=function( call ) -- no guarding "should" be necessary.
        local exe
        local opts
        if not str:is( catPath ) then
            catPath = catalog:getPath()
        end
        local targets = { catPath }
        local doPrompt
        if WIN_ENV then
            exe = app:getPref( "lrApp" ) or app:getGlobalPref( "lrApp" ) -- set one of these in plugin manager or the like, to avoid prompt each time.
            opts = "-restart"
            if not str:is( exe ) or not fso:existsAsFile( exe ) then
                if not str:is( exe ) then
                    app:logVerbose( "Consider setting 'lrApp' in plugin manager or the like." )
                    Debug.pause()
                else
                    app:logWarning( "Lightroom app does not exist here: '^1' - consider changing pref...", exe )
                end
                repeat
                    exe = dia:selectFile{ -- this serves as the "prompt".
                        title = "Select lightroom.exe file for restart.",
                        fileTypes = { "exe" },
                    }
                    if exe ~= nil then
                        if fso:existsAsFile( exe ) then
                            break
                        else
                            app:show{ warning="Nope - try again." }                            
                        end
                    else
                        return false, "user cancelled"
                    end
                until false
            elseif not noPrompt then
                doPrompt = true
            -- else just do it.
            end
            --app:setGlobalPref( "lrApp", exe ) -- not working: seems pref is not commited, even if long sleep.
            --app:sleep( 1 ) -- persist prefs
            --assert( app:getGlobalPref( "lrApp" ) == exe, "no" )
        else
            exe = "open"
            doPrompt = true
        end
        if doPrompt then
            local btn = app:show{ confirm="Lightroom will restart now, if it's OK with you.",
                actionPrefKey = "Restart Lightroom",
            }
            if btn ~= 'ok' then
                return false, "user cancelled"
            end
        -- else don't prompt
        end
        app:executeCommand( exe, opts, targets )
        app:error( "Lightroom should have restarted." )
    end } )
end
   
   
   
return Lightroom 