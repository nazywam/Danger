package objects ;

import flixel.FlxSprite;

/**
 * ...
 * @author Michael
 */
class Spike extends FlxSprite {

	public function new(X:Float=0, Y:Float=0) {
		super(X, Y);
		loadGraphic(Data.SpikeImg);
		
		width = 16;
		height = 16;
		
		x += 8;
		y += 8;
		
		offset.set(8, 8);
	}
	
}