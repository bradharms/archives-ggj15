package ;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadManager;
import flixel.input.gamepad.XboxButtonID;
import nape.geom.Vec2;

using Std;

/**
 * ...
 * @author ...
 */
class Items extends FlxNapeSprite
{

	public var holdPosXR : Float;
	public var holdPosXL : Float;
	public var holdPosY  : Float;

	override public function new(X, Y) 
	{
		super(X, Y);
	}
	
	public function useItem(x, y)
	{
		var item = new Vec2(x, y);
		this.body.position.set(item);
	}
}
