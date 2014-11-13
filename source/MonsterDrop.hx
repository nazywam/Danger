package ;
import flixel.FlxSprite;

/**
 * ...
 * @author Michael
 */
class MonsterDrop extends FlxSprite{

	public function new(X : Float, Y : Float) {
		super(X, Y);
		loadGraphic(Data.MonsterImage, true, 32, 32);
		visible = false;
		solid = true;
	}
	
}