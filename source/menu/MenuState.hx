package menu ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;


class MenuState extends FlxState {
	
	var levels : Array<Level>;
	
	override public function create() {
		super.create();
		
		#if web
		FlxG.log.redirectTraces = true;
		#end
		
		FlxG.fixedTimestep = false;
		
		levels = new Array<Level>();
		for (y in 0...4) {
			for (x in 0...4) {
				var l = new Level(x * 60 + 125, y * 60 + 40);
				l.ID = y * 4 + x;
				l.text.text = Std.string(l.ID);
				l.text.x -= l.text.width / 2;
				l.text.y -= l.text.height/ 2;
				levels.push(l);
				add(l);
			}	
		}
	}

	override public function destroy() {
		super.destroy();
	}

	function clickLevel(id : Int) {
		Reg.activeLevel = id;
		FlxG.switchState(new PlayState());
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		#if mobile
			for (t in FlxG.touches.list) {
				if (t.justPressed) {
					for (x in levels) {
						var l = cast(x, Level);
						if (t.overlaps(l.icon)) {
							clickLevel(x.ID);
						}
					}
				}
			}
		#end
		
		#if web
			//if (FlxG.mouse.pressed) click(FlxG.mouse.x, FlxG.mouse.y);
			if (FlxG.mouse.justPressed) {				
				for (x in levels) {
					var l = cast(x, Level);
					if (FlxG.mouse.overlaps(l.icon)) {
						clickLevel(x.ID);
					}
				}
			}
			
		#end
		
	//	FlxG.switchState(new PlayState());
	}
}