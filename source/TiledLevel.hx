package ;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;

/**
 * ...
 * @author Michael
 */
class TiledLevel extends TiledMap {

	public var firstFloor : FlxGroup;
	public var secondFloor : FlxGroup;
	public var bricks : FlxGroup;
	public var background : FlxGroup;
	
	public function new(Data:Dynamic){
		super(Data);
		
		firstFloor = new FlxGroup();
		secondFloor = new FlxGroup();
		bricks = new FlxGroup();
		background = new FlxGroup();
		
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
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 1, 1);
			
			if (tileLayer.name == "Bricks") {
				tilemap.y -= 16;
				bricks.add(tilemap);
			} else if(tileLayer.name == "firstFloor"){
				firstFloor.add(tilemap);
			} else if (tileLayer.name == "secondFloor") {
				tilemap.y -= 16;
				secondFloor.add(tilemap);
			} else if (tileLayer.name == "Background") {
				background.add(tilemap);
			}
			
		}
		
	}
	
}