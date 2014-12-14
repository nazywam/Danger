package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Michael
 */

//a panel which shows up after all creeps have been rescued or killed, or the monster has died
class FinishPanel extends FlxGroup {

	public var background : FlxSprite;
	public var continueButton : Button;
	public var restartButton : Button;
	
	public function new()  {
		super();
	
		visible = false;
				
		background = new FlxSprite(92, 110, Data.FinishPanelImg);
		add(background);
		
		restartButton = new Button(100, 120, Data.FinishRestartImg, true);
		add(restartButton);
		
		continueButton = new Button(270, 120, Data.FinishContinueImg, false);
		add(continueButton);
		
	}
	
	// a handy function used for checking mouse overlap with buttons
	function overlaps(clickX : Float, clickY : Float, target : FlxSprite) : Bool {
		if (clickX < target.x || clickX > target.x + target.width) return false;
		if (clickY < target.y || clickY > target.y + target.height) return false;
		return true;
	}
	
	//handle mouse presses
	function handlePress(x : Float, y : Float) {
		if (overlaps(x, y, restartButton)) {
			restartButton.animation.play("pressed");
		}
		if (overlaps(x, y, continueButton)) {
			continueButton.animation.play("pressed");
		}
	}
	//handle mouse releases, check animations to ensure that the same button has been pressed and released
	function handleReleased(x : Float, y : Float) {
		if (overlaps(x, y, restartButton) && restartButton.animation.name == "pressed" ) {
			FlxG.switchState(new PlayState());
		}
		if (overlaps(x, y, continueButton) && continueButton.animation.name == "pressed") {
			if (continueButton.clickable) {
				Reg.activeLevel++;
				FlxG.switchState(new PlayState());	
			}
		}
		
		//reset all buttons to default state
		if (continueButton.clickable) {
			continueButton.animation.play("default");
		}
		restartButton.animation.play("default");
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