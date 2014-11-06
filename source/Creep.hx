package ;

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
	
	public function new(X : Float, Y  : Float) {
			super(X, Y);
	
			loadGraphic(Data.CreepImage, true, 17, 20);
			animation.add("stand", [0], 1);
			animation.add("walk", [0, 1, 2, 3], 15);
			animation.add("run", [10, 11, 12, 13], 20);
			
			gibs.loadParticles(Data.CreepGibs, 20, 16, true);
			
			width = 10;
			offset.x = 3;
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
	}
}