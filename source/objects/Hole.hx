package objects;
import flixel.FlxSprite;

/**
 * ...
 * @author Michael
 */
class Hole extends FlxSprite {

	public var filled = false;
	
	public function new(X : Float, Y : Float)  {
			super(X, Y);
			immovable = true;
			loadGraphic(Data.EmptyImg, false, 32, 32);
			//offset.y = 16;
			
			height = 8;
			width = 10;
			x += 11;
			y += 8;
			
	}
	
}