package hud ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;


/**
 * ...
 * @author Michael
 */
class ScorePanel extends FlxGroup {

	public var score : Digit;
	public var slash : FlxSprite;
	public var maxScore : Digit;
	
	public var background : FlxSprite;
	
	public var state : Int = 1;
	
	public function new() {
		super();
		
		background = new FlxSprite(FlxG.width / 2, 10);
		background.loadGraphic(Data.ScorePanelImg);
		background.x -= background.width / 2;
		add(background);
		
		score = new Digit(250, 30, 0);
		add(score);	
		
		slash = new FlxSprite(265, 30, Data.Slash);
		add(slash);
		
		maxScore = new Digit(280, 30, 0);
		add(maxScore);
	}
	
	public function toggle() {
		
		state = (state+1) % 2;
		
		//FlxTween.tween(background, { y: -background.height + background.height * state }, Rules.ScorePanelTweenTime, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
		//FlxTween.tween(score, { y: -background.height + 20  + (background.height + 10)* state }, Rules.ScorePanelTweenTime, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
	}
	
}