
package ;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;

using Reflect;

enum Actions {
    RIGHT;
    DOWN;
    LEFT;
    UP;
    JUMP;
    FIRE;
    ACTION;
}


typedef KeyConf = Map<Actions, String>;

typedef GamepadConf = Map<Actions, {
    ?button : Int,
    ?axis   : {
        id        : Int,
        threshold : Float,
    },
}>;

typedef GamepadConfMap = Map<Int, GamepadConf>;

typedef InputConf = {
    ?keys     : KeyConf,
    ?gamepads : GamepadConfMap,
};

typedef InputMap = Map<Int, Input>;


@:allow(Input)
class Input 
{

    private static var _instances = new InputMap();
    private static var _dummy     = new Input({});

    private var _keyConf    : KeyConf;
    private var _gamepadConfs : GamepadConfMap;

    private function new(conf : InputConf) {
        _keyConf = new KeyConf();
        _gamepadConfs = new GamepadConfMap();
        configure(conf);
    }

    public static function define(confs : Map<Int, InputConf>) {
        var instances = new InputMap();

        for (playerID in confs.keys()) {
            var conf = confs[playerID];
            if (!_instances.exists(playerID)) {
                _instances[playerID] =
                instances[playerID] = new Input(conf);
            } else {
                instances[playerID] = _instances[playerID].configure(conf);
            }
        }

        return instances;
    }

    public static function exportAll() : Map<Int, InputConf> {
        var exInputs = new Map<Int, InputConf>();
        for (playerID in _instances.keys()) {
            var instance = _instances[playerID];
            exInputs[playerID] = {
                keys : instance._keyConf.copy(),
                gamepads : instance._gamepadConfs.copy(), // TODO: May require a deeper copy
            }
        }
        return exInputs;
    }

    public function configure(conf : InputConf) {
        if (conf == null) {
            conf = {};
        } else {
            conf = {
                keys : conf.keys,
                gamepads : conf.gamepads,
            };
        }

        if (conf.keys == null) {
            conf.keys = new KeyConf();
        }

        if (conf.gamepads == null) {
            conf.gamepads = new GamepadConfMap();
        }

        // Process the configuration for each key
        for (action in conf.keys.keys()) {
            var key = conf.keys[action];
            // Allow key configurations to be deleted
            if (key == null) {
                if (_keyConf.exists(action))
                    _keyConf.remove(action);
            // Assign key to action
            } else {
                _keyConf[action] = key;
            }
        }

        // Gamepads
        for (gamepadID in conf.gamepads.keys()) {
            var gamepadConf = conf.gamepads[gamepadID];

            // Allow gamepad confs to be erased
            if (gamepadConf == null) {
                if (_gamepadConfs.exists(gamepadID))
                    _gamepadConfs.remove(gamepadID);

            // Process the configuration for each gamepad
            } else {
                
                // Create the config mapping object for this gamepad if it does
                // not exist
                var myGamepadConf = _gamepadConfs[gamepadID] =
                    (!_gamepadConfs.exists(gamepadID))
                        ? new GamepadConf()
                        : _gamepadConfs[gamepadID];

                // Process the configuration for each of this gamepad's buttons
                for (action in gamepadConf.keys()) {
                    var gamepadConfAction = gamepadConf[action];
                    // Allow gamepad action configurations to be deleted
                    if (gamepadConfAction == null) {
                        if (myGamepadConf.exists(action)) {
                            myGamepadConf.remove(action);
                        }

                    // Assign my action to gamepad button
                    } else {
                        myGamepadConf[action] = gamepadConfAction;
                    }
                }
            }
        }

        return this;
    }

    public function pressed(action : Actions) {
        var p = false;
        
        // Check for key
        p = p || (_keyConf.exists(action)
            && FlxG.keys.anyPressed([_keyConf[action]]));

        // Check for each gamepad
        for (gamepadID in _gamepadConfs.keys()) {
            for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                if (_gamepadConfs.exists(gamepadID) && gamepad.id == gamepadID) {
                    var gamepadConf = _gamepadConfs[gamepadID];
                    p = p || (gamepadConf.exists(action)
                        && gamepad.anyPressed([gamepadConf[action].button]));
                }
            }
        }

        return p;
    }

    public function justPressed(action : Actions) {
        var p = false;
        
        // Check for key
        p = p || FlxG.keys.anyJustPressed([_keyConf[action]]);

        // Check for each gamepad
        for (gamepadID in _gamepadConfs.keys()) {
            for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                if (_gamepadConfs.exists(gamepadID) && gamepad.id == gamepadID) {
                    var gamepadConf = _gamepadConfs[gamepadID];
                    p = p || (gamepadConf.exists(action)
                        && gamepad.anyJustPressed([gamepadConf[action].button]));
                }
            }
        }

        return p;
    }

    public function justReleased(action : Actions) {
        var p = false;
        
        // Check for key
        p = p || FlxG.keys.anyJustReleased([_keyConf[action]]);

        // Check for each gamepad
        for (gamepadID in _gamepadConfs.keys()) {
            for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                if (_gamepadConfs.exists(gamepadID) && gamepad.id == gamepadID) {
                    var gamepadConf = _gamepadConfs[gamepadID];
                    p = p || (gamepadConf.exists(action)
                        && gamepad.anyJustReleased([gamepadConf[action].button]));
                }
            }
        }

        return p;
    }

    public static function getPlayer(playerID) {
        return  _instances.exists(playerID)
            ? _instances[playerID]
            : define([(playerID) => {}])[playerID];
    }

    public static function traceInputs() {

    }

}
