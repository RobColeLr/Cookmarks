--[[
        Info.lua
--]]

return {
    appName = "Cookmarks",
    author = "Rob Cole",
    authorsWebsite = "www.robcole.com",
    donateUrl = "http://www.robcole.com/Rob/Donate",
    platforms = { 'Windows', 'Mac' },
    pluginId = "com.robcole.lightroom.Cookmarks",
    xmlRpcUrl = "http://www.robcole.com/Rob/_common/cfpages/XmlRpc.cfm",
    LrPluginName = "RC Cookmarks",
    LrSdkMinimumVersion = 3.0,
    LrSdkVersion = 4.0,
    LrPluginInfoUrl = "http://www.robcole.com/Rob/ProductsAndServices/CookmarksLrPlugin",
    LrPluginInfoProvider = "ExtendedManager.lua",
    LrToolkitIdentifier = "com.robcole.lightroom.Cookmarks",
    LrInitPlugin = "Init.lua",
    LrShutdownPlugin = "Shutdown.lua",
    LrExportMenuItems = {
        { title = "Create a PV2012 Cookmar&k", file = "mCookmark2012.lua" },
        { title = "Create a Legacy Cookmar&k", file = "mCookmarkLegacy.lua" },
    },
    LrMetadataTagsetFactory = "Tagsets.lua",
    URLHandler = "urlHandler.lua",    
    VERSION = { display = "2.1    Build: 2012-07-31 13:36:14" },
}
