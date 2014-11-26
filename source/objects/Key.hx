package objects ;
import flixel.FlxSprite;
/**
 * ...
 * @author Michael
 */
class Key extends FlxSprite {

	public var taken : Bool = false;
	
	public function new(X : Float, Y : Float, i : Int){
		super(X, Y);
		loadGraphic(Data.Keys, true, 32, 32);
		for (x in 0...16) {
			animation.add(Std.string(x), [x]);
		}
		ID = i;
		animation.play(Std.string(ID));
	}
	
	
	override public function update (elapsed : Float) {
		super.update(elapsed);
		if (taken) {
			scale.x = Math.max(0, scale.x - 0.1);
			scale.y = Math.max(0, scale.y - 0.1);
		}
	}
}