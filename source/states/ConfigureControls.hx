package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyList;
import flixel.text.FlxText;
import InputMapper.Action;
import InputMapper.Input;

using Std;
using Reflect;
using Type;

class ConfigureControls extends FlxState
{
    public static inline var TEXT_SIZE = 32;
    public static inline var HEADER = "Configure player controls. [Esc] = use defaults.";

    public var txtHeader          : FlxText;
    public var txtInfo            : FlxText;
    public var actions            : Array<Action>;
    public var maxPlayers         = 2;
    public var currentPlayer      = 0;
    public var currentActionIndex = 0;

    private var _prevAxisPos      : Map<Int, Array<Float>>;

    override public function create() {
        txtHeader = new FlxText(0, 0, Main.gameWidth, HEADER, TEXT_SIZE, true);
        add(txtHeader);
        txtInfo = new FlxText(txtHeader.x, txtHeader.y+txtHeader.height, txtHeader.width, "", TEXT_SIZE, true);
        add(txtInfo);

        if (FlxG.save.data.hasField("inputs")) {
            //Input.define(cast(FlxG.save.data.inputs, Map<Int, InputConf>));
            gotoNextState();
        } else {
            for (playerID in 0...maxPlayers)
                InputMapper.define([ playerID => null ]);
            actions = [for (f in Action.getEnumConstructs()) if (f != "") Action.createEnum(f) ];
        }

        _prevAxisPos = new Map<Int, Array<Float>>();
    }

    override public function update() {
        var key = FlxG.keys.firstJustPressed();
        var gamepad = FlxG.gamepads.getFirstActiveGamepad();

        txtInfo.text = 'Press ${actions[currentActionIndex]} for player ${currentPlayer}';

        // If the user pressed the ESCAPE key, use the default controls
        if (key == "ESCAPE") {
            defineDefaultControls();
            gotoNextState();

        // If the user pressed any key other than the ESCAPE key, use that key as the input for the current player's current action
        } else if (key != "") {
            InputMapper.define([
                currentPlayer => [
                    actions[currentActionIndex] => [Input.Key(FlxG.keys.getKeyCode(key))]
                ]
            ]);
            trace ('Player ${currentPlayer} ${actions[currentActionIndex]} set to key ${key}');
            gotoNextInput();

        // If the user did not press a key but did activate a gamepad input, figure out what that gamepad input was
        } else if (gamepad != null) {

            // If the gamepad has a button being pressed, use the button
            var buttonID = gamepad.firstJustPressedButtonID();
            if (buttonID != -1) {
                InputMapper.define([
                    currentPlayer => [
                        actions[currentActionIndex] => [Input.GamepadButton(buttonID, gamepad.id)]
                    ]
                ]);
                trace ('Player ${currentPlayer} ${actions[currentActionIndex]} set to gamepad ${gamepad.id} button ${buttonID}');
                gotoNextInput();

            // Look for axises that have just crossed the threshold
            } else {
                // If we haven't started scanning for axis positions on this gamepad yet, start now
                if (!_prevAxisPos.exists(gamepad.id))
                    _prevAxisPos[gamepad.id] = [for (i in 0...6) 0.0];

                // NOTE: We are only going to scan for the first 6 inputs (X1, Y1, X2, Y2, LT, RT)
                for (axisID in 0...6) {
                    var axisPos = switch (axisID) {
                        case 0: gamepad.getXAxis(axisID);
                        case 1: gamepad.getYAxis(axisID);
                        default: gamepad.getAxis(axisID);
                    }
                    var prevAxisPos = _prevAxisPos[gamepad.id][axisID];
                    _prevAxisPos[gamepad.id][axisID] = axisPos;
                    
                    // See if the axis has crossed the positive threshold
                    if (axisPos >= 0.5 && prevAxisPos < 0.5) {
                        InputMapper.define([
                            currentPlayer => [
                                actions[currentActionIndex] => [Input.GamepadAxis(axisID, 0.5, gamepad.id)]
                            ]
                        ]);
                        trace ('Player ${currentPlayer} ${actions[currentActionIndex]} set to gamepad ${gamepad.id} positive axis ${axisID}');
                        gotoNextInput();

                    // See if the axis has crossed the negative threshold
                    } else if (axisPos <= -0.5 && prevAxisPos > -0.5) {
                        InputMapper.define([
                            currentPlayer => [
                                actions[currentActionIndex] => [Input.GamepadAxis(axisID, -0.5, gamepad.id)]
                            ]
                        ]);
                        trace ('Player ${currentPlayer} ${actions[currentActionIndex]} set to gamepad ${gamepad.id} negative axis ${axisID}');
                        gotoNextInput();
                    }
                }
            }
        }
    }

    public function gotoNextInput() {
        currentActionIndex++;
        if (currentActionIndex >= actions.length) {
            currentPlayer++;
            if (currentPlayer >= maxPlayers) {
                save();
                gotoNextState();
            }
            currentActionIndex = 0;
        }
    }

    public function save() {
        // FlxG.save.data.inputs = Input.exportAll();
        // FlxG.save.flush();
    }

    public function gotoNextState() {
        FlxG.switchState(new states.Level00());
    }

    public static function defineDefaultControls() {
        InputMapper.define([
            // Player 1 default controls
            0 => [
                Action.UP     => [Input.Key(FlxKey.W)],
                Action.LEFT   => [Input.Key(FlxKey.A)],
                Action.DOWN   => [Input.Key(FlxKey.S)],
                Action.RIGHT  => [Input.Key(FlxKey.D)],
                Action.JUMP   => [Input.Key(FlxKey.Z)],
                Action.FIRE   => [Input.Key(FlxKey.X)],
                Action.ACTION => [Input.Key(FlxKey.C)],
            ],

            // Player 2 default controls
            1 => [
                Action.UP     => [Input.GamepadButton(0)],
                Action.LEFT   => [Input.GamepadButton(1)],
                Action.DOWN   => [Input.GamepadButton(2)],
                Action.RIGHT  => [Input.GamepadButton(3)],
                Action.JUMP   => [Input.GamepadButton(4)],
                Action.FIRE   => [Input.GamepadButton(5)],
                Action.ACTION => [Input.GamepadButton(6)],
            ],
        ]);
    }
}
