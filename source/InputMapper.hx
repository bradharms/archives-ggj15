
package ;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.keyboard.FlxKey;

using Lambda;
using Reflect;
using Util;

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
    Key(key:Int);
    GamepadButton(buttonID:Int, ?gamepadID:Int);
    GamepadAxis(axisID:Int, threshold:Float, ?gamepadID:Int);
    GamepadDPad(x:Float, y:Float, ?gamepadID:Int);
}

typedef ActionInputsMap = Map<Action, Array<Input>>;

@:allow(InputMapper)
class InputMapper 
{

    public static inline var MAX_AXIS = 6;

    private static var _instances = new Map<Int, InputMapper>();
    private static var _prevAxisPos = new Map<Int, Array<Float>>();

    #if !flash
    private static var _prevDPadAxisPos = new Map<Int, {x:Float, y:Float}>();
    #end

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
            var inputs = actionInputsMap[action];
            this._actionInputsMap[action] = inputs;

            for (input in inputs) {
                switch (input) {
                    // Initialize missing axis threshold data if necessary 
                    case GamepadAxis(axisID, _, gamepadID):
                        if (!_prevAxisPos.exists(gamepadID))
                            _prevAxisPos[gamepadID] = [];
                        while (_prevAxisPos[gamepadID].length < axisID)
                            _prevAxisPos[gamepadID].push(0.0);

                    #if !flash
                    // Initialize missing hat position data if necessary
                    case GamepadDPad(_, _, gamepadID):
                        if (!_prevDPadAxisPos.exists(gamepadID))
                            _prevDPadAxisPos[gamepadID] = {x:0.0, y:0.0};
                    #end
                    
                    default: // this line is required for haxe
                }
            }
        }

        return this;
    }

    public function checkStatus(action : Action, status = FlxKey.PRESSED) {
        var p = false;

        if (_actionInputsMap.exists(action)) {
            for (input in _actionInputsMap[action]) {
                if (p) break;
                p = p || switch (input) {

                    case Key(key):
                        _checkKey(key, status);

                    case GamepadButton(buttonID, gamepadID):
                        _checkGamepadButton(gamepadID, buttonID, status);

                    case GamepadAxis(axisID, threshold, gamepadID):
                        _checkGamepadAxis(gamepadID, axisID, threshold, status);
                    
                    case GamepadDPad(x, y, gamepadID):
                        _checkGamepadDPad(gamepadID, x, y, status);

                    default: false;
                }
            }
        }

        return p;
    }

    private static inline function _checkKey(key, status) {
        return FlxG.keys.checkStatus(key, status);
    }

    private static inline function _checkGamepadButton(gamepadID:Int, buttonID:Int, status:Int) {
        return (FlxG.gamepads.getActiveGamepadIDs().indexOf(gamepadID) != -1) 
            && (FlxG.gamepads.getByID(gamepadID).checkStatus(buttonID, status));
    }

    private static inline function _checkGamepadAxis(gamepadID:Int, axisID:Int, threshold:Float, status:Int) {
        var result = false;
        if (FlxG.gamepads.getActiveGamepadIDs().indexOf(gamepadID) != -1) {
            var gamepad = FlxG.gamepads.getByID(gamepadID);
            var s       = threshold >= 0 ? 1 : -1;
            
            // Use X and Y-specific functions for the first two
            // axises because the docs say the generic function
            // doesn't work on the flash target
            var pos = switch (axisID) {
                case 0:  gamepad.getXAxis(axisID);
                case 1:  gamepad.getYAxis(axisID);
                default: gamepad.getAxis(axisID);
            }

            var prevPos = _prevAxisPos[gamepadID][axisID];
            _prevAxisPos[gamepadID][axisID] = pos;

            switch (status) {
                case FlxKey.PRESSED:
                    result = (pos * s) >= (threshold * s);
                
                case FlxKey.JUST_PRESSED:
                    result =(pos * s) >= (threshold * s)
                        && (prevPos * s) < (threshold * s);
                
                case FlxKey.JUST_RELEASED:
                    result = (pos * s) < (threshold * s)
                        && (prevPos * s) >= (threshold *s);

                default: 
                    result = false;
            }
        }
        return result;
    }

    private static inline function _checkGamepadDPad(gamepadID:Int, x:Float, y:Float, status:Int) {
        
        // Non-flash targets use this calculation
        #if !flash
        
        var result = false;
        if (FlxG.gamepads.getActiveGamepadIDs().indexOf(gamepadID) != -1) {
            var dp                      = FlxG.gamepads.getByID(gamepadID).hat;
            var prevDP                  = _prevDPadAxisPos[gamepadID];
            _prevDPadAxisPos[gamepadID] = {x: dp.x, y: dp.y};

            var sx  = x.sign();
            var sy  = y.sign();
            var sxD = dp.x.sign();
            var syD = dp.y.sign();
            var sxP = prevDP.x.sign();
            var syP = prevDP.y.sign();

                     // At least one dimension must be in use
            result = (x != 0 || y != 0) && switch (status) {

                case FlxKey.PRESSED:

                    // Current signs must match; don't care about previous signs
                       ((sx == 0) || (sx == sxD))
                    && ((sy == 0) || (sy == syD));

                case FlxKey.JUST_PRESSED:

                    // Current signs must match, previous signs must differ
                       ((sx == 0) || ((sx == sxD) && (sxD != sxP)))
                    && ((sy == 0) || ((sy == syD) && (syD != syP)));

                case FlxKey.JUST_RELEASED:
                    
                    // Current signs must differ, previous signs must match
                       ((sx == 0) || ((sx != sxD) && (sxD == sxP)))
                    && ((sy == 0) || ((sy != syD) && (syD == syP)));
                
                default: false;
            }

        }

        return result;
        
        // Flash sees false for this no matter what
        #else

        return false;
        
        #end
    }

    public inline function pressed(action : Action) {
        return checkStatus(action, FlxKey.PRESSED);
    }

    public inline function justPressed(action : Action) {
        return checkStatus(action, FlxKey.JUST_PRESSED);
    }

    public inline function justReleased(action : Action) {
        return checkStatus(action, FlxKey.JUST_RELEASED);
    }

    /**
     * Return the next input being pressed by the user in the form of an Input constant
     *
     * @param axisThreshold Amount by which an axis has to be pushed in either direction in order to register as an input press
     */
    static public function acquire(axisThreshold = 0.5) : Input {
        var input : Input = null;

        var key = FlxG.keys.firstJustPressed();

        if (key != "") {
            input = Input.Key(FlxG.keys.getKeyCode(key));

        } else {
            var gamepad = FlxG.gamepads.getFirstActiveGamepad();

            if (gamepad != null) {

                var buttonID = gamepad.firstJustPressedButtonID();
                if (buttonID != -1) {
                    input = Input.GamepadButton(buttonID, gamepad.id);

                } else {

                    #if !flash
                    if (!_prevDPadAxisPos.exists(gamepad.id))
                        _prevDPadAxisPos[gamepad.id] = {x : 0.0, y : 0.0};

                    var dpX     = gamepad.hat.x;
                    var dpY     = gamepad.hat.y;
                    var prevDpX = _prevDPadAxisPos[gamepad.id].x;
                    var prevDpY = _prevDPadAxisPos[gamepad.id].y;
                    _prevDPadAxisPos[gamepad.id] = {x : dpX, y : dpY};

                    if (dpX != 0 && dpX != prevDpX && dpY != 0 && dpY != prevDpY) {
                        input = Input.GamepadDPad(dpX.sign(), dpY.sign(), gamepad.id);
                    } else if (dpX != 0 && dpX != prevDpX) {
                        input = Input.GamepadDPad(dpX.sign(), 0, gamepad.id);
                    } else if (dpY != 0 && dpY != prevDpY) {
                        input = Input.GamepadDPad(0, dpY.sign(), gamepad.id);
                    }
                    #end

                    if (input == null) {
                        if (!_prevAxisPos.exists(gamepad.id))
                            _prevAxisPos[gamepad.id] = [for (i in 0...MAX_AXIS) 0.0];

                        for (axisID in 0...MAX_AXIS) {
                            var axisPos = switch (axisID) {
                                case 0:  gamepad.getXAxis(axisID);
                                case 1:  gamepad.getYAxis(axisID);
                                default: gamepad.getAxis(axisID);
                            }

                            var prevAxisPos = _prevAxisPos[gamepad.id][axisID];
                            _prevAxisPos[gamepad.id][axisID] = axisPos;
                            
                            if (axisPos >= axisThreshold && prevAxisPos < axisThreshold) {
                                input = Input.GamepadAxis(axisID, axisThreshold, gamepad.id);
                                break;
                            }
                            else if (axisPos <= -axisThreshold && prevAxisPos > -axisThreshold) {
                                input = Input.GamepadAxis(axisID, -axisThreshold, gamepad.id);
                                break;
                            }
                        }
                    }
                }
            }
        }

        return input;
    }

    /**
     * Acquire the next input pressed by the user and assign it as the input for the given action.
     * Does nothing if there is currently no user input.
     * Returns whether or not an input was assigned.
     */
    public function grab(action:Action, axisThreshold = 0.5) {
        var input = acquire(axisThreshold);
        if (input != null) {
            _actionInputsMap[action] = [input];
            return true;
        } else {
            return false;
        }
    }

    public static function getPlayer(playerID) {
        return _instances.exists(playerID)
            ? _instances[playerID]
            : define([playerID => null])[playerID];
    }

    public static function traceInput() {

    }

}
