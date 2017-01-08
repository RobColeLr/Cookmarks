---
title: Cookmarks Lightroom Plugin
subtitle: Relative adjustment of develop settings - presets via bookmarks.
...

# Introduction

You can use your browser to adjust photos in Lightroom, by clicking on links or bookmarks. Unconventional perhaps, but very useful indeed...

## Featuring:

-   **Supports all develop settings** except for point curves and locals.
-   **Any adjustment amount**, small or large...
-   **Absolute adjustments** can be mixed in too.
-   **User-friendly URL generator** for on-the-fly adjustments - can be bookmarked for reuse in the future.

## System Requirements

-   **Lightroom 4**
-   **Works equally well on Mac or Windows.**

***See the readme file after downloading for usage and other notes.***

## Cookmarks FAQ (Frequently Asked Questions)

**(no particular order)**

------------------------------------------------------------------------

These FAQs come partly from users, and partly from my imagination. Please let me know if there are errors or omissions in this FAQ - thanks.

NOTE: The following Q&A's assume that the plugin is working as I expect... If, after your best effort, still "no go", please let me know.

------------------------------------------------------------------------

[Question:]{.question} Why would I ever need or want such a thing as Cookmarks?

[Answer:]{.answer}

-   Cookmarks allow you to make relative adjustments to your photos, like Lightroom's Quick Develop, except:
    -   It supports all settings.
    -   You can adjust settings by any amount.
    -   Does not require the Library module.
    -   Multiple adjustments can be saved for future use - like presets, except stored/used/organized via your browser's bookmark/favorites feature.
-   Cookmarks also supports mixing of absolute and relative adjustments, so you can set one or more thing absolutely along with making relative adjustments to other things.

------------------------------------------------------------------------

[Question:]{.question} How does it work?

[Answer:]{.answer} Lightroom plugins can handle URL's that are issued using the 'lightroom' protocol. So the cookmarks plugin gets all the develop setting adjustments from lightroom URLs issued via your browser, and applys them to selected photo(s).

------------------------------------------------------------------------

[Question:]{.question} How do I get started?

[Answer:]{.answer} At some point, I may post some bookmarks for you to import. For now, simply create a bookmark and enter an appropriate URL - see below for syntax, examples, and a bunch of ready-made links you can bookmark and optionally modify. Also, the cookmarks plugin has an item on the file menu for creating the location (URL) to be used in cookin' bookmarks.

------------------------------------------------------------------------

[Question:]{.question} How to create a custom bookmark in my browser?

[Answer:]{.answer} Since there is no page to bookmark, you have to create the bookmark using the context menu or equivalent. For example, in Firefox:

1.  Right/ctrl-click a bookmark folder and select 'New Bookmark'.
2.  'Name' can be whatever you like.
3.  'Location' is the URL.

------------------------------------------------------------------------

[Question:]{.question} What does "Queue full" mean?

[Answer:]{.answer} If you click a bookmark, while cookmarks is still busy with the previous request, the incoming URL is put in a queue, if there's room. If no room in the queue, then you'll see the above warning - remedy is to wait a moment, then try again.

------------------------------------------------------------------------

[Question:]{.question} In the advanced settings, what is format of the prefix option for the edit history?

[Answer:]{.answer} `{date}{id}{time} {settings}`, where:

-   `{date}` is `YYMMDD`
-   `{id}` is `CM`, meaning "CookMarks"
-   `{time}` is `HHMMSS`
-   `{settings}` are the adjustments. If you can't see them all, use a wider panel max (see tip elsewhere on this page).

------------------------------------------------------------------------

[Question:]{.question} Any other hot tips?

[Answer:]{.answer} Yes:

-   Put `$/locale_metric/Mac/Panel/maxWidth=900`/`$/locale_metric/Win/Panel/maxWidth=900` in a file named `TranslatedStrings.txt` in a subdirectory named `Resources/{language}` of the directory containing your lightroom executable, so you can open the left panel wide enough to see the entire line of cookmarks edit-history. `{language}` should be a 2-character code, e.g. `en` for "English". Or, just use Jeffrey Friedl's online configurator to widen..., link: <http://regex.info/Lightroom/Config/>
-   Use 2 monitors:
    -   Right-hand monitor for Lightroom in a window, with right-hand panel open but as narrow as possible.
    -   Extend Lightroom window leftward onto left monitor so that only the left panel is on it, at full/maximum width.
    -   On left part of left monitor, open a different browser than your default, and use it only for cookmarks, and use it as your exclusive Lightroom control panel, instead of Lightroom proper, except for tone/point curve tweaks and locals.
    -   This setup allows your image to be as large as possible during development, but with both panels open wide... - next best thing to full-screen editing.

------------------------------------------------------------------------

[Question:]{.question} What are some of Cookmarks' limitations and what are your plans for it's future?

[Answer:]{.answer}

1.  It's a little tricky to create the URL's - the user interface is not as sophisticated as it could be.
2.  It's a little tricky to create the bookmarks, without a real page to bookmark.
3.  'Twould be nice to support parameterized cookmark links on this page, like for cam-cal profile or presets.
4.  Presets must be created for each magnitude of application and for reversing effects too (or use Lightroom undo/edit-history).

------------------------------------------------------------------------

## Cookmark URL syntax

It's simplest to *use the Cookmark URL generator on the file menu (plugin extras), so you never have to learn the cookmark url syntax*. But, for those do-it-yerself'rs:

`lightroom://com.robcole.lightroom.Cookmarks/\[i\]{name}={value}&\[i\]{name}={value}...`

The complete list of names is available in the drop-down list in the URL generator.

*Note: Prefix names with 'i' to make them incremental (relative).*

[Examples:]{#examples}

-   `lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=5&iClarity2012=-5`
    -   Increase PV2012 contrast by 5 and reduce clarity by 5.
-   `lightroom://com.robcole.lightroom.Cookmarks/Contrast2012=15`
    -   Set PV2012 contrast to 15.
-   `lightroom://com.robcole.lightroom.Cookmarks/Preset/Clear Edit History`
    -   Special expression for applying a regular Lightroom develop preset.

@v2.0:

-   `lightroom://com.robcole.lightroom.Cookmarks/Multiplier/5/iContrast2012=2&iClarity2012=-2`
    -   Increase PV2012 contrast by 10 and reduce clarity by 10.
-   `lightroom://com.robcole.lightroom.Cookmarks/Preset/Black//White`
    -   Apply Black/White preset. Note: if preset name has a `/` in it, you will need to "escape" it by adding an extra slash. Same goes for other things like lens profile names...

Next section has a full complement of links you can use as is, or as examples... - of course they can be bookmarked too, er - I mean "cookmarked" ;-)

Remember to try the special 'Hello' link below first, after installing plugin.

## How to create a cookmark

Reminder: Bookmarks (aka "Favorites") are how custom cookmark develop presets are saved for re-use.

`File Menu → RC Cookmarks → Create a Cookmark`

1.  Select an item
2.  Enter a value
3.  If numeric adjustment, then check the 'Relative' box, unless you want to make an absolute adjustment.
4.  Click 'Add'

When finished, copy the URL onto the clipboard and paste it into the field of your browser's bookmark properties labeled "Location" or "URL".

Consult your browser documentation for help on creating custom bookmarks.

e.g. in Firefox, you right/ctrl-click on a bookmark folder and select 'New Bookmark'.

You can also bookmark the cookmark links on this page below. To change the URL, right/ctrl-click the bookmark and choose 'Properties'.

# Cookmark Links (for adjusting selected photos in Lightroom)

*If you haven't already done so, install cookmarks plugin and assure it is enabled.*

Note: Some links are for PV2012 only, others are for PV2010/03 only - they should be so indicated. If no indication, they should be universal.

**Reminder: The links below are hot - If you have Lightroom running (and cookmarks plugin installed and enabled) you *will* be adjusting selected photos when you click them. There's a prompt to warn you the first time, but after that - you're on your own!**

On this page, there links for several combined adjustments, as well as links for each individual adjustment except lens corrections and camera calibration. The cookmarks plugin supports lens corrections and camera calibration too - all settings except crop, orientation, and tone-curve-enable.

Feel free to bookmark these as a starting point for your own cookmark presets.

Note: In the right column, the +1 settings are listed.

*Due to the image-adaptive nature of PV2012, these settings sometimes do not do exactly what's advertised without a little tweak afterward.*

## Special

Note: Always try 'Hello' link first, after installing cookmarks plugin...

|                                                                                                         |                                                                                                                                                                                                                                                                                                                                                                                                            |
|---------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Hello](lightroom://com.robcole.lightroom.Cookmarks/Hello)                                              | Verify cookmarks plugin is enabled, without modifying any photos. After clicking the 'Hello' link, a dialog box should pop up in Lightroom, confirming cookmarks plugin is ready for photo adjustments...                                                                                                                                                                                                  |
| [Preset: Clear Edit History](lightroom://com.robcole.lightroom.Cookmarks/Preset/Clear%20Edit%20History) | *In order for this to work, **you must first create a preset in Lightroom named 'Clear Edit History'*** - this is just an example of how to issue presets via cookmarks. PS - to create a "clear edit history" preset, just create a blank preset then edit with a text editor and enter ClearEditHistory = true as it's only setting. Note: it will only clear top of edit history - not the whole thing. |
| [Test Error Handling](lightroom://com.robcole.lightroom.Cookmarks/Error=For%20Sure...)                  | See if errors are being handled appropriately - hint: try 'Hello' first.                                                                                                                                                                                                                                                                                                                                   |

[Special] | [Basics] | [Tone PV2012] | [Color] | [Black&White] | [Split Toning] | [Detail] | [Effects] | [Tone+Color Combos] | [PV2010/03]

## Basics

Auto Tone

[-10](lightroom://com.robcole.lightroom.Cookmarks/Mult/-1/AutoTone)
[-5](lightroom://com.robcole.lightroom.Cookmarks/Mult/-.5/AutoTone)
[-3](lightroom://com.robcole.lightroom.Cookmarks/Mult/-.3/AutoTone)
[-2](lightroom://com.robcole.lightroom.Cookmarks/Mult/-.2/AutoTone)
[-1](lightroom://com.robcole.lightroom.Cookmarks/Mult/-.1/AutoTone)
[+1](lightroom://com.robcole.lightroom.Cookmarks/Mult/.1/AutoTone)
[+2](lightroom://com.robcole.lightroom.Cookmarks/Mult/.2/AutoTone)
[+3](lightroom://com.robcole.lightroom.Cookmarks/Mult/.3/AutoTone)
[+5](lightroom://com.robcole.lightroom.Cookmarks/Mult/.5/AutoTone)
[+10](lightroom://com.robcole.lightroom.Cookmarks/Mult/1/AutoTone)

Percent auto-toning: +1=10%, +10=100%

Instructions: First, edit photo manually, as best you can. Then, try 10% or 20% movement toward auto-toned values (for example). If it makes it a little better, consider clicking it again... Maybe tweak a particular setting which is getting a little "off course", then click again... - try it!

*White Balance*

Note: Temperature & Tint adjustments will go much faster if already set to 'Custom'.

|               |                                                                           |                                                                               |                                                                       |                                                                               |                                                                           |                                                                         |                                                                               |                                                                                     |                                                                         |
|---------------|---------------------------------------------------------------------------|-------------------------------------------------------------------------------|-----------------------------------------------------------------------|-------------------------------------------------------------------------------|---------------------------------------------------------------------------|-------------------------------------------------------------------------|-------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
| White Balance | [Custom](lightroom://com.robcole.lightroom.Cookmarks/WhiteBalance=Custom) | [As Shot](lightroom://com.robcole.lightroom.Cookmarks/WhiteBalance=As%20Shot) | [Auto](lightroom://com.robcole.lightroom.Cookmarks/WhiteBalance=Auto) | [Daylight](lightroom://com.robcole.lightroom.Cookmarks/WhiteBalance=Daylight) | [Cloudy](lightroom://com.robcole.lightroom.Cookmarks/WhiteBalance=Cloudy) | [Shade](lightroom://com.robcole.lightroom.Cookmarks/WhiteBalance=Shade) | [Tungsten](lightroom://com.robcole.lightroom.Cookmarks/WhiteBalance=Tungsten) | [Fluorescent](lightroom://com.robcole.lightroom.Cookmarks/WhiteBalance=Fluorescent) | [Flash](lightroom://com.robcole.lightroom.Cookmarks/WhiteBalance=Flash) |

\
|                 |                                                                                |                                                                                |                                                                              |                                                                              |                                                                              |                                                                              |                                                                             |                                                                             |                                                                             |                                                                             |                                                                               |                                                                               |                            |
|-----------------|--------------------------------------------------------------------------------|--------------------------------------------------------------------------------|------------------------------------------------------------------------------|------------------------------------------------------------------------------|------------------------------------------------------------------------------|------------------------------------------------------------------------------|-----------------------------------------------------------------------------|-----------------------------------------------------------------------------|-----------------------------------------------------------------------------|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------|-------------------------------------------------------------------------------|----------------------------|
| Temperature     | [-30](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=-1500)          | [-10](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=-500)           | [-5](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=-250)          | [-3](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=-150)          | [-2](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=-100)          | [-1](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=-50)           | [+1](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=50)           | [+2](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=100)          | [+3](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=150)          | [+5](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=250)          | [+10](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=500)           | [+30](lightroom://com.robcole.lightroom.Cookmarks/iTemperature=1500)          | +temperature(50) Raw only. |
| Tint            | [-30](lightroom://com.robcole.lightroom.Cookmarks/iTint=-30)                   | [-10](lightroom://com.robcole.lightroom.Cookmarks/iTint=-10)                   | [-5](lightroom://com.robcole.lightroom.Cookmarks/iTint=-5)                   | [-3](lightroom://com.robcole.lightroom.Cookmarks/iTint=-3)                   | [-2](lightroom://com.robcole.lightroom.Cookmarks/iTint=-2)                   | [-1](lightroom://com.robcole.lightroom.Cookmarks/iTint=-1)                   | [+1](lightroom://com.robcole.lightroom.Cookmarks/iTint=1)                   | [+2](lightroom://com.robcole.lightroom.Cookmarks/iTint=2)                   | [+3](lightroom://com.robcole.lightroom.Cookmarks/iTint=3)                   | [+5](lightroom://com.robcole.lightroom.Cookmarks/iTint=5)                   | [+10](lightroom://com.robcole.lightroom.Cookmarks/iTint=10)                   | [+30](lightroom://com.robcole.lightroom.Cookmarks/iTint=30)                   | +tint(1) Raw only.         |
|                 |                                                                                |                                                                                |                                                                              |                                                                              |                                                                              |                                                                              |                                                                             |                                                                             |                                                                             |                                                                             |                                                                               |                                                                               |                            |
| RGB Temperature | [-30](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=-30) | [-10](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=-10) | [-5](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=-5) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=-3) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=-2) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=-1) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=1) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=2) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=3) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=5) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=10) | [+30](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTemperature=30) | +temperature(1) RGB only.  |
| RGB Tint        | [-30](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=-30)        | [-10](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=-10)        | [-5](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=-5)        | [-3](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=-3)        | [-2](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=-2)        | [-1](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=-1)        | [+1](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=1)        | [+2](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=2)        | [+3](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=3)        | [+5](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=5)        | [+10](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=10)        | [+30](lightroom://com.robcole.lightroom.Cookmarks/iIncrementalTint=30)        | +tint(1) RGB only.         |

*Tone PV2012*

|            |                                                                        |                                                                        |                                                                      |                                                                      |                                                                      |                                                                      |                                                                     |                                                                     |                                                                     |                                                                     |                                                                       |                                                                       |                |
|------------|------------------------------------------------------------------------|------------------------------------------------------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|---------------------------------------------------------------------|---------------------------------------------------------------------|---------------------------------------------------------------------|---------------------------------------------------------------------|-----------------------------------------------------------------------|-----------------------------------------------------------------------|----------------|
| Exposure   | [-30](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.3)   | [-10](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.1)   | [-5](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.05) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.03) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.02) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.01) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.01) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.02) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.03) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.05) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.1)   | [+30](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.3)   | +exposure(.01) |
| Contrast   | [-30](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-30)   | [-10](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-10)   | [-5](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-5)   | [-3](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-3)   | [-2](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-2)   | [-1](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-1)   | [+1](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=1)   | [+2](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=2)   | [+3](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=3)   | [+5](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=5)   | [+10](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=10)   | [+30](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=30)   | +contrast(1)   |
|            |                                                                        |                                                                        |                                                                      |                                                                      |                                                                      |                                                                      |                                                                     |                                                                     |                                                                     |                                                                     |                                                                       |                                                                       |                |
| Highlights | [-30](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-30) | [-10](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-10) | [-5](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-5) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-3) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-2) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-1) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=1) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=2) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=3) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=5) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=10) | [+30](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=30) | +highlights(1) |
| Shadows    | [-30](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=-30)    | [-10](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=-10)    | [-5](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=-5)    | [-3](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=-3)    | [-2](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=-2)    | [-1](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=-1)    | [+1](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=1)    | [+2](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=2)    | [+3](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=3)    | [+5](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=5)    | [+10](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=10)    | [+30](lightroom://com.robcole.lightroom.Cookmarks/iShadows2012=30)    | +shadows(1)    |
|            |                                                                        |                                                                        |                                                                      |                                                                      |                                                                      |                                                                      |                                                                     |                                                                     |                                                                     |                                                                     |                                                                       |                                                                       |                |
| Whites     | [-30](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-30)     | [-10](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-10)     | [-5](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-5)     | [-3](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-3)     | [-2](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-2)     | [-1](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-1)     | [+1](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=1)     | [+2](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=2)     | [+3](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=3)     | [+5](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=5)     | [+10](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=10)     | [+30](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=30)     | +whites(1)     |
| Blacks     | [-30](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-30)     | [-10](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-10)     | [-5](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-5)     | [-3](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-3)     | [-2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-2)     | [-1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-1)     | [+1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=1)     | [+2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=2)     | [+3](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=3)     | [+5](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=5)     | [+10](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=10)     | [+30](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=30)     | +blacks(1)     |

*Presence*

|              |                                                                     |                                                                     |                                                                   |                                                                   |                                                                   |                                                                   |                                                                  |                                                                  |                                                                  |                                                                  |                                                                    |                                                                    |                          |
|--------------|---------------------------------------------------------------------|---------------------------------------------------------------------|-------------------------------------------------------------------|-------------------------------------------------------------------|-------------------------------------------------------------------|-------------------------------------------------------------------|------------------------------------------------------------------|------------------------------------------------------------------|------------------------------------------------------------------|------------------------------------------------------------------|--------------------------------------------------------------------|--------------------------------------------------------------------|--------------------------|
| Clarity 2012 | [-30](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-30) | [-10](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-10) | [-5](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-5) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-3) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-2) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-1) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=1) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=2) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=3) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=5) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=10) | [+30](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=30) | +clarity(1) PV2012 only. |
| Sharpness    | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-30)   | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-10)   | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-5)   | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-3)   | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-2)   | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-1)   | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=1)   | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=2)   | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=3)   | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=5)   | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=10)   | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=30)   | +sharpening(1) amount.   |
|              |                                                                     |                                                                     |                                                                   |                                                                   |                                                                   |                                                                   |                                                                  |                                                                  |                                                                  |                                                                  |                                                                    |                                                                    |                          |
| Vibrance     | [-30](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=-30)    | [-10](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=-10)    | [-5](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=-5)    | [-3](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=-3)    | [-2](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=-2)    | [-1](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=-1)    | [+1](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=1)    | [+2](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=2)    | [+3](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=3)    | [+5](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=5)    | [+10](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=10)    | [+30](lightroom://com.robcole.lightroom.Cookmarks/iVibrance=30)    | +vibrance(1)             |
| Saturation   | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=-30)  | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=-10)  | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=-5)  | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=-3)  | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=-2)  | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=-1)  | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=1)  | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=2)  | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=3)  | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=5)  | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=10)  | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSaturation=30)  | +saturation(1)           |

[Special] | [Basics] | [Tone PV2012] | [Color] | [Black&White] | [Split Toning] | [Detail] | [Effects] | [Tone+Color Combos] | [PV2010/03]

## Tone PV2012

Definitions:

-   Symmetrical - Highlight and shadows values will be adjusted by the same amount, but in opposite directions, thus maintaining highlight/shadow symmetry.

*Symmetrical*

Exposure + Fill
[-30](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.3&iHighlights2012=30&iShadows2012=-30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.1&iHighlights2012=10&iShadows2012=-10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.05&iHighlights2012=5&iShadows2012=-5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.03&iHighlights2012=3&iShadows2012=-3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.02&iHighlights2012=2&iShadows2012=-2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.01&iHighlights2012=1&iShadows2012=-1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.01&iHighlights2012=-1&iShadows2012=1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.02&iHighlights2012=-2&iShadows2012=2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.03&iHighlights2012=-3&iShadows2012=3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.05&iHighlights2012=-5&iShadows2012=5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.1&iHighlights2012=-10&iShadows2012=10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.3&iHighlights2012=-30&iShadows2012=30)
[](http://web.archive.org/web/20130303033922/http://www.robcole.com/Rob/ProductsAndServices/CookmarksLrPlugin/footnote_1) +exposure(.01) -highlights(1) +shadows(1)

 
This is the closest thing Lr4 has to Lr3 fill light. It uses +shadows to fill dark tones, +exposure to fill midtones and highlights, and -highlights to reduce highlight fill. Although it will brighten the blacks a little bit, not that much due to PV2012 design. If you are having difficulties getting enough fill this way, consider tossing in some +blacks, or reducing contrast. You can also add a local gradient to increase shadow fill. If still not enough try the tone curve, if still not enough, use locals (paint). If you could stand some more shadow detail, try clarity.

Sometimes a good one to start with, when photo needs both darks & mids brightened...

 
 
 
 
 
 
 
 
 
 
 
 
 
 
Fill (Progressive)
[-30](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.3&iShadows2012=-60&iHighlights2012=60&iBlacks2012=6)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.1&iShadows2012=-20&iHighlights2012=20&iBlacks2012=2)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.05&iShadows2012=-10&iHighlights2012=10&iBlacks2012=1)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.03&iShadows2012=-6&iHighlights2012=6&iBlacks2012=.6)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.02&iShadows2012=-4&iHighlights2012=4&iBlacks2012=.4)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.01&iShadows2012=-2&iHighlights2012=2&iBlacks2012=.2)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.01&iShadows2012=2&iHighlights2012=-2&iBlacks2012=-.2)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.02&iShadows2012=4&iHighlights2012=-4&iBlacks2012=-.4)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.03&iShadows2012=6&iHighlights2012=-6&iBlacks2012=-.6)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.05&iShadows2012=10&iHighlights2012=-10&iBlacks2012=-1)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.1&iShadows2012=20&iHighlights2012=-20&iBlacks2012=-2)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.3&iShadows2012=60&iHighlights2012=-60&iBlacks2012=-6)
+exposure(.01) +shadows(2) -highlights(2) -blacks(-.02)
 
Similar to 'Exposure + Fill', except easier on the exposure, and keeps blacks well-seated to maintain maximum intra-shadow contrast.

Toss this one into the mix when you need more fill, but mids are nearly bright enough already, and blacks are becoming unclipped too much.

 
 
 
 
 
 
 
 
 
 
 
 
 
 
Combined Fill
[-30](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-30&iShadows2012=-30&iHighlights2012=30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-10&iShadows2012=-10&iHighlights2012=10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-5&iShadows2012=-5&iHighlights2012=5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-3&iShadows2012=-3&iHighlights2012=3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-2&iShadows2012=-2&iHighlights2012=2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-1&iShadows2012=-1&iHighlights2012=1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=1&iShadows2012=1&iHighlights2012=-1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=2&iShadows2012=2&iHighlights2012=-2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=3&iShadows2012=3&iHighlights2012=-3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=5&iShadows2012=5&iHighlights2012=-5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=10&iShadows2012=10&iHighlights2012=-10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=30&iShadows2012=30&iHighlights2012=-30)
+blacks(1) +shadows(1) -highlights(1)
 
Fills shadows using both blacks and shadows sliders (without overbrightening highlights). This is good when your shadows have plenty of contrast already, but still need more fill.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Bottom Drop
[-30](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=30&iShadows2012=-30&iHighlights2012=30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=10&iShadows2012=-10&iHighlights2012=10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=5&iShadows2012=-5&iHighlights2012=5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=3&iShadows2012=-3&iHighlights2012=3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=2&iShadows2012=-2&iHighlights2012=2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=1&iShadows2012=-1&iHighlights2012=1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-1&iShadows2012=1&iHighlights2012=-1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-2&iShadows2012=2&iHighlights2012=-2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-3&iShadows2012=3&iHighlights2012=-3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-5&iShadows2012=5&iHighlights2012=-5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-10&iShadows2012=10&iHighlights2012=-10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-30&iShadows2012=30&iHighlights2012=-30)
-blacks(1) +shadows(1) -highlights(1)
 
Drops the bottom end of the photograph down. This is good for left-shifting photo tones, without losing right end, and without over-darkening the shadows in the process.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Contrast/Saturation
[-30](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-90&iSaturation=30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-30&iSaturation=10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-15&iSaturation=5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-9&iSaturation=3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-6&iSaturation=2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-3&iSaturation=1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=3&iSaturation=-1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=6&iSaturation=-1)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=9&iSaturation=-3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=15&iSaturation=-5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=30&iSaturation=-10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=90&iSaturation=-30)
+contrast(3) -saturation(1)
 
Increase contrast without over saturating. Note: I often use this in reverse (negative values) to decrease contrast without losing saturation - for when more shadow fill and/or highlight stratification is needed, and its OK or desirable to reduce midtone contrast in the doing...
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Highlights/Shadows
[-30](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-30&iShadows2012=30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-10&iShadows2012=10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-5&iShadows2012=5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-3&iShadows2012=3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-2&iShadows2012=2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=-1&iShadows2012=1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=1&iShadows2012=-1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=2&iShadows2012=-2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=3&iShadows2012=-3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=5&iShadows2012=-5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=10&iShadows2012=-10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iHighlights2012=30&iShadows2012=-30)
+highlights(1) -shadows(1)
 
Positive values for when other adjustments have resulted in overly reduced highlights and over-filled shadows. Negative values for the opposite.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Clarity/Contrast
[-30](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-30&iContrast2012=30&iHighlights2012=-30&iShadows2012=30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-10&iContrast2012=10&iHighlights2012=-10&iShadows2012=10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-5&iContrast2012=5&iHighlights2012=-5&iShadows2012=5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-3&iContrast2012=3&iHighlights2012=-3&iShadows2012=3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-2&iContrast2012=2&iHighlights2012=-2&iShadows2012=2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-1&iContrast2012=1&iHighlights2012=-1&iShadows2012=1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=1&iContrast2012=-1&iHighlights2012=1&iShadows2012=-1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=2&iContrast2012=-2&iHighlights2012=2&iShadows2012=-2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=3&iContrast2012=-3&iHighlights2012=3&iShadows2012=-3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=5&iContrast2012=-5&iHighlights2012=5&iShadows2012=-5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=10&iContrast2012=-10&iHighlights2012=10&iShadows2012=-10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=30&iContrast2012=-30&iHighlights2012=30&iShadows2012=-30)
+clarity(1) -contrast(1) +highlights(1) -shadows(1)
 
Positive values replace global contrast with local contrast. Negative values replace clarity with global midtone contrast.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Midtone Contrast
[-30](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-30&iHighlights2012=30&iShadows2012=-30&iSaturation=10)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-10&iHighlights2012=10&iShadows2012=-10&iSaturation=3)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-5&iHighlights2012=5&iShadows2012=-5&iSaturation=1.7)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-3&iHighlights2012=3&iShadows2012=-3&iSaturation=3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-2&iHighlights2012=2&iShadows2012=-2&iSaturation=.7)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=-1&iHighlights2012=1&iShadows2012=-1&iSaturation=.3)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=1&iHighlights2012=-1&iShadows2012=1&iSaturation=-.3)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=2&iHighlights2012=-2&iShadows2012=2&iSaturation=-.7)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=3&iHighlights2012=-3&iShadows2012=3&iSaturation=-1)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=5&iHighlights2012=-5&iShadows2012=5&iSaturation=-1.7)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=10&iHighlights2012=-10&iShadows2012=10&iSaturation=-3)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iContrast2012=30&iHighlights2012=-30&iShadows2012=30&iSaturation=-10)
+contrast(1) -highlights(1) +shadows(1) -saturation(.3)
 
Positive values increase midtone contrast, without overbrightening highlights or over-compressing shadows, and without over-saturating.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Highlight extension/contrast
[-30](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-30&iExposure2012=.3)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-10&iExposure2012=.1)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-5&iExposure2012=.05)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-3&iExposure2012=.03)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-2&iExposure2012=.02)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-1&iExposure2012=.01)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=1&iExposure2012=-.01)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=2&iExposure2012=-.02)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=3&iExposure2012=-.03)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=5&iExposure2012=-.05)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=10&iExposure2012=-.1)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=30&iExposure2012=-.3&)
+whites(1) -exposure(.01)
 
Positive values extend/expand the highlights. There will be a corresponding reduction in midtone and shadow brightness.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Intra-highlight contrast
[-30](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-30&iExposure2012=.18&iHighlights2012=12&iShadows2012=-12)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-10&iExposure2012=.06&iHighlights2012=4&iShadows2012=-4)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-5&iExposure2012=.03&iHighlights2012=2&iShadows2012=-2)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-3&iExposure2012=.018&iHighlights2012=1.2&iShadows2012=-1.2)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-2&iExposure2012=.012&iHighlights2012=.8&iShadows2012=-.8)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-1&iExposure2012=.006&iHighlights2012=.4&iShadows2012=-.4)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=1&iExposure2012=-.006&iHighlights2012=-.4&iShadows2012=.4)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=2&iExposure2012=-.012&iHighlights2012=-.8&iShadows2012=.8)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=3&iExposure2012=-.018&iHighlights2012=-1.2&iShadows2012=1.2)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=5&iExposure2012=-.03&iHighlights2012=-2&iShadows2012=2)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=10&iExposure2012=-.06&iHighlights2012=-4&iShadows2012=4)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=30&iExposure2012=-.18&iHighlights2012=-12&iShadows2012=12)
+whites(1) -exposure(.006) -highlights(.4) +shadows(.4)
 
Extends and expands the highlights, but without the corresponding reduction in midtone and shadow brightness.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Whites Recovery
[-30](lightroom://com.robcole.lightroom.Cookmarks/Mult/-30/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[-10](lightroom://com.robcole.lightroom.Cookmarks/Mult/-10/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[-5](lightroom://com.robcole.lightroom.Cookmarks/Mult/-5/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[-3](lightroom://com.robcole.lightroom.Cookmarks/Mult/-3/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[-2](lightroom://com.robcole.lightroom.Cookmarks/Mult/-2/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[-1](lightroom://com.robcole.lightroom.Cookmarks/Mult/-1/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/Mult/1/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/Mult/2/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[+3](lightroom://com.robcole.lightroom.Cookmarks/Mult/3/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[+5](lightroom://com.robcole.lightroom.Cookmarks/Mult/5/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[+10](lightroom://com.robcole.lightroom.Cookmarks/Mult/10/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
[+30](lightroom://com.robcole.lightroom.Cookmarks/Mult/30/iWhites2012=-2&iExposure2012=+.01&iContrast2012=1)
-whites(2) +exposure(.01) +contrast(1)
Intra-whites Contrast
[-30](lightroom://com.robcole.lightroom.Cookmarks/Mult/-100/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[-10](lightroom://com.robcole.lightroom.Cookmarks/Mult/-33.3/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[-5](lightroom://com.robcole.lightroom.Cookmarks/Mult/-17.7/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[-3](lightroom://com.robcole.lightroom.Cookmarks/Mult/-10/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[-2](lightroom://com.robcole.lightroom.Cookmarks/Mult/-6.7/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[-1](lightroom://com.robcole.lightroom.Cookmarks/Mult/-3.3/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/Mult/3.3/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/Mult/6.7/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[+3](lightroom://com.robcole.lightroom.Cookmarks/Mult/10/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[+5](lightroom://com.robcole.lightroom.Cookmarks/Mult/17.7/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[+10](lightroom://com.robcole.lightroom.Cookmarks/Mult/33.3/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
[+30](lightroom://com.robcole.lightroom.Cookmarks/Mult/100/ParametricHighlightSplit=90&iParametricHighlights=-.8&iParametricLights=-.4&iParametricDarks=-.2&iParametricShadows=-.1&iWhites2012=+.1&iExposure2012=+.005&iContrast2012=+.2&iHighlights2012=-.1&iShadows2012=+.1&iBlacks2012=-.1)
absolute adjustment of parametric tone curve: highlight split = 90, accompanied by relative adjustment of tone curve to debrighten, with upward inflection in whites. Also, a myriad of slider adjustments...
 
Enhances definition of whites (brightest tones of any color). Good for bright clouds, snow, waterfalls, white flowers, white wedding dresses...

Consider shifting parametric midtone and shadow splitters leftward after using, to keep from losing intra-highlight contrast.

 

*Asymmetrical*

Extended Fill
To undo it, use Lightroom proper.
[+1](lightroom://com.robcole.lightroom.Cookmarks/Shadows2012=100&Blacks2012=3&iWhites2012=1&iExposure2012=-.01&iHighlights2012=-1&iContrast2012=-1&ParametricShadowSplit=25&ParametricMidtoneSplit=50&ParametricHighlightSplit=75&ParametricShadows=3&ParametricDarks=-6&ParametricLights=-3&ParametricHighlights=-1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/Shadows2012=100&Blacks2012=6&iWhites2012=2&iExposure2012=-.02&iHighlights2012=-2&iContrast2012=-2&ParametricShadowSplit=25&ParametricMidtoneSplit=50&ParametricHighlightSplit=75&ParametricShadows=6&ParametricDarks=-12&ParametricLights=-6&ParametricHighlights=-2)
[+4](lightroom://com.robcole.lightroom.Cookmarks/Shadows2012=100&Blacks2012=12&iWhites2012=4&iExposure2012=-.04&iHighlights2012=-4&iContrast2012=-4&ParametricShadowSplit=25&ParametricMidtoneSplit=50&ParametricHighlightSplit=75&ParametricShadows=9&ParametricDarks=-18&ParametricLights=-9&ParametricHighlights=-3)
[+8](lightroom://com.robcole.lightroom.Cookmarks/Shadows2012=100&Blacks2012=25&iWhites2012=8&iExposure2012=-.08&iHighlights2012=-8&iContrast2012=-8&ParametricShadowSplit=25&ParametricMidtoneSplit=50&ParametricHighlightSplit=75&ParametricShadows=12&ParametricDarks=-24&ParametricLights=-12&ParametricHighlights=-4)
[+16](lightroom://com.robcole.lightroom.Cookmarks/Shadows2012=100&Blacks2012=50&iWhites2012=16&iExposure2012=-.16&iHighlights2012=-16&iContrast2012=-16&ParametricShadowSplit=25&ParametricMidtoneSplit=50&ParametricHighlightSplit=75&ParametricShadows=15&ParametricDarks=-30&ParametricLights=-15&ParametricHighlights=-5)
[+32](lightroom://com.robcole.lightroom.Cookmarks/Shadows2012=100&Blacks2012=100&iWhites2012=32&iExposure2012=-.32&iHighlights2012=-32&iContrast2012=-32&ParametricShadowSplit=25&ParametricMidtoneSplit=50&ParametricHighlightSplit=75&ParametricShadows=18&ParametricDarks=-36&ParametricLights=-18&ParametricHighlights=-6)
 
Mix of absolute and relative. Max shadows, with varying amounts of +blacks too, and other (relative) adjustments. Raw or RGB.
 
For those times when you need more bottom-end oomph than shadow slider alone can provide (without increasing exposure). Won't overbrighten highlights.

\*\*\* Includes absolute adjustment of parametric tone curve.

 
 
 
 
 
 
 
 
 
 
Deep Fill, Ultimate
To undo it, use Lightroom proper.
[Do It (Raw)](lightroom://com.robcole.lightroom.Cookmarks/Blacks2012=100&Shadows2012=100&ParametricShadowSplit=10&ParametricMidtoneSplit=50&ParametricHighlightSplit=90&ParametricShadows=40&ParametricDarks=-40&ParametricLights=-30&ParametricHighlights=-20&iExposure2012=-1&iWhites2012=30&iSaturation=-10&iVibrance=-10&iClarity2012=20&iTemperature=-200&iTint=2)
Starts with max shadows and max blacks, then mixes in some compensations and tone curve.
 
Fill deepest tones most - you'll need to make some adjustments to exposure, contrast, highlights and/or whites afterward, maybe even clarity and color/vib/sat. This can be used to accomplish an effect similar to Lr3 fill-light, in cases when more conventional PV2012 shadow fill techniques ain't cuttin' it. Raw files only.
 
 
 
 
Deep Fill, Ultimate
To undo it, use Lightroom proper.
[Do It (RGB)](lightroom://com.robcole.lightroom.Cookmarks/Blacks2012=100&Shadows2012=100&ParametricShadowSplit=10&ParametricMidtoneSplit=50&ParametricHighlightSplit=90&ParametricShadows=40&ParametricDarks=-40&ParametricLights=-30&ParametricHighlights=-20&iExposure2012=-1&iWhites2012=30&iSaturation=-10&iVibrance=-10&iClarity2012=20&iIncrementalTemperature=-2&iIncrementalTint=1)
Ditto, but for RGB files, not raw files.
Reduce Shadow Detail
To undo it, use Lightroom proper.
[+1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=3&iShadows2012=-3&iHighlights2012=-1&iContrast2012=1&ParametricShadowSplit=10&ParametricMidtoneSplit=50&ParametricHighlightSplit=90&ParametricShadows=-6&ParametricDarks=2&ParametricLights=0&ParametricHighlights=0)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=6&iShadows2012=-6&iHighlights2012=-3&iContrast2012=2&ParametricShadowSplit=10&ParametricMidtoneSplit=50&ParametricHighlightSplit=90&ParametricShadows=-12&ParametricDarks=4&ParametricLights=0&ParametricHighlights=0)
[+4](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=12&iShadows2012=-12&iHighlights2012=-6&iContrast2012=4&ParametricShadowSplit=10&ParametricMidtoneSplit=50&ParametricHighlightSplit=90&ParametricShadows=-18&ParametricDarks=6&ParametricLights=0&ParametricHighlights=0)
[+8](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=24&iShadows2012=-24&iHighlights2012=-12&iContrast2012=8&ParametricShadowSplit=10&ParametricMidtoneSplit=50&ParametricHighlightSplit=90&ParametricShadows=-24&ParametricDarks=8&ParametricLights=0&ParametricHighlights=0)
[+16](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=48&iShadows2012=-48&iHighlights2012=-24&iContrast2012=16&ParametricShadowSplit=10&ParametricMidtoneSplit=50&ParametricHighlightSplit=90&ParametricShadows=-30&ParametricDarks=10&ParametricLights=0&ParametricHighlights=0)
[+32](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=96&iShadows2012=-96&iHighlights2012=-48&iContrast2012=32&ParametricShadowSplit=10&ParametricMidtoneSplit=50&ParametricHighlightSplit=90&ParametricShadows=-36&ParametricDarks=12&ParametricLights=0&ParametricHighlights=0)
 
Compress shadows, deepest tones most.
 
Guts of this are +blacks -shadows +contrast -highlights, but:

\*\*\* Includes absolute adjustment of tone curve.

 
 
 
 
 
 
 
 
 
 
Blacks/Shadows
[-32](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-96&iShadows2012=32&iContrast2012=-32&iHighlights2012=64)
[-16](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-48&iShadows2012=16&iContrast2012=-16&iHighlights2012=32)
[-8](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-24&iShadows2012=8&iContrast2012=-8&iHighlights2012=16)
[-4](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-12&iShadows2012=4&iContrast2012=-4&iHighlights2012=8)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-6&iShadows2012=2&iContrast2012=-2&iHighlights2012=4)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-3&iShadows2012=1&iContrast2012=-1&iHighlights2012=2)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=3&iShadows2012=-1&iContrast2012=1&iHighlights2012=-2)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=6&iShadows2012=-2&iContrast2012=2&iHighlights2012=-4)
[+4](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=12&iShadows2012=-4&iContrast2012=4&iHighlights2012=-8)
[+8](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=24&iShadows2012=-8&iContrast2012=8&iHighlights2012=-16)
[+16](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=48&iShadows2012=-16&iContrast2012=16&iHighlights2012=-32)
[+32](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=96&iShadows2012=-32&iContrast2012=32&iHighlights2012=-64)
 
Switches the balance of fill to use more blacks and less shadows.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Contrast/Blacks
[-32](lightroom://com.robcole.lightroom.Cookmarks/Mult/-32/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[-16](lightroom://com.robcole.lightroom.Cookmarks/Mult/-16/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[-8](lightroom://com.robcole.lightroom.Cookmarks/Mult/-8/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[-4](lightroom://com.robcole.lightroom.Cookmarks/Mult/-4/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[-2](lightroom://com.robcole.lightroom.Cookmarks/Mult/-2/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/Mult/-1/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[+1](lightroom://com.robcole.lightroom.Cookmarks/Mult/1/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[+2](lightroom://com.robcole.lightroom.Cookmarks/Mult/2/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[+4](lightroom://com.robcole.lightroom.Cookmarks/Mult/4/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[+8](lightroom://com.robcole.lightroom.Cookmarks/Mult/8/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[+16](lightroom://com.robcole.lightroom.Cookmarks/Mult/16/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
[+32](lightroom://com.robcole.lightroom.Cookmarks/Mult/32/iContrast2012=1&iBlacks2012=1&iHighlights2012=-.5&iSaturation=-.2)
 
+contrast(1) +blacks(1) -highlights(.5) -saturation(.2)
 
Sometimes I use the negative version of this to reduce contrast in favor of pulling the blacks back.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Brighten & compress highlights
[-32](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-64&iShadows2012=32&iContrast2012=-32&iSaturation=16&iHighlights2012=32)
[-16](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-32&iShadows2012=16&iContrast2012=-16&iSaturation=8&iHighlights2012=16)
[-8](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-16&iShadows2012=8&iContrast2012=-8&iSaturation=4&iHighlights2012=8)
[-4](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-8&iShadows2012=4&iContrast2012=-4&iSaturation=2&iHighlights2012=4)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-4&iShadows2012=2&iContrast2012=-2&iSaturation=1&iHighlights2012=2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=-2&iShadows2012=1&iContrast2012=-1&iSaturation=.5&iHighlights2012=1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=2&iShadows2012=-1&iContrast2012=1&iSaturation=-.5&iHighlights2012=-1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=4&iShadows2012=-2&iContrast2012=2&iSaturation=-1&iHighlights2012=-2)
[+4](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=8&iShadows2012=-4&iContrast2012=4&iSaturation=-2&iHighlights2012=-4)
[+8](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=16&iShadows2012=-8&iContrast2012=8&iSaturation=-4&iHighlights2012=-8)
[+16](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=32&iShadows2012=-16&iContrast2012=16&iSaturation=-8&iHighlights2012=-16)
[+32](lightroom://com.robcole.lightroom.Cookmarks/iBlacks2012=64&iShadows2012=-32&iContrast2012=32&iSaturation=-16&iHighlights2012=-32)
 
+blacks(2) -shadows(1) +contrast(1) -saturation(.5) -highlights(1)
 
In a nutshell: Brightens shadows and midtones, compresses highlights.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Clarity Light
[-32](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-96&iBlacks2012=-32&iHighlights2012=32)
[-16](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-48&iBlacks2012=-16&iHighlights2012=16)
[-8](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-24&iBlacks2012=-8&iHighlights2012=8)
[-4](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-12&iBlacks2012=-4&iHighlights2012=4)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-6&iBlacks2012=-2&iHighlights2012=2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-3&iBlacks2012=-1&iHighlights2012=1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=3&iBlacks2012=1&iHighlights2012=-1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=6&iBlacks2012=2&iHighlights2012=-2)
[+4](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=12&iBlacks2012=4&iHighlights2012=-4)
[+8](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=24&iBlacks2012=8&iHighlights2012=-8)
[+16](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=48&iBlacks2012=16&iHighlights2012=-16)
[+32](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=96&iBlacks2012=32&iHighlights2012=-32)
 
+clarity(3) +blacks(1) -highlights(1)
 
Increases clarity, but in a way that keeps from too much darkening. Will brighten photos slightly, but won't overbrighten highlights.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Midtone Clarity
[-32](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-96&iBlacks2012=-48&iShadows2012=32&iHighlights2012=32&iContrast2012=32)
[-16](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-48&iBlacks2012=-24&iShadows2012=16&iHighlights2012=16&iContrast2012=16)
[-8](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-24&iBlacks2012=-12&iShadows2012=8&iHighlights2012=8&iContrast2012=8)
[-4](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-12&iBlacks2012=-6&iShadows2012=4&iHighlights2012=4&iContrast2012=4)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-6&iBlacks2012=-3&iShadows2012=2&iHighlights2012=2&iContrast2012=2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=-3&iBlacks2012=-1.5&iShadows2012=1&iHighlights2012=1&iContrast2012=1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=3&iBlacks2012=1.5&iShadows2012=-1&iHighlights2012=-1&iContrast2012=-1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=6&iBlacks2012=3&iShadows2012=-2&iHighlights2012=-2&iContrast2012=-2)
[+4](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=12&iBlacks2012=6&iShadows2012=-4&iHighlights2012=-4&iContrast2012=-4)
[+8](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=24&iBlacks2012=12&iShadows2012=-8&iHighlights2012=-8&iContrast2012=-8)
[+16](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=48&iBlacks2012=24&iShadows2012=-16&iHighlights2012=-16&iContrast2012=-16)
[+32](lightroom://com.robcole.lightroom.Cookmarks/iClarity2012=96&iBlacks2012=48&iShadows2012=-32&iHighlights2012=-32&iContrast2012=-32)
 
+clarity(3) +blacks(1.5) -shadows(1) -highlights(1) -contrast(1)
 
Increases clarity, somewhat confining it's effect to the midtones.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Midtone Brightness
[-30](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.3&iHighlights2012=60&iShadows2012=60)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.1&iHighlights2012=20&iShadows2012=20)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.05&iHighlights2012=10&iShadows2012=10)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.03&iHighlights2012=6&iShadows2012=6)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.02&iHighlights2012=4&iShadows2012=4)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=-.01&iHighlights2012=2&iShadows2012=2)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.01&iHighlights2012=-2&iShadows2012=-2)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.02&iHighlights2012=-4&iShadows2012=-4)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.03&iHighlights2012=-6&iShadows2012=-6)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.05&iHighlights2012=-10&iShadows2012=-10)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.1&iHighlights2012=-20&iShadows2012=-20)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iExposure2012=.3&iHighlights2012=-60&iShadows2012=-60)
 
+exposure(.01) -highlights(2) -shadows(2)
 
I most often use this toward the end of editing, to fine tune the midtone level, without impacting the shadows or highlights too much.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
[Special] | [Basics] | [Tone PV2012] | [Color] | [Black&White] | [Split Toning] | [Detail] | [Effects] | [Tone+Color Combos] | [PV2010/03]

## Color

|                   |                                                                                                              |                                                                                                               |                                                                                                            |                                                                                                            |                                                                                                            |                                                                                                            |                                                                                                          |                                                                                                          |                                                                                                          |                                                                                                          |                                                                                                             |                                                                                                             |                                                                              |
|-------------------|--------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------|
| Red Hue           | [-30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=-30)                                     | [-10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=-10)                                      | [-5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=-5)                                     | [-3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=-3)                                     | [-2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=-2)                                     | [-1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=-1)                                     | [+1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=1)                                    | [+2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=2)                                    | [+3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=3)                                    | [+5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=5)                                    | [+10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=10)                                     | [+30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentRed=30)                                     |                                                                              |
| Orange Hue        | [-30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=-30)                                  | [-10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=-10)                                   | [-5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=-5)                                  | [-3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=-3)                                  | [-2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=-2)                                  | [-1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=-1)                                  | [+1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=1)                                 | [+2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=2)                                 | [+3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=3)                                 | [+5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=5)                                 | [+10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=10)                                  | [+30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentOrange=30)                                  |                                                                              |
| Yellow Hue        | [-30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=-30)                                  | [-10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=-10)                                   | [-5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=-5)                                  | [-3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=-3)                                  | [-2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=-2)                                  | [-1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=-1)                                  | [+1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=1)                                 | [+2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=2)                                 | [+3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=3)                                 | [+5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=5)                                 | [+10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=10)                                  | [+30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentYellow=30)                                  |                                                                              |
| Green Hue         | [-30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=-30)                                   | [-10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=-10)                                    | [-5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=-5)                                   | [-3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=-3)                                   | [-2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=-2)                                   | [-1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=-1)                                   | [+1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=1)                                  | [+2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=2)                                  | [+3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=3)                                  | [+5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=5)                                  | [+10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=10)                                   | [+30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentGreen=30)                                   |                                                                              |
| Aqua Hue          | [-30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=-30)                                    | [-10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=-10)                                     | [-5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=-5)                                    | [-3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=-3)                                    | [-2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=-2)                                    | [-1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=-1)                                    | [+1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=1)                                   | [+2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=2)                                   | [+3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=3)                                   | [+5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=5)                                   | [+10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=10)                                    | [+30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentAqua=30)                                    |                                                                              |
| Blue Hue          | [-30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=-30)                                    | [-10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=-10)                                     | [-5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=-5)                                    | [-3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=-3)                                    | [-2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=-2)                                    | [-1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=-1)                                    | [+1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=1)                                   | [+2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=2)                                   | [+3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=3)                                   | [+5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=5)                                   | [+10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=10)                                    | [+30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentBlue=30)                                    |                                                                              |
| Purple Hue        | [-30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=-30)                                  | [-10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=-10)                                   | [-5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=-5)                                  | [-3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=-3)                                  | [-2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=-2)                                  | [-1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=-1)                                  | [+1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=1)                                 | [+2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=2)                                 | [+3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=3)                                 | [+5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=5)                                 | [+10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=10)                                  | [+30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentPurple=30)                                  |                                                                              |
| Magenta Hue       | [-30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=-30)                                 | [-10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=-10)                                  | [-5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=-5)                                 | [-3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=-3)                                 | [-2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=-2)                                 | [-1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=-1)                                 | [+1](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=1)                                | [+2](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=2)                                | [+3](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=3)                                | [+5](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=5)                                | [+10](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=10)                                 | [+30](lightroom://com.robcole.lightroom.Cookmarks/iHueAdjustmentMagenta=30)                                 |                                                                              |
|                   |                                                                                                              |                                                                                                               |                                                                                                            |                                                                                                            |                                                                                                            |                                                                                                            |                                                                                                          |                                                                                                          |                                                                                                          |                                                                                                          |                                                                                                             |                                                                                                             |                                                                              |
| Red Sat           | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=-30)                              | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=-10)                               | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=-5)                              | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=-3)                              | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=-2)                              | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=-1)                              | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=1)                             | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=2)                             | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=3)                             | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=5)                             | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=10)                              | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentRed=30)                              |                                                                              |
| Orange Sat        | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=-30)                           | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=-10)                            | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=-5)                           | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=-3)                           | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=-2)                           | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=-1)                           | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=1)                          | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=2)                          | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=3)                          | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=5)                          | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=10)                           | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentOrange=30)                           |                                                                              |
| Yellow Sat        | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=-30)                           | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=-10)                            | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=-5)                           | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=-3)                           | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=-2)                           | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=-1)                           | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=1)                          | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=2)                          | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=3)                          | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=5)                          | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=10)                           | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentYellow=30)                           |                                                                              |
| Green Sat         | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=-30)                            | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=-10)                             | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=-5)                            | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=-3)                            | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=-2)                            | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=-1)                            | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=1)                           | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=2)                           | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=3)                           | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=5)                           | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=10)                            | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentGreen=30)                            |                                                                              |
| Aqua Sat          | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=-30)                             | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=-10)                              | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=-5)                             | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=-3)                             | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=-2)                             | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=-1)                             | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=1)                            | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=2)                            | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=3)                            | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=5)                            | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=10)                             | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentAqua=30)                             |                                                                              |
| Blue Sat          | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-30)                             | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-10)                              | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-5)                             | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-3)                             | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-2)                             | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-1)                             | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=1)                            | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=2)                            | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=3)                            | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=5)                            | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=10)                             | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=30)                             |                                                                              |
| Purple Sat        | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=-30)                           | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=-10)                            | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=-5)                           | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=-3)                           | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=-2)                           | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=-1)                           | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=1)                          | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=2)                          | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=3)                          | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=5)                          | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=10)                           | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentPurple=30)                           |                                                                              |
| Magenta Sat       | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=-30)                          | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=-10)                           | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=-5)                          | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=-3)                          | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=-2)                          | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=-1)                          | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=1)                         | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=2)                         | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=3)                         | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=5)                         | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=10)                          | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentMagenta=30)                          |                                                                              |
|                   |                                                                                                              |                                                                                                               |                                                                                                            |                                                                                                            |                                                                                                            |                                                                                                            |                                                                                                          |                                                                                                          |                                                                                                          |                                                                                                          |                                                                                                             |                                                                                                             |                                                                              |
| Red Lum           | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=-30)                               | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=-10)                                | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=-5)                               | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=-3)                               | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=-2)                               | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=-1)                               | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=1)                              | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=2)                              | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=3)                              | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=5)                              | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=10)                               | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentRed=30)                               |                                                                              |
| Orange Lum        | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=-30)                            | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=-10)                             | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=-5)                            | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=-3)                            | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=-2)                            | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=-1)                            | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=1)                           | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=2)                           | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=3)                           | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=5)                           | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=10)                            | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentOrange=30)                            |                                                                              |
| Yellow Lum        | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=-30)                            | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=-10)                             | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=-5)                            | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=-3)                            | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=-2)                            | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=-1)                            | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=1)                           | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=2)                           | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=3)                           | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=5)                           | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=10)                            | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentYellow=30)                            |                                                                              |
| Green Lum         | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=-30)                             | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=-10)                              | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=-5)                             | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=-3)                             | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=-2)                             | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=-1)                             | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=1)                            | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=2)                            | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=3)                            | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=5)                            | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=10)                             | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentGreen=30)                             |                                                                              |
| Aqua Lum          | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=-30)                              | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=-10)                               | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=-5)                              | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=-3)                              | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=-2)                              | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=-1)                              | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=1)                             | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=2)                             | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=3)                             | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=5)                             | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=10)                              | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentAqua=30)                              |                                                                              |
| Blue Lum          | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=-30)                              | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=-10)                               | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=-5)                              | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=-3)                              | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=-2)                              | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=-1)                              | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=1)                             | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=2)                             | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=3)                             | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=5)                             | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=10)                              | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentBlue=30)                              |                                                                              |
| Purple Lum        | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=-30)                            | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=-10)                             | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=-5)                            | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=-3)                            | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=-2)                            | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=-1)                            | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=1)                           | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=2)                           | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=3)                           | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=5)                           | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=10)                            | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentPurple=30)                            |                                                                              |
| Magenta Lum       | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=-30)                           | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=-10)                            | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=-5)                           | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=-3)                           | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=-2)                           | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=-1)                           | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=1)                          | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=2)                          | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=3)                          | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=5)                          | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=10)                           | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceAdjustmentMagenta=30)                           |                                                                              |
|                   |                                                                                                              |                                                                                                               |                                                                                                            |                                                                                                            |                                                                                                            |                                                                                                            |                                                                                                          |                                                                                                          |                                                                                                          |                                                                                                          |                                                                                                             |                                                                                                             |                                                                              |
| Brighten Blue Sky | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-30&iLuminanceAdjustmentBlue=-1) | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-10&iLuminanceAdjustmentBlue=-10) | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-5&iLuminanceAdjustmentBlue=-5) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-3&iLuminanceAdjustmentBlue=-3) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-2&iLuminanceAdjustmentBlue=-2) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=-1&iLuminanceAdjustmentBlue=-1) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=1&iLuminanceAdjustmentBlue=1) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=2&iLuminanceAdjustmentBlue=2) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=3&iLuminanceAdjustmentBlue=3) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=5&iLuminanceAdjustmentBlue=5) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=10&iLuminanceAdjustmentBlue=10) | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSaturationAdjustmentBlue=30&iLuminanceAdjustmentBlue=30) | Without desaturating too much. Warning: affects \*all\* blues, not just sky. |

[Special] | [Basics] | [Tone PV2012] | [Color] | [Black&White] | [Split Toning] | [Detail] | [Effects] | [Tone+Color Combos] | [PV2010/03]

## Black&White

Black&White
[Colored](lightroom://com.robcole.lightroom.Cookmarks/ConvertToGrayscale=false)
[Black&White](lightroom://com.robcole.lightroom.Cookmarks/ConvertToGrayscale=true)
[Automix](lightroom://com.robcole.lightroom.Cookmarks/AutoGrayscaleMix=true)
Automix requires Black&White first.
 
 
 
 
Red
[-30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=-30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=-10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=-5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=-3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=-2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=-1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerRed=30)
 
Orange
[-30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=-30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=-10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=-5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=-3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=-2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=-1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerOrange=30)
 
Yellow
[-30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=-30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=-10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=-5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=-3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=-2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=-1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerYellow=30)
 
Green
[-30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=-30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=-10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=-5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=-3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=-2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=-1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerGreen=30)
 
Aqua
[-30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=-30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=-10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=-5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=-3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=-2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=-1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerAqua=30)
 
Blue
[-30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=-30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=-10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=-5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=-3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=-2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=-1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerBlue=30)
 
Purple
[-30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=-30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=-10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=-5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=-3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=-2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=-1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerPurple=30)
 
Magenta
[-30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=-30)
[-10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=-10)
[-5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=-5)
[-3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=-3)
[-2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=-2)
[-1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=-1)
[+1](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=1)
[+2](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=2)
[+3](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=3)
[+5](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=5)
[+10](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=10)
[+30](lightroom://com.robcole.lightroom.Cookmarks/iGrayMixerMagenta=30)
 
 

[Special] | [Basics] | [Tone PV2012] | [Color] | [Black&White] | [Split Toning] | [Detail] | [Effects] | [Tone+Color Combos] | [PV2010/03]

## Split Toning

|               |                                                                                        |                                                                                        |                                                                                      |                                                                                      |                                                                                      |                                                                                      |                                                                                     |                                                                                     |                                                                                     |                                                                                     |                                                                                       |                                                                                       |     |
|---------------|----------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|-----|
| Highlight Hue | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=-30)        | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=-10)        | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=-5)        | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=-3)        | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=-2)        | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=-1)        | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=1)        | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=2)        | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=3)        | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=5)        | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=10)        | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightHue=30)        |     |
| Highlight Sat | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=-30) | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=-10) | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=-5) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=-3) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=-2) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=-1) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=1) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=2) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=3) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=5) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=10) | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningHighlightSaturation=30) |     |
| Balance       | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=-30)             | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=-10)             | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=-5)             | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=-3)             | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=-2)             | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=-1)             | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=1)             | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=2)             | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=3)             | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=5)             | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=10)             | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningBalance=30)             |     |
| Shadow Hue    | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=-30)           | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=-10)           | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=-5)           | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=-3)           | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=-2)           | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=-1)           | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=1)           | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=2)           | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=3)           | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=5)           | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=10)           | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowHue=30)           |     |
| Shadow Sat    | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=-30)    | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=-10)    | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=-5)    | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=-3)    | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=-2)    | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=-1)    | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=1)    | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=2)    | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=3)    | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=5)    | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=10)    | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSplitToningShadowSaturation=30)    |     |

 

[Special] | [Basics] | [Tone PV2012] | [Color] | [Black&White] | [Split Toning] | [Detail] | [Effects] | [Tone+Color Combos] | [PV2010/03]

## Detail

*Singles*

|                           |                                                                                         |                                                                                         |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                         |                                                                                         |                                  |
|---------------------------|-----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|----------------------------------|
| Sharpness                 | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-30)                       | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-10)                       | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-5)                       | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-3)                       | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-2)                       | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-1)                       | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+1)                       | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+2)                       | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+3)                       | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+5)                       | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+10)                       | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+30)                       | Sharpening Amount                |
| Radius                    | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=-3)                    | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=-1)                    | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=-.5)                  | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=-.3)                  | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=-.2)                  | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=-.1)                  | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=+.1)                  | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=+.2)                  | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=+.3)                  | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=+.5)                  | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=+1)                    | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSharpenRadius=+3)                    |                                  |
| Detail                    | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=-30)                   | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=-10)                   | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=-5)                   | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=-3)                   | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=-2)                   | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=-1)                   | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=+1)                   | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=+2)                   | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=+3)                   | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=+5)                   | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=+10)                   | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSharpenDetail=+30)                   |                                  |
| Masking                   | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=-30)              | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=-10)              | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=-5)              | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=-3)              | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=-2)              | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=-1)              | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=+1)              | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=+2)              | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=+3)              | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=+5)              | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=+10)              | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSharpenEdgeMasking=+30)              |                                  |
|                           |                                                                                         |                                                                                         |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                         |                                                                                         |                                  |
| Luminance Noise Reduction | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=-30)              | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=-10)              | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=-5)              | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=-3)              | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=-2)              | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=-1)              | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=+1)              | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=+2)              | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=+3)              | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=+5)              | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=+10)              | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceSmoothing=+30)              |                                  |
| Detail preservation       | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=-30)   | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=-10)   | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=-5)   | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=-3)   | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=-2)   | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=-1)   | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=+1)   | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=+2)   | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=+3)   | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=+5)   | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=+10)   | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionDetail=+30)   | Reminder: Lr default base is 50. |
| Contrast enhancement      | [-30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=-30) | [-10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=-10) | [-5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=-5) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=-3) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=-2) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=-1) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=+1) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=+2) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=+3) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=+5) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=+10) | [+30](lightroom://com.robcole.lightroom.Cookmarks/iLuminanceNoiseReductionContrast=+30) | Reminder: default base is 0.     |
|                           |                                                                                         |                                                                                         |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                       |                                                                                         |                                                                                         |                                  |
| Color Noise Reduction     | [-30](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=-30)             | [-10](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=-10)             | [-5](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=-5)             | [-3](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=-3)             | [-2](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=-2)             | [-1](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=-1)             | [+1](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=+1)             | [+2](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=+2)             | [+3](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=+3)             | [+5](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=+5)             | [+10](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=+10)             | [+30](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReduction=+30)             |                                  |
| Detail preservation       | [-30](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=-30)       | [-10](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=-10)       | [-5](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=-5)       | [-3](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=-3)       | [-2](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=-2)       | [-1](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=-1)       | [+1](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=+1)       | [+2](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=+2)       | [+3](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=+3)       | [+5](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=+5)       | [+10](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=+10)       | [+30](lightroom://com.robcole.lightroom.Cookmarks/iColorNoiseReductionDetail=+30)       |                                  |

*Combos*

|                                      |                                                                                                            |                                                                                                            |                                                                                                        |                                                                                                        |                                                                                                        |                                                                                                        |                                                                                                          |                                                                                                          |                                                                                                          |                                                                                                          |                                                                                                              |                                                                                                              |                                                   |
|--------------------------------------|------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|---------------------------------------------------|
| Sharpen with less Detail and Masking | [-30](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-30&iSharpenDetail=30&iSharpenEdgeMasking=30) | [-10](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-10&iSharpenDetail=10&iSharpenEdgeMasking=10) | [-5](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-5&iSharpenDetail=5&iSharpenEdgeMasking=5) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-3&iSharpenDetail=3&iSharpenEdgeMasking=3) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-2&iSharpenDetail=2&iSharpenEdgeMasking=2) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=-1&iSharpenDetail=1&iSharpenEdgeMasking=1) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+1&iSharpenDetail=-1&iSharpenEdgeMasking=-1) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+2&iSharpenDetail=-2&iSharpenEdgeMasking=-2) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+3&iSharpenDetail=-3&iSharpenEdgeMasking=-3) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+5&iSharpenDetail=-5&iSharpenEdgeMasking=-1) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+10&iSharpenDetail=-10&iSharpenEdgeMasking=-10) | [+30](lightroom://com.robcole.lightroom.Cookmarks/iSharpness=+30&iSharpenDetail=-30&iSharpenEdgeMasking=-30) | Net result will be slight increase in sharpening. |

 

[Special] | [Basics] | [Tone PV2012] | [Color] | [Black&White] | [Split Toning] | [Detail] | [Effects] | [Tone+Color Combos] | [PV2010/03]

## Effects

*Post-crop vignette*

|            |                                                                                           |                                                                                           |                                                                                         |                                                                                         |                                                                                         |                                                                                         |                                                                                         |                                                                                         |                                                                                         |                                                                                         |                                                                                           |                                                                                           |     |
|------------|-------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----|
| Amount     | [-30](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=-30)            | [-10](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=-10)            | [-5](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=-5)            | [-3](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=-3)            | [-2](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=-2)            | [-1](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=-1)            | [+1](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=+1)            | [+2](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=+2)            | [+3](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=+3)            | [+5](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=+5)            | [+10](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=+10)            | [+30](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteAmount=+30)            |     |
| Midpoint   | [-30](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=-30)          | [-10](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=-10)          | [-5](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=-5)          | [-3](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=-3)          | [-2](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=-2)          | [-1](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=-1)          | [+1](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=+1)          | [+2](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=+2)          | [+3](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=+3)          | [+5](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=+5)          | [+10](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=+10)          | [+30](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteMidpoint=+30)          |     |
| Roundness  | [-30](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=-30)         | [-10](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=-10)         | [-5](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=-5)         | [-3](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=-3)         | [-2](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=-2)         | [-1](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=-1)         | [+1](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=+1)         | [+2](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=+2)         | [+3](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=+3)         | [+5](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=+5)         | [+10](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=+10)         | [+30](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteRoundness=+30)         |     |
| Feather    | [-30](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=-30)           | [-10](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=-10)           | [-5](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=-5)           | [-3](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=-3)           | [-2](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=-2)           | [-1](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=-1)           | [+1](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=+1)           | [+2](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=+2)           | [+3](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=+3)           | [+5](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=+5)           | [+10](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=+10)           | [+30](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteFeather=+30)           |     |
| Highlights | [-30](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=-30) | [-10](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=-10) | [-5](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=-5) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=-3) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=-2) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=-1) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=+1) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=+2) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=+3) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=+5) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=+10) | [+30](lightroom://com.robcole.lightroom.Cookmarks/iPostCropVignetteHighlightContrast=+30) |     |

*Grain*

|           |                                                                        |                                                                        |                                                                      |                                                                      |                                                                      |                                                                      |                                                                      |                                                                      |                                                                      |                                                                      |                                                                        |                                                                        |     |
|-----------|------------------------------------------------------------------------|------------------------------------------------------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|------------------------------------------------------------------------|------------------------------------------------------------------------|-----|
| Amount    | [-30](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=-30)    | [-10](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=-10)    | [-5](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=-5)    | [-3](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=-3)    | [-2](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=-2)    | [-1](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=-1)    | [+1](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=+1)    | [+2](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=+2)    | [+3](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=+3)    | [+5](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=+5)    | [+10](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=+10)    | [+30](lightroom://com.robcole.lightroom.Cookmarks/iGrainAmount=+30)    |     |
| Size      | [-30](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=-30)      | [-10](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=-10)      | [-5](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=-5)      | [-3](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=-3)      | [-2](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=-2)      | [-1](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=-1)      | [+1](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=+1)      | [+2](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=+2)      | [+3](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=+3)      | [+5](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=+5)      | [+10](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=+10)      | [+30](lightroom://com.robcole.lightroom.Cookmarks/iGrainSize=+30)      |     |
| Roughness | [-30](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=-30) | [-10](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=-10) | [-5](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=-5) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=-3) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=-2) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=-1) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=+1) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=+2) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=+3) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=+5) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=+10) | [+30](lightroom://com.robcole.lightroom.Cookmarks/iGrainFrequency=+30) |     |

 

[Special] | [Basics] | [Tone PV2012] | [Color] | [Black&White] | [Split Toning] | [Detail] | [Effects] | [Tone+Color Combos] | [PV2010/03]

## Tone+Color Combos

|                                     |                                                                                                                                                                                                     |                                                                                                                                                                                                     |                                                                                                                                                                                                   |                                                                                                                                                                                                   |                                                                                                                                                                                                   |                                                                                                                                                                                                   |                                                                                                                                                                                                  |                                                                                                                                                                                                  |                                                                                                                                                                                                  |                                                                                                                                                                                                  |                                                                                                                                                                                                    |                                                                                                                                                                                                    |                                                                                                                  |
|-------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| Punch (PV2012) Normal               | [-30](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-30&iExposure2012=.15&iContrast2012=-30&iClarity2012=-30&iHighlights2012=30&iShadows2012=-30&iVibrance=-20&iSaturation=-10)           | [-10](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-10&iExposure2012=.05&iContrast2012=-10&iClarity2012=-10&iHighlights2012=10&iShadows2012=-10&iVibrance=-7&iSaturation=-3)             | [-5](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-5&iExposure2012=.025&iContrast2012=-5&iClarity2012=-5&iHighlights2012=5&iShadows2012=-5&iVibrance=-3&iSaturation=-2)                | [-3](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-3&iExposure2012=.015&iContrast2012=-3&iClarity2012=-3&iHighlights2012=3&iShadows2012=-3&iVibrance=-2&iSaturation=-1)                | [-2](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-2&iExposure2012=.01&iContrast2012=-2&iClarity2012=-2&iHighlights2012=2&iShadows2012=-2&iVibrance=-1&iSaturation=0)                  | [-1](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=-1&iExposure2012=.005&iContrast2012=-1&iClarity2012=-1&iHighlights2012=1&iShadows2012=-1&iVibrance=0&iSaturation=0)                  | [+1](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=1&iExposure2012=-.005&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=0&iSaturation=0)                   | [+2](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=2&iExposure2012=-.01&iContrast2012=2&iClarity2012=2&iHighlights2012=-2&iShadows2012=2&iVibrance=1&iSaturation=0)                    | [+3](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=3&iExposure2012=-.015&iContrast2012=3&iClarity2012=3&iHighlights2012=-3&iShadows2012=3&iVibrance=2&iSaturation=1)                   | [+5](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=5&iExposure2012=-.025&iContrast2012=5&iClarity2012=5&iHighlights2012=-5&iShadows2012=5&iVibrance=3&iSaturation=2)                   | [+10](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=10&iExposure2012=-.05&iContrast2012=10&iClarity2012=10&iHighlights2012=-10&iShadows2012=10&iVibrance=7&iSaturation=3)                | [+30](lightroom://com.robcole.lightroom.Cookmarks/iWhites2012=30&iExposure2012=-.15&iContrast2012=30&iClarity2012=30&iHighlights2012=-30&iShadows2012=30&iVibrance=20&iSaturation=10)              | Make more contrasty and saturated... - PV2012 only. Includes a good dose of +whites (w/ -exposure compensation). |
| Punch (PV2012) for Autotoned Images | [-30](lightroom://com.robcole.lightroom.Cookmarks/Mult/-30/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [-10](lightroom://com.robcole.lightroom.Cookmarks/Mult/-10/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [-5](lightroom://com.robcole.lightroom.Cookmarks/Mult/-5/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [-3](lightroom://com.robcole.lightroom.Cookmarks/Mult/-3/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [-2](lightroom://com.robcole.lightroom.Cookmarks/Mult/-2/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [-1](lightroom://com.robcole.lightroom.Cookmarks/Mult/-1/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [+1](lightroom://com.robcole.lightroom.Cookmarks/Mult/1/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [+2](lightroom://com.robcole.lightroom.Cookmarks/Mult/2/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [+3](lightroom://com.robcole.lightroom.Cookmarks/Mult/3/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [+5](lightroom://com.robcole.lightroom.Cookmarks/Mult/5/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [+10](lightroom://com.robcole.lightroom.Cookmarks/Mult/10/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | [+30](lightroom://com.robcole.lightroom.Cookmarks/Mult/30/iWhites2012=.333&iExposure2012=-.00333&iContrast2012=1&iClarity2012=1&iHighlights2012=-1&iShadows2012=1&iVibrance=.666&iSaturation=.333) | Ditto, except reduced +whites, since auto-toning already provides a good dose.                                   |

 

[Special] | [Basics] | [Tone PV2012] | [Color] | [Black&White] | [Split Toning] | [Detail] | [Effects] | [Tone+Color Combos] | [PV2010/03]

## PV2010/03

|            |                                                                           |                                                                           |                                                                         |                                                                         |                                                                         |                                                                         |                                                                        |                                                                        |                                                                        |                                                                        |                                                                          |                                                                          |     |
|------------|---------------------------------------------------------------------------|---------------------------------------------------------------------------|-------------------------------------------------------------------------|-------------------------------------------------------------------------|-------------------------------------------------------------------------|-------------------------------------------------------------------------|------------------------------------------------------------------------|------------------------------------------------------------------------|------------------------------------------------------------------------|------------------------------------------------------------------------|--------------------------------------------------------------------------|--------------------------------------------------------------------------|-----|
| Exposure   | [-30](lightroom://com.robcole.lightroom.Cookmarks/iExposure=-30)          | [-10](lightroom://com.robcole.lightroom.Cookmarks/iExposure=-10)          | [-5](lightroom://com.robcole.lightroom.Cookmarks/iExposure=-5)          | [-3](lightroom://com.robcole.lightroom.Cookmarks/iExposure=-3)          | [-2](lightroom://com.robcole.lightroom.Cookmarks/iExposure=-2)          | [-1](lightroom://com.robcole.lightroom.Cookmarks/iExposure=-1)          | [+1](lightroom://com.robcole.lightroom.Cookmarks/iExposure=1)          | [+2](lightroom://com.robcole.lightroom.Cookmarks/iExposure=2)          | [+3](lightroom://com.robcole.lightroom.Cookmarks/iExposure=3)          | [+5](lightroom://com.robcole.lightroom.Cookmarks/iExposure=5)          | [+10](lightroom://com.robcole.lightroom.Cookmarks/iExposure=10)          | [+30](lightroom://com.robcole.lightroom.Cookmarks/iExposure=30)          |     |
| Recovery   | [-30](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=-30) | [-10](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=-10) | [-5](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=-5) | [-3](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=-3) | [-2](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=-2) | [-1](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=-1) | [+1](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=1) | [+2](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=2) | [+3](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=3) | [+5](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=5) | [+10](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=10) | [+30](lightroom://com.robcole.lightroom.Cookmarks/iHighlightRecovery=30) |     |
| Fill Light | [-30](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=-30)         | [-10](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=-10)         | [-5](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=-5)         | [-3](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=-3)         | [-2](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=-2)         | [-1](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=-1)         | [+1](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=1)         | [+2](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=2)         | [+3](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=3)         | [+5](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=5)         | [+10](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=10)         | [+30](lightroom://com.robcole.lightroom.Cookmarks/iFillLight=30)         |     |
| Blacks     | [-30](lightroom://com.robcole.lightroom.Cookmarks/iShadows=-30)           | [-10](lightroom://com.robcole.lightroom.Cookmarks/iShadows=-10)           | [-5](lightroom://com.robcole.lightroom.Cookmarks/iShadows=-5)           | [-3](lightroom://com.robcole.lightroom.Cookmarks/iShadows=-3)           | [-2](lightroom://com.robcole.lightroom.Cookmarks/iShadows=-2)           | [-1](lightroom://com.robcole.lightroom.Cookmarks/iShadows=-1)           | [+1](lightroom://com.robcole.lightroom.Cookmarks/iShadows=1)           | [+2](lightroom://com.robcole.lightroom.Cookmarks/iShadows=2)           | [+3](lightroom://com.robcole.lightroom.Cookmarks/iShadows=3)           | [+5](lightroom://com.robcole.lightroom.Cookmarks/iShadows=5)           | [+10](lightroom://com.robcole.lightroom.Cookmarks/iShadows=10)           | [+30](lightroom://com.robcole.lightroom.Cookmarks/iShadows=30)           |     |
|            |                                                                           |                                                                           |                                                                         |                                                                         |                                                                         |                                                                         |                                                                        |                                                                        |                                                                        |                                                                        |                                                                          |                                                                          |     |
| Brightness | [-30](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=-30)        | [-10](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=-10)        | [-5](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=-5)        | [-3](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=-3)        | [-2](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=-2)        | [-1](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=-1)        | [+1](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=1)        | [+2](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=2)        | [+3](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=3)        | [+5](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=5)        | [+10](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=10)        | [+30](lightroom://com.robcole.lightroom.Cookmarks/iBrightness=30)        |     |
| Contrast   | [-30](lightroom://com.robcole.lightroom.Cookmarks/iContrast=-30)          | [-10](lightroom://com.robcole.lightroom.Cookmarks/iContrast=-10)          | [-5](lightroom://com.robcole.lightroom.Cookmarks/iContrast=-5)          | [-3](lightroom://com.robcole.lightroom.Cookmarks/iContrast=-3)          | [-2](lightroom://com.robcole.lightroom.Cookmarks/iContrast=-2)          | [-1](lightroom://com.robcole.lightroom.Cookmarks/iContrast=-1)          | [+1](lightroom://com.robcole.lightroom.Cookmarks/iContrast=1)          | [+2](lightroom://com.robcole.lightroom.Cookmarks/iContrast=2)          | [+3](lightroom://com.robcole.lightroom.Cookmarks/iContrast=3)          | [+5](lightroom://com.robcole.lightroom.Cookmarks/iContrast=5)          | [+10](lightroom://com.robcole.lightroom.Cookmarks/iContrast=10)          | [+30](lightroom://com.robcole.lightroom.Cookmarks/iContrast=30)          |     |
|            |                                                                           |                                                                           |                                                                         |                                                                         |                                                                         |                                                                         |                                                                        |                                                                        |                                                                        |                                                                        |                                                                          |                                                                          |     |
| Clarity    | [-30](lightroom://com.robcole.lightroom.Cookmarks/iClarity=-30)           | [-10](lightroom://com.robcole.lightroom.Cookmarks/iClarity=-10)           | [-5](lightroom://com.robcole.lightroom.Cookmarks/iClarity=-5)           | [-3](lightroom://com.robcole.lightroom.Cookmarks/iClarity=-3)           | [-2](lightroom://com.robcole.lightroom.Cookmarks/iClarity=-2)           | [-1](lightroom://com.robcole.lightroom.Cookmarks/iClarity=-1)           | [+1](lightroom://com.robcole.lightroom.Cookmarks/iClarity=1)           | [+2](lightroom://com.robcole.lightroom.Cookmarks/iClarity=2)           | [+3](lightroom://com.robcole.lightroom.Cookmarks/iClarity=3)           | [+5](lightroom://com.robcole.lightroom.Cookmarks/iClarity=5)           | [+10](lightroom://com.robcole.lightroom.Cookmarks/iClarity=10)           | [+30](lightroom://com.robcole.lightroom.Cookmarks/iClarity=30)           |     |

 

[Special] | [Basics] | [Tone PV2012] | [Color] | [Black&White] | [Split Toning] | [Detail] | [Effects] | [Tone+Color Combos] | [PV2010/03]

# Cookmarks Revision History

**(reverse chronological order)**

## Version 2.1, released 2012-07-31

- Added percent auto-toning, in case you just want to go part of the way from where you are to where auto-toning would take you...

## Version 2.0, released 2012-05-04

- Extended syntax of URL to allow multiple sections, and added Mult section, for setting multiplier.

## Version 1.3, released 2012-05-02

- Added 'Try It' button and a multiplier field to URL generator form so you can test URL (at extra strength) without pasting in browser.

## Version 1.2, released 2012-05-01

- Improved cookmarks URL generator by organizing the adjustment items into the same groups as they are in Lightroom proper.

## Version 1.1, released 2012-04-30

- Fixed potential compatibility problem with Lr4 RC2, and certified it for compatibility with Lr4.

## Version 1.0, released 2012-03-26

- Initial release.

