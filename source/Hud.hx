package ;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxG;

/**
 * ...
 * @author Michael
 */
class Hud extends FlxGroup {
	
	public var scoreText : FlxText;
	
	public function new() {
		super();
		scoreText = new FlxText(FlxG.width / 2, 2, 0, "0", 16);
		scoreText.x -= scoreText.width / 2;
		scoreText.y += scoreText.height;
		add(scoreText);
	}
	
}