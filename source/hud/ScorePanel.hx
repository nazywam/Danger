package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class ScorePanel extends FlxGroup {

    public var score : Digit;
    var slash : FlxSprite;
    public var maxScore : Digit;

    var background : FlxSprite;

    var state : Int = 1;

    public var time : Float = 0;

    public function new() {
        super();

        background = new FlxSprite(FlxG.width / 2, 0);
        background.loadGraphic(Data.ScorePanelImg);
        background.x -= background.width / 2;
        add(background);

        score = new Digit(250, 20, 0);
        add(score);

        slash = new FlxSprite(265, 20, Data.Slash);
        add(slash);

        maxScore = new Digit(280, 20, 0);
        add(maxScore);
    }

    private function toggle() {

        state = (state + 1) % 2;

        FlxTween.tween(background, { y: -background.height + background.height * state }, Rules.ScorePanelTweenTime, { ease: FlxEase.cubeOut, type: FlxTween.PERSIST } );
        FlxTween.tween(score, { y: -background.height + 20 + background.height * state }, Rules.ScorePanelTweenTime, { ease: FlxEase.cubeOut, type: FlxTween.PERSIST } );
        FlxTween.tween(slash, { y: -background.height + 20 + background.height * state }, Rules.ScorePanelTweenTime, { ease: FlxEase.cubeOut, type: FlxTween.PERSIST } );
        FlxTween.tween(maxScore, { y: -background.height + 20 + background.height * state }, Rules.ScorePanelTweenTime, { ease: FlxEase.cubeOut, type: FlxTween.PERSIST } );
    }

    override public function update(elapsed : Float) {
        if (time == -1 && state == 0) {
            toggle();
        }
        else if (time > 0) {
            time = Math.max(time - .1, 0);
            if (state == 0) {
                toggle();
            }
        }
        else if (time == 0 && state == 1) {
            toggle();
        }
    }

}