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
	public var switchState : FlxSprite;
	
	public var exit : FlxSprite;
	public var restart : FlxSprite;
	public var calibrate : FlxSprite;
	
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
			
			switchState = new FlxSprite(-8, background.y);
			switchState.loadGraphic(Data.MenuPanelSwitchStateImg);
			add(switchState);
			
			restart = new FlxSprite(2-170, 67);
			restart.loadGraphic(Data.MenuPanelRestartImg, true, 155, 60);
			restart.animation.add("default", [0]);
			restart.animation.add("pressed", [1]);
			restart.animation.play("default");
			add(restart);

			calibrate = new FlxSprite(2-170, restart.y + 60);
			calibrate.loadGraphic(Data.MenuPanelCalibrateImg, true, 155, 60);
			calibrate.animation.add("default", [0]);
			calibrate.animation.add("pressed", [1]);
			calibrate.animation.play("default");
			add(calibrate);
			
			exit = new FlxSprite(2-170, calibrate.y + 60);
			exit.loadGraphic(Data.MenuPanelExitImg, true, 155, 60);
			exit.animation.add("default", [0]);
			exit.animation.add("pressed", [1]);
			exit.animation.play("default");
			add(exit);
			
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
			FlxTween.tween(switchState, { x: -8 + 171 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
			
			FlxTween.tween(restart, { x: 2-170 + 188 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
			FlxTween.tween(calibrate, { x: 2-170 + 188 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
			FlxTween.tween(exit, { x: 2-170 + 188 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
	}
	
	private function handlePress(x : Float, y : Float) {
		if (overlaps(x, y, switchState)) {
		}
		if (overlaps(x, y, restart)) {
			restart.animation.play("pressed");
		}
		if (overlaps(x, y, calibrate)) {
			calibrate.animation.play("pressed");
		}
		if (overlaps(x, y, exit)) {
			exit.animation.play("pressed");
		}
		if (!overlaps(x, y, background) && state == 1) {
			toggle();
		}
	}
	
	private function handleRelease(x : Float, y : Float) {
		if (overlaps(x, y, switchState)) {
			toggle();
		}
		
		if (overlaps(x, y, restart)) {
			FlxG.switchState(new PlayState());
		}
			
		if (overlaps(x, y, calibrate)) {
			#if mobile
				Reg.calibrationPoint.set(tiltHandler.x, tiltHandler.y);
			#end
			toggle();
		}
		
		if (overlaps(x, y, exit)) {
			FlxG.switchState(new MenuState());
		}
		
		restart.animation.play("default");
		calibrate.animation.play("default");
		exit.animation.play("default");

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