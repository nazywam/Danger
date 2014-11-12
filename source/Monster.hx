package ;

import flixel.FlxSprite;

/**
 * ...
 * @author Michael
 */
class Monster extends Actor {
	
	public function new(X : Float, Y : Float)  {
		super(X, Y);
		loadGraphic(Data.MonsterImage, true, 32, 32);
		animation.add("stand", [0]);
		animation.add("walk", [0]);
		animation.add("run", [0]);
		animation.play("stand");
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
	}
}