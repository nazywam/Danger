package objects ;
import flixel.FlxSprite;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Michael
 */
class Key extends FlxSprite {

	public var taken : Bool = false;
	
	public function new(X : Float, Y : Float, i : Int){
		super(X, Y);
		loadGraphic(Data.KeysImg, true, 32, 32);
		for (x in 0...16) {
			animation.add(Std.string(x), [x]);
		}
		ID = i;
		animation.play(Std.string(ID));
		
		
		var path = new Array<FlxPoint>();
		path.push(new FlxPoint(x, y));
		path.push(new FlxPoint(x, y + 4));
		path.push(new FlxPoint(x, y));
		
		FlxTween.linearPath(this, path, 1.5, true,  { type:FlxTween.LOOPING } );
	}
	
	
	override public function update (elapsed : Float) {
		super.update(elapsed);
		if (taken) {
			scale.x = Math.max(0, scale.x - 0.1);
			scale.y = Math.max(0, scale.y - 0.1);
		}
	}
}