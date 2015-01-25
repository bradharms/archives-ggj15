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
class SpaceMan extends FlxNapeSprite
{
	public static inline var ANIM_STAND = 'stand';
	public static inline var ANIM_WALK  = 'walk';
	public static inline var ANIM_CLIMB = 'climb';

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
		
		loadGraphic('assets/spacemanFullSS.png', true, 348, 348);
		animation.add(ANIM_STAND, [0] ,                   10, true);
		animation.add(ANIM_WALK,  [for (i in 10...20) i], 15, true);
		animation.add(ANIM_CLIMB, [20, 21],               4,  true);
		
		animation.play(ANIM_WALK);
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
			
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_DOWN))
			{
				trace('test');
			}
			if (FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_LEFT))
			{
				var force = new Vec2(-50, 0);
				var newVel = this.body.velocity.add( force );
				if (newVel.x > -500)
					this.body.velocity = newVel; 
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
}
