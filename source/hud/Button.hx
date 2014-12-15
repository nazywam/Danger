package hud;

import flixel.FlxSprite;

class Button extends FlxSprite {

    public var clickable : Bool;

    public function new(X : Float, Y : Float, data : String, clickable : Bool) {
        super(X, Y);
        loadGraphic(data, true, 155, 60);
        animation.add("default", [0]);
        animation.add("pressed", [1]);

        if (clickable) {
            animation.play("default");
        }
        else {
            animation.play("pressed");
        }
    }

}