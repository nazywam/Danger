package  ;

import flixel.FlxSprite;
import flixel.FlxState;
import hud.Button;
import flixel.FlxG;
import menu.MenuState;

/**
 * ...
 * @author Michael
 */
class Outro extends FlxState {

	var background : FlxSprite;
	
	var followButton :  Button;
	var continueButton :  Button;
	
	override public function create() {
		super.create();

		background = new FlxSprite(0, 0, Data.OutroBackground);
		add(background);
		
		followButton = new Button(80, 220, Data.OutroFollowButton, true);
		add(followButton);
		
		continueButton = new Button(300, 220, Data.FinishContinueImg, true);
		add(continueButton);
	}
	
	function overlaps(clickX : Float, clickY : Float, target : FlxSprite): Bool {
        if (clickX < target.x || clickX > target.x + target.width) return false;
        if (clickY < target.y || clickY > target.y + target.height) return false;
        return true;
    }
	
	 private function handlePress(x : Float, y : Float) {
        if (overlaps(x, y, followButton)) {
            followButton.animation.play("pressed");
        }
        else if (overlaps(x, y, continueButton)) {
            continueButton.animation.play("pressed");
        }
    }

    private function handleRelease(x : Float, y : Float) {
        if (overlaps(x, y, followButton) && followButton.animation.name == "pressed") {
			FlxG.openURL("https://twitter.com/nazywam");
        }
        else if (overlaps(x, y, continueButton) && continueButton.animation.name == "pressed") {
            FlxG.switchState(new MenuState());
        }

        followButton.animation.play("default");
        continueButton.animation.play("default");
    }
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		#if mobile
		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				handlePress(touch.x, touch.y);
			}
			if (touch.justReleased) {
				handleRelease(touch.x, touch.y);
			}
        }
		#end

       #if web
            if (FlxG.mouse.justPressed) {
                handlePress(FlxG.mouse.x, FlxG.mouse.y);
            }
            if (FlxG.mouse.justReleased) {
                handleRelease(FlxG.mouse.x, FlxG.mouse.y);
            }
        #end

		
	}
}