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
	
	public function new()  {
		super();
	
		visible = false;
		
		background = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
		background.loadGraphic(Data.FinishPanelImg);
		background.x -= background.width / 2;
		background.y -= background.height / 2;
		add(background);
		
	}
	
	function overlaps(clickX : Float, clickY : Float, target : FlxSprite) : Bool {
		if (clickX < target.x || clickX > target.x + target.width) return false;
		if (clickY < target.y || clickY > target.y + target.height) return false;
		return true;
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		#if mobile
			for (touch in FlxG.touches.list) {
				if (touch.justPressed && overlaps(touch.x, touch.y, background) && visible) {
					Reg.activeLevel++;
					FlxG.switchState(new PlayState());
				}
			}
		#end
		
		#if web
			if (FlxG.mouse.justPressed && overlaps(FlxG.mouse.x, FlxG.mouse.y, background) && visible) {
				Reg.activeLevel++;
				FlxG.switchState(new PlayState());
			}
		#end
		
	}
	
}