package objects ;
import flixel.FlxSprite;

/**
 * ...
 * @author Michael
 */
class Doors extends FlxSprite {

	var disappearing : Bool = false;
	
	public function new(X : Float, Y : Float, i : Int) {
		super(X, Y);
		loadGraphic(Data.DoorsImg, true, 32, 48);
		ID = i;
		animation.add("default", [i]);
		animation.play("default");
		immovable = true;
	}
	
	public function disappear() {
		disappearing = true;
		solid = false;
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		if (disappearing) {
			scale.x = Math.max(0, scale.x - 0.1);
			scale.y = Math.max(0, scale.y - 0.1);
			
		}
	}
	
}