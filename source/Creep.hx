package ;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxG;

/**
 * ...
 * @author Michael
 */
class Creep extends FlxSprite {

	var destination : FlxPoint;
	var needAnotherDestination : Bool = true;
	
	public function new(X : Float, Y  : Float) {
			super(X, Y);
			destination = new FlxPoint(x, y);
			
			loadGraphic(Data.CreepImage, true, 17, 20);
			animation.add("stand", [0], 1);
			animation.add("walk", [0, 1, 2, 3], 15);
			animation.add("run", [10, 11, 12, 13], 15);
	}
	
	private function changeAnimation() {
		
		flipX = (velocity.x < 0);
		
		if (velocity.x == 0 && velocity.y == 0) {
			animation.play("stand");
		} else {
			animation.play("walk");
		}
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
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
			destination.set(x + Std.random(100) - 50, y + (Std.random(100) - 50));
			needAnotherDestination = false;
		}	
		
		changeAnimation();
	}
	public function bounce() {
		needAnotherDestination = true;
	}
}