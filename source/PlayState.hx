package ;

import actors.*;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
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
	
	///
	var framerate : FlxText;
	///
	
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
		
		/////////////////////////////////////////////////
		framerate = new FlxText(0, 0);
		framerate.scrollFactor.x = framerate.scrollFactor.y = 0;
		add(framerate);
		/////////////////////////////////////////////////
	
		var t = new FlxTimer();
		t.start(Rules.InitialPlayStatePauseTime, function(_) { paused = false; hud.scorePanel.toggle(); } );
		
	}
	
	//get distance between point 1 and 2
	function distance(x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Float {
		return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
	}

	function crateOverlapsCrates(crate : Crate) : Bool {
		var colides = false;
		FlxG.overlap(crate, crates, function(_, c : Crate) { 
			if (c.popped == 1) {
				colides = true;
			}
		});
		return colides;
	}
	
	function sortCrates(order:Int, a : Crate, b : Crate) {
		var result : Int = 0;
		if (a.popped == 0) {
			result = order;
		} else if (b.popped == 0) {
			result = -order;
		} else {
			result = FlxSort.byY(order, a, b);
		}
		return result;
	}
	
	function sortCreeps(order:Int, a : Creep, b : Creep) {
		var result : Int = 0;
		if (!a.alive) {
			result = order;
		} else if (!b.alive) {
			result = -order;
		} else {
			result = FlxSort.byY(order, a, b);
		}
		return result;
	}
	
	override public function update(elapsed : Float) {
		
		if (paused) return;
		
		if (hud.menuPanel.state == 1) {
			hud.update(elapsed);
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
									xSum -= dx / length;
									ySum -= dy / length;
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

		FlxG.overlap(holes, crates, function(hole : Hole, crate : Crate) {
			if (!hole.filled && crate.y% 32 == 0 && crate.x % 32 == 0) {
				hole.filled = true;
				crate.pop();
			}
		});
		FlxG.overlap(monsters, crates, function(m : Monster, c : Crate) {
			if (c.popped == 1 || c.tweening) {
				FlxG.collide(m, c, function(monster : Monster, crate : Crate) {	
				if (!crate.tweening) {
					switch(crate.touching) {
						case FlxObject.LEFT:
							crate.x += 1;
							if (map.secondFloor.overlaps(crate) || crateOverlapsCrates(crate)) {
								crate.x -= 1;
							} else {
								crate.x += 15;
							}
						case FlxObject.RIGHT:
							crate.x -= 1;
							if (map.secondFloor.overlaps(crate) || crateOverlapsCrates(crate)) {
								crate.x += 1;
							} else {
								crate.x -= 15;
							}
						case FlxObject.UP:
							crate.y += 1;
							if (map.secondFloor.overlaps(crate) || crateOverlapsCrates(crate)) {
								crate.y -= 1;
							} else {
								crate.y += 15;
							}
						case FlxObject.DOWN:
							crate.y -= 1;
							if (map.secondFloor.overlaps(crate) || crateOverlapsCrates(crate)) {
								crate.y += 1;
							} else {
								crate.y -= 15;
							}
						}
					}
				});

			}
		});
		
		FlxG.collide(crates, map.secondFloor);
		
		//creep completes the level
		FlxG.overlap(creeps, exits, function(c : actors.Creep, _) {
			c.enterExit();
			var timer = new FlxTimer();
			timer.start(.5, function(_) { c.kill(); } );
			score++;
			
			if (score == creeps.length) {
				hud.finishPanel.visible = true;
			}
			
			if (hud.scorePanel.state == 0) {
				hud.scorePanel.toggle();	
				var t = new FlxTimer();
				t.start(1, function(_) {
					hud.scorePanel.toggle();
				});
			}
			
			
			hud.scorePanel.score.text = Std.string(score);
		});
		FlxG.collide(creeps, map.secondFloor, function(creep : actors.Creep, _) { creep.bounceFromWall(); } );
		
		//kill creep when monster walks into it
		FlxG.overlap(creeps, monsters, function(creep : actors.Creep, m : actors.Monster) {
			if (creep.alive) {
				FlxG.camera.shake(0.02, 0.15);
				creep.alive = false;
				creep.animation.play("dead");
			}
		});

		#if mobile
			
			for (x in monsters) {
				var m = cast(x, actors.Monster);
				m.finalVelocity.x = Math.min((tiltHandler.y) * 250, 250);
				m.finalVelocity.y = Math.min((tiltHandler.x - Reg.calibrationPoint.x) * 200, 250);
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
		
		framerate.text = Std.string(Math.round(1 / FlxG.elapsed));

	}
}
