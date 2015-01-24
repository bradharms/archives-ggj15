package source.states;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import openfl.display.FPS;

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
		add(new FlxSprite(0, 0, "assets/Environment_1.png"));
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		FlxG.removeChild(fps);
	}
	
	
	
	
}