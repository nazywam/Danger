package ;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Michael
 */
class Spike extends FlxSprite {

	public function new(X:Float=0, Y:Float=0) {
		super(X, Y);
		loadGraphic(Data.Spike);
		
		width = 16;
		height = 16;
		
		x += 8;
		y += 8;
		
		offset.set(8, 8);
	}
	
}