package hud ;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import hud.ScorePanel;

/**
 * ...
 * @author Michael
 */
class Hud extends FlxGroup {
	
	public var scorePanel : ScorePanel;
	
	public var panel : Panel;
	
	public function new() {
		super();
		
		scorePanel = new ScorePanel();
		add(scorePanel);

		panel = new Panel();
		add(panel);
	}	
}