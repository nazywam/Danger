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
	
	public var disappearing : Bool = false;

	
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
	
	//disappear from map
	public function disappear() {
		solid = false;
		disappearing = true;
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		//disappear from map
		if (disappearing) {
			angle += Rules.CreepDisappearingAngleChange;
			scale.x = Math.max(scale.x - Rules.CreepDisappearingScaleChange, 0);
			scale.y = Math.max(scale.y - Rules.CreepDisappearingScaleChange, 0);
		}
			
		
		velocity.x += (finalVelocity.x - velocity.x) / Rules.VelocityPercentChange;
		velocity.y += (finalVelocity.y - velocity.y) / Rules.VelocityPercentChange;
		
		finalVelocity.x = finalVelocity.y = 0;
	}
}