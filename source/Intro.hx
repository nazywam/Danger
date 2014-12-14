package ;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.FlxAccelerometer;
import flixel.FlxG;
import menu.MenuState;

/**
 * ...
 * @author Michael
 */
class Intro extends FlxState {

	var background : FlxSprite;
	
	var monster : FlxSprite;
	var target : FlxSprite;
	
	#if mobile
		var tiltHandler : FlxAccelerometer;
	#end
	
	override public function create() {
		super.create();
		
		background = new FlxSprite(0, 0, Data.IntroBackground);
		add(background);
		
		target = new FlxSprite(FlxG.width / 2, FlxG.height * 3 / 4 + 20);
		target.loadGraphic(Data.IntroTarget);
		target.scale.x = target.scale.y = 2;
		target.x -= target.width / 2;
		target.y -= target.height / 2;
		add(target);
		
		monster = new FlxSprite(0, 0);
		monster.loadGraphic(Data.MonsterImg, true, 19, 23);
		monster.scale.x = monster.scale.y = 2;
		add(monster);
		
		tiltHandler = new FlxAccelerometer();
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		monster.x += (tiltHandler.y * FlxG.width + FlxG.width / 2 - monster.x) / 50;
		monster.y += (tiltHandler.x * FlxG.height + FlxG.height * 3 / 4 + 10 - monster.y) / 50;
		
		if (FlxG.overlap(monster, target)) {
			target.scale.x = Math.max(target.scale.x - 0.01, 0);
			target.scale.y = Math.max(target.scale.y - 0.01, 0);
			
			if (target.scale.x == 0 && target.scale.y == 0) {
				FlxG.camera.alpha -= 0.05;
				if (FlxG.camera.alpha == 0) {
					FlxG.switchState(new MenuState());
				}
			}
		}
	}
	
}