package actors;

import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class Creep extends Actor {

	var destinationPoint : FlxPoint;
	var originPoint : FlxPoint;


	var needAnotherDestination : Bool = true;
	var waitingForRandomMove : Bool = false;

    public function new(X : Float, Y : Float) {
        super(X, Y);

        destinationPoint = new FlxPoint(x, y);
        originPoint = new FlxPoint(x, y);

        loadGraphic(Data.CreepImg, true, 17, 20);
        animation.add("stand", [0], 1);
        animation.add("walk", [0, 1, 2, 3], 15);
        animation.add("run", [4, 5, 6, 7], 20);
        animation.add("dead", [8]);

        width = 10;
        offset.x = 3;
    }

    override private function changeAnimation() {
        super.changeAnimation();

        if ( (velocity.x == 0 && velocity.y == 0) || (waitingForRandomMove && !running)) {
            animation.play("stand");
        }
        else if (!running) {
            animation.play("walk");
        }
        else if (running) {
            animation.play("run");
        }
    }

    function getAnotherTarget() {
        destinationPoint.set(originPoint.x + Std.random(Rules.CreepRandomMoveMaxRange * 2) - Rules.CreepRandomMoveMaxRange, originPoint.y + (Std.random(Rules.CreepRandomMoveMaxRange * 2) - Rules.CreepRandomMoveMaxRange));
    }

    //apply velocity, move randomly if not chased
    private function moveRandomly() {
        if (Math.abs(destinationPoint.x - x) > 1) {
            if (destinationPoint.x < x) finalVelocity.x = -Rules.CreepRandomMoveVelocity;
            else finalVelocity.x = Rules.CreepRandomMoveVelocity;
        }
        else {
            finalVelocity.x = 0;
        }
        if (Math.abs(destinationPoint.y - y) > 1) {
            if (destinationPoint.y < y) finalVelocity.y = -Rules.CreepRandomMoveVelocity;
            else finalVelocity.y = Rules.CreepRandomMoveVelocity;
        }
        else {
            finalVelocity.y = 0;
        }

        //If targetPoint is close engouth look for another target
        if (Math.abs(destinationPoint.x - x) < 3 && Math.abs(destinationPoint.y - y) < 3) needAnotherDestination = true;

        if (needAnotherDestination) {
            getAnotherTarget();
            needAnotherDestination = false;
            waitingForRandomMove = true;
            var timer = new FlxTimer();
            timer.start(Math.random() * 5, function(_) {
                    waitingForRandomMove = false;
                } );
        }
    }

    //when hit wall look for another target
    public function bounceFromWall() {
        if (!running) {
            getAnotherTarget();
            waitingForRandomMove = true;
            var timer = new FlxTimer();
            timer.start(Math.random() * 2, function(_) {
                    waitingForRandomMove = false;
                } );
        }
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);

        if (alive) {

            changeAnimation();

            if (running) {
                originPoint.set(x, y);
            }
            if (!running && !waitingForRandomMove) {
                moveRandomly();
            }
        }
    }
}