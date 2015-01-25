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
class Level00 extends FlxNapeState
{
<<<<<<< Updated upstream
	static public inline var FNAME  = "assets/level1.png";
	static public inline var CELL_W = 100.0;
	static public inline var CELL_H = 100.0;

	var loader : LevelLoader;	
	var fps:FPS;
	public var players:Array;

	override public function create() 
	{
		super.create();
		add(new FlxSprite(0, 0, "assets/Environment_1.png"));
		loader = new LevelLoader(this, FNAME, CELL_W, CELL_H);
		loader.load();
		FlxNapeState.space.gravity.setxy(0, 500);
	}
	
	public function createFloor(X:Float, Y:Float, W:Float, H:Float) {
		var floor = new FlxNapeSprite(X, Y);
		floor.makeGraphic(W.int(), H.int(), 0xFFFFFFFF);
		floor.createRectangularBody(0, 0, BodyType.STATIC);
		floor.setBodyMaterial(.5, .5, .5, 2);
		return floor;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		FlxG.removeChild(fps);
	}
	
	
	
	
}
