package ;

import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.display.BlendMode;
import flixel.math.FlxRandom;

/**
 * ...
 * @author Michael
 */
class Stars extends FlxGroup {
	
	public function new()  {
		super();
		
		var r = new FlxRandom();
		for (x in 0...70) {
			var a = new FlxSprite(Std.random(Std.int(FlxG.width / 16)) * 16, Std.random(Std.int(FlxG.height / 16)) * 16);
			a.makeGraphic(16, 16, 0xFF37946e + Std.random(0x000088) - 0x000044);
			add(a);
		}
		
		
	}	
}