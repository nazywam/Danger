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
	var monsters : FlxGroup;
	
	var touchScroll : FlxPoint;
	
	public var exit : Exit;
	
	override public function create() {
		super.create();
		
		//load map
		map = new TiledLevel("assets/data/map.tmx");
		add(map.background);
		add(map.firstFloor);
		add(map.bricks);

		map.loadObjects(this);
		
		creeps = new FlxGroup();
		add(creeps);
		monsters = new FlxGroup();
		add(monsters);
		 
		for (x in 0...20) {
			var c= new Creep(Std.random(9*32)+96, Std.random(64)+32*3);
			creeps.add(c);	
		}
		
		add(map.secondFloor);
		
		touchScroll = new FlxPoint(0, 0);
		
		FlxG.camera.setScrollBounds(0, map.width * 32, 0,  map.height * 32);
		FlxG.worldBounds.set(0, 0, map.width * 32, map.height * 32);
	}
	
	
	function handleScrolling(x : Float, y : Float) {
		FlxG.camera.scroll.x += (touchScroll.x - x) / 1.6;
		FlxG.camera.scroll.y += (touchScroll.y - y) / 1.6;
		touchScroll.x = x;
		touchScroll.y = y;
	}
	
	//get distance between point 1 and 2
	function distance(x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Float {
		return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		
		//calculate positions of every monster for each creep
		for (x in creeps.members) {
			var c = cast(x, Creep);
			c.runningAway = false;
			for (y in monsters.members) {
				var m = cast(y, Monster);
				if (!m.chasing) {
					m.velocity.x = m.velocity.y = 0;
					m.chasing = true;
				}
				
				var dist = distance(c.x, c.y, m.x, m.y);
				
				if (dist < 75 && !c.disappearing) {
					if (!c.runningAway) {
						c.runningAway = true;	
						c.needAnotherDestination = true;
						c.velocity.x = c.velocity.y = 0;
					
					}
					//calculate velocity vector and apply it to creep and monster
					var currX = c.x - m.x;
					var currY = c.y - m.y;
					
					c.velocity.x += currX;
					c.velocity.y += currY;
					
					m.velocity.x += currX;
					m.velocity.y += currY;
					
				}
			}
			
			var dist = distance(c.x, c.y, exit.x, exit.y);
			if (dist < 75) {
					c.runningAway = true;
					c.velocity.x += (exit.x - c.x)*2;
					c.velocity.y += (exit.y - c.y)*2;
			}
			//reduce creep speed
			while (Math.abs(c.velocity.x) > 45 || Math.abs(c.velocity.y) > 45) {
				c.velocity.x /= 2;
				c.velocity.y /= 2;
			}
		}
		
		//reduce monster speed
		for (x in monsters.members) {
			var m = cast(x, Monster);
			while (Math.abs(m.velocity.x) > 30 || Math.abs(m.velocity.y) > 30) {
				m.velocity.x /= 2;
				m.velocity.y /= 2;
			}
		}
		
		FlxG.collide(monsters, map.secondFloor);
		FlxG.overlap(creeps, exit, function(c : Creep, _) {
			c.enterExit();
		});
		FlxG.collide(creeps, map.secondFloor, function(creep : Creep, _) { creep.bounce(); } );
		FlxG.collide(creeps, creeps, function(m1 : Creep, m2: Creep) { m1.bounce(); m2.bounce(); } );
		//kill creep
		FlxG.overlap(creeps, monsters, function(c : Creep, m : Monster) {
			c.alpha = 0;
			c.solid = false;
			FlxG.camera.shake(0.01, 0.2);
		});
		
		#if mobile
		for (touch in FlxG.touches.list) {
			if (touch.justPressed) touchScroll.set(touch.x, touch.y);
			if (touch.pressed) handleScrolling(touch.x, touch.y);
			if (touch.justPressed) {
				monsters.add(new Monster(touch.x, touch.y));
			}
		}
		#end
		#if web
			if (FlxG.mouse.justPressed) touchScroll.set(FlxG.mouse.x, FlxG.mouse.y);
			if (FlxG.mouse.pressed) handleScrolling(FlxG.mouse.x, FlxG.mouse.y);
			
			if (FlxG.mouse.justPressedMiddle) {
				monsters.add(new Monster(FlxG.mouse.x, FlxG.mouse.y));
			}
		#end
	}
}