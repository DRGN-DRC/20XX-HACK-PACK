![The 20XX HACK PACK](/imgs/Logo.png) 

A full-game enhancement to the hit GameCube game, Super Smash Bros. Melee.

Find the official thread on Smashboards [here](https://smashboards.com/threads/the-20xx-melee-training-hack-pack-v5-0-11-21-2021.351221/).

![Downloads](/imgs/Downloads.png)

This repository's primary point of interest is the Code Library (the "20XXHP 5.0 Code Library" folder), which allows you to view or customize the code that goes into 20XX. For downloads of the patch file to create the mod (which includes the character costumes, stages, etc.), see the [releases](https://github.com/DRGN-DRC/20XX-HACK-PACK/releases) section and download the `.zip` file, or see the OP in the official thread linked above for a mirror. You will need an NTSC v1.02 copy of the game to create the mod. From there, it's only a single-step process to create the mod with the patch. Instructions are in the download.

![Usage](/imgs/Usage.png)

To install new custom code to 20XX, you need the latest build of [MCM (The Melee Code Manager)](https://smashboards.com/threads/melee-code-manager-v4-4-easily-add-mods-to-your-game.416437/). To begin, download that and the "20XXHP 5.0 Code Library" folder from this repo, and unzip them both. You will also need a vanilla NTSC 1.02 DOL (which you can extract from a vanilla copy of the game using MCM or DTW).

1. Add whatever codes you'd like to the 20XX Code Library you downloaded (see [here](https://smashboards.com/threads/melee-code-manager-v4-4-1-easily-add-mods-to-your-game.416437/post-20075377) for details)
2. Open MCM
3. Click on the Mods Library Selection button in the top-right (the books icon)
4. Click "Add Another Library Path", and navigate to where you saved the 20XX Code Library
5. Once you've added the new library, it should be selected by default. Click OK to close the window
6. Once the new library has loaded, use the "Open" button or drag-and-drop your vanilla DOL onto the program
7. Click the "Code-Space Options" button, enable the "20XXHP 5.0 Regions" for use, and close the window
8. Hold Shift and Click "Select All"; this will select all of the codes in the library for installation
9. Click "Save As..." to create a new DOL file, so you don't overwrite your vanilla copy
10. Import the DOL you just created into your copy of 20XX using MCM or DTW

![Credits](/imgs/Credits.png)

    Achilles ~ For creating this project, of course!
    Punkline ~ For many codes, and help in reverse engineering game processes
    UnclePunch ~ Also for many codes, and helping with ASM-related questions
    Ripple ~ For SD Remix v5.0
    tauKhan ~ For the DI Draw memory allocation bugfix, and help with the HFLR code
    Ploaj ~ For the audio codec, MeleeMedia
    The Melee Workshop community ~ For character costumes, stages, and more!

    I also have credits for every character costume artist I could find,
    available in the "20XXHP Costume List.xls" file.
