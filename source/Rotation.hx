package ;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Michael
 */
class Rotation {
	
	var yaw : Float = 0;
	var pitch : Float = 0;
	
	public function new(x : Float, y : Float, z : Float) {
		var r = rotationFromVector(x, y, z);
		yaw = r.x;
		pitch = r.y;
	}
	
	public function rotationFromVector(x : Float, y : Float, z : Float):FlxPoint {
		var r = Math.sqrt(x * x + y * y + z * z);
		return new FlxPoint(Math.atan2(y, x), Math.acos(z/r));
	}
	
	public function setCalibration(x : Float, y : Float, z : Float) {
		var r = rotationFromVector(x, y, z);
		yaw = r.x;
		pitch = r.y;
	}
		
	public function getMovementVector(x : Float, y : Float, z : Float) : FlxPoint {
		var r = rotationFromVector(x, y, z);
		var t = r.x - yaw;
		var p = r.y - pitch;
		return new FlxPoint(Math.sin(p)*Math.cos(t), Math.sin(p)*Math.sin(t));
	}
}