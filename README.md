# WoW - NewAddon
## A template for creating Lua-only addons for World of Warcraft.

(If you plan on using XML for frames definitions, this probably isn't for you.)

To create an addon based on this template:

* Copy the `.toc` and `.lua` file into a folder in `WoW/Interface/Addons`, named with your addon name.
    * e.g. `WoW/Interface/Addons/MyAddon`
* Rename the files to match your addon name
    * e.g. `MyAddon.lua` and `MyAddon.toc`
* Edit `MyAddon.toc` and adjust the title, notes, author settings. The `SavedVariablesPerCharacter` should be set to e.g. `MyAddonPrefs`. The last line of the file must point to your `.lua` file.
* Edit `MyAddon.lua` and replace every occurance of `NewAddon` with `MyAddon`
* Launch WoW

The addon should spawn a black square in the center of the viewport, with a constantly changing number in it. Dragging the square around will move it. The position of the square will be stored in preferences. Right-clicking the square will show some text in chat.

<center><img src="http://iamcal.github.com/NewAddon/demo.png" /></center>

You can now modify the addon to suit your purposes. Type `/reload` into chat to see changes take effect.