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
import flixel.util.FlxTimer;
import menu.MenuState;
import openfl.Assets;
class PlayState extends FlxState {
	
	var map : TiledLevel;
	
	var hud : Hud;
	
	var creeps : FlxGroup;

	var creepsGibs : FlxGroup;
	
	public var doors : FlxGroup;
	public var keys : FlxGroup;
	
	var monsters : FlxGroup;
	public var creepSpawns : Array<FlxPoint>;
	public var exit : Exit;
	
	
	var allowScrolling : Bool = false;
	var touchScroll : FlxPoint;
	
	public var score : Int = 0;
	
	var monsterDrop : FlxSprite;
	var monsterButton : FlxSprite;
	
	var reset : FlxSprite;
	var framerate : FlxText;
	
	override public function create() {
		super.create();
		
		//load map
		if (Assets.getText("assets/data/level" + Std.string(Reg.activeLevel) + ".tmx") == null) {
			throw("assets/data/level" + Std.string(Reg.activeLevel) + ".tmx, no such File");
		}
		map = new TiledLevel(("assets/data/level" + Std.string(Reg.activeLevel) + ".tmx"));
		add(map.background);
		add(map.firstFloor);
		add(map.bricks);

		creepSpawns = new Array<FlxPoint>();
		
		doors  = new FlxGroup();
		keys = new FlxGroup();
		add(doors);
		add(keys);
		
		map.loadObjects(this);
		
		if (creepSpawns.length == 0) {
			throw("No creepspawn on map");
		}
		if (exit == null) {
			throw("No exit on map");
		}
		
		creepsGibs = new FlxGroup();
		add(creepsGibs);
		creeps = new FlxGroup();
		add(creeps);
		monsters = new FlxGroup();
		add(monsters);
		 
		for (x in 0...3) {
			var randomIndex = Std.random(creepSpawns.length);
			var c = new Creep(creepSpawns[randomIndex].x + Std.random(32), creepSpawns[randomIndex].y - Std.random(8));
			creeps.add(c);	
			creepsGibs.add(c.gibs);
		}
		
		add(map.secondFloor);
		touchScroll = new FlxPoint(0, 0);
		
		hud = new Hud();
		add(hud);
		
		FlxG.camera.setScrollBounds(0, map.width * 32, 0,  map.height * 32);
		FlxG.worldBounds.set(0, 0, map.width * 32, map.height * 32);
		
		
		monsterDrop = new FlxSprite(0, 0);
		monsterDrop.loadGraphic(Data.MonsterImage, true, 32, 32);
		monsterDrop.visible = false;
		monsterDrop.solid = true;
		add(monsterDrop);
		
		monsterButton = new FlxSprite(0, FlxG.height / 2);
		monsterButton.loadGraphic(Data.MonsterImage, true, 32, 32);
		monsterButton.scale.x = monsterButton.scale.y = 1.5;
		monsterButton.y -= monsterButton.height / 2;
		add(monsterButton);
		
		/////////////////////////////////////////////////
		reset = new FlxSprite(0, FlxG.height);
		reset.makeGraphic(50, 30);
		reset.y -= reset.height;
		reset.scrollFactor.x = reset.scrollFactor.y = 0;
		add(reset);
		
		
		framerate = new FlxText(0, 0);
		framerate.scrollFactor.x = framerate.scrollFactor.y = 0;
		add(framerate);
		/////////////////////////////////////////////////
	}
	
	//handle scrolling
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
	
	function handleJustPressed(x : Float, y : Float) {
		monsterDrop.visible = true;
		if (allowScrolling) {					
			touchScroll.set(FlxG.mouse.x, FlxG.mouse.y);
		}
	}
	function handlePressed(x : Float, y : Float) {
		monsterDrop.x = Math.round((x - monsterDrop.width / 2) / 1) * 1;
		monsterDrop.y = Math.round((y - monsterDrop.height / 2) / 1) * 1;
		
		if (FlxG.collide(monsterDrop, map.secondFloor)) {
			monsterDrop.color = 0xFF0000;
		} else {
			monsterDrop.color = 0x00FF00;
		}
	}
	function handleReleased(x : Float, y : Float) {
		monsterDrop.visible = false;
		if (monsterDrop.color == 0x00FF00) {
			monsters.add(new Monster(Math.round((x - monsterDrop.width / 2) / 1) * 1, Math.round((y - monsterDrop.height / 2) / 16) * 16));
		}
	}
	
	
	override public function update(elapsed : Float) {
		super.update(elapsed);
		
		//calculate positions of every monster for each creep
		/*
		for (x in creeps.members) {
			if(x != null){
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
				if (dist < 60) {
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
		}*/
		
		for (c in creeps) {
			var creep = cast(c, Creep);
			
			var lengthSum = 0.0;
			
			var xSum = 0.0;
			var ySum = 0.0;
			
			
			for (o in creeps) {
				var otherCreep = cast(o, Creep);
				if (otherCreep != creep) {
		
					var dx = otherCreep.x - creep.x;
					var dy = otherCreep.y - creep.y;
					
					var length = distance(0, 0, dx, dy);
					lengthSum += length;
					
					if (length < 100) {
						if (length > 10) {
							xSum += dx / length;
							ySum += dy / length;
						}
						else {
							xSum -= dx / length;
							ySum -= dy / length;
						}
					}
				}
			}
			
			var monsterXSum = 0.0;
			var monsterYSum = 0.0;
			var monsterLength = 0;
			
			for (m in monsters) {
				
				var monster = cast(m, Monster);
				
				var dx = monster.x - creep.x;
				var dy = monster.y - creep.y;
				
				var length = distance(0, 0, dx, dy);
				lengthSum += length*3;
				
				xSum -= dx / length * 3;
				ySum -= dy / length * 3;
			}
			
			var dist = distance(0, 0, xSum, ySum);
			if (dist != 0) {
				creep.velocity.set(xSum / dist * 10, ySum / dist * 10);
			}
		}
		
		//collect key
		FlxG.overlap(creeps, keys, function(_, x : Key) {
			var key = cast(x, Key);
			key.taken = true;
			for (y in doors) {
				var d = cast(y, Doors);
				if (d.ID == key.ID) {
					d.disappear();
				}
			}
		});
		
		//reduce monster speed
		for (x in monsters.members) {
			var m = cast(x, Monster);
			while (Math.abs(m.velocity.x) > 40 || Math.abs(m.velocity.y) > 40) {
				m.velocity.x /= 2;
				m.velocity.y /= 2;
			}
		}
		
		FlxG.collide(monsters, map.secondFloor, function(monster : Monster, _) { monster.bounce(); } );
		FlxG.collide(creeps, doors);
		FlxG.collide(monsters, doors);
		//creep completes the level
		FlxG.overlap(creeps, exit, function(c : Creep, _) {
			c.enterExit();
			new FlxTimer(1, function(_) { creeps.remove(c); } );
			score++;
			hud.scoreText.text = Std.string(score);
		});
		FlxG.collide(creeps, map.secondFloor, function(creep : Creep, _) { creep.bounce(); } );
		//FlxG.collide(creeps, creeps, function(m1 : Creep, m2: Creep) { m1.bounce(); m2.bounce(); } );
		
		//kill creep when monster walks into it
		FlxG.overlap(creeps, monsters, function(c : Creep, m : Monster) {
			c.alpha = 0;
			c.solid = false;
			c.gibs.setPosition(c.x + c.width / 2, c.y + c.height / 2);
			c.gibs.start(true, 0.1, 10);
			FlxG.camera.shake(0.007, 0.1);
		});
		
		//collide gibs with walls
		for (x in creeps) {
			var m = cast(x, Creep);
			FlxG.collide(m.gibs, map.bricks);
			FlxG.collide(m.gibs, map.secondFloor);
		}
		
		#if mobile
		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				FlxG.overlap(new FlxObject(touch.x, touch.y, 1,1), reset, function(_, _) { FlxG.switchState(new MenuState()); } );				
				monsterDrop.visible = true;
				if (allowScrolling) {					
					touchScroll.set(touch.x, touch.y);
				}
			}
			if (touch.pressed) {
				handlePressed(touch.x, touch.y);
				
				if (allowScrolling) {
					handleScrolling(touch.x, touch.y);
				}
			}
			if (touch.justReleased) {
				handleReleased(touch.x, touch.y);
			}
		}
		#end
		
		#if web
			if (FlxG.mouse.justPressed) {
				//
				FlxG.overlap(new FlxObject(FlxG.mouse.x, FlxG.mouse.y, 1, 1), reset, function(_, _) { FlxG.switchState(new MenuState()); } );
				//
				monsterDrop.visible = true;
				if (allowScrolling) {					
					touchScroll.set(FlxG.mouse.x, FlxG.mouse.y);
				}

			}
			if (FlxG.mouse.pressed) {
				handlePressed(FlxG.mouse.x, FlxG.mouse.y);
				if (allowScrolling) {
					handleScrolling(FlxG.mouse.x, FlxG.mouse.y);
				}
			}
			if (FlxG.mouse.justReleased) {
				handleReleased(FlxG.mouse.x, FlxG.mouse.y);
			}
		#end
		framerate.text = Std.string(Math.round(1 / FlxG.elapsed));
	}
}