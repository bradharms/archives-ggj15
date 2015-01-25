
package ;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxSprite;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.errors.Error;
import nape.phys.BodyType;

using Std;

class MyBaseState extends FlxNapeState
{
    static public inline var DEFAULT_CELL_W = 100.0;
    static public inline var DEFAULT_CELL_H = 100.0;
    static public inline var DEFAULT_GRAIVITY = 500.0;

    public var fps     : FPS;
    public var bkg     : FlxSprite;
    public var loader  : LevelLoader;   
    public var players : Array<SpaceMan>;
    public var cellW   : Float;
    public var cellH   : Float; 

    private var _fnameBkg   : String;
    private var _fnameLevel : String;
    private var _grav       : Float;

    public function new(fnameLevel, fnameBkg, cellW_=0.0, cellH_=0.0, grav=0.0) {
        super();

        _fnameLevel = fnameLevel;
        _fnameBkg   = fnameBkg;
        cellW       = cellW_ != 0.0 ? cellW_ : DEFAULT_CELL_W;
        cellH       = cellH_ != 0.0 ? cellH_ : DEFAULT_CELL_H;
        _grav       = grav   != 0.0 ? grav   : DEFAULT_GRAIVITY;
        players     = [null, null];
    }

    override public function create() 
    {
        super.create();

        // Reset cameras, prepare to have them attached by the level loader
        //FlxG.cameras.reset();
        //FlxG.cameras.remove(FlxG.camera);
        
        // Add the background
        bkg = new FlxSprite(0, 0, _fnameBkg);
        add(bkg);

        // Load the level (this will add cameras)
        loader = new LevelLoader(this, _fnameLevel, cellW, cellH);
        loader.load();

        // Apply gravity
        FlxNapeState.space.gravity.setxy(0, _grav);
    }

    override public function destroy():Void 
    {
        super.destroy();
        FlxG.removeChild(fps);
    }

    public function createFloor(X:Float, Y:Float, W:Float, H:Float) {
        var floor = new FlxNapeSprite(X, Y);
        floor.makeGraphic(W.int(), H.int(), 0xFFFFFFFF);
        floor.createRectangularBody(0, 0, BodyType.STATIC);
        floor.setBodyMaterial(.5, .5, .5, 2);
        return floor;
    }

}
