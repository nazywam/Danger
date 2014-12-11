package menu;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

/**
 * ...
 * @author Michael
 */
class Level extends FlxSprite {
	public function new(X:Float=0, Y:Float=0, id){
		super();
		x = X;
		y = Y;
		ID = id;
		
		loadGraphic(Data.LevelIcon, true, 64, 62);
		animation.add("default", [ID*2]);
		animation.add("pressed", [ID*2 + 1]);
		animation.play("default");
	}
}