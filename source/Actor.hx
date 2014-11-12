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
	
	public var waitingForRandomMove : Bool = false;
	public var running = false;
	
	public var gibs : FlxEmitter;
	
	public var finalVelocity : FlxPoint;
	
	public function new(X : Float, Y : Float) {
		super(X, Y);
		destinationPoint = new FlxPoint(x, y);
		originPoint = new FlxPoint(x, y);
		finalVelocity = new FlxPoint(0, 0);
		
		gibs = new FlxEmitter();
		gibs.solid = true;
		gibs.launchMode = FlxEmitterMode.CIRCLE;
		gibs.drag.set(50, 50, 100, 100, 50, 50, 100, 100);
		gibs.lifespan.set(1, 10);
	}
	
	//change to appropiate animation/direction
	private function changeAnimation() {
		flipX = (velocity.x < 0);
		
		if ( (velocity.x == 0 && velocity.y == 0) || (waitingForRandomMove && !running)) {
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
		if (destinationPoint.x < x) finalVelocity.x = -20;
		else finalVelocity.x = 20;
		} else {
			finalVelocity.x = 0;
		}
		if (Math.abs(destinationPoint.y - y) > 1) {
			if (destinationPoint.y < y) finalVelocity.y = -20;
			else finalVelocity.y = 20;
		} else {
			finalVelocity.y = 0;
		}
		//If targetPoint is closer than 3 px look for another target
		if (Math.abs(destinationPoint.x - x) < 3 && Math.abs(destinationPoint.y - y) < 3) needAnotherDestination = true;
		//Generate another target
		if (needAnotherDestination) {
			destinationPoint.set(originPoint.x + Std.random(30) - 15, originPoint.y + (Std.random(30) - 15));
			needAnotherDestination = false;
			
			waitingForRandomMove = true;
			new FlxTimer(Math.random()*5, function(_) { waitingForRandomMove = false; } );
		}
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		changeAnimation();
		
		velocity.x += (finalVelocity.x - velocity.x) / 10;
		velocity.y += (finalVelocity.y - velocity.y) / 10;
		finalVelocity.x = finalVelocity.y = 0;
		
		if (running) {
			originPoint.set(x, y);
		}
		if (!running && !waitingForRandomMove) {
			moveRandomly();
		}
	}
	
	//when hit wall look for another target
	public function bounce() {
		needAnotherDestination = true;
	}
	
}