package ;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadManager;
import flixel.input.gamepad.XboxButtonID;
import nape.geom.Vec2;
import nape.phys.BodyType;

using Std;

/**
 * ...
 * @author ...
 */
class Blaster extends Items
{
	public static inline var blasterWidth = 82.0;
	public static inline var blasterHeight = 73.0;
	
	public function new(X, Y) 
	{
		super(X, Y, blasterWidth, blasterHeight);		
		loadGraphic('assets/blaster.png');
	}
	
	override public function useItem(x, y) {
		super.useItem(x, y);		
	}
	
}
