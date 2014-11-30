package objects;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Michael
 */
class Crate extends FlxSprite {

	public var popped = 1;
	public var tweening = false;
	public var top : FlxSprite;
	
	public function new(x : Float, y : Float) {
		super(x, y);		
		immovable = true;
		loadGraphic(Data.CrateImg, true, 32, 64);
		
		animation.add("default", [0]);
		animation.add("hide", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], 16, false);
		
		height = 32;
		
	}
	
	public function pop() {
		
		popped = (popped + 1) % 2;
		FlxTween.tween(this, { y: y + 16 - 32 * popped }, 1, { type:FlxTween.PERSIST } );				
		tweening = true;
		var t = new FlxTimer();
		t.start(1, function(_) { tweening = false; });
		animation.play("hide");
	}
	
}