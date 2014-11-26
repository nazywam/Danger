package objects ;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Michael
 */
class Exit extends FlxSprite {

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
		super(X, Y);
		loadGraphic(Data.Exit, false, 32, 32);
	}
	
}