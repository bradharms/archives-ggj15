package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import Input.Actions;
import Input.InputConf;

using Std;
using Reflect;
using Type;

class ConfigureControls extends FlxState
{
    public static inline var TEXT_SIZE = 32;
    public static inline var HEADER = "Configure player controls. [Esc] = use defaults.";

    var txtHeader          : FlxText;
    var txtInfo            : FlxText;
    var actions            : Array<Actions>;
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
                Input.define([ playerID => {} ]);
            actions = [for (f in Actions.getEnumConstructs()) if (f != "") Actions.createEnum(f) ];
        }
    }

    override public function update() {
        var key = FlxG.keys.firstJustPressed();
        var gamepad = FlxG.gamepads.getFirstActiveGamepad();

        txtInfo.text = 'Press ${actions[currentActionIndex]} for player ${currentPlayer}';

        if (key != "") {
            Input.define([
                currentPlayer => {
                    keys: [
                        actions[currentActionIndex] => key
                    ]
                }
            ]);
            gotoNextInput();
        } else if (gamepad != null) {
            var buttonID = gamepad.firstJustPressedButtonID();
            var axisID = gamepad.getAxis
            if (buttonID != -1) {
                Input.define([
                    currentPlayer => { 
                        gamepads : [
                            gamepad.id => [
                                actions[currentActionIndex] => {
                                    button : buttonID,
                                    axis : null
                                }
                            ]
                        ]
                    }
                ]);
                trace ('Player ${playerID} ${actions[currentActionIndex]} set to gamepad ${gamepad.id} button ${buttonID}');
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
        Input.define([
            // Player 1 default controls
            0 => {
                keys : [
                    Actions.UP     => "W",
                    Actions.LEFT   => "A",
                    Actions.DOWN   => "S",
                    Actions.RIGHT  => "D",
                    Actions.JUMP   => "Z",
                    Actions.FIRE   => "X",
                    Actions.ACTION => "C",
                ],
            },

            // Player 2 default controls
            1 => {
                gamepads : [
                    0 => [
                        Actions.UP     => {button : 0, axis : null},
                        Actions.LEFT   => {button : 1, axis : null},
                        Actions.DOWN   => {button : 2, axis : null},
                        Actions.RIGHT  => {button : 3, axis : null},
                        Actions.JUMP   => {button : 4, axis : null},
                        Actions.FIRE   => {button : 5, axis : null},
                        Actions.ACTION => {button : 6, axis : null},
                    ],
                ],
            },
        ]);
    }
}
