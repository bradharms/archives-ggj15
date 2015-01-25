package ;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadManager;
import flixel.input.gamepad.XboxButtonID;

using Std;
/**
 * ...
 * @author ...
 */
class SpaceMan extends FlxNapeSprite
{
	// User properties
	public static inline var myWidth = 100.0;
	public static inline var myHeight = 310.0;
	public static inline var jumpHeight:Int = 310;
	public static inline var myVelocity:Int = 500;
	// User status
	public var weapon:Dynamic;
	// User gamepad
	private var _gamePad:FlxGamepad;
	public var jump:Bool; // Controller:A Keyboard:S
	public var use:Bool; // Controller:X Keyboard:A 
	public var fire:Bool; // Controller:B Keyboard:D
	public var move_left:Bool; // Direction controls are keyboard arrow keys or Controller DPAD
	public var move_right:Bool;
	public var move_up:Bool;
	public var move_down:Bool;
	
	
	public function new(X, Y) 
	{
		super();		
		weapon = null;
		
		makeGraphic(myWidth.int(), myHeight.int(), 0xFFFFFFFF);
		createRectangularBody();
		loadGraphic('assets/spaceman.png');
		setBodyMaterial(.5, .5, .5, 2);
		body.position.y = Y;
		body.position.x = X;
		body.allowRotation = false;
	}
	
	override public function update()
	{
		super.update();
	}
	
}