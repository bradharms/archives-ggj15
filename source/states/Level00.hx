package states;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import openfl.display.FPS;
import nape.phys.BodyType;
using Std;

/**
 * ...
 * @author ...
 */
class Level00 extends MyBaseState
{
	static public inline var FNAME_LEVEL  = "assets/level00.png";
	static public inline var FNAME_BKG    = "assets/Environment_1.png";

	public function new() {
		super(FNAME_LEVEL, FNAME_BKG);
	}

	override public function create() {
		super.create();
		//trace(FlxG.cameras.list[0].)
	}
}
