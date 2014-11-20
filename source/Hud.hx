package ;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Michael
 */
class Hud extends FlxGroup {
	
	public var scoreText : FlxText;
	
	public var panel : Panel;
	
	public function new() {
		super();
		scoreText = new FlxText(FlxG.width / 2, 2, 0, "0", 16);
		scoreText.x -= scoreText.width / 2;
		scoreText.y += scoreText.height;
		scoreText.scrollFactor.x = scoreText.scrollFactor.y = 0;
		add(scoreText);

		panel = new Panel();
		add(panel);
	}
	
	
}