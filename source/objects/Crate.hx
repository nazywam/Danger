package objects;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Crate extends FlxSprite {

    public var lowered : Bool = false;

    public function new(x : Float, y : Float) {
        super(x, y);
        immovable = true;

        loadGraphic(Data.CrateImg, true, 32, 64);

        animation.add("default", [0]);
        animation.add("hide", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], 16, false);

        height = 32;
    }

    //crate falls into a hole
    public function lower() {
        lowered = true;

        FlxTween.tween(this, { y: y + 16}, 1, { type: FlxTween.PERSIST } );
        var t = new FlxTimer();
        t.start(1, function(_) {
                solid = false;
            });
        animation.play("hide");
    }

}