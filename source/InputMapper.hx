
package ;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.keyboard.FlxKey;

using Lambda;
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
    Key(key:Int);
    GamepadButton(buttonID:Int, ?gamepadID:Int);
    GamepadAxis(axisID:Int, threshold:Float, ?gamepadID:Int);
    GamepadDPad(x:Float, y:Float, ?gamepadID:Int);
}

typedef ActionInputsMap = Map<Action, Array<Input>>;

@:allow(InputMapper)
class InputMapper 
{

    private static var _instances = new Map<Int, InputMapper>();
    private static var _prevAxisPos = new Map<Int, Map<Int, Float>>();
    private static var _prevDPadAxisPos = new Map<Int, {x:Float, y:Float}>();

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
                            _prevAxisPos[gamepadID] = new Map<Int, Float>();
                        if (!_prevAxisPos[gamepadID].exists(axisID))
                            _prevAxisPos[gamepadID][axisID] = 0.0;

                    // Initialize missing hat position data if necessary
                    case GamepadDPad(_, _, gamepadID):
                        if (!_prevDPadAxisPos.exists(gamepadID))
                            _prevDPadAxisPos[gamepadID] = {x:0.0, y:0.0};
                    
                    default: // this line is required for haxe
                }
            }
        }

        return this;
    }

    public function checkStatus(action : Action, status = FlxKey.PRESSED) {
        var gamepad : FlxGamepad;
        var p       = false;
        var pos     : Float;
        var prevPos : Float;
        var s       : Int;

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

    private static inline function _checkGamepadDPad(gamepadID, x:Float, y:Float, status) {
        
        // Non-flash targets use this calculation
        #if !flash
        
        var result = false;
        if (FlxG.gamepads.getActiveGamepadIDs().indexOf(gamepadID) != -1) {
            var dp                      = FlxG.gamepads.getByID(gamepadID).hat;
            var prevDP                  = _prevDPadAxisPos[gamepadID];
            _prevDPadAxisPos[gamepadID] = {x: dp.x, y: dp.y};

            result = switch (status) {

                case FlxKey.PRESSED:

                    // Current signs match
                    
                      ((x == 0 && dp.x == 0)
                    || (x >  0 && dp.x >  0)
                    || (x <  0 && dp.x <  0))
                    &&
                      ((y == 0 && dp.y != 0)
                    || (y >  0 && dp.y >  0)
                    || (y <  0 && dp.y <  0));

                case FlxKey.JUST_PRESSED:

                    // Current signs match, previous signs do NOT match
                    
                      (((x == 0) && (dp.x == 0) && (prevDP.x != 0))
                    || ((x >  0) && (dp.x >  0) && (prevDP.x <= 0))
                    || ((x <  0) && (dp.x <  0) && (prevDP.x >= 0)))
                    
                    &&

                      (((y == 0) && (dp.y == 0) && (prevDP.y != 0))
                    || ((y >  0) && (dp.y >  0) && (prevDP.y <= 0))
                    || ((y <  0) && (dp.y <  0) && (prevDP.y >= 0)));

                case FlxKey.JUST_PRESSED:
                    
                    // Current signs do NOT match, previous signs match
                    
                      (((x == 0) && (dp.x != 0) && (prevDP.x != 0))
                    || ((x >  0) && (dp.x <  0) && (prevDP.x >= 0))
                    || ((x <  0) && (dp.x >  0) && (prevDP.x <= 0)))
                    
                    &&

                      (((y == 0) && (dp.y == 0) && (prevDP.y != 0))
                    || ((y >  0) && (dp.y <  0) && (prevDP.y >= 0))
                    || ((y <  0) && (dp.y >  0) && (prevDP.y <= 0)));
                
                default: false;
            }

        }
        return result;
        
        // Flash sees false for this no matter what
        #else

        false;
        
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

    public static function getPlayer(playerID) {
        return _instances.exists(playerID)
            ? _instances[playerID]
            : define([playerID => null])[playerID];
    }

    public static function traceInput() {

    }

}
