package menu ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class MenuState extends FlxState {
	
	var touchPoint : FlxPoint;
	
	var levels : Array<Level>;
	
	var playButton : FlxSprite;
	var optionsButton : FlxSprite;
	
	var activeScreen : Int = 0;
	
	override public function create() {
		super.create();
		
		FlxG.log.redirectTraces = true;
		FlxG.fixedTimestep = false;
		
		touchPoint = new FlxPoint(0, 0);
		
		playButton = new FlxSprite(FlxG.width - 190, 20);
		playButton.loadGraphic(Data.PlayButton);
		add(playButton);
		
		optionsButton = new FlxSprite(-50, 20);
		optionsButton.loadGraphic(Data.OptionsButton);
		add(optionsButton);
		
		levels = new Array<Level>();
		for (y in 0...4) {
			for (x in 0...4) {
				var l = new Level(x * 60 + 600, y * 60 + 40);
				l.ID = y * 4 + x;
				l.text.text = Std.string(l.ID);
				l.text.x -= l.text.width / 2;
				l.text.y -= l.text.height/ 2;
				levels.push(l);
				add(l);
			}	
		}	
	}

	function switchLevel(lvl : Int) {
		if (activeScreen == lvl) {
			activeScreen = 0;
		} else {
			activeScreen = lvl;
		}
		FlxTween.tween(FlxG.camera.scroll, { x:480*activeScreen }, 1, { ease:FlxEase.cubeInOut, type:FlxTween.PERSIST } );				
	}
	
	override public function destroy() {
		super.destroy();
	}

	function clickLevel(id : Int) {
		Reg.activeLevel = id;
		FlxG.switchState(new PlayState());
	}
	
	function overlaps(click : FlxPoint, target : FlxSprite) : Bool {
		if (click.x < target.x || click.x > target.x + target.width)return false;
		if (click.y < target.y || click.y > target.y + target.height)return false;
		return true;
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		touchPoint.set( -1, -1);
		
		#if mobile
			for (t in FlxG.touches.list) {
				if (t.justPressed) {
					touchPoint.set(t.x, t.y);
				}
			}
		#end
		
		#if web
			if (FlxG.mouse.justPressed) {				
				touchPoint.set(FlxG.mouse.x, FlxG.mouse.y);
			}
		#end
		
		for (x in levels) {
			var l = cast(x, Level);
			if (overlaps(touchPoint, l.icon)) { 
				clickLevel(x.ID);
			}
		}
		
		if (overlaps(touchPoint, playButton)) {
			switchLevel(1);
		}
		if (overlaps(touchPoint, optionsButton)) {
			switchLevel(-1);
		}
	}
}