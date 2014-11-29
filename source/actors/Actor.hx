package actors ;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Michael
 */
class Actor extends FlxSprite {
	
	public var running = false;
	
	public var finalVelocity : FlxPoint;
	
	public function new(X : Float, Y : Float) {
		super(X, Y);
		finalVelocity = new FlxPoint(0, 0);
	}
	
	//change to appropiate animation/direction
	private function changeAnimation() {
		if (velocity.x < 0 ) {
			flipX = true;
		} else if (velocity.x > 0) {
			flipX = false;
		}
	}
	
	//get distance between point 1 and 2
	function distance(x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Float {
		return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		velocity.x += (finalVelocity.x - velocity.x) / Rules.VelocityPercentChange;
		velocity.y += (finalVelocity.y - velocity.y) / Rules.VelocityPercentChange;
		
		finalVelocity.x = finalVelocity.y = 0;
	}
}