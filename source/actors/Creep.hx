package actors ;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Michael
 */
class Creep extends Actor {
	
	public var disappearing : Bool = false;
	
	public var destinationPoint : FlxPoint;
	public var originPoint : FlxPoint;
	
	public var needAnotherDestination : Bool = true;
	public var waitingForRandomMove : Bool = false;
	
	public function new(X : Float, Y  : Float) {
			super(X, Y);
	
			destinationPoint = new FlxPoint(x, y);
			originPoint = new FlxPoint(x, y);
			
			loadGraphic(Data.CreepImage, true, 17, 20);
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
		} else if (!running) {
			animation.play("walk");
		} else if (running) {
			animation.play("run");
		}
	}
	
	//Generate another target
	function getAnotherTarget() {
		destinationPoint.set(originPoint.x + Std.random(30) - 15, originPoint.y + (Std.random(30) - 15));
	}
	//apply velocity, move randomly if not chased
	private function moveRandomly() {
		if (Math.abs(destinationPoint.x - x) > 1) {
		if (destinationPoint.x < x) finalVelocity.x = -25;
		else finalVelocity.x = 25;
		} else {
			finalVelocity.x = 0;
		}
		if (Math.abs(destinationPoint.y - y) > 1) {
			if (destinationPoint.y < y) finalVelocity.y = -25;
			else finalVelocity.y = 25;
		} else {
			finalVelocity.y = 0;
		}
		
		//If targetPoint is close look for another target
		if (Math.abs(destinationPoint.x - x) < 3 && Math.abs(destinationPoint.y - y) < 3) needAnotherDestination = true;
		
		if (needAnotherDestination) {
			getAnotherTarget();
			needAnotherDestination = false;
			waitingForRandomMove = true;
			var timer = new FlxTimer();
			timer.start(Math.random()*5, function(_) { waitingForRandomMove = false; } );
		}
	}	
	
	//disappear from map
	public function enterExit() {
		solid = false;
		disappearing = true;
	}
	
	//when hit wall look for another target
	public function bounce() {
		if (!running) {
			getAnotherTarget();
			waitingForRandomMove = true;
			var timer = new FlxTimer();
			timer.start(Math.random()*2, function(_) { waitingForRandomMove = false; } );
		}
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		if (alive) {
		
			changeAnimation();
			
			//disappear from map
			if (disappearing) {
				angle += 13;
				scale.x = Math.max(scale.x - 0.02, 0);
				scale.y = Math.max(scale.y - 0.02, 0);
			}
			
			if (running) {
				originPoint.set(x, y);
			}
			if (!running && !waitingForRandomMove) {
				moveRandomly();
			}
		}
	}
}