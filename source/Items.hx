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
class Items extends FlxNapeSprite
{

	public var holdPosXR : Float;
	public var holdPosXL : Float;
	public var holdPosY  : Float;

	override public function new(X:Float, Y:Float, W:Float, H:Float) 
	{
		super(X, Y);
		makeGraphic(W.int(), H.int(), 0xFFFFFFFF);
		createRectangularBody();
		setBodyMaterial(.5, .5, .5, 0.001);
		this.body.type = BodyType.DYNAMIC;
		body.allowRotation = false;
		body.allowMovement = true;
	}
	
	public function useItem(x, y)
	{
		var item = new Vec2(x, y);
		this.body.position.set(item);
	}
}
