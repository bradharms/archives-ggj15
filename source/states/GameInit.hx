
package states;

import flixel.FlxG;
import flixel.FlxState;

class GameInit extends FlxState
{

    override public function create() {
        gotoNextState();
    }

    public function gotoNextState() {
        FlxG.switchState(new states.ConfigureControls());
    }

}
