package menu;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

/**
 * ...
 * @author Michael
 */
class Level extends FlxGroup {

	var x : Float;
	var y : Float;

	public var icon : FlxSprite;
	public var text : FlxText;
	
	public function new(X:Float=0, Y:Float=0, id){
		super();
		x = X;
		y = Y;
		ID = id;
		
		icon = new FlxSprite(x, y);
		icon.loadGraphic(Data.LevelIcon, true, 64, 62);
		icon.animation.add("default", [ID*2]);
		icon.animation.add("pressed", [ID*2 + 1]);
		icon.animation.play("default");
		add(icon);
		
		text = new FlxText(x + 16, y + 16);
		text.text = Std.string(ID);
		text.size = 24;
		//add(text);
	}
	
}