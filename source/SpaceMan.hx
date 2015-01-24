package source;

import flixel.addons.nape.FlxNapeSprite;

/**
 * ...
 * @author ...
 */
class SpaceMan extends FlxNapeSprite
{
	public var myWidth = 100.0;
	public var myHeight = 310.0;
	
	override public function create(X, Y) 
	{
		super.create();
		loadGraphic('assets/spaceman.png');
		setBodyMaterial(.5, .5, .5, 2);
		body.position.y = Y;
		body.position.x = X;
		body.allowRotation = false;
		origin.x = 118.0;
		origin.y = 35.0;
	}
	
}