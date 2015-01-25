
package ;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import nape.phys.BodyType;


using Std;

class MyBaseBlock extends FlxNapeSprite
{
    static public inline var DEFAULT_TILE_COLOR = 0xFFCCAAFF; 

    private var _fname : String;

    public function new(fname:String, X:Float, Y:Float, tileW:Float, tileH:Float) {
        super(X, Y);
        _fname = fname;
        makeGraphic(tileW.int(), tileH.int(), DEFAULT_TILE_COLOR);
        createRectangularBody( 0, 0, BodyType.STATIC );
        setBodyMaterial(.5, .5, .5, 2);

        loadGraphic( _fname );
        origin.x = width * 0.5;
        origin.y = height * 0.5;
        scale.x = body.bounds.width/width;
        scale.y = body.bounds.height/height;
    }

}
