package states;

class RaceState extends PlayState
{
    var pathPrefix:String = 'assets/data/ogmo/raceLevels/';
    var fileSuffix:String = '.json';

    public static var LEVEL_PATH:Array<String> = [
        //'raceStart0',
        //'raceStart0',
        'raceStart0'
    ];

    override function create()
    {
        PlayState.isRace = true;

        super.create();
    }
    
    override function createInitialLevel()
    {
        createLevel(pathPrefix + LEVEL_PATH[PlayState.curLevel] + fileSuffix);
    }
}