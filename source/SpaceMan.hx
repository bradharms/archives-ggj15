package ;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadManager;
import flixel.input.gamepad.XboxButtonID;
import nape.geom.Vec2;
import openfl.Assets;
import openfl.media.Sound;
import openfl.media.SoundChannel;

using Std;
/**
 * ...
 * @author ...
 */
class SpaceMan extends FlxNapeSprite
{
	public static inline var GFX_FNAME  = 'assets/spacemanFullSS.png';
	
	#if flash
	public static inline var STEP_FNAME  = 'assets/sound/footsteps.mp3';
	#else
	public static inline var STEP_FNAME  = 'assets/sound/footsteps.ogg';
	#end

	public static inline var ANIM_STAND = 'stand';
	public static inline var ANIM_WALK  = 'walk';
	public static inline var ANIM_CLIMB = 'climb';

	// User properties
	public static inline var myWidth = 100.0;
	public static inline var myHeight = 310.0;
	public static inline var jumpPower:Int = 600;
	public static inline var accel:Float = 80;
	public static inline var maxSpeed:Float = 500;
	// User status
	public var weapon:Items;
	private var _gamepad:FlxGamepad;
	public var jump:Bool; // Controller:A Keyboard:S
	public var use:Bool; // Controller:X Keyboard:A 
	public var fire:Bool; // Controller:B Keyboard:D
	public var move_left:Bool; // Direction controls are keyboard arrow keys or Controller DPAD
	public var move_right:Bool;
	public var move_up:Bool;
	public var move_down:Bool;
	
	public var playerID:Int;
	public var sfx : Sound;
	public var sfxChan : SoundChannel = null;
	
	public function new(X, Y, playerID_) 
	{
		playerID = playerID_;
		super(X, Y);		
		makeGraphic(myWidth.int(), myHeight.int(), 0xFFFFFFFF);
		createRectangularBody();
		setBodyMaterial(0.1, .999, .999);
		body.allowRotation = false;
		
		loadGraphic(GFX_FNAME, true, 348, 348);
		animation.add(ANIM_STAND, [0] ,                   10, true);
		animation.add(ANIM_WALK,  [for (i in 10...20) i], 15, true);
		animation.add(ANIM_CLIMB, [20, 21],               4,  true);
		
		
		animation.play(ANIM_STAND);

		sfx = Assets.getSound(STEP_FNAME);
	}
	
	override public function update()
	{
		var force : Vec2,
		    newVel : Vec2;

		super.update();
		
		// User gamepad
		var gamepad = FlxG.gamepads.lastActive;
		if (playerID == 0 || gamepad != null)
		{
			if ((playerID == 0 && FlxG.keys.pressed.UP)
				|| (playerID == 1 && FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_UP)))
			{

			}
			
			if ((playerID == 0 && FlxG.keys.pressed.DOWN)
				|| (playerID == 1 && FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_DOWN)))
			{
				trace('test');
			}

			if ((playerID == 0 &&  FlxG.keys.pressed.LEFT)
				|| (playerID == 1 && FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_LEFT)))
			{
				force = Vec2.weak(-accel, 0);
				newVel = this.body.velocity.add( force );
				if (newVel.x > -maxSpeed)
					this.body.velocity = newVel;
			}

			if ((playerID == 0 && FlxG.keys.pressed.RIGHT)
				|| (playerID == 1 && FlxG.gamepads.lastActive.pressed(XboxButtonID.DPAD_RIGHT)))
			{
				force = Vec2.weak(accel, 0);
				newVel = this.body.velocity.add( force );
				if (newVel.x < maxSpeed)
					this.body.velocity = newVel; 
			}

			if ((playerID == 0 && FlxG.keys.justPressed.S)
				|| (playerID == 1 && FlxG.gamepads.lastActive.pressed(XboxButtonID.A)))
			{
				if (body.velocity.y == 0)
					this.body.velocity.y = -jumpPower;
			}

			if ((playerID == 0 && FlxG.keys.justPressed.A)
				||  (playerID == 1 && FlxG.gamepads.lastActive.pressed(XboxButtonID.B)))
			{
				var collisions = body.interactingBodies();
				var st = cast(FlxG.state, MyBaseState);
				var shortestDist = 999999.0;
				var closestItem : Items = null;
				for (stItem in st.items) {
					var dist = Vec2.distance(body.position, stItem.body.position);
					if (dist < shortestDist) {
						shortestDist = dist;
						closestItem = stItem;
					}
				}
				if (shortestDist < 250.0 && closestItem != null
					&& ( (playerID == 0 && st.players[1].weapon != closestItem) ||
					 	 (playerID == 1 && st.players[0].weapon != closestItem))) {
					trace("pickup");
				}
			}

			if ((playerID == 0 && FlxG.keys.justPressed.D)
				||  (playerID == 1 && FlxG.gamepads.lastActive.pressed(XboxButtonID.X)))
			{
				trace("Fire.");
			}
		}

		// animation
		if (body.velocity.x > 0.01) {
			animation.play(ANIM_WALK);
			this.flipX = false;
			stepSounds(true);
		} else if (body.velocity.x < -0.01) {
			animation.play(ANIM_WALK);
			this.flipX = true;
			stepSounds(true);
		} else {
			animation.play(ANIM_STAND);
			stepSounds(false);
		}
	}

	function stepSounds(on) {
		if (on) {
			if (sfxChan == null && sfx != null) {
				sfxChan = sfx.play( 0 , 10 );
			}
		} else {
			if (sfxChan != null) {
				sfxChan.stop();
				sfxChan = null;
			}
		}
	}
}
