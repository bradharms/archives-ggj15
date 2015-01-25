
package ;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxPoint;
import openfl.Assets;
import openfl.display.FPS;
import openfl.errors.Error;
import nape.phys.BodyType;
import openfl.media.Sound;
import openfl.media.SoundChannel;

using Std;

class MyBaseState extends FlxNapeState
{
    static public inline var DEFAULT_CELL_W = 150.0;
    static public inline var DEFAULT_CELL_H = 150.0;
    static public inline var DEFAULT_GRAIVITY = 500.0;

    static public var bgmChan : SoundChannel = null;
    
    public var fps     : FPS;
    public var bkg     : FlxSprite;
    public var loader  : LevelLoader;
    public var bgm     : Sound;
    public var players : Array<SpaceMan>;
    public var items   : Array<Items>;
    public var cellW   : Float;
    public var cellH   : Float; 

    private var _fnameBkg   : String;
    private var _fnameLevel : String;
    private var _fnameBgm   : String;
    private var _grav       : Float;

    public function new(fnameLevel, fnameBkg, ?fnameBgm, cellW_=0.0, cellH_=0.0, grav=0.0) {
        super();

        _fnameLevel = fnameLevel;
        _fnameBkg   = fnameBkg;
        _fnameBgm   = fnameBgm;
        cellW       = cellW_ != 0.0 ? cellW_ : DEFAULT_CELL_W;
        cellH       = cellH_ != 0.0 ? cellH_ : DEFAULT_CELL_H;
        _grav       = grav   != 0.0 ? grav   : DEFAULT_GRAIVITY;
        players     = [null, null];
        items       = [];
    }

    override public function create() 
    {
        super.create();

        // Play music for this level
        if (_fnameBgm != null) {
            bgm = Assets.getSound(_fnameBgm);
            if (bgmChan != null) {
                bgmChan.stop();
            }
            if (bgm != null) {
                bgmChan = bgm.play();
            }
        }

        // Reset cameras, prepare to have them attached by the level loader
        //FlxG.cameras.reset();
        //FlxG.cameras.remove(FlxG.camera);
        
        // Add the background
        bkg = new FlxSprite(0, 0, _fnameBkg);
        bkg.scrollFactor.set(0.0, 0.0);
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

    override public function update() {
        super.update();
        if (players[0] != null && players[1] != null) {
            var midX = (players[0].body.position.x + players[1].body.position.x) * 0.5;
            var midY = (players[0].body.position.y + players[1].body.position.y) * 0.5;
            FlxG.camera.focusOn(new FlxPoint(midX, midY));
            //FlxG.camera.setScale(0.5, 0.5);
        }
    }

    public function createFloor(X:Float, Y:Float, W:Float, H:Float) {
        var floor = new FlxNapeSprite(X, Y);
        floor.makeGraphic(W.int(), H.int(), 0xFFFFFFFF);
        floor.createRectangularBody(0, 0, BodyType.STATIC);
        floor.setBodyMaterial(.5, .5, .5, 2);
        return floor;
    }

}
