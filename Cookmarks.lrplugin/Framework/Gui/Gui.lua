--[[
        Gui.lua
--]]

local Gui, dbg = Object:newClass{ className = 'Gui' }


Gui.moduleNames = { "Library", "Develop" } -- these are the only ones used.



--- Constructor for extending class.
--
function Gui:newClass( t )
    return Object.newClass( self, t )
end



--- Constructor for new instance.
--
function Gui:new( t )
    local o = Object.new( self, t )
    return o
end



--- Switch to specified module.
--
--  @param moduleNumber -- 1=library, 2=develop (other modules not supported).
--
--  @usage No guarantees - involve user with a prompt if absolute assurance required.
--
function Gui:switchModule( moduleNumber, mandatory )
    if moduleNumber == nil then
        error( 'Module number must not be nil' )
    end
    moduleNumber = tonumber( moduleNumber ) -- make it a number, if not already a number.
    if moduleNumber >= 1 and moduleNumber <= 2 then -- 
        local s, m 
        if WIN_ENV then
            s, m = app:sendWinAhkKeys( "{Ctrl Down}{Alt Down}" .. moduleNumber .. "{Ctrl Up}{Alt Up}" )
        else
            s, m = app:sendMacEncKeys( "CmdOption-" .. moduleNumber )
        end
        if s then
            -- log verbose externally if desired.
            return true
        elseif not mandatory then
            return s, m -- let failure be dealt with externally, or not.
        else
            repeat
                local btn = app:show{ info="Unable to switch automatically to ^1 module, which is mandatory for operation to succeed. If already in that module, just click 'Already in ^1 Module', otherwise click 'Dismiss dialog for 3 seconds' button, and switch module manually.",
                    subs = { Gui.moduleNames[moduleNumber] },
                    buttons = { dia:btn( str:fmtx( "Already in ^1 Module", Gui.moduleNames[moduleNumber] ), 'ok' ), dia:btn( "Dismiss dialog for 3 seconds", 'other' ) },
                }
                if btn == 'other' then
                    app:sleep( 3 )
                    if shutdown then return false, "shutdown" end
                elseif btn == 'cancel' then
                    return false, "Unable to switch modules."
                else
                    return true
                end
            until false
        end
    else
        return false, "Invalid module number: " .. str:to( moduleNumber )
    end
end
    


return Gui
