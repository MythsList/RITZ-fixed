package states;

import ui.MinimapSubstate;
import ui.Minimap;
import props.Cheese;
import props.Checkpoint;
import props.Player;

class AdventureState extends PlayState
{
    var pathPrefix:String = 'assets/data/ogmo/levels/';
    var fileSuffix:String = '.json';
    
    public static var LEVEL_PATH:Array<String> = [
        // 'dumbassLevel',
        // 'normassLevel',
        'smartassLevel'
    ];

	var minimap:Minimap;
    
    override function create()
    {
        PlayState.isRace = false;

        super.create();
        
		minimap = new Minimap(pathPrefix + LEVEL_PATH[PlayState.curLevel] + fileSuffix);
    }
    
    override function createInitialLevel()
    {
		createLevel(pathPrefix + LEVEL_PATH[PlayState.curLevel] + fileSuffix);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        var pressedMap = false;

        grpPlayers.forEach
        (
            player->
            {
                minimap.updateSeen(player.playCamera);
                
                if (!pressedMap && player.controls.MAP)
                    openSubState(new MinimapSubstate(minimap, player, warpTo));
            }
        );
    }
    
    override function handleCheckpoint(checkpoint:Checkpoint, player:Player)
    {
        super.handleCheckpoint(checkpoint, player);

        minimap.showCheckpointGet(checkpoint.ID);
    }
    
    override function onFeedCheese(cheese:Cheese)
    {
        super.onFeedCheese(cheese);
        
		minimap.showCheeseGet(cheese.ID);
    }
}