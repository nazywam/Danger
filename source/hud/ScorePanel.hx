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

	public var score : FlxText;
	public var background : FlxSprite;
	
	public var state : Int = 1;
	
	public function new() {
		super();
		
		background = new FlxSprite(FlxG.width / 2, 10);
		background.loadGraphic(Data.ScorePanelImg);
		background.x -= background.width / 2;
		add(background);
		
		score = new FlxText(280, 20, 0, "0", 24);
		add(score);	
	}
	
	public function toggle() {
		
		state = (state+1) % 2;
		FlxTween.tween(background, { y: -background.height + background.height * state }, .5, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
		FlxTween.tween(score, { y: -score.height + (10 + score.height) * state }, .5, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
	}
	
}