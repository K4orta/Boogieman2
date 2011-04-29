package org.lemonparty 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class Vector2D {
		public var p0:FlxPoint = new FlxPoint();
		public var p1:FlxPoint = new FlxPoint();
		public var slope:FlxPoint = new FlxPoint();
		public var length:Number;
		public var normal:FlxPoint = new FlxPoint(); 
		
		public function Vector2D(P1:FlxPoint, P2:FlxPoint){
			p0 = P1;
			p1 = P2;
			update();
		}
		
		public function update():void {
			slope.x = p1.x - p0.x;
			slope.y = p1.y - p0.y;
			length = Math.sqrt(slope.x*slope.x+slope.y*slope.y);
			normal.x = slope.x / length; 
			normal.y = slope.y / length;
		}
		
		public function intersect(v1:Vector2D,v2:Vector2D):FlxPoint {
			var v3:Vector2D = new Vector2D(new FlxPoint(v1.p0.x,v1.p0.y),new FlxPoint(v2.p0.x, v2.p0.y));
			//v3.slope.make(v2.p0.x-v1.p0.x, v2.p0.y-v1.p0.y);
			var t:Number;
			if ((v1.normal.x == v2.normal.x && v1.normal.y == v2.normal.y) || (v1.normal.x == -v2.normal.x && v1.normal.y == -v2.normal.y)){
				return null;
			}else{
				t = perP(v3, v2)/perP(v1, v2);
			}
			
			return new FlxPoint(v1.p0.x+v1.slope.x*t, v1.p0.y + v1.slope.y * t);
		}
		
		public function perP(v1:Vector2D,v2:Vector2D):Number {
			return v1.slope.x * v2.slope.y - v1.slope.y * v2.slope.x;
		}
		
	}

}