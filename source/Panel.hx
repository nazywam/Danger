package ;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
/**
 * ...
 * @author Michael
 */
class Panel extends FlxGroup {

	public var state : Int = 0;
	
	public var background : FlxSprite;
	public var switchState : FlxSprite;
	
	public var exit : FlxSprite;
	
	public function new() {
			super();
			
			background = new FlxSprite( -188, 20);
			background.loadGraphic(Data.PanelBackground);
			add(background);
			
			
			switchState = new FlxSprite(0, background.y);
			switchState.loadGraphic(Data.SwitchState);
			add(switchState);
			
			exit = new FlxSprite( -120, 150);
			exit.loadGraphic(Data.PanelExit);
			add(exit);
			
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		#if web
			
			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(switchState)) {
				state = (state+1) % 2;
				
				FlxTween.tween(background, { x: -188 + 188 * state }, .75, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
				FlxTween.tween(exit, { x: -120 + 150 * state }, .75, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
				FlxTween.tween(switchState, { x: 188 * state }, .75, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				

			}
		
		#end
		
		#if mobile
		
			for (touch in FlxG.touches.list) {
				if (touch.justPressed) {	
					if (touch.overlaps(switchState)) {
						state = (state+1) % 2;
				
						FlxTween.tween(background, { x: -188 + 188 * state }, .75, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
						FlxTween.tween(switchState, { x: 188 * state }, .75, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
					}
				}
			}
		
		#end
		
	}
	
}