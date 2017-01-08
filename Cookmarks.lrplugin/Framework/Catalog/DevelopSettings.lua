--[[
        DevelopSettings.lua

        Object that represents develop settings from a catalog point of view.
--]]


local DevelopSettings, dbg = Object:newClass{ className = "DevelopSettings", register=true }


DevelopSettings.pvCodeLegacy = 1
DevelopSettings.pvCode2012 = 2



--[[
        Note: @1/May/2012 only "writeable" fields are supported, i.e. those supported by cookmarks, dev-adjust, ...
            To use in dev-meta or whatever, they will need to be augmented.
        
        Field notes:
            * table key (string) setting ID in develop-settings table for photo(s).
            * friendly (string) Name for UI.
            * data-type (string) 'boolean', 'number', or 'string'.
            * constraints (optional table) may be required for numerics(???)
              * numeric: min, max
              * string: array of strings.
            * prereq (optional table) name and value of dependent (pre-requisite) setting. - so far, there has only been one of these.
              note: applies-to can be considered a pre-req...
            * appliesTo (number) defaults to "all PV". Bit mask indexed by PV.
            * group (string) for dividing in UI according to group.
            * subGroup (string) for further dividing in UI according to sub-group.
            * subName (string) name for setting when divided by sub-group.
--]]
DevelopSettings.table = { -- static table with all info for all settings.
    -- array of groups
    {   groupName="Basic",
        members={
            { id='AutoTone', friendly="Auto Tone", dataType='boolean' },
            { members = { -- anonymous sub-group
                { id='AutoExposure', friendly="Auto Exposure (Legacy)", dataType='boolean', appliesTo=1 },
                { id='AutoHighlightRecovery', friendly="Auto Highlight Recovery (Legacy)", dataType='boolean', appliesTo=1 }, -- ###1 works?
                { id='AutoShadows', friendly="Auto Shadows (Legacy)", dataType='boolean', appliesTo=1 },
                { id='AutoFillLight', friendly="Auto Fill Light (Legacy)", dataType='boolean', appliesTo=1 }, -- ###1?
                { id='AutoBrightness', friendly="Auto Brightness (Legacy)", dataType='boolean', appliesTo=1 },
                { id='AutoContrast', friendly="Auto Contrast (Legacy)", dataType='boolean', appliesTo=1 },
            }},
            { id='WhiteBalance', friendly="White Balance", dataType ='string', constraints = { "Custom", "As Shot", "Daylight", "Cloudy", "Shade", "Tungsten", "Fluorescent", "Flash", "Auto" } },
            { members = { -- anonymous sub-group
                { id='Temperature', friendly="Temperature (Raw)", dataType = 'number', constraints = { min=-10000, max=10000 }, prereq = { name='WhiteBalance', value='Custom' } },
                { id='Tint', friendly="Tint (Raw)", dataType = 'number', constraints = { min=-100, max=100 }, prereq={ name='WhiteBalance', value='Custom' } },
                { id='IncrementalTemperature', friendly="Temperature (RGB)", dataType = 'number', constraints = { min=-100, max=100 }, prereq = { name='WhiteBalance', value='Custom' } }, -- for RGB files, not raw.
                { id='IncrementalTint', friendly="Tint (RGB)", dataType = 'number', constraints = { min=-100, max=100 }, prereq = { name='WhiteBalance', value='Custom' } }, -- for RGB files, not raw.
            }},
            { id='Exposure2012', friendly="Exposure (2012)", dataType = 'number', constraints = { min=-5, max=5, }, appliesTo=2 },
            { id='Contrast2012', friendly="Contrast (2012)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=2 }, 
            { id='Highlights2012', friendly="Highlights (2012)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=2 }, 
            { id='Shadows2012', friendly="Shadows (2012)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=2 }, 
            { id='Whites2012', friendly="Whites (2012)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=2 }, 
            { id='Blacks2012', friendly="Blacks (2012)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=2 }, 
            { id='Exposure', friendly="Exposure (Legacy)", dataType = 'number', constraints = { min=-4, max=4 }, appliesTo=1 }, 
            { id='HighlightRecovery', friendly="Highlight Recovery (Legacy)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=1 }, 
            { id='Shadows', friendly="Blacks (Legacy)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=1 }, 
            { id='FillLight', friendly="Fill Light (Legacy)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=1 }, 
            { id='Brightness', friendly="Brightness (Legacy)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=1 }, 
            { id='Contrast', friendly="Contrast (Legacy)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=1 }, 
            { members = { -- anonymous sub-group (presence)
                { id='Clarity2012', friendly="Clarity (2012)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=2 }, 
                { id='Clarity', friendly="Clarity (Legacy)", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=1 }, 
                { id='Vibrance', friendly="Vibrance", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='Saturation', friendly="Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
            }},
        },
    },
    {   groupName = "Tone Curve",
        members={
            { id='ParametricShadowSplit', friendly="Parametric Shadow Split", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='ParametricMidtoneSplit', friendly="Parametric Midtone Split", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='ParametricHighlightSplit', friendly="Parametric Highlight Split", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='ParametricShadows', friendly="Parametric Shadows", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='ParametricDarks', friendly="Parametric Darks", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='ParametricLights', friendly="Parametric Lights", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='ParametricHighlights', friendly="Parametric Highlights", dataType = 'number', constraints = { min=-100, max=100 } }, 
        },
    },            
    {   groupName = "HSL",
        members={
            { members={ -- anonymous sub-group (hue)
                { id='HueAdjustmentRed', friendly="Red Hue", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='HueAdjustmentOrange', friendly="Orange Hue", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='HueAdjustmentYellow', friendly="Yellow Hue", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='HueAdjustmentGreen', friendly="Green Hue", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='HueAdjustmentAqua', friendly="Aqua Hue", dataType='number', constraints = { min=-100, max=100 } }, 
                { id='HueAdjustmentBlue', friendly="Blue Hue", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='HueAdjustmentPurple', friendly="Purple Hue", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='HueAdjustmentMagenta', friendly="Magenta Hue", dataType = 'number', constraints = { min=-100, max=100 } },
            }},
            { members={ -- sat
                { id='SaturationAdjustmentRed', friendly="Red Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='SaturationAdjustmentOrange', friendly="Orange Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='SaturationAdjustmentYellow', friendly="Yellow Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='SaturationAdjustmentGreen', friendly="Green Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='SaturationAdjustmentAqua', friendly="Aqua Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='SaturationAdjustmentBlue', friendly="Blue Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='SaturationAdjustmentPurple', friendly="Purple Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='SaturationAdjustmentMagenta', friendly="Magenta Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
            }},
            { members={
                { id='LuminanceAdjustmentRed', friendly="Red Luminance", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LuminanceAdjustmentOrange', friendly="Orange Luminance", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LuminanceAdjustmentYellow', friendly="Yellow Luminance", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LuminanceAdjustmentGreen', friendly="Green Luminance", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LuminanceAdjustmentAqua', friendly="Aqua Luminance", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LuminanceAdjustmentBlue', friendly="Blue Luminance", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LuminanceAdjustmentPurple', friendly="Purple Luminance", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LuminanceAdjustmentMagenta', friendly="Magenta Luminance", dataType = 'number', constraints = { min=-100, max=100 } }, 
            }},
        },
    },
    {   groupName = "B&W",
        members={
            { id='ConvertToGrayscale', friendly="Convert to Black & White", dataType = 'boolean' },
            { id='EnableGrayscaleMix', friendly="Enable Black & White", dataType = 'boolean' }, 
            { members={
                { id='AutoGrayscaleMix', friendly="B&W Auto", dataType = 'boolean' },
                { id='GrayMixerRed', friendly="B&W Red", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='GrayMixerOrange', friendly="B&W Orange", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='GrayMixerYellow', friendly="B&W Yellow", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='GrayMixerGreen', friendly="B&W Green", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='GrayMixerAqua', friendly="B&W Aqua", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='GrayMixerBlue', friendly="B&W Blue", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='GrayMixerPurple', friendly="B&W Purple", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='GrayMixerMagenta', friendly="B&W Magenta", dataType = 'number', constraints = { min=-100, max=100 } }, 
            }},
        },
    },
    {   groupName = "Split Toning",
        members={
            { id='SplitToningHighlightHue', friendly="Split Toning Highlight Hue", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='SplitToningHighlightSaturation', friendly="Split Toning Highlight Saturation", dataType = 'number', constraints = { min=0, max=100 } }, 
            { id='SplitToningBalance', friendly="Split Toning Balance", dataType = 'number', constraints = { min=0, max=100 } }, 
            { id='SplitToningShadowHue', friendly="Split Toning Shadow Hue", dataType = 'number', constraints = { min=-360, max=360 } }, 
            { id='SplitToningShadowSaturation', friendly="Split Toning Shadow Saturation", dataType = 'number', constraints = { min=0, max=100 } }, 
        },
    },
    {   groupName = "Detail",
        members={
            { members={ -- sharpness sub-group
                { id='Sharpness', friendly="Sharpening Amount", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='SharpenRadius', friendly="Sharpening Radius", dataType = 'number', constraints = { min=.5, max=3 } }, 
                { id='SharpenDetail', friendly="Sharpening Detail", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='SharpenEdgeMasking', friendly="Sharpening Masking", dataType = 'number', constraints = { min=-100, max=100 } }, 
            }},
            { members={ -- noise
                { id='LuminanceSmoothing', friendly="Luminance NR", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LuminanceNoiseReductionDetail', friendly="Luminance NR Detail", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LuminanceNoiseReductionContrast', friendly="Luminance NR Contrast", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='ColorNoiseReduction', friendly="Color NR", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='ColorNoiseReductionDetail', friendly="Color NR Detail", dataType = 'number', constraints = { min=-100, max=100 } },
            }},
            
        },
    },
    {   groupName = "Lens Corrections",
        members = {
            { members={ -- profile-based
                { id='LensProfileEnable', friendly="Lens Profile Enable", dataType = 'number', constraints = { 0, 1 } }, 
                { id='LensProfileSetup', friendly="Lens Profile Setup", dataType = 'string' }, -- constraints = "LensDefaults", -- ###1
                -- Not sure where's the Make??? ###1
                { id='LensProfileName', friendly="Lens Profile Name", dataType ='string', prereq = { name='LensProfileEnable', value=1 } }, -- "Adobe (Canon PowerShot G12)", -- ###1
                { id='LensProfileFilename', friendly="Lens Profile Filename", dataType ='string', prereq = { name="LensProfileEnable", value=1 } },-- , "Canon PowerShot G12 - RAW.lcp", -- ###1
                { id='LensProfileDistortionScale', friendly="Lens Profile Distortion Scale", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LensProfileDistortionScale', friendly="Lens Profile Distortion Scale", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='LensProfileVignettingScale', friendly="Lens Profile Vignetting Amount", dataType = 'number', constraints = { min=-100, max=100 } }, 
            }},
            { members={ -- color
                { id='AutoLateralCA', friendly="Remove Chromatic Aberration", dataType = 'number', constraints = { 0, 1 } }, 
                { id='DefringePurpleAmount', friendly="Defringe Purple Amount", dataType='number', constraints = { 0, 20 } },            
                { id='DefringePurpleHueLo', friendly="Defringe Purple Hue - Low", dataType='number', constraints = { 0, 90 } },            
                { id='DefringePurpleHueHi', friendly="Defringe Purple Hue - High", dataType='number', constraints = { 10, 100 } },       
                { id='DefringeGreenAmount', friendly="Defringe Green Amount", dataType='number', constraints = { 0, 20 } },            
                { id='DefringeGreenHueLo', friendly="Defringe Green Hue - Low", dataType='number', constraints = { 0, 90 } },            
                { id='DefringeGreenHueHi', friendly="Defringe Green Hue - High", dataType='number', constraints = { 10, 100 } },
            }},
            { members={ -- manual
                { id='LensManualDistortionAmount', friendly="Lens Manual Distortion Amount", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='PerspectiveVertical', friendly="Lens Manual Perspective Vertial", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='PerspectiveHorizontal', friendly="Perspective Horizontal", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='PerspectiveRotate', friendly="Perspective Rotate", dataType = 'number', constraints = { min=-360, max=360 } }, 
                { id='PerspectiveScale', friendly="Lens Manual Perspective Scale", dataType = 'number', constraints = { min=-200, max=200 } }, 
                { id='CropConstrainToWarp', friendly="Lens Manual Contrain To Warp", dataType = 'number', constraints = { 0, 1 } },
                { id='VignetteMidpoint', friendly="Lens Manual Vignette Midpoint", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='VignetteAmount', friendly="Lens Manual Vignette Amount", dataType = 'number', constraints = { min=-100, max=100 } }, 
            }},
        }            
    },
    {   groupName = "Effects",
        members = {
            { members={ -- post-crop vignetting
                { id='PostCropVignetteStyle', friendly="Post-crop Vignette Style", dataType = 'number', constraints = { 0, 1, 2 } }, -- should be string -> number.
                { id='PostCropVignetteAmount', friendly="Post-crop Vignette Amount", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='PostCropVignetteMidpoint', friendly="Post-crop Vignette Midpoint", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='PostCropVignetteRoundness', friendly="Post-crop Vignette Roundness", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='PostCropVignetteFeather', friendly="Post-crop Vignette Feather", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='PostCropVignetteHighlightContrast', friendly="Post-crop Vignette Highlights", dataType = 'number', constraints = { min=-100, max=100 } }, 
            }},
            { members={ -- grain
                { id='GrainAmount', friendly="Grain Amount", dataType = 'number', constraints = { min=-100, max=100 } }, 
                { id='GrainSize', friendly="Grain Size", dataType = 'number', constraints = { min=0, max=100 } }, 
                { id='GrainFrequency', friendly="Grain Roughness", dataType = 'number', constraints = { min=-100, max=100 } }, 
            }},
        },
    },
    {   groupName = "Camera Calibration",
        members = {
            { id='ProcessVersion', friendly="Process Version", dataType = 'string', constraints = { "5.0", "5.7", "6.6", "6.7" } },
            { id='CameraProfile', friendly="Camera Profile", dataType = 'string' }, -- constraints = "Canon PowerShot G12 Adobe Standard (RC Debright)", -- ###1
            { id='ShadowTint', friendly="Camera Calibration Shadow Tint", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='RedHue', friendly="Primary Red Hue", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='RedSaturation', friendly="Primary Red Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='GreenHue', friendly="Primary Green Hue", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='GreenSaturation', friendly="Primary Green Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='BlueHue', friendly="Primary Blue Hue", dataType = 'number', constraints = { min=-100, max=100 } }, 
            { id='BlueSaturation', friendly="Primary Blue Saturation", dataType = 'number', constraints = { min=-100, max=100 } }, 
        },
    },
    {   groupName = "Enable/Disable Groups",
        members = {
            { members={
                { id='EnableToneCurve', friendly="Enable Tone Curve (broken? ###1)", dataType = 'boolean' }, -- ###1 don't think this works.
            }},
            { id='EnableColorAdjustments', friendly="Enable HSL Adjustments", dataType = 'boolean' }, 
            { id='EnableSplitToning', friendly="Enable Split Toning", dataType = 'boolean' },
            { id='EnableDetail', friendly="Enable Detail", dataType = 'boolean' }, 
            { id='EnableLensCorrections', friendly="Enable Lens Corrections", dataType = 'boolean' }, 
            { id='EnableEffects', friendly="Enable Effects", dataType = 'boolean' }, 
            { id='EnableCalibration', friendly="Enable Camera Calibration", dataType = 'boolean' },
            { members={            
                { id='EnableRetouch', friendly="Enable Retouch", dataType = 'boolean' }, 
                { id='EnableRedEye', friendly="Enable Red-eye", dataType = 'boolean' }, 
                { id='EnableGradientBasedCorrections', friendly="Enable Gradients", dataType = 'boolean' }, 
                { id='EnablePaintBasedCorrections', friendly="Enable Paint", dataType = 'boolean' }, 
            }},
        },
    },
    {   groupName = nil, -- "Unsupported in Lr4",
        members = {
            -- { id='LensProfileChromaticAberrationScale', friendly="Auto Tone", dataType = 'number', constraints = { min=-200, max=200 } }, 
            -- { id='ChromaticAberrationB', friendly="CA Blue", dataType = 'number', constraints = { min=-100, max=100 }, appliesTo=0 }, -- no longer supported in Lr4, for any PV.
            -- { id='ChromaticAberrationR', friendly="CA Red", dataType = 'number', constraints = { min=-100, max=100 } }, 
            -- { id='Defringe', friendly="Defringe", dataType = 'number', constraints = { min=0, max=2 } }, 
        },
    },                        
    {   groupName = nil, -- "Unsupported by Adobe",
        members = {
            --    orientation = "AB",
            --    CropLeft = { min=-10000, max=10000, appliesTo=0 },  -- no sirve...
            --    CropAngle = { min=-1000, max=1000, appliesTo=0 }, -- no sirve...
            --    CropBottom = { dataType = 'number', constraints = { min=-10000, max=10000 } }, 
            --    CropRight = { dataType = 'number', constraints = { min=-10000, max=10000 } }, 
            --    CropTop = { dataType = 'number', constraints = { min=-10000, max=10000 } }, 
        },
    },                        
    {   groupName = nil, -- "Unsupported by Elare Plugin Framework",
        members = {
            --    ToneCurveName2012 = { dataType = 'string' }, -- constraints = "Custom", -- ###1 - not working? - Don't need to manipulate the name directly, maybe - seems just setting parameters or points will do it.
            --    ToneCurveName = { dataType ='string', constraints = { "Medium Contrast", "Linear", "Strong Contrast" }, appliesTo=1 }, -- Could be custom name too. ###1 - not working.
            --[[    ToneCurve = { -- legacy
                    [1] = 0, 
                    [2] = 0, 
                    [3] = 32, 
                    [4] = 22, 
                    [5] = 64, 
                    [6] = 56, 
                    [7] = 128, 
                    [8] = 128, 
                    [9] = 192, 
                    [10] = 196, 
                    [11] = 255, 
                    [12] = 255}, --]]
            --[[    ToneCurvePV2012Red = {
                    [1] = 0, 
                    [2] = 0, 
                    [3] = 255, 
                    [4] = 255}, --]]
            --    RedEyeInfo = { }, - not supported
            --    RetouchInfo = {}, 
            --[[    ToneCurvePV2012 = {
                    [1] = 0, 
                    [2] = 0, 
                    [3] = 120, 
                    [4] = 113, 
                    [5] = 255, 
                    [6] = 255}, --]]
            --[[    ToneCurvePV2012Green = {
                    [1] = 0, 
                    [2] = 0, 
                    [3] = 255, 
                    [4] = 255}, --]]
            --[[    ToneCurvePV2012Blue = {
                    [1] = 0, 
                    [2] = 0, 
                    [3] = 255, 
                    [4] = 255}, --]]
        },
    },
    {   groupName = nil, -- "Unsupported",
        members = {
            --    LensProfileDigest = "973B26A8CCE61821111161707E048A48", 
        },
    }, 
}


--- Constructor for extending class.
--
function DevelopSettings:newClass( t )
    return Object.newClass( self, t )
end



--- Constructor for new instance.
--
--  @usage      Represents the collection of all publish services defined under for a plugin.
--
function DevelopSettings:new( t )
    local o = Object.new( self, t )
    o:_init() -- init settings lookup and item list.
    --o:_initItemList()
    return o
end




function DevelopSettings:_init()
    self.settingLookup = {}
    self.popupItems = {}
    local function add( item )
        if item.appliesTo == 0 then
            return
        end
        self.settingLookup[item.id] = item
        local pItem = { title=item.friendly, value=item }
        self.popupItems[#self.popupItems + 1] = pItem
    end
    for i, group in ipairs( DevelopSettings.table ) do
        repeat
            if group.groupName == nil then
                break -- convenience
            end
            if group.members == nil then
                app:error( "group sans members" )
                -- break
            end
            for j, member in ipairs( group.members ) do
                if member.id then
                    add( member )
                else
                    local pItem = { separator=true }
                    self.popupItems[#self.popupItems + 1] = pItem
                    for ii, submember in ipairs( member.members ) do
                        add( submember )
                    end
                    local pItem = { separator=true }
                    self.popupItems[#self.popupItems + 1] = pItem
                end
            end
            self.popupItems[#self.popupItems + 1] = { separator=true }
        until true
    end
    if self.popupItems[#self.popupItems].separator then
        self.popupItems[#self.popupItems] = nil -- kill extraneous separator.
    end
end



--- Get popup according to specified stipulation (process version - internal string representation).
--
function DevelopSettings:getPopupMenuItems( pv )
    if pv == nil then
        return self.popupItems
    else
        local cuz = {}
        local sep = false
        for i, item in ipairs( self.popupItems ) do
            if item.value ~= nil then
                if item.value.appliesTo ~= nil then
                    if item.value.appliesTo == pv then
                        cuz[#cuz + 1] = item
                        sep = false
                    -- else
                    end
                else
                    cuz[#cuz + 1] = item
                    sep = false
                end
            else -- include separators
                if not sep then -- protect from 2 successive separators, in case a group or sub-group is empty.
                    cuz[#cuz + 1] = item
                    sep = true
                end
            end
        end
        if sep then
            cuz[#cuz] = nil -- kill extraneous separator.
        end
        return cuz
    end
end



--- Get lookup table for setting ID to setting spec.
--
function DevelopSettings:getLookup()
    return self.settingLookup
end



--- Adjust specified settings.
--
--  @param photos (array of LrPhoto, reauired) photos to adjust.
--  @param undoTitle (string, reauired) alias: presetName.
--  @param ments (table, required) adjust-ments to make, as a table of name/value pairs.
--  @param tmo (number, default=10) seconds to wait for catalog - ignored if already has write access.
--
--  @usage will wrap with catalog accessor if need be.
--  @usage synchronous - must be called from async task.
--
--  @return status.
--  @return message
--
function DevelopSettings:adjustPhotos( photos, undoTitle, ments, tmo )
    return app:call( Call:new{ name=undoTitle, async=false, main=function( call )
        local function adjust()
            local preset = LrApplication.addDevelopPresetForPlugin( _PLUGIN, undoTitle, ments )
            if preset then
                app:logVerbose( "Got preset named '^1'", undoTitle )
            else
                error( "No preset" )
            end
            for i, photo in ipairs( photos ) do
                photo:applyDevelopPreset( preset, _PLUGIN )
            end
        end
        if catalog.hasWriteAccess then
            adjust()
        else
            local s, m = cat:update( tmo or 10, call.name, adjust )
            if not s then
                error( m )
            end
        end
    end } )
end



return DevelopSettings
