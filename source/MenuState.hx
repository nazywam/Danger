package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;


class MenuState extends FlxState {
	override public function create() {
		FlxG.log.redirectTraces = true;
		
		super.create();
		
		add(new FlxText(FlxG.width / 2, FlxG.height / 2, 0, "Click"));
	}

	override public function destroy() {
		super.destroy();
	}

	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		FlxG.switchState(new PlayState());
	}
}