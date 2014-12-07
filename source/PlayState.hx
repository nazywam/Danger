package ;

import actors.*;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import hud.*;
import menu.*;
import objects.*;
import openfl.Assets;



class PlayState extends FlxState {
	
	var map : TiledLevel;
	var hud : Hud;
	
	var creeps : FlxTypedGroup<Creep>;
	var monsters : FlxTypedGroup<Monster>;

	var stars : Stars;
	
	public var corpses : FlxGroup;
	public var doors : FlxTypedGroup<Doors>;
	public var spikes : FlxTypedGroup<Spike>;
	public var keys : FlxTypedGroup<Key>;
	public var crates : FlxTypedGroup<Crate>;
	public var holes : FlxTypedGroup<Hole>;
	
	public var creepSpawns : Array<FlxPoint>;
	public var monsterSpawns : Array<FlxPoint>;
	public var exits : FlxTypedGroup<Exit>;
	
	public var score : Int = 0;
	
	#if mobile
	var tiltHandler : FlxAccelerometer;
	#end
	
	var paused : Bool = true;
	
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
		
		//stars = new Stars();
		//add(stars);
		
		
		
		map = new TiledLevel(("assets/data/level" + Std.string(Reg.activeLevel) + ".tmx"));
		add(map.background);
		add(map.firstFloor);
		
		
		add(map.bricks);

		creepSpawns = new Array<FlxPoint>();
		monsterSpawns = new Array<FlxPoint>();
		
		doors  = new FlxTypedGroup<Doors>();
		keys = new FlxTypedGroup<Key>();
		spikes = new FlxTypedGroup<Spike>();
		add(doors);
		add(keys);
		add(spikes);
		
		exits = new FlxTypedGroup<Exit>();
		add(exits);
		
		corpses = new FlxGroup();
		add(corpses);
		
		crates = new FlxTypedGroup<Crate>();
		add(crates);
		
		holes = new FlxTypedGroup<Hole>();
		add(holes);
		
		map.loadObjects(this);
		
		if (creepSpawns.length == 0) {
			throw("No creepspawn on map");
		}
		if (exits.length == 0) {
			throw("No exits on map");
		}
		
		creeps = new FlxTypedGroup<Creep>();
		add(creeps);
		monsters = new FlxTypedGroup<Monster>();
		add(monsters);
		
		for (index in 0...creepSpawns.length) {
			var c = new actors.Creep(creepSpawns[index].x + Std.random(8), creepSpawns[index].y + Std.random(8));
			c.ID = index;
			creeps.add(c);	
		}
	
		for (index in 0...monsterSpawns.length) {
			var m = new actors.Monster(monsterSpawns[index].x, monsterSpawns[index].y);
			monsters.add(m);
		}
		
		add(map.secondFloor);
				

		FlxG.camera.setScrollBounds(0, map.width * 32, 0,  map.height * 32);
		FlxG.worldBounds.set(0, 0, map.width * 32, map.height * 32);
		
		hud = new hud.Hud();
		add(hud);
		
		hud.scorePanel.time = 13;
		hud.scorePanel.maxScore.animation.play(Std.string(creeps.countLiving()));
		var t = new FlxTimer();
		t.start(Rules.InitialPlayStatePauseTime, function(_) { paused = false; } );
		
	}
	
	//get distance between point 1 and 2
	function distance(x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Float {
		return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
	}
	
	function crateOverlapsCrates(crate : Crate) : Bool {
		var colides = false;
		FlxG.overlap(crate, crates, function(_, c : Crate) { 
			if (!c.lowered) {
				colides = true;
			}
		});
		return colides;
	}
	
	function sortCrates(order:Int, a : Crate, b : Crate) {
		var result : Int = 0;
		if (a.lowered) {
			result = order;
		} else if (b.lowered) {
			result = -order;
		} else {
			result = FlxSort.byY(order, a, b);
		}
		return result;
	}
	
	function sortCreeps(order:Int, a : Creep, b : Creep) {
		var result : Int = 0;
		if (a.alive == b.alive) {
			result = FlxSort.byY(order, a, b);
		} else if (!a.alive) {
			result = order;
		} else if (!b.alive) {
			result = -order;
		}
		return result;
	}
	
	override public function update(elapsed : Float) {
		
		if (paused) return;
		
		if (hud.menuPanel.state == 1) {
			hud.update(elapsed);
			return;
		}
		if (creeps.countLiving() <= 0 && !hud.finishPanel.visible) {
			hud.finishPanel.visible = true;
			hud.scorePanel.time = -1;
		}
		if (hud.finishPanel.visible) {
			hud.finishPanel.update(elapsed);
			return;
		}
		
		super.update(elapsed);		
		
		for (c in creeps) {
			var creep = cast(c, actors.Creep);
			
			if (creep.alive) {
				
				var xSum = 0.0;
				var ySum = 0.0;
							
				//push creep away from monsters, atract monsters to creep
				for (m in monsters) {
					var monster = cast(m, actors.Monster);
					
					var dx = monster.x - creep.x;
					var dy = monster.y - creep.y;
					
					var length = distance(0, 0, dx, dy);
					
					if (length < Rules.CreepToMonsterMinRange) {
						xSum -= dx / length * Rules.CreepToMonsterPower;
						ySum -= dy / length * Rules.CreepToMonsterPower;
					}				
				}
				
				var dx = 0.0;
				var dy = 0.0;
				var length = 1.0;
				
				//attract creep to closest exit
				for (e in exits) {
					
					var exit = cast(e, objects.Exit);
					
					var cx = exit.x - creep.x;
					var cy = exit.y - creep.y;
					
					length = distance(0, 0, cx, cy);
					
					if (length < Rules.CreepToExitMinRange) {
						
						dx = cx;
						dy = cy;
					}
				}
				
				xSum += dx / length * Rules.CreepToExitPower;
				ySum += dy / length * Rules.CreepToExitPower;			
				
				//attract creeps to creep
				if (creep.running) {
					for (o in creeps) {
						var otherCreep = cast(o, actors.Creep);
						if (otherCreep != creep && otherCreep.alive) {
				
							var dx = otherCreep.x - creep.x;
							var dy = otherCreep.y - creep.y;
							
							var length = distance(0, 0, dx, dy);
							
							if (length < Rules.CreepToCreepMaxRange) {
								if (length > Rules.CreepToCreepMinRange) {
									xSum += dx / length;
									ySum += dy / length;
								}
								else {
									xSum -= dx / length * 2;
									ySum -= dy / length * 2;
								}
							}
						}
					}
				}

				//normalize creep velocity
				var dist = distance(0, 0, xSum, ySum);
				if (dist != 0) {
					creep.running = true;
					creep.finalVelocity.set(xSum / dist * Rules.CreepMaxVelocity, ySum / dist * Rules.CreepMaxVelocity);
				} else {
					creep.running = false;
				}
			}
		}	

		//kill creep when he walks into spikes
		FlxG.overlap(creeps, spikes, function(creep : actors.Creep, _) {
			if (creep.alive) {				
				creep.animation.play("dead");
				creep.alive = false;
				FlxG.camera.shake(0.02, 0.15);
			}
		});
		
		//collect key
		FlxG.overlap(creeps, keys, function(_, x : objects.Key) {
			var key = cast(x, objects.Key);
			key.taken = true;
			for (y in doors) {
				var d = cast(y, objects.Doors);
				if (d.ID == key.ID) {
					d.disappear();
				}
			}
		});

		//keep lower creeps on top of higher ones
		creeps.sort(sortCreeps);
		//keep lower crates on top of higher ones
		crates.sort(sortCrates);
		
		FlxG.collide(monsters, map.secondFloor);
		FlxG.collide(creeps, doors);
		FlxG.collide(monsters, doors);

		
		//creep gets crushed with a crate
		FlxG.collide(creeps, crates, function(creep : Creep, _) {
			if ( (creep.isTouching(FlxObject.LEFT) && creep.isTouching(FlxObject.RIGHT)) || (creep.isTouching(FlxObject.UP) && creep.isTouching(FlxObject.DOWN))) {
				FlxG.camera.shake(0.02, 0.15);
				creep.alive = false;
				creep.animation.play("dead");
				creeps.remove(creep, true);
				corpses.add(creep);
			}
		});
		
		FlxG.overlap(holes, crates, function(hole : Hole, crate : Crate) {
			if (!hole.filled && crate.y% 32 == 0 && crate.x % 32 == 0) {
				hole.filled = true;
				crate.lower();
			}
		});
		
		FlxG.collide(monsters, crates, function(monster : Monster, crate : Crate) {	
		if (!crate.lowered) {
			switch(crate.touching) {
				case FlxObject.LEFT:
					crate.x += 1;
					if (map.secondFloor.overlaps(crate) || crateOverlapsCrates(crate)) {
						crate.x -= 1;
					} else {
						crate.x += 3;
					}
				case FlxObject.RIGHT:
					crate.x -= 1;
					if (map.secondFloor.overlaps(crate) || crateOverlapsCrates(crate)) {
						crate.x += 1;
					} else {
						crate.x -= 3;
					}
				case FlxObject.UP:
					crate.y += 1;
					if (map.secondFloor.overlaps(crate) || crateOverlapsCrates(crate)) {
						crate.y -= 1;
					} else {
						crate.y += 3;
					}
				case FlxObject.DOWN:
					crate.y -= 1;
					if (map.secondFloor.overlaps(crate) || crateOverlapsCrates(crate)) {
						crate.y += 1;
					} else {
						crate.y -= 3;
					}
				}
			}
		});
		
		//monster falls into a hole
		FlxG.overlap(monsters, holes, function(monster : Monster, hole : Hole) {
			if (!hole.filled) {
				monster.disappear();
				var timer = new FlxTimer();
				timer.start(.5, function(_) { monster.kill(); hud.finishPanel.visible = true; } );
			}
		});
		
		//creep falls into a hole
		FlxG.overlap(creeps, holes, function(creep : Creep, hole : Hole) {
			if (!hole.filled) {
				creep.disappear();
				var timer = new FlxTimer();
				timer.start(.5, function(_) { creep.kill(); } );
			}
		});
		
		//creep completes the level
		FlxG.overlap(creeps, exits, function(c : actors.Creep, _) {
			c.disappear();
			var timer = new FlxTimer();
			timer.start(.5, function(_) { c.kill(); } );
			score++;
			
			hud.scorePanel.time += 7;
			hud.scorePanel.score.animation.play(Std.string(score));
		});
		
		//FlxG.collide(crates, map.secondFloor); don't need it ?
		
		//bounce creeps of walls
		FlxG.collide(creeps, map.secondFloor, function(creep : actors.Creep, _) { creep.bounceFromWall(); } );
		
		//kill creep when monster walks into it
		FlxG.overlap(creeps, monsters, function(creep : actors.Creep, m : actors.Monster) {
			if (creep.alive) {
				FlxG.camera.shake(0.02, 0.15);
				creep.alive = false;
				creep.animation.play("dead");
				creeps.remove(creep, true);
				corpses.add(creep);
			}
		});

		#if mobile
			
			for (x in monsters) {
				var m = cast(x, actors.Monster);
				m.finalVelocity.x = Math.max(Math.min((tiltHandler.y) * 150, 60), -60);
				m.finalVelocity.y = Math.max(Math.min((tiltHandler.x - Reg.calibrationPoint.x) * 100, 60), -60);
			}
			
		#end
		
		#if !mobile
			for (x in monsters) {
				var m = cast(x, actors.Monster);
				if (FlxG.keys.pressed.LEFT) m.finalVelocity.x = -Rules.KeyMaxVelocity;
				if (FlxG.keys.pressed.RIGHT) m.finalVelocity.x = Rules.KeyMaxVelocity;
				if (FlxG.keys.pressed.UP) m.finalVelocity.y = -Rules.KeyMaxVelocity;
				if (FlxG.keys.pressed.DOWN) m.finalVelocity.y = Rules.KeyMaxVelocity;
			}
		#end
	}
}
