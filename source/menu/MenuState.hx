package menu ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Assets;


class MenuState extends FlxState {
	
	var touchPoint : FlxPoint;
	
	var levels : Array<Level>;
	
	var background : FlxSprite;
	
	var playButton : FlxSprite;
	var optionsButton : FlxSprite;
	
	var activeScreen : Int = 0;
	
	var levelsBackground : FlxSprite;
	
	override public function create() {
		super.create();
		
		FlxG.log.redirectTraces = true;
		FlxG.fixedTimestep = false;
		
		touchPoint = new FlxPoint(0, 0);
		
		background = new FlxSprite(0, 0);
		background.loadGraphic(Data.Background);
		background.scrollFactor.x = background.scrollFactor.y = 0;
		add(background);
		
		playButton = new FlxSprite(FlxG.width - 190, 20);
		playButton.loadGraphic(Data.PlayButton);
		add(playButton);
		
		optionsButton = new FlxSprite(-50, 20);
		optionsButton.loadGraphic(Data.OptionsButton);
		add(optionsButton);
		
		levelsBackground = new FlxSprite(FlxG.width * 3 / 2, FlxG.height / 2);
		levelsBackground.loadGraphic(Data.LevelsBackground);
		levelsBackground.x -= levelsBackground.width / 2;
		levelsBackground.y -= levelsBackground.height / 2;
		
		add(levelsBackground);
		
		levels = new Array<Level>();
		for (y in 0...3) {
			for (x in 0...4) {
				if (Assets.getText("assets/data/level" + Std.string(y * 4 + x) + ".tmx") != null) {
					var l = new Level(x * 65 + levelsBackground.x + 26, y * 68 + levelsBackground.y + 28);
					l.ID = y * 4 + x;
					l.text.text = Std.string(l.ID);
					l.text.x -= l.text.width / 2;
					l.text.y -= l.text.height/ 2;
					levels.push(l);
					add(l);
				}
			}	
		}	
		
		Reg.calibrationPoint = new FlxPoint(0, 0);
		
	}
	
	function switchLevel(lvl : Int) {
		if (activeScreen == lvl) {
			activeScreen = 0;
		} else {
			activeScreen = lvl;
		}
		FlxTween.tween(FlxG.camera.scroll, { x:FlxG.width*activeScreen }, Rules.SwitchLevelTweenTime, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
	}

	function clickLevel(id : Int) {
		Reg.activeLevel = id;
		FlxG.switchState(new PlayState());
	}
	
	function overlaps(click : FlxPoint, target : FlxSprite) : Bool {
		if (click.x < target.x || click.x > target.x + target.width) return false;
		if (click.y < target.y || click.y > target.y + target.height) return false;
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
		
		#if !mobile
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