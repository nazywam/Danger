package actors;

import flixel.FlxSprite;

class Monster extends Actor {

    public function new(X : Float, Y : Float) {
        super(X, Y);
        loadGraphic(Data.MonsterImg, true, 19, 23);
        animation.add("stand", [0]);
        animation.add("walk", [0, 1, 2, 3], 12);
        animation.add("run", [4, 5, 6, 7], 12);
        animation.play("stand");
    }

    override private function changeAnimation() {
        super.changeAnimation();

        if ( Math.abs(velocity.x) <= 2 && Math.abs(velocity.y) <= 2) {
            animation.play("stand");
        }
        else {
            animation.play("run");
        }
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);
        changeAnimation();
    }
}