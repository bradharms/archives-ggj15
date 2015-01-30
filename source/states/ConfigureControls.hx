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

    var txtHeader          : FlxText;
    var txtInfo            : FlxText;
    var actions            : Array<Action>;
    var maxPlayers         = 2;
    var currentPlayer      = 0;
    var currentActionIndex = 0;

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
    }

    override public function update() {
        var key = FlxG.keys.firstJustPressed();
        var gamepad = FlxG.gamepads.getFirstActiveGamepad();

        txtInfo.text = 'Press ${actions[currentActionIndex]} for player ${currentPlayer}';

        if (key == "ESCAPE") {
            defineDefaultControls();
            gotoNextState();
        } else if (key != "") {
            InputMapper.define([
                currentPlayer => [
                    actions[currentActionIndex] => [Input.Key(key)]
                ]
            ]);
            gotoNextInput();
        } else if (gamepad != null) {
            var buttonID = gamepad.firstJustPressedButtonID();
            if (buttonID != -1) {
                InputMapper.define([
                    currentPlayer => [
                        actions[currentActionIndex] => [Input.GamepadButton(buttonID, gamepad.id)]
                    ]
                ]);
                trace ('Player ${currentPlayer} ${actions[currentActionIndex]} set to gamepad ${gamepad.id} button ${buttonID}');
                gotoNextInput();
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
                Action.UP     => [Input.Key("W")],
                Action.LEFT   => [Input.Key("A")],
                Action.DOWN   => [Input.Key("S")],
                Action.RIGHT  => [Input.Key("D")],
                Action.JUMP   => [Input.Key("Z")],
                Action.FIRE   => [Input.Key("X")],
                Action.ACTION => [Input.Key("C")],
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
