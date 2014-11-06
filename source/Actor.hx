package ;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Michael
 */
class Actor extends FlxSprite {

	public var destinationPoint : FlxPoint;
	public var originPoint : FlxPoint;
	public var needAnotherDestination : Bool = true;
	
	public var waiting : Bool = false;
	public var running = false;
	
	public var gibs : FlxEmitter;
	
	public function new(X : Float, Y : Float) {
		super(X, Y);
		destinationPoint = new FlxPoint(x, y);
		originPoint = new FlxPoint(x, y);
		
		gibs = new FlxEmitter();
		gibs.solid = true;
		gibs.launchMode = FlxEmitterMode.CIRCLE;
		gibs.drag.set(50, 50, 100, 100, 50, 50, 100, 100);
		gibs.lifespan.set(100, 10000);
	}
	
	//change to appropiate animation/direction
	private function changeAnimation() {
		flipX = (velocity.x < 0);
		
		if (velocity.x == 0 && velocity.y == 0) {
			animation.play("stand");
		} else if (!running) {
			animation.play("walk");
		} else if (running) {
			animation.play("run");
		}
	}
	
	//get distance between point 1 and 2
	function distance(x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Float {
		return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
	}
	
	//apply velocity, move randomly if not chased
	private function moveRandomly() {
		if (Math.abs(destinationPoint.x - x) > 1) {
		if (destinationPoint.x < x) velocity.x = -20;
		else velocity.x = 20;
		} else {
			velocity.x = 0;
		}
		if (Math.abs(destinationPoint.y - y) > 1) {
			if (destinationPoint.y < y) velocity.y = -20;
			else velocity.y = 20;
		} else {
			velocity.y = 0;
		}
		//If targetPoint is closer than 3 px look for another target
		if (Math.abs(destinationPoint.x - x) < 3 && Math.abs(destinationPoint.y - y) < 3) needAnotherDestination = true;
		//Generate another target
		if (needAnotherDestination) {
			destinationPoint.set(originPoint.x + Std.random(20) - 10, originPoint.y + (Std.random(20) - 10));
			needAnotherDestination = false;
			
			waiting = true;
			new FlxTimer(Math.random()*5, function(_) { waiting = false; } );
		}
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		if ( running) {
			originPoint.set(x, y);
			needAnotherDestination = true;
		}
		if (!running && !waiting) {
			moveRandomly();
		}
		changeAnimation();
	}
	
	//when hit wall look for another target
	public function bounce() {
		needAnotherDestination = true;
		velocity.x *= 1.1;
	}
	
}