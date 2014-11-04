package ;

import flixel.FlxSprite;

/**
 * ...
 * @author Michael
 */
class Monster extends FlxSprite {

	public var chasing : Bool = false;
	
	public function new(X : Float, Y : Float)  {
		super(X, Y);
		loadGraphic(Data.MonsterImage, true, 32, 32);
		animation.add("stand", [0]);
		animation.play("stand");
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
	}
	
}