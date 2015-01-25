
package ;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxCamera;
import flixel.util.FlxPoint;
import nape.phys.BodyType;
import openfl.Assets;

using Std;

typedef SpawnerCallback = Int -> Int -> Int -> Void;


class LevelLoader
{


    static public inline var COL_EMPTY          = 0xFFFFFF;
    static public inline var COL_SOLID          = 0x000000;
    static public inline var COL_DIRT           = 0xFF4444;
    static public inline var COL_LADDER         = 0x888888;
    static public inline var COL_PLAYER1        = 0xFF0000;
    static public inline var COL_PLAYER2        = 0x0000FF;
    static public inline var COL_JETPACK        = 0xFFFF00;
    static public inline var COL_BLASTER        = 0x00FF00;
    static public inline var COL_SPAWNLADDER    = 0xFF8800;
    static public inline var COL_SWITCHLADDER   = 0xFF00FF;
    static public inline var COL_MOVINGPLATFORM = 0x8800FF;

    public var spawners : Map<Int, SpawnerCallback>;
    
    public var state    : MyBaseState;
    public var fname    : String;
    public var tileW    : Float;
    public var tileH    : Float;

    public function new(state:MyBaseState, fname:String, tileW : Float, tileH : Float) {
        this.state = state;
        this.fname = fname;
        this.tileW = tileW;
        this.tileH = tileH;

        spawners = [
            COL_EMPTY          => spawnEmpty,
            COL_SOLID          => spawnSolid,
            COL_DIRT           => spawnDirt,
            COL_LADDER         => spawnLadder,
            COL_PLAYER1        => spawnPlayer1,
            COL_PLAYER2        => spawnPlayer2,
            COL_JETPACK        => spawnJetpack,
            COL_BLASTER        => spawnBlaster,
            COL_SPAWNLADDER    => spawnSpawnLadder,
            COL_SWITCHLADDER   => spawnSwitchLadder,
            COL_MOVINGPLATFORM => spawnMovingPlatform,
        ];
    };

    public function load() {
        var bitmapData = Assets.getBitmapData(fname);

        for (cellY in 0...bitmapData.height) {
            for (cellX in 0...bitmapData.width) {
                var col = bitmapData.getPixel(cellX, cellY);
                if (spawners.exists(col)) {
                    spawners[col](cellX, cellY, col);
                } else {
                    trace ('Unknown color at ${cellX}, ${cellY}');
                }
            }
        }
    }

    public function spawnEmpty(cellX, cellY, col) {
        
    }

    public function spawnSolid(cellX, cellY, col) {
        var p = getPoint(cellX, cellY);
        //var brick = new FlxNapeSprite(p.x, p.y);
        //brick.makeGraphic( tileW.int(), tileH.int(), DEFAULT_TILE_COLOR);
        //brick.createRectangularBody( 0, 0, BodyType.STATIC );
        //brick.setBodyMaterial(.5, .5, .5, 2);
        var brick = new GoldBlock(p.x, p.y, tileW, tileH);
        state.add(brick);
    }

    public function spawnDirt(cellX, cellY, col) {

    }

    public function spawnLadder(cellX, cellY, col) {
        
    }

    public function spawnPlayer1(cellX, cellY, col) {
        var p = getPoint(cellX, cellY);
        var player = new SpaceMan(p.x, p.y, 0);
        state.players[0] = player;
        state.add(player);

        //var camera = new FlxCamera(0, 0, Main. , ?Height : Int , ?Zoom : Float );
    }

    public function spawnPlayer2(cellX, cellY, col) {
        var p = getPoint(cellX, cellY);
        var player = new SpaceMan(p.x, p.y, 1);
        state.players[1] = player;
        state.add(player);
    }

    public function spawnJetpack(cellX, cellY, col) {
        
    }

    public function spawnBlaster(cellX, cellY, col) {
        
    }

    public function spawnSpawnLadder(cellX, cellY, col) {
        
    }

    public function spawnSwitchLadder(cellX, cellY, col) {
        
    }

    public function spawnMovingPlatform(cellX, cellY, col) {
        
    }

    public function getPoint(cellX, cellY) {
        return new FlxPoint(
            (cellX * tileW),
            (cellY * tileH)
        );
    }
}
