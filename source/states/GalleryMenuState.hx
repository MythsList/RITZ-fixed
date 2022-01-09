package states;

import ui.MenuItem;

import flixel.FlxG;
import flixel.effects.FlxFlicker;
import flixel.FlxSubState;

class GalleryMenuState extends MenuBackend
{
    public function new():Void
    {
        super(["Art Gallery", "Music Gallery", "Back"]);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}