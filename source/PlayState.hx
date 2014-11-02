package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState {
	
	var map : TiledLevel;
	var creeps : FlxGroup;
	
	var touchScroll : FlxPoint;
	var touchScrollActive : Bool = false;
	
	override public function create() {
		super.create();
		
		map = new TiledLevel("assets/data/map.tmx");
		add(map.background);
		add(map.firstFloor);
		add(map.bricks);

		
		creeps = new FlxGroup();
		add(creeps);
	
		
		 
		for (x in 0...20) {
			var c= new Creep(Std.random(400)+20, Std.random(400)+20);
			creeps.add(c);		
		}
		
		add(map.secondFloor);
		
		touchScroll = new FlxPoint(0, 0);
		
		FlxG.camera.setScrollBounds(0, map.width * 32, 0,  map.height * 32);
		FlxG.worldBounds.set(0, 0, map.width * 32, map.height * 32);
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		FlxG.collide(creeps, map.secondFloor, function(creep : Creep, _) { creep.bounce(); } );
		
		#if mobile
		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				touchScrollActive = true;
				touchScroll.set(touch.x, touch.y);
			}
			if (touch.pressed) {
				FlxG.camera.scroll.x += (touchScroll.x - touch.x) / 1.5;
				FlxG.camera.scroll.y += (touchScroll.y - touch.y) / 1.5;
				touchScroll.x = touch.x;
				touchScroll.y = touch.y;
			}
		}
		#end
		#if web

			if (FlxG.mouse.justPressed) {
				touchScrollActive = true;
				touchScroll.set(FlxG.mouse.x, FlxG.mouse.y);
			}
			if (FlxG.mouse.pressed) {
				FlxG.camera.scroll.x += (touchScroll.x - FlxG.mouse.x) / 1.5;
				FlxG.camera.scroll.y += (touchScroll.y - FlxG.mouse.y) / 1.5;
				touchScroll.x = FlxG.mouse.x;
				touchScroll.y = FlxG.mouse.y;
			}
		#end
	}
}