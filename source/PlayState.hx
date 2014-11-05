package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState {
	
	var map : TiledLevel;
	
	var hud : Hud;
	
	var creeps : FlxGroup;
	var monsters : FlxGroup;
	public var creepSpawns : Array<FlxPoint>;
	public var exit : Exit;
	
	
	var allowScrolling : Bool = false;
	var touchScroll : FlxPoint;
	
	public var score : Int = 0;
	
	var monsterDrop : FlxSprite;
	
	var reset : FlxSprite;
	
	override public function create() {
		super.create();
		
		//load map
		map = new TiledLevel("assets/data/map.tmx");
		add(map.background);
		add(map.firstFloor);
		add(map.bricks);

		creepSpawns = new Array<FlxPoint>();
		
		map.loadObjects(this);
		
		creeps = new FlxGroup();
		add(creeps);
		monsters = new FlxGroup();
		add(monsters);
		 
		for (x in 0...20) {
			var randomIndex = Std.random(creepSpawns.length);
			var c= new Creep(creepSpawns[randomIndex].x + Std.random(32), creepSpawns[randomIndex].y - Std.random(8));
			creeps.add(c);	
		}
		
		add(map.secondFloor);
		touchScroll = new FlxPoint(0, 0);
		
		hud = new Hud();
		add(hud);
		
		FlxG.camera.setScrollBounds(0, map.width * 32, 0,  map.height * 32);
		FlxG.worldBounds.set(0, 0, map.width * 32, map.height * 32);
		
		
		monsterDrop = new FlxSprite(0, 0);
		monsterDrop.loadGraphic(Data.MonsterImage, false, 32, 32);
		monsterDrop.visible = false;
		add(monsterDrop);
		
		/////////////////////////////////////////////////
		reset = new FlxSprite(0, FlxG.height);
		reset.makeGraphic(50, 30);
		reset.y -= reset.height;
		add(reset);
		/////////////////////////////////////////////////
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
			c.running = false;
			
			for (y in monsters.members) {
				var m = cast(y, Monster);
				
				var dist = distance(c.x, c.y, m.x, m.y);
				if (dist < 75 && !c.disappearing) {
					
					if (!m.running) {
						m.velocity.x = m.velocity.y = 0;
						m.running = true;
					}
					
					if (!c.running) {
						c.running = true;	
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
			//attract creeps to exit
			var dist = distance(c.x, c.y, exit.x + 16, exit.y + 16);
			if (dist < 50) {
					c.running = true;
					c.velocity.x += (exit.x + 16 - c.x) * 2;
					c.velocity.y += (exit.y + 16 - c.y) * 2;
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
			while (Math.abs(m.velocity.x) > 40 || Math.abs(m.velocity.y) > 40) {
				m.velocity.x /= 2;
				m.velocity.y /= 2;
			}
		}
		
		FlxG.collide(monsters, map.secondFloor);
		//creep completes the level
		FlxG.overlap(creeps, exit, function(c : Creep, _) {
			c.enterExit();
			score++;
			hud.scoreText.text = Std.string(score);
		});
		FlxG.collide(creeps, map.secondFloor, function(creep : Creep, _) { creep.bounce(); } );
		FlxG.collide(creeps, creeps, function(m1 : Creep, m2: Creep) { m1.bounce(); m2.bounce(); } );
		//kill creep when monster walks into it
		FlxG.overlap(creeps, monsters, function(c : Creep, m : Monster) {
			c.alpha = 0;
			c.solid = false;
			FlxG.camera.shake(0.01, 0.2);
		});
		
		#if mobile
		for (touch in FlxG.touches.list) {
			FlxG.overlap(new FlxObject(touch.x, touch.y, 1,1), reset, function(_, _) { FlxG.switchState(new PlayState()); } );
			if (touch.justPressed && allowScrolling) touchScroll.set(touch.x, touch.y);
			if (touch.pressed && allowScrolling) handleScrolling(touch.x, touch.y);
			if (touch.justPressed) {
				monsters.add(new Monster(touch.x, touch.y));
			}
		}
		#end
		#if web
			if (FlxG.mouse.justPressed) {
				FlxG.overlap(new FlxObject(FlxG.mouse.x, FlxG.mouse.y, 1,1), reset, function(_, _) { FlxG.switchState(new PlayState()); } );				
			}
			if (FlxG.mouse.justPressed) {
				monsterDrop.visible = true;
				if (allowScrolling) {					
					touchScroll.set(FlxG.mouse.x, FlxG.mouse.y);
				}
			}
			if (FlxG.mouse.pressed) {
				monsterDrop.x = Math.round((FlxG.mouse.x - monsterDrop.width / 2) / 16) * 16;
				monsterDrop.y = Math.round((FlxG.mouse.y - monsterDrop.height / 2) / 16) * 16;
				
				if (allowScrolling) {
					handleScrolling(FlxG.mouse.x, FlxG.mouse.y);
				}
			}
			if (FlxG.mouse.justReleased) {
				monsterDrop.visible = false;
				monsters.add(new Monster(Math.round((FlxG.mouse.x - monsterDrop.width / 2) / 16) * 16, Math.round((FlxG.mouse.y - monsterDrop.height / 2) / 16) * 16));
			}
		#end
	}
}