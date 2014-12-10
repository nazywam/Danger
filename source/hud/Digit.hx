package hud;

import flixel.FlxSprite;

/**
 * ...
 * @author Michael
 */

//a changing sprite used to show the score
class Digit extends FlxSprite {
	
	var digit : Int;
	
	public function new(X:Float = 0, Y:Float = 0, d:Int ) {
		super(X, Y);
		digit = d;
		
		loadGraphic(Data.Digits, true, 14, 16);
		for (x in 0...10) {
			animation.add(Std.string(x), [x]);
		}
	}
}