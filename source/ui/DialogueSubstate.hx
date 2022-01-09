package ui;

import props.Player;
import flixel.group.FlxGroup.FlxTypedGroup;
import data.PlayerSettings;
import states.BootState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

class DialogueSubstate extends flixel.FlxSubState
{
    public var daInterface:FlxTypedGroup<Dynamic>;

    public var dialogueText:TypeTextTwo;
    public var blackBarTop:FlxSprite;
    public var blackBarBottom:FlxSprite;
    public var uiCamera:FlxCamera = null;

    public var controls:Controls = null;
    public var isCreditsDialogue:Bool;

    public function new(dialogue:String, controls:Null<Controls>, ?playerCamera:PlayCamera, startNow = true, delay:Float = 0.25, isCreditsDialogue:Bool = false)
    {
        super();

        this.controls = controls;
        this.isCreditsDialogue = isCreditsDialogue;

        var cameraSettings:Array<Dynamic> = (!isCreditsDialogue ? [playerCamera.x, playerCamera.y] : [0, 0]);

        uiCamera = new FlxCamera(Std.int(cameraSettings[0]), Std.int(cameraSettings[1]), Std.int(FlxG.width), Std.int(FlxG.height));
        uiCamera.bgColor.alpha = 0;

        FlxG.cameras.add(uiCamera);

        daInterface = new FlxTypedGroup<Dynamic>();
        add(daInterface);

        dialogueText = new TypeTextTwo(0, 0, FlxG.width, parseDialogue(dialogue), 16);
        dialogueText.sounds = [FlxG.sound.load('assets/sounds/talksound' + BootState.soundEXT), FlxG.sound.load('assets/sounds/talksound1' + BootState.soundEXT)];
        dialogueText.finishSounds = true;
        dialogueText.skipKeys = [];
        dialogueText.visible = false;
        
        blackBarBottom = new FlxSprite().makeGraphic(FlxG.width, Std.int(FlxG.height * 0.22), FlxColor.BLACK);
        blackBarBottom.y = FlxG.height;
        
        blackBarTop = new FlxSprite();
        final height = Math.max(blackBarBottom.height, dialogueText.finalHeight);
        blackBarTop.makeGraphic(FlxG.width, Std.int(height), FlxColor.BLACK);
        blackBarTop.y = -blackBarTop.height;
        
        daInterface.add(blackBarBottom);
        daInterface.add(blackBarTop);
        daInterface.add(dialogueText);

        daInterface.cameras = [uiCamera];
        
        FlxTween.tween(blackBarTop, {y: 0}, 0.25, {ease:FlxEase.quadIn});
        FlxTween.tween(blackBarBottom, {y: Std.int(FlxG.height - blackBarBottom.height)}, 0.25, {ease:FlxEase.quadIn});
        
        if (startNow) start(delay);
    }
    
    function parseDialogue(d:String):String
    {
        if (~/\{.+\}/.match(d))
        {
            var start = d.indexOf("{");
            while(start != -1)
            {
                var end = d.indexOf("}", start);
                if (end == -1)
                    throw '"{" token found with no matching "}" token';
                var inputName = d.substring(start + 1, end);
                trace('token $inputName');
                d = d.split('{$inputName}')
                    .join(controls.getDialogueNameFromToken(inputName));
                start = d.indexOf("{", end + 1);
            }
        }
        return d;
    }
    
    inline public function start(delay = 0.05):Void
    {
        dialogueText.visible = true;
        dialogueText.start(delay);
    }

    override function update(elapsed:Float)
    {
        var controlsArray:Array<Dynamic> = [];

        if (controls != null) controlsArray = [controls.BACK, controls.ACCEPT];

        if (dialogueText.visible && ((controls != null && controlsArray.contains(true)) || (controls == null && FlxG.keys.justPressed.ANY)))
        {
            if (dialogueText.isFinished)
                startClose();
            else
                dialogueText.skip();
        }
        
        super.update(elapsed);
    }
    
    override function close()
    {   
        remove(daInterface);

        if (FlxG.cameras.list.contains(uiCamera))
            FlxG.cameras.remove(uiCamera);

        super.close();
    }
    
    function startClose():Void
    {
        FlxTween.tween(blackBarTop, {y: -blackBarTop.height}, 0.25, {ease:FlxEase.quadIn});
        FlxTween.tween(blackBarBottom, {y: FlxG.height}, 0.25,
            { ease:FlxEase.quadIn, onComplete: (_)->(!isCreditsDialogue ? closeCallback() : close()) }
        );
        dialogueText.visible = false;
        controls = null;
    }
}

@:forward
abstract ZoomDialogueSubstate(DialogueSubstate) to DialogueSubstate
{
    inline public function new(dialogue:String, focalPoint:FlxPoint, settings:PlayerSettings, player:Player, onComplete:()->Void)
    {
        final camera = player.playCamera;
        final oldZoom = camera.zoom;
        final oldCamPos = camera.scroll.copyTo();
        this = new DialogueSubstate(dialogue, player.controls, camera, false, 0.25, false);
        
        final zoomAmount = 2;
        final yOffset = (this.blackBarTop.height - this.blackBarBottom.height) / 2 / zoomAmount;

        tweenCamera(camera, 0.25, oldZoom * zoomAmount,
            focalPoint.x - FlxG.width / 2,
            focalPoint.y - FlxG.height / 2 - yOffset,
            (_)->this.start()
        );

        focalPoint.putWeak();
        
        this.closeCallback = function()
        {   
            tweenCamera(camera, 0.3, oldZoom, oldCamPos.x, oldCamPos.y, (_)->onComplete());
            oldCamPos.put();
            this.close();
        };
    }
    
    inline function tweenCamera(camera:FlxCamera, time:Float, zoom:Float, x:Float, y:Float, onComplete:(FlxTween)->Void):FlxTween
    {
        return FlxTween.tween(camera, { zoom: zoom, "scroll.x":x, "scroll.y":y }, time, { onComplete:onComplete });
    }
    
    public function getViewRect(?rect:FlxRect):FlxRect
    {
        if (rect == null)
            rect = new FlxRect();
        
        rect.y = this.blackBarTop.height;
        rect.width = FlxG.width;
        rect.height = FlxG.height - this.blackBarBottom.height;
        return rect;
    }
}