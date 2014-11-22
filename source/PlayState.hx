package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.input.FlxAccelerometer;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import menu.MenuState;
import openfl.Assets;

class PlayState extends FlxState {
	
	var map : TiledLevel;
	var hud : Hud;
	
	var creeps : FlxGroup;
	var monsters : FlxGroup;

	public var doors : FlxGroup;
	public var keys : FlxGroup;
	
	public var creepSpawns : Array<FlxPoint>;
	public var monsterSpawns : Array<FlxPoint>;
	public var exits : FlxGroup;
	
	public var score : Int = 0;
	
	#if mobile
	var tiltHandler : FlxAccelerometer;
	#end
	
	///
	var framerate : FlxText;
	///
	
	override public function create() {
		super.create();
	
		
		//load map
		if (Assets.getText("assets/data/level" + Std.string(Reg.activeLevel) + ".tmx") == null) {
			throw("assets/data/level" + Std.string(Reg.activeLevel) + ".tmx, no such File");
		}
		
		#if mobile
			tiltHandler = new FlxAccelerometer();
			Reg.calibrationPoint.set(tiltHandler.x, tiltHandler.y);
		#end
		
		map = new TiledLevel(("assets/data/level" + Std.string(Reg.activeLevel) + ".tmx"));
		add(map.background);
		add(map.firstFloor);
		add(map.bricks);

		creepSpawns = new Array<FlxPoint>();
		monsterSpawns = new Array<FlxPoint>();
		
		doors  = new FlxGroup();
		keys = new FlxGroup();
		add(doors);
		add(keys);
		
		exits = new FlxGroup();
		add(exits);
		
		map.loadObjects(this);
		
		if (creepSpawns.length == 0) {
			throw("No creepspawn on map");
		}
		if (exits.length == 0) {
			throw("No exits on map");
		}
		
		creeps = new FlxGroup();
		add(creeps);
		monsters = new FlxGroup();
		add(monsters);
		
		for (index in 0...creepSpawns.length) {
			var c = new Creep(creepSpawns[index].x + Std.random(8), creepSpawns[index].y + Std.random(8));
			creeps.add(c);	
		}
	
		for (index in 0...monsterSpawns.length) {
			var m = new Monster(monsterSpawns[index].x, monsterSpawns[index].y);
			monsters.add(m);
		}
		
		add(map.secondFloor);
				

		FlxG.camera.setScrollBounds(0, map.width * 32, 0,  map.height * 32);
		FlxG.worldBounds.set(0, 0, map.width * 32, map.height * 32);
		
		hud = new Hud();
		add(hud);
		
		/////////////////////////////////////////////////
		
		framerate = new FlxText(20, 20, 100, "AAAA", 32);
		//framerate.scrollFactor.x = framerate.scrollFactor.y = 0;
		add(framerate);
		/////////////////////////////////////////////////
		
	}
	
	//get distance between point 1 and 2
	function distance(x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Float {
		return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
	}

	
	override public function update(elapsed : Float) {
		
		if (hud.panel.state == 1) {
			hud.update(elapsed);
			return;
		}
		
		super.update(elapsed);		
		
		for (c in creeps) {
			var creep = cast(c, Creep);
			
			var xSum = 0.0;
			var ySum = 0.0;
						
			//push creep away from monsters, atract monsters to creep
			for (m in monsters) {
				var monster = cast(m, Monster);
				
				var dx = monster.x - creep.x;
				var dy = monster.y - creep.y;
				
				var length = distance(0, 0, dx, dy);
				
				if (length < 75) {
					xSum -= dx / length * 3;
					ySum -= dy / length * 3;
				}				
			}
			
			var dx = 0.0;
			var dy = 0.0;
			var length = 1.0;
			
			var minDist = 70;
			
			//attract creep to closest exit
			for (e in exits) {
				
				var exit = cast(e, Exit);
				
				var cx = exit.x - creep.x;
				var cy = exit.y - creep.y;
				
				length = distance(0, 0, cx, cy);
				
				if (length < minDist) {
					
					dx = cx;
					dy = cy;
				}
			}
			
			xSum += dx / length * 2;
			ySum += dy / length * 2;	
			
			//attract creeps to creep
			if (creep.running) {
				for (o in creeps) {
					var otherCreep = cast(o, Creep);
					if (otherCreep != creep) {
			
						var dx = otherCreep.x - creep.x;
						var dy = otherCreep.y - creep.y;
						
						var length = distance(0, 0, dx, dy);
						
						if (length < 100) {
							if (length > 20) {
								xSum += dx / length;
								ySum += dy / length;
							}
							else {
								xSum -= dx / length *2;
								ySum -= dy / length *2;
							}
						}
					}
				}
			}

			//normalize creep velocity
			var dist = distance(0, 0, xSum, ySum);
			if (dist != 0) {
				creep.running = true;
				creep.finalVelocity.set(xSum / dist * 40, ySum / dist * 40);
			} else {
				creep.running = false;
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

		FlxG.collide(monsters, map.secondFloor);
		FlxG.collide(creeps, doors);
		FlxG.collide(monsters, doors);

		//creep completes the level
		FlxG.overlap(creeps, exits, function(c : Creep, _) {
			c.enterExit();
			var timer = new FlxTimer();
			timer.start(1, function(_) { creeps.remove(c); } );
			score++;
			hud.scoreText.text = Std.string(score);
		});
		FlxG.collide(creeps, map.secondFloor, function(creep : Creep, _) { creep.bounce(); } );
		
		//kill creep when monster walks into it
		FlxG.overlap(creeps, monsters, function(c : Creep, m : Monster) {
			c.alpha = 0;
			c.solid = false;
			FlxG.camera.shake(0.02, 0.15);
		});

		#if mobile
			
			for (x in monsters) {
				var m = cast(x, Monster);
				m.finalVelocity.x = Math.min((tiltHandler.y - Reg.calibrationPoint.y) * 150, 250);
				m.finalVelocity.y = Math.min((tiltHandler.x - Reg.calibrationPoint.x) * 125, 250);
			}
			
		#end
		
		#if !mobile
			for (x in monsters) {
				var m = cast(x, Monster);
				if (FlxG.keys.pressed.LEFT) m.finalVelocity.x = -100;
				if (FlxG.keys.pressed.RIGHT) m.finalVelocity.x = 100;
				if (FlxG.keys.pressed.UP) m.finalVelocity.y = -100;
				if (FlxG.keys.pressed.DOWN) m.finalVelocity.y = 100;
			}
		#end
		
		//framerate.text = Std.string(Math.round(1 / FlxG.elapsed));

	}
}
