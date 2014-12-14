package hud ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import menu.MenuState;
/**
 * ...
 * @author Michael
 */
class MenuPanel extends FlxGroup {

	public var state : Int = 0;
	
	public var background : FlxSprite;
	
	public var toggleButton : FlxSprite;
	public var exitButton : Button;
	public var restartButton : Button;
	
	public function new() {
			super();
			
			background = new FlxSprite(25, FlxG.height / 2);
			background.loadGraphic(Data.MenuPanelImg);
			background.x -= background.width;
			background.y -= background.height / 2;
			add(background);
			
			toggleButton = new FlxSprite( -8, background.y);
			toggleButton.ID = 0;
			toggleButton.loadGraphic(Data.MenuPanelSwitchStateImg);
			toggleButton.animation.add("default", [0]);
			toggleButton.animation.add("pressed", [0]);
			toggleButton.animation.play("default");
			toggleButton.height = background.height;
			toggleButton.width += 10;
			add(toggleButton);
			
			restartButton = new Button(18 - 173, background.y + 27, Data.MenuPanelRestartImg, true);
			restartButton.ID = 0;
			add(restartButton);

			exitButton = new Button(20 - 173, restartButton.y + 60, Data.MenuPanelExitImg, true);
			exitButton.ID = 2;
			add(exitButton);
	}
	
	
	function overlaps(clickX : Float, clickY : Float, target : FlxSprite) : Bool {
		if (clickX < target.x || clickX > target.x + target.width) return false;
		if (clickY < target.y || clickY > target.y + target.height) return false;
		return true;
	}
	
	public function toggle() {
		state = (state+1) % 2; 
			
			var time = Rules.MenuPanelTweenTime;
			if (state == 0) {
				time -= .25;
			}
			
			FlxTween.tween(background, { x: -196+25 + 171 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
			FlxTween.tween(toggleButton, { x: -8 + 171 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
			
			FlxTween.tween(restartButton, { x: 20-173 + 173 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
			FlxTween.tween(exitButton, { x: 20-173 + 173 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
	}
	
	// handle mouse presses
	private function handlePress(x : Float, y : Float) {
		if (overlaps(x, y, toggleButton)) {
			toggleButton.animation.play("pressed");
		} else if (overlaps(x, y, restartButton)) {
			restartButton.animation.play("pressed");
		} else if (overlaps(x, y, exitButton)) {
			exitButton.animation.play("pressed");
		} else if (!overlaps(x, y, background) && state == 1) {
			toggle();
		}
	}
	
	private function handleRelease(x : Float, y : Float) {
		if (overlaps(x, y, toggleButton) && toggleButton.animation.name == "pressed") {
			toggle();
		} else if (overlaps(x, y, restartButton) && restartButton.animation.name == "pressed") {
			FlxG.switchState(new PlayState());
		} else if (overlaps(x, y, exitButton) && exitButton.animation.name == "pressed") {
			FlxG.switchState(new MenuState());
		}
		
		toggleButton.animation.play("default");
		restartButton.animation.play("default");
		exitButton.animation.play("default");
	}
	
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		#if web
			
			if (FlxG.mouse.justPressed) {
				handlePress(FlxG.mouse.x, FlxG.mouse.y);
			}
			
			if (FlxG.mouse.justReleased) {
				handleRelease(FlxG.mouse.x, FlxG.mouse.y);
			}
		
		#end
		
		#if mobile
		
			for (touch in FlxG.touches.list) {
				if (touch.justPressed) {	
					handlePress(touch.x, touch.y);
					break;
				}
				
				if (touch.justReleased) {
					handleRelease(touch.x, touch.y);
				}
			}
		
		#end
		
	}
	
}