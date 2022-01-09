package states;

import props.Checkpoint;
import props.Player;
import ui.DialogueSubstate;
import utils.NGio;
import io.newgrounds.NG;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class EndState extends flixel.FlxState
{
    private var creds:Array<String> = [
        "RITZ",
        "Originally for Pixel Day 2020 on Newgrounds.com",
        "",
        "A game by",
        "ninjamuffin99",
        "MKMaffo", 
        "Digimin",
        "Kawaisprite",
        "",
        "",
        "Programming, design and writing",
        "ninjamuffin99",
        "", 
        "Character art and animation",
        "MKMaffo",
        "",
        "Tile, background art and additional writing",
        "Digimin",
        "",
        "Music and sounds",
        "Kawaisprite",
        "",
        "",
        "Made with HaxeFlixel",
        "",
        "Shoutouts to mike for trigonomety math help lmao",
        "",
        "Source code",
        "github.com/ninjamuffin99/actualPixelDay2020",
        "",
        "Map editor",
        "OGMO 3",
        "",
        "",
        "",
        "Special Thanks",
        "OzoneOrange",
        "Wandaboy",
        "Snackers",
        "Carmet",
        "HenryEYES",
        "FuShark",
        "PhantomArcade",
        "GeoKureli",
        "Joe Swanson from Family Guy",
        "MuccTucc",
        "SuperMega",
        "DonRRR",
        "",
        "Tom Fulp and Newgrounds"
    ];

    var endDialogue:String = "Huh, looks like it's over. Thanks for playing Ritz! I'm still kinda hungry though... go find me more cheese!";
    var text:FlxText;
    var dumbass:Checkpoint;

    override function create()
    {
        FlxG.sound.playMusic('assets/music/ritz' + BootState.soundEXT, 0.8);

        PlayState.curLevel = 0;

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

        text = new FlxText(0, FlxG.height + 100, 0, '', 16);
        text.alignment = CENTER;

        for (item in creds)
        {
            text.text += item + '\n';
        }

        dumbass = new Checkpoint(0, text.y + text.height + 300, endDialogue);
        dumbass.screenCenter(X);

        add(bg);
        add(text);
        add(dumbass);
        
        super.create();
    }

    var credsCounter:Int = 0;
    var finishedShit:Bool = false;

    override function update(elapsed:Float)
    {
        credsCounter ++;

        if (dumbass.y + dumbass.height < -10 && finishedShit)
            FlxG.switchState(new TitleState());

        if (dumbass.y <= (FlxG.height / 2) - (dumbass.height / 2) && !finishedShit)
        {
            finishedShit = true;
            openSubState(new DialogueSubstate(dumbass.dialogue, null, null, true, 0.05, true));
        }

        if (text.y + text.height < -10 && FlxG.sound.music.volume >= 0.8)
            FlxG.sound.music.fadeOut(2, 0);

        if (credsCounter >= 2)
        {
            credsCounter = 0;
            text.y -= 1.45;
            dumbass.y -= 1.45;
        }
        
        super.update(elapsed);
    }
}