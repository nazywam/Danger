package objects;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Michael
 */
class Crate extends FlxGroup {

	public var popped = true;
	public var top : FlxSprite;
	
	public function new(x : Float, y : Float) {
		super();
		
		top = new FlxSprite(x, y);
		//top.immovable = true;
		top.loadGraphic(Data.CrateImg);
		top.height = 32;
		add(top);	
	}
	
	
	
}