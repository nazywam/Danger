package actors;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

//base class for Creep and Monster
class Actor extends FlxSprite {

    public var running = false;
    public var finalVelocity : FlxPoint;
    var disappearing : Bool = false;

    public function new(X : Float, Y : Float) {
        super(X, Y);
        finalVelocity = new FlxPoint(0, 0);
    }

    private function changeAnimation() {
        if (velocity.x < 0 ) {
            flipX = true;
        }
        else if (velocity.x > 0) {
            flipX = false;
        }
    }

    function distance(x1 : Float, y1 : Float, x2 : Float, y2 : Float): Float {
        return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
    }

    public function disappear() {
        solid = false;
        disappearing = true;
    }

    public function die() {

        alive = false;
        animation.play("dead");

        FlxTween.angle(this, angle, angle + 90, .3, {ease: FlxEase.bounceOut, type: FlxTween.PERSIST } );
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);

        if (disappearing) {
            angle += Rules.CreepDisappearingAngleChange;
            scale.x = Math.max(scale.x - Rules.CreepDisappearingScaleChange, 0);
            scale.y = Math.max(scale.y - Rules.CreepDisappearingScaleChange, 0);
        }

        // smooth the velocity change
        velocity.x += (finalVelocity.x - velocity.x) / Rules.VelocityPercentChange;
        velocity.y += (finalVelocity.y - velocity.y) / Rules.VelocityPercentChange;

        finalVelocity.x = finalVelocity.y = 0;
    }
}