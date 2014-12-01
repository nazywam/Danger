package hud;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;

/**
 * ...
 * @author Michael
 */
class FinishPanel extends FlxGroup {

	var background : FlxSprite;
	
	var continueButton : FlxSprite;
	var restartButton : FlxSprite;
	
	public function new()  {
		super();
	
		visible = false;
		
		background = new FlxSprite(92, 110);
		background.loadGraphic(Data.FinishPanelImg);
		add(background);
		
		restartButton = new FlxSprite(100, 120);
		restartButton.loadGraphic(Data.FinishRestartImg, true, 155, 60);
		restartButton.animation.add("default", [0]);
		restartButton.animation.add("pressed", [1]);
		restartButton.animation.play("default");
		add(restartButton);
		
		continueButton = new FlxSprite(270, 120);
		continueButton.loadGraphic(Data.FinishContinueImg, true, 155, 60);
		continueButton.animation.add("default", [0]);
		continueButton.animation.add("pressed", [1]);
		continueButton.animation.play("default");
		add(continueButton);
		
	}
	
	function overlaps(clickX : Float, clickY : Float, target : FlxSprite) : Bool {
		if (clickX < target.x || clickX > target.x + target.width) return false;
		if (clickY < target.y || clickY > target.y + target.height) return false;
		return true;
	}
	
	function handlePress(x : Float, y : Float) {
		if (overlaps(x, y, restartButton)) {
			restartButton.animation.play("pressed");
		}
		if (overlaps(x, y, continueButton)) {
			continueButton.animation.play("pressed");
		}
	}
	function handleReleased(x : Float, y : Float) {
		if (overlaps(x, y, restartButton)) {
			FlxG.switchState(new PlayState());
		}
		if (overlaps(x, y, continueButton)) {
			Reg.activeLevel++;
			FlxG.switchState(new PlayState());
		}
		restartButton.animation.play("default");
		continueButton.animation.play("default");
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		#if mobile
			for (touch in FlxG.touches.list) {
				if (visible) {
					if (touch.justPressed) {
						handlePress(touch.x, touch.y);
					}
					if (touch.justReleased) {
						handleReleased(touch.x, touch.y);
					}
				}
			}
		#end
		
		#if web
			if (visible) {			
				if (FlxG.mouse.justPressed) {
					handlePress(FlxG.mouse.x, FlxG.mouse.y);
				}
				if (FlxG.mouse.justReleased) {
					handleReleased(FlxG.mouse.x, FlxG.mouse.y);
				}
			}
		#end
		
	}
	
}