package hud ;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxG;

/**
 * ...
 * @author Michael
 */
class ScorePanel extends FlxGroup {

	public var score : FlxText;
	public var background : FlxSprite;
	
	public function new() {
		super();
		
		background = new FlxSprite(FlxG.width / 2, 10);
		background.loadGraphic(Data.ScorePanelImg);
		background.x -= background.width / 2;
		add(background);
		
		score = new FlxText(290, 20, 0, "0", 24);
		add(score);	
	}
	
}