package ;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import haxe.io.Path;
import objects.Crate;
import objects.Exit;
import objects.Hole;

/**
 * ...
 * @author Michael
 */
class TiledLevel extends TiledMap {

	public var firstFloor : FlxTilemap;
	public var secondFloor : FlxTilemap;
	public var bricks : FlxTilemap;
	public var background : FlxTilemap;
	
	public function new(Data:Dynamic){
		super(Data);
		
		firstFloor = new FlxTilemap();
		secondFloor = new FlxTilemap();
		bricks = new FlxTilemap();
		background = new FlxTilemap();
		
		for (tileLayer in layers) {
			
			var tileSheetName:String = tileLayer.properties.get("tileset");
						
			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
				
			var tileSet:TiledTileSet = null;
			for (ts in tilesets) {
				if (ts.name == tileSheetName) {
					tileSet = ts;
					break;
				}
			}
			var imagePath = new Path(tileSet.imageSource);
			var processedPath = "assets/images/" + imagePath.file + "." + imagePath.ext;
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath, tileSet.tileWidth, tileSet.tileHeight, 1, 1);
			
			if (tileLayer.name == "Bricks") {
				bricks = tilemap;
			} else if (tileLayer.name == "firstFloor") {
				tilemap.y += 16;
				firstFloor = tilemap;
			} else if (tileLayer.name == "secondFloor") {
				secondFloor = tilemap;
			} else if (tileLayer.name == "Background") {
				tilemap.y += 16;
				background = tilemap;
			}
		}
	}
	
	public function loadObjects(state:PlayState) {
		for (group in objectGroups) {
			for (o in group.objects) {
				loadObject(o, group, state);
			}
		}
	}
	
	private function loadObject(o:TiledObject, g:TiledObjectGroup, state:PlayState) {
		var x:Int = o.x;
		var y:Int = o.y;
		
		if (o.gid != -1) {
			y -= g.map.getGidOwner(o.gid).tileHeight;
		}
		
		switch (o.type.toLowerCase()) {
				
			case "exit":
				var exit = new Exit(x, y);
				state.exits.add(exit);
			case "creepspawn":
				state.creepSpawns.push(new FlxPoint(x, y));
			case "doors":
				state.doors.add(new objects.Doors(x, y, Std.parseInt(o.custom.keys.get("id"))));
			case "key":
				state.keys.add(new objects.Key(x, y, Std.parseInt(o.custom.keys.get("id"))));
			case "monsterspawn":
				state.monsterSpawns.push(new FlxPoint(x, y));
			case "spike":
				state.spikes.add(new objects.Spike(x, y));
			case "crate":
				state.crates.add(new Crate(x, y));
			case "hole":
				state.holes.add(new Hole(x, y + 16));
		}
	}
	
}