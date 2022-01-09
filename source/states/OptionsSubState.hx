package states;

import flixel.effects.FlxFlicker;
import flixel.FlxG;
import ui.BitmapText;
import ui.MenuItem;
import flixel.FlxState;
import flixel.FlxSubState;

class OptionsSubState extends MenuBackend
{
	public static var masterVol:Float = 100;
	public static var musicVol:Float = 100;
	public static var soundVol:Float = 100;
	public static var DXmusic:String = "DX";

    public function new()
    {
		var isDX:Bool = (DXmusic != '' ? true : false);
		
		var menuItems:Array<String> = [
			'Master Volume',
			'Music Volume',
			'SFX Volume',
			'DX OST',
			'Back'
		];
	
		var optionItems:Array<Dynamic> = [
			[
				masterVol * 100, musicVol * 100, soundVol * 100, isDX
			],
			[
				1, 1, 1, 2, 0
			]
		];

		super(menuItems, optionItems);
	}

	override function update(elapsed:Float)
	{
		masterVol = grpMenuItems.members[0].percentage / 100;
		musicVol = grpMenuItems.members[1].percentage / 100;
		soundVol = grpMenuItems.members[2].percentage / 100;

		var curDX:String = DXmusic;

		DXmusic = (grpMenuItems.members[3].isOn ? 'DX' : '');

		if (curDX != DXmusic)
		{
			// Change so can dynamically switch music in-game
			// FlxG.sound.playMusic('assets/music/fluffydream' + OptionsSubState.DXmusic + BootState.soundEXT);
		}
	
		FlxG.watch.addQuick('masterVol', masterVol);

		if (FlxG.sound.music != null)
			FlxG.sound.music.volume = masterVol * musicVol;

		super.update(elapsed);
	}
}