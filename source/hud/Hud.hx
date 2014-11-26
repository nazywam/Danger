package hud ;

import flixel.group.FlxGroup;
import hud.ScorePanel;

/**
 * ...
 * @author Michael
 */
class Hud extends FlxGroup {
	
	public var scorePanel : ScorePanel;
	public var menuPanel : MenuPanel;
	public var finishPanel : FinishPanel;
	
	public function new() {
		super();
		
		scorePanel = new ScorePanel();
		add(scorePanel);

		menuPanel = new MenuPanel();
		add(menuPanel);
		
		finishPanel = new FinishPanel();
		add(finishPanel);
	}	
}