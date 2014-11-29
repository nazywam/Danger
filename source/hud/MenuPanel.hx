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
			
			background = new FlxSprite( -188, 20);
			background.loadGraphic(Data.MenuPanelImg);
			add(background);
			
			
			switchState = new FlxSprite(0, background.y);
			switchState.loadGraphic(Data.MenuPanelSwitchStateImg);
			add(switchState);
			
			restart = new FlxSprite(-170, 105);
			restart.loadGraphic(Data.MenuPanelRestartImg);
			add(restart);

			calibrate = new FlxSprite(-170, 160);
			calibrate.loadGraphic(Data.MenuPanelCalibrateImg);
			add(calibrate);
			
			exit = new FlxSprite( -170, 215);
			exit.loadGraphic(Data.MenuPanelExitImg);
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
			
				
			FlxTween.tween(background, { x: -188 + 188 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
			FlxTween.tween(switchState, { x: 188 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
			
			FlxTween.tween(restart, { x: -170 + 188 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
			FlxTween.tween(calibrate, { x: -170 + 188 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
			FlxTween.tween(exit, { x: -170 + 188 * state }, time, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );
	}
	
	private function handleClick(x : Float, y : Float) {
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
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		#if web
			
			if (FlxG.mouse.justPressed) {
				handleClick(FlxG.mouse.x, FlxG.mouse.y);
			}
		
		#end
		
		#if mobile
		
			for (touch in FlxG.touches.list) {
				if (touch.justPressed) {	
					handleClick(touch.x, touch.y);
					break;
				}
			}
		
		#end
		
	}
	
}