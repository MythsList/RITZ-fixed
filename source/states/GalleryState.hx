package states;

import ui.Controls;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import lime.utils.Assets;
import haxe.Json;
import haxe.ds.ReadOnlyArray;

class GalleryState extends flixel.FlxSubState
{
    final controls:Controls;

    private var artObjects:FlxTypedGroup<FlxSprite>;
    private var descText:FlxText;

    private var data:Array<Dynamic> = [];
    private var artDescriptions:Array<String> = [];

    var curSelected:Int = 0;
    var canSelect:Bool = false;
    var canChangeSelection:Array<Bool> = [false, false];

    public function new(controls)
    {
        this.controls = controls;

        super();
    }

    override function create()
    {
        data = Json.parse(Assets.getText('assets/data/artMetadata.json'));

        artObjects = new FlxTypedGroup<FlxSprite>();
        add(artObjects);

        for (i in 0...Std.int(data.length))
        {
            var artObj:FlxSprite = new FlxSprite().loadGraphic(data[i].path);
            artDescriptions.push(data[i].description);
            artObj.ID = i;
            artObj.setGraphicSize(Std.int(artObj.width * data[i].size));
            artObj.updateHitbox();
            artObj.screenCenter();

            artObjects.add(artObj);
        }

        descText = new FlxText(0, 0, FlxG.width, 'PlaceHolder', 20);
        descText.alignment = LEFT;
        descText.setPosition(2, FlxG.height - (descText.height + 2));
        add(descText);

        changeSelection(0);
        
        super.create();
    }

    override function update(elapsed:Float)
    {
        if (canSelect)
        {
            if (controls.LEFT_P && canChangeSelection[0])
                changeSelection(-1);

            if (controls.RIGHT_P && canChangeSelection[1])
                changeSelection(1);

            if (controls.BACK)
            {
                close();
                FlxG.state.openSubState(new GalleryMenuState());
            }
        }
    }

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        if (change != 0)
        {
            var randomSound:Int = (FlxG.random.bool() ? 2 : 0);
            FlxG.sound.play('assets/sounds/Munchsound' + Std.string((change == -1 ? 2 : 1) + randomSound) + BootState.soundEXT);
        }

        if (curSelected <= 0)
            canChangeSelection = [false, true];
        else if (curSelected >= artObjects.length - 1)
            canChangeSelection = [true, false];
        else
            canChangeSelection = [true, true];

        for (item in artObjects)
        {
            item.visible = (item.ID == curSelected ? true : false);
        }

        if (change == 0) canSelect = true;

        descText.text = artDescriptions[curSelected];
        descText.setPosition(2, FlxG.height - (descText.height + 2));
    }
}