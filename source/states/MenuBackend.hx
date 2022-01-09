package states;

import data.PlayerSettings;
import ui.Controls;
import ui.BitmapText;
import ui.MenuItem;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class MenuBackend extends FlxSubState
{
    var textMenuItems:Array<String> = [
        'Back'
    ];

    var optionValues:Array<Dynamic> = [
        [
        
        ],
        [
            0
        ]
    ]; 
    
    var grpMenuItems:FlxTypedGroup<MenuItem>;
    var grpMenuBars:FlxTypedGroup<FlxSprite>;

    public var curSelected:Int = 0;
    var selected:Bool = false;
    
    var controls(get, never):Controls;
    inline function get_controls() return PlayerSettings.player1.controls;
    
    public function new(menuItems:Array<String>, ?optionItems:Array<Dynamic>)
    {
        super();

        if (menuItems != null) textMenuItems = menuItems;
        if (optionItems != null) optionValues = optionItems;

        grpMenuItems = new FlxTypedGroup<MenuItem>();
        
        var bullshit:Int = 0;

        for (text in textMenuItems)
        {
            addMenuItem(text, bullshit, optionValues[1][Std.int(bullshit)]);
            bullshit++;
        }

        add(grpMenuItems);

        var overlay:FlxSprite = new FlxSprite().loadGraphic('assets/images/ui/main_menu/overlay.png');
        add(overlay);
    }

    public function addMenuItem(text:String, bullshit:Int, itemType:Int = 0):MenuItem
    {
        var menuItem:MenuItem = new MenuItem(0, 0, controls, text, itemType, optionValues[0][Std.int(bullshit)]);
        menuItem.targetY = bullshit;

        grpMenuItems.add(menuItem);

        return menuItem;
    }

    override function update(elapsed:Float) 
    {
        for (i in 0...grpMenuItems.members.length)
        {
            grpMenuItems.members[i].isSelected = (i == curSelected ? true : false);
        }

        if (controls.UP_P)
            changeSelection(-1);

        if (controls.DOWN_P)
            changeSelection(1);
    
        if (controls.ACCEPT && !selected && grpMenuItems.members[curSelected].itemType == MenuItem.SELECTION)
        {
            selected = true;
            FlxG.sound.play('assets/sounds/startbleep' + BootState.soundEXT);

            FlxFlicker.flicker(grpMenuItems.members[curSelected], 0.5, 0.04, false, true, function(flic:FlxFlicker)
            {
                var daText:String = textMenuItems[curSelected];

                switch(daText.toLowerCase())
                {
                    case 'adventure mode':
                        PlayState.curLevel = 0;
                        openState(new AdventureState());
                    case 'race mode':
                        PlayState.curLevel = 0;
                        openState(new RaceState());
                    case 'credits':
                        openState(new EndState());
                    case 'gallery':
                        close();
                        selected = false;
                        FlxG.state.openSubState(new GalleryMenuState());
                    case 'art gallery':
						close();
                        selected = false;
                        FlxG.state.openSubState(new GalleryState(controls));
                    case 'music gallery':
						close();
                        selected = false;
                        FlxG.state.openSubState(new MusicGalleryState(controls));
                    case 'options':
                        close();
                        selected = false;
                        FlxG.state.openSubState(new OptionsSubState());
                    case 'back':
                        close();
                        selected = false;
                        FlxG.state.openSubState(new MenuBackend(MainMenuState.textMenuItems));
                    default:
                        selected = false;
                        trace('No button selected or no button function!');
                }
            });
        }
    
        super.update(elapsed);
    }

    private function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        if (change != 0)
        {
            var randomSound:Int = (FlxG.random.bool() ? 2 : 0);
            FlxG.sound.play('assets/sounds/Munchsound' + Std.string((change == -1 ? 2 : 1) + randomSound) + BootState.soundEXT);
        }

        if (curSelected < 0)
            curSelected = textMenuItems.length - 1;
        else if (curSelected >= textMenuItems.length)
            curSelected = 0;
    
        var bullshit:Int = 0;

        for (item in grpMenuItems.members)
        {
            item.targetY = bullshit - curSelected;
            bullshit++;
        }
    }

    private function openState(daState:FlxState):Void
    {
        FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
        {
            FlxG.switchState(daState);
        });
    }
}