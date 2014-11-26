package hud ;

import flixel.group.FlxGroup;
import hud.ScorePanel;

/**
 * ...
 * @author Michael
 */
class Hud extends FlxGroup {
	
	public var scorePanel : ScorePanel;
	public var panel : MenuPanel;
	
	public function new() {
		super();
		
		scorePanel = new ScorePanel();
		add(scorePanel);

		panel = new MenuPanel();
		add(panel);
	}	
}