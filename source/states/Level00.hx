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
	var fps:FPS;
	override public function create() 
	{
		super.create();
		var spaceMan = new SpaceMan(200, 400);
		add(new FlxSprite(0, 0, "assets/Environment_1.png"));
		add(spaceMan);
		add(createFloor(100, spaceMan.body.position.y + spaceMan.myHeight, 50, 50));
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