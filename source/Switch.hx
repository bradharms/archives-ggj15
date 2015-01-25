
package ;

import flixel.FlxSprite ;

class Switch extends FlxSprite {
{
    public function new (X, Y) {
        super(X,Y);
        this.loadGraphic("assets/switch48.png", true, 48, 48);
    }

}
