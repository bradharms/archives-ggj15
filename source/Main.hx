package;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.system.FlxSplash;
import openfl.Lib;
import states.*;

class Main extends Sprite 
{
	public static var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var gameHeight:Int = 800; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	public static var initialState:Class<FlxState> = states.Level00; // The FlxState the game starts with.
	public static var framerate:Int = 30; // How many frames per second the game should run at.
	public static var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	public static var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	
	// You can pretty much ignore everything from here on - your code should go in your states.
	
	public static function main():Void
	{	
		Lib.current.addChild(new Main());
	}
	
	public function new() 
	{
		super();
		
		if (stage != null) 
		{
			init();
		}
		else 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	private function init(?E:Event):Void 
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		setupGame();
	}
	
	private function setupGame():Void
	{
		applyCameraZoom(FlxG.camera);
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
	}

	public static function applyCameraZoom(camera) {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var sw = Lib.current.stage.stageWidth;
			var sh = Lib.current.stage.stageHeight;
			var ratioX:Float =  sw/ gameWidth;
			var ratioY:Float =  sh / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(sw / zoom);
			gameHeight = Math.ceil(sh / zoom);
		}
	}
}
