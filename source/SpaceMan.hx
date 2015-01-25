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
	public var _gamePad:FlxGamepad;
	public var jump:Bool; // Controller:A Keyboard:S
	public var use:Bool; // Controller:X Keyboard:A 
	public var fire:Bool; // Controller:B Keyboard:D
	public var move_left:Bool; // Direction controls are keyboard arrow keys or Controller DPAD
	public var move_right:Bool;
	public var move_up:Bool;
	public var move_down:Bool;
	
	public var playerID:Int;
	
	public function new(X, Y, playerID_) 
	{
		playerID = playerID_;
		super(X, Y);		
		makeGraphic(myWidth.int(), myHeight.int(), 0xFFFFFFFF);
		createRectangularBody();
		setBodyMaterial(.5, .5, .5, 2);
		body.allowRotation = false;
		
		loadGraphic('assets/spaceman.png');
	}
	
	override public function update()
	{
		super.update();
		if (_gamePad != null)
		{
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_UP))
			{
				trace("The up button of the Xbox 360 controller is pressed.");
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_DOWN))
			{
				trace('test');
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_LEFT))
			{
				this.body.velocity.setxy(0, -500);
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_RIGHT))
			{
				this.body.velocity.setxy(0, 500);
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.A))
			{
				trace("Jump");
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.B))
			{
				trace("Pick Up.");
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.X))
			{
				trace("Fire.");
			}
			
		}
	}
	
}
