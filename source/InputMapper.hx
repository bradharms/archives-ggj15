
package ;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;

using Reflect;

enum Action {
    RIGHT;
    DOWN;
    LEFT;
    UP;
    JUMP;
    FIRE;
    ACTION;
}
 
enum Input {
    Key(key:String);
    GamepadButton(buttonID:Int, ?gamepadID:Int);
    GamepadAxis(axisID:Int, threshold:Float, ?gamepadID:Int);
}

typedef ActionInputsMap = Map<Action, Array<Input>>;

@:allow(InputMapper)
class InputMapper 
{

    private static var _instances = new Map<Int, InputMapper>();

    private var _actionInputsMap : ActionInputsMap;

    private function new(actionInputsMap : ActionInputsMap) {
        _actionInputsMap = new ActionInputsMap();
        configure(actionInputsMap);
    }

    public static function define(confs : Map<Int, ActionInputsMap>) {
        var instances = new Map<Int, InputMapper>();

        for (playerID in confs.keys()) {
            var actionInputsMap = confs[playerID];
            if (!_instances.exists(playerID)) {
                _instances[playerID] =
                instances[playerID] = new InputMapper(actionInputsMap);
            } else {
                instances[playerID] = _instances[playerID].configure(actionInputsMap);
            }
        }

        return instances;
    }

    // public static function exportAll() : Map<Int, InputConf> {
    //     var exInputs = new Map<Int, InputConf>();
    //     for (playerID in _instances.keys()) {
    //         var instance = _instances[playerID];
    //         exInputs[playerID] = {
    //             keys : instance._keyConf.copy(),
    //             gamepads : instance._gamepadConfs.copy(), // TODO: May require a deeper copy
    //         }
    //     }
    //     return exInputs;
    // }

    public function configure(?actionInputsMap : ActionInputsMap) {
        if (actionInputsMap == null)
            actionInputsMap = new ActionInputsMap();

        // Process the configuration for input
        for (action in actionInputsMap.keys()) {
            this._actionInputsMap[action] = actionInputsMap[action];
        }

        return this;
    }

    public function pressed(action : Action) {
        var p = false;
        
        for (input in _actionInputsMap[action]) {
            switch (input) {
                case Key(key):
                    p = FlxG.keys.anyPressed([key]);

                case GamepadButton(buttonID, gamepadID):
                    for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                        if (gamepad.id == gamepadID) {
                            p = gamepad.anyPressed([buttonID]);
                        }
                    }

                case GamepadAxis(axisID, threshold, gamepadID):
                    for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                        if (gamepad.id == gamepadID) {
                            var f = threshold >= 0 ? 1 : -1;
                            p = gamepad.getAxis(axisID) >= (threshold * f);
                        }
                    }

                default:
            }
        }

        return p;
    }

    public function justPressed(action : Action) {
        var p = false;
        
        for (input in _actionInputsMap[action]) {
            switch (input) {
                case Key(key):
                    p = FlxG.keys.anyPressed([key]);

                case GamepadButton(buttonID, gamepadID):
                    for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                        if (gamepad.id == gamepadID) {
                            p = gamepad.anyJustPressed([buttonID]);
                        }
                    }

                default:
            }
        }

        return p;
    }

    public function justReleased(action : Action) {
        var p = false;
        
        for (input in _actionInputsMap[action]) {
            switch (input) {
                case Key(key):
                    p = FlxG.keys.anyPressed([key]);

                case GamepadButton(buttonID, gamepadID):
                    for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                        if (gamepad.id == gamepadID) {
                            p = gamepad.anyJustReleased([buttonID]);
                        }
                    }

                default:
            }
        }

        return p;
    }

    public static function getPlayer(playerID) {
        return  _instances.exists(playerID)
            ? _instances[playerID]
            : define([playerID => null])[playerID];
    }

    public static function traceInput() {

    }

}
