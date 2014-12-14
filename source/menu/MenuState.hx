package menu ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import hud.Button;
import openfl.Assets;


class MenuState extends FlxState {
	
	var levels : Array<Level>;
	
	var background : FlxSprite;
	var playButton : Button;
	
	var activeScreen : Int = 0;
	
	var levelsBackground : FlxSprite;
	
	var pressedID : Int = -1;
	
	override public function create() {
		super.create();
		
		#if !mobile
			FlxG.log.redirectTraces = true;
		#end
		FlxG.fixedTimestep = false;
		
		background = new FlxSprite(0, 0);
		background.loadGraphic(Data.Background);
		add(background);
		
		playButton = new Button(FlxG.width / 2 + 125, FlxG.height / 2 + 30, Data.PlayButton, true);
		playButton.x -= playButton.width / 2;
		playButton.y -= playButton.height / 2;
		add(playButton);
		
		levelsBackground = new FlxSprite(FlxG.width * 3 / 2, FlxG.height / 2 - 22);
		levelsBackground.loadGraphic(Data.LevelsBackground);
		levelsBackground.x -= levelsBackground.width / 2;
		levelsBackground.y -= levelsBackground.height / 2;
		
		add(levelsBackground);
		
		levels = new Array<Level>();
		for (y in 0...3) {
			for (x in 0...4) {
				if (Assets.getText("assets/data/level" + Std.string(y * 4 + x) + ".tmx") != null) {
					var l = new Level(x * 65 + levelsBackground.x + 13 -4, y * 68 + levelsBackground.y + 13 -4, y * 4 + x);
					levels.push(l);
					add(l);
				}
			}	
		}	
	}
	
	function switchScreen(lvl : Int) {
		if (activeScreen == lvl) {
			activeScreen = 0;
		} else {
			activeScreen = lvl;
		}
		FlxTween.tween(FlxG.camera.scroll, { x:FlxG.width*activeScreen }, Rules.SwitchLevelTweenTime, { ease:FlxEase.cubeOut, type:FlxTween.PERSIST } );				
	}

	function switchLevel(id : Int) {
		Reg.activeLevel = id;
		FlxG.switchState(new PlayState());
	}
	
	function handlePress(x : Float, y : Float) {
		for (l in levels) {
			var level = cast(l, Level);
			if (overlaps(x, y, level)) { 
				level.animation.play("pressed");
				pressedID = l.ID;
			}
		}
		
		if (overlaps(x, y, playButton)) {
			playButton.animation.play("pressed");
		}
	}
	
	function handleReleased(x : Float, y : Float) {
		for (l in levels) {
			var level = cast(l, Level);
			if (overlaps(x, y, level)) { 
				if (pressedID == level.ID) {
					switchLevel(level.ID);
				}
			}
			level.animation.play("default");
		}
		if (overlaps(x, y, playButton)) {
			switchScreen(1);
		}
		playButton.animation.play("default");
	}
	
	function overlaps(clickX : Float, clickY : Float, target : FlxSprite) : Bool {
		if (clickX < target.x || clickX > target.x + target.width) return false;
		if (clickY < target.y || clickY > target.y + target.height) return false;
		return true;
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		#if mobile
			for (t in FlxG.touches.list) {
				if (t.justPressed) {
					handlePress(t.x, t.y);
				}
				if (t.justReleased) {
					handleReleased(t.x, t.y);
				}
			}
		#end
		
		#if !mobile
			if (FlxG.mouse.justPressed) {				
				handlePress(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.mouse.justReleased) {
				handleReleased(FlxG.mouse.x, FlxG.mouse.y);
			}
		#end
	
	}
}