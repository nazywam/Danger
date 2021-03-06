package hud;

import Outro;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import menu.MenuState;
import flixel.util.FlxTimer;

class FinishPanel extends FlxGroup {

    var background : FlxSprite;
    public var continueButton : Button;
    var restartButton : Button;

	var dooming : Bool = false;
	
    public function new() {
        super();

        visible = false;

        background = new FlxSprite(92, 110, Data.FinishPanelImg);
        add(background);

        restartButton = new Button(100, 120, Data.FinishRestartImg, true);
        add(restartButton);

        continueButton = new Button(270, 120, Data.FinishContinueImg, false);
        add(continueButton);
    }

    function overlaps(clickX : Float, clickY : Float, target : FlxSprite): Bool {
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
        if (overlaps(x, y, restartButton) && restartButton.animation.name == "pressed" ) {
            FlxG.switchState(new PlayState());
        }
        if (overlaps(x, y, continueButton) && continueButton.animation.name == "pressed") {
            if (continueButton.clickable) {
                if (Reg.activeLevel < 10) {
                    Reg.activeLevel++;
					dooming = true;
					
					var t = new FlxTimer();
					t.start(.5, function(_) {
						FlxG.switchState(new PlayState());
					});
                }
                else {
                    dooming = true;
					var t = new FlxTimer();
					t.start(.5, function(_) {
						FlxG.switchState(new Outro());
					});
                }
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

		if (dooming) FlxG.camera.alpha -= 0.03;
		
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