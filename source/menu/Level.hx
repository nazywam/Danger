package menu;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
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
	
	public function new(X:Float=0, Y:Float=0){
		super();
		x = X;
		y = Y;
		
		icon = new FlxSprite(x, y);
		icon.loadGraphic(Data.LevelIcon);
		add(icon);
		
		text = new FlxText(x+16, y+16);
		text.size = 24;
		add(text);
	}
	
}