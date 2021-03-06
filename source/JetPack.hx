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
class JetPack extends Items
{
	public static inline var JETPACK_FNAME = 'assets/jetPack157_SS.png';
	
	public static inline var JETPACK_ANIM_OFF = 'off';
	public static inline var JETPACK_ANIM_ON = 'on';
	
	public static inline var jetpackWidth = 75.0;
	public static inline var jetpackHeight = 123.0;
	
	public function new(X, Y) 
	{
		super(X, Y, jetpackWidth, jetpackHeight);
		holdPosXR = -80.0;
		holdPosXL = 80.0;
		holdPosY  = -35.0;
		
		loadGraphic(JETPACK_FNAME, true, 156, 156);
		animation.add(JETPACK_ANIM_ON, [for (i in 0...2) i], 30, true);
		animation.add(JETPACK_ANIM_OFF, [0], 10, true);
		
		animation.play(JETPACK_ANIM_ON);
	}
	
	override public function useItem(x, y) {
		super.useItem(x, y);
		
	}
	
}
