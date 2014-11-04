package ;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Michael
 */
class Creep extends FlxSprite {

	var destination : FlxPoint;
	public var needAnotherDestination : Bool = true;
	public var waiting : Bool = false;
	
	public var runningAway : Bool = false;
	
	public var disappearing : Bool = false;
	
	public function new(X : Float, Y  : Float) {
			super(X, Y);
			destination = new FlxPoint(x, y);
			
			loadGraphic(Data.CreepImage, true, 17, 20);
			animation.add("stand", [0], 1);
			animation.add("walk", [0, 1, 2, 3], 15);
			animation.add("run", [10, 11, 12, 13], 20);
	}
	
	//get appropiate animation/direction
	private function changeAnimation() {
		
		flipX = (velocity.x < 0);
		
		if (velocity.x == 0 && velocity.y == 0) {
			animation.play("stand");
		} else if (!runningAway) {
			animation.play("walk");
		} else if (runningAway) {
			animation.play("run");
		}
	}
	
	//disappear from map
	public function enterExit() {
		solid = false;
		disappearing = true;
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		//disappear from map
		if (disappearing) {
			angle += 13;
			scale.x = Math.max(scale.x - 0.02, 0);
			scale.y = Math.max(scale.y - 0.02, 0);
		}
		
		//apply velocity, move randomly if not chased
		if (!runningAway && !waiting) {
			if (Math.abs(destination.x - x) > 1) {
			if (destination.x < x) velocity.x = -20;
			else velocity.x = 20;
			} else {
				velocity.x = 0;
			}
			if (Math.abs(destination.y - y) > 1) {
				if (destination.y < y) velocity.y = -20;
				else velocity.y = 20;
			} else {
				velocity.y = 0;
			}
			if (Math.abs(destination.x - x) < 3 && Math.abs(destination.y - y) < 3) needAnotherDestination = true;
			if (needAnotherDestination) {
				destination.set(x + Std.random(20) - 10, y + (Std.random(20) - 10));
				needAnotherDestination = false;
				waiting = true;
				new FlxTimer(Math.random()*5, function(_) { waiting = false; } );
			}
		}
		
		changeAnimation();
	}
	//when hit wall look for another target
	public function bounce() {
		needAnotherDestination = true;
	}
}