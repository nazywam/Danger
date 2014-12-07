package hud ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.FlxAccelerometer;
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
	public var exitButton : FlxSprite;
	public var restartButton : FlxSprite;
	public var calibrateButton : FlxSprite;
	
	public var clickedButtonID : Int = -1;
	
	#if mobile
		var tiltHandler : FlxAccelerometer;
	#end
	
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
			toggleButton.height = 225;
			add(toggleButton);
			
			restartButton = new FlxSprite(18-173, 67);
			restartButton.loadGraphic(Data.MenuPanelRestartImg, true, 155, 60);
			restartButton.animation.add("default", [0]);
			restartButton.animation.add("pressed", [1]);
			restartButton.animation.play("default");
			add(restartButton);

			calibrateButton = new FlxSprite(20 - 173, restartButton.y + 60);
			calibrateButton.ID  = 1;
			calibrateButton.loadGraphic(Data.MenuPanelCalibrateImg, true, 155, 60);
			calibrateButton.animation.add("default", [0]);
			calibrateButton.animation.add("pressed", [1]);
			calibrateButton.animation.play("default");
			add(calibrateButton);
			
			exitButton = new FlxSprite(20 - 173, calibrateButton.y + 60);
			exitButton.ID = 2;
			exitButton.loadGraphic(Data.MenuPanelExitImg, true, 155, 60);
			exitButton.animation.add("default", [0]);
			exitButton.animation.add("pressed", [1]);
			exitButton.animation.play("default");
			add(exitButton);
			
			#if mobile
				tiltHandler = new FlxAccelerometer();
			#end
	}
	
	
	function overlaps(clickX : Float, clickY : Float, target : FlxSprite) : Bool {
		if (clickX < target.x || clickX > target.x + target.width) return false;
		if (clickY < target.y || clickY > target.y + target.height) return false;
		return true;
	}
	
	function toggle() {
		state = (state+1) % 2; 
			
			var time = Rules.MenuPanelTweenTime;
			if (state == 0) {
				time -= .25;
			}
			
			FlxTween.tween(background, { x: -196+25 + 171 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
			FlxTween.tween(toggleButton, { x: -8 + 171 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
			
			FlxTween.tween(restartButton, { x: 20-173 + 173 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
			FlxTween.tween(calibrateButton, { x: 20-173 + 173 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
			FlxTween.tween(exitButton, { x: 20-173 + 173 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
	}
	
	private function handlePress(x : Float, y : Float) {
		if (overlaps(x, y, toggleButton)) {
			clickedButtonID = toggleButton.ID;
		} else if (overlaps(x, y, restartButton)) {
			restartButton.animation.play("pressed");
			clickedButtonID = restartButton.ID;
		} else if (overlaps(x, y, calibrateButton)) {
			calibrateButton.animation.play("pressed");
			clickedButtonID = calibrateButton.ID;
		} else if (overlaps(x, y, exitButton)) {
			exitButton.animation.play("pressed");
			clickedButtonID = exitButton.ID;
		} else if (!overlaps(x, y, background) && state == 1) {
			toggle();
		}
	}
	
	private function handleRelease(x : Float, y : Float) {
		if (overlaps(x, y, toggleButton) && clickedButtonID == toggleButton.ID) {
			toggle();
		} else if (overlaps(x, y, restartButton) && clickedButtonID == restartButton.ID ) {
			FlxG.switchState(new PlayState());
		} else if (overlaps(x, y, calibrateButton) && clickedButtonID == calibrateButton.ID ) {
			#if mobile
				Reg.calibrationPoint.set(tiltHandler.x, tiltHandler.y);
			#end
			toggle();
		} else if (overlaps(x, y, exitButton) && clickedButtonID == exitButton.ID ) {
			FlxG.switchState(new MenuState());
		}
		
		restartButton.animation.play("default");
		calibrateButton.animation.play("default");
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