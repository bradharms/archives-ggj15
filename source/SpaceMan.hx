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
	// User status
	public var weapon:Dynamic;
	private var _gamepad:FlxGamepad;
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
		// User gamepad
		if (FlxG.gamepads.lastActive != null)
		{
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_UP))
			{
			}
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_DOWN))
			{
				trace('test');
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_LEFT))
			{
				this.body.velocity.setxy(-500, 0);
			}
			if (FlxG.gamepads.lastActive.justReleased(XboxButtonID.DPAD_LEFT))
			{
				this.body.velocity.setxy(0, 0);
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_RIGHT))
			{
				this.body.velocity.setxy(500, 0);
			}
			if (FlxG.gamepads.lastActive.justReleased(XboxButtonID.DPAD_RIGHT))
			{
				this.body.velocity.setxy(0, 0);
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.A))
			{
				this.body.velocity.setxy(0, -500);
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
