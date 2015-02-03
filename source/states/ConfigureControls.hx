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
    public var inputMapper        : InputMapper;
    public var currentActionIndex = 0;

    override public function create() {
        txtHeader = new FlxText(0, 0, Main.gameWidth);
        txtHeader.setFormat("assets/Xolonium-Regular.otf" ,TEXT_SIZE,0xFFFFFF,"left",0,0,true);
        add(txtHeader);
        txtInfo = new FlxText(txtHeader.x, txtHeader.y+txtHeader.height);
        txtInfo.setFormat("assets/Xolonium-Regular.otf",TEXT_SIZE,0xFFFFFF,"left",0,0,true);
        add(txtInfo);

        if (FlxG.save.data.hasField("inputs")) {
            //Input.define(cast(FlxG.save.data.inputs, Map<Int, InputConf>));
            gotoNextState();
        } else {
            for (playerID in 0...maxPlayers)
                InputMapper.define([ playerID => null ]);
            actions = [for (f in Action.getEnumConstructs()) if (f != "") Action.createEnum(f) ];
            inputMapper = InputMapper.getPlayer(currentPlayer);
        }
    }

    override public function update() {

        txtInfo.text = 'Press ${actions[currentActionIndex]} for player ${currentPlayer}';

        // If the user pressed the ESCAPE key, use the default controls
        if (FlxG.keys.justPressed.ESCAPE) {
            defineDefaultControls();
            gotoNextState();

        // If the user did not press the escape key, attempt to grab an input and assign it
        } else {
            if (inputMapper.grab(actions[currentActionIndex], 0.5)) {
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
            } else {
                inputMapper = InputMapper.getPlayer(currentPlayer);
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
                Action.UP     => [Input.GamepadDPad(0, -1)],
                Action.LEFT   => [Input.GamepadDPad(-1, 0)],
                Action.DOWN   => [Input.GamepadDPad(0,  1)],
                Action.RIGHT  => [Input.GamepadDPad(1,  0)],
                Action.JUMP   => [Input.GamepadButton(0)],
                Action.FIRE   => [Input.GamepadButton(1)],
                Action.ACTION => [Input.GamepadButton(2)],
            ],
        ]);
    }
}
