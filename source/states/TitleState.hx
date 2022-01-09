package states;

import ui.Controls;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class TitleState extends FlxState
{
    var pressStart:FlxSprite;

    var canSelect:Bool = false;
    var selected:Bool = false;

    override public function create()
    {
        FlxG.sound.playMusic('assets/music/fluffydream' + OptionsSubState.DXmusic + BootState.soundEXT, 0.7);
        FlxG.camera.fade(FlxColor.WHITE, 2, true);
        FlxG.sound.play('assets/sounds/titleCrash' + BootState.soundEXT, 0.4);

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF3D73A2);
        
        var titleBg:FlxSprite = new FlxSprite("assets/images/ui/intro/bg.png");
        titleBg.screenCenter(X);
        
        var ritz:FlxSprite = new FlxSprite().loadGraphic("assets/images/ui/intro/ritz.png", true, titleBg.graphic.width, titleBg.graphic.height);
        ritz.screenCenter(X);
        ritz.animation.add('idle', [ritz.animation.frames - 1]);
        ritz.animation.play('idle');

        pressStart = new FlxSprite().loadGraphic("assets/images/ui/intro/instructions.png");
        pressStart.screenCenter(X);

        add(bg);
        add(titleBg);
        add(ritz);
        add(pressStart);

        FlxFlicker.flicker(pressStart, 0, 0.5);

        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            canSelect = true;
        });
        
        super.create();
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ANY && !selected && canSelect)
        {
            selected = true;

            FlxFlicker.flicker(pressStart, 1, 0.04, false, true, function(_)
            {
                FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
                {
                    FlxG.switchState(new MainMenuState());
                });
            });
            
            FlxG.sound.play('assets/sounds/startbleep' + BootState.soundEXT);

            if (FlxG.sound.music != null)
            {
                FlxG.sound.music.stop();
                FlxG.sound.music = null;
            }
        }
        
        super.update(elapsed);
    }
}