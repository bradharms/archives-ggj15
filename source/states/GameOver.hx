package states;

import flixel.text.FlxText;

import flixel.FlxState;

class GameOver extends FlxState {
    
    override public function create() {
        super.create();
        var txt = new FlxText( 640, 400, "You got sucked into a black hole, and won the game.", 16 );
        add(txt);
    }
}
