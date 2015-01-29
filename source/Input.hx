
package ;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;

enum Buttons {
    RIGHT;
    DOWN;
    LEFT;
    UP;
    JUMP;
    FIRE;
    ACTION;
}

typedef KeyConf = Map<Buttons, String>;

typedef GamepadConf = Map<Buttons, {
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

class Input 
{

    private static var _instances = new InputMap();
    private static var _dummy     = new Input({});

    private var _keysConf    : KeyConf;
    private var _gamepadConfs : GamepadConfMap;
    private var _gamepads       : Map<Int,FlxGamepad>;

    private function new(conf : InputConf) {
        _keysConf = new KeyConf();
        _gamepadConfs = new GamepadConfMap();
        _gamepads = new Map<Int,FlxGamepad>();
        configure(conf);
    }

    public static function define(confs : Map<Int, InputConf>) {
        var instances = new InputMap();

        trace ("BEGIN PLAYER INPUT DEFINITIONS:");

        for (playerID in confs.keys()) {
            trace('  BEGIN PLAYER ${playerID} INPUT DEFINITION:');
            var conf = confs[playerID];
            if (!_instances.exists(playerID)) {
                trace("  Creating new...");
                _instances[playerID] =
                instances[playerID] = new Input(conf);
            } else {
                trace("  Updating existing...");
                instances[playerID] = _instances[playerID].configure(conf);
            }
            trace ('  END PLAYER ${playerID} DEFINITIONS');
        }

        trace ("END PLAYER INPUT DEFINITIONS.");

        return instances;
    }

    public function configure(conf : InputConf) {
        if (conf == null) {
            trace("    Conf passed was null; defaulting to empty.");
            conf = {};
        } else {
            conf = {
                keys : conf.keys,
                gamepads : conf.gamepads,
            };
        }

        if (conf.keys == null) {
            trace ("    Key conf passed was null; defaulting to empty.");
            conf.keys = new KeyConf();
        }

        if (conf.gamepads == null) {
            trace ("    Gamepad conf passed was null; defaulting to empty.");
            conf.gamepads = new GamepadConfMap();
        }

        // Process the configuration for each key
        for (btn in conf.keys.keys()) {
            var key = conf.keys[btn];
            // Allow key configurations to be deleted
            if (key == null) {
                trace ('    Deleting key for ${btn}.');
                if (_keysConf.exists(btn))
                    _keysConf.remove(btn);
            // Assign key to button
            } else {
                trace ('    Setting key for ${btn} to ${key}');
                _keysConf[btn] = key;
            }
        }

        // Gamepads
        for (gamepadID in conf.gamepads.keys()) {
            var gamepadConf = conf.gamepads[gamepadID];

            // Allow gamepad confs to be erased
            if (gamepadConf == null) {
                trace ('   Removing gamepad ${gamepadID}');
                if (_gamepadConfs.exists(gamepadID))
                    _gamepadConfs.remove(gamepadID);

            // Process the configuration for each gamepad
            } else {
                trace ('   Configuring gamepad ${gamepadID}');
                
                // Create the config mapping object for this gamepad if it does
                // not exist
                var myGamepadConf = _gamepadConfs[gamepadID] =
                    (!_gamepadConfs.exists(gamepadID))
                        ? new GamepadConf()
                        : _gamepadConfs[gamepadID];

                // Process the configuration for each of this gamepad's buttons
                for (btn in gamepadConf.keys()) {
                    var gamepadConfBtn = gamepadConf[btn];
                    // Allow gamepad button configurations to be deleted
                    if (gamepadConfBtn == null) {
                        if (myGamepadConf.exists(btn)) {
                            myGamepadConf.remove(btn);
                        }

                    // Assign my button to gamepad button
                    } else {
                        myGamepadConf[btn] = gamepadConfBtn;
                    }
                }
            }
        }

        return this;
    }

    public function pressed(btn : Buttons) {
        var p = false;
        
        // Check for key
        p = p || FlxG.keys.anyPressed([_keysConf[btn]]);

        // Check for each gamepad
        for (gamepadID in _gamepadConfs.keys()) {
            for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                if (gamepad.id == gamepadID) {
                    var gamepadConf = _gamepadConfs[gamepadID];
                    p = p || gamepad.anyPressed([gamepadConf[btn].button]);
                }
            }
        }

        return p;
    }

    public function justPressed(btn : Buttons) {
        var p = false;
        
        // Check for key
        p = p || FlxG.keys.anyJustPressed([_keysConf[btn]]);

        // Check for each gamepad
        for (gamepadID in _gamepadConfs.keys()) {
            for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                if (gamepad.id == gamepadID) {
                    var gamepadConf = _gamepadConfs[gamepadID];
                    p = p || gamepad.anyJustPressed([gamepadConf[btn].button]);
                }
            }
        }

        return p;
    }

    public function justReleased(btn : Buttons) {
        var p = false;
        
        // Check for key
        p = p || FlxG.keys.anyJustReleased([_keysConf[btn]]);

        // Check for each gamepad
        for (gamepadID in _gamepadConfs.keys()) {
            for (gamepad in FlxG.gamepads.getActiveGamepads()) {
                if (gamepad.id == gamepadID) {
                    var gamepadConf = _gamepadConfs[gamepadID];
                    p = p || gamepad.anyJustReleased([gamepadConf[btn].button]);
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
