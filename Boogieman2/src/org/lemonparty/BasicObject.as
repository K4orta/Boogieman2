package org.lemonparty 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxGroup;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxPoint;
	import flash.geom.ColorTransform;
	import org.flixel.FlxU;
	
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BasicObject extends FlxSprite {
		protected var 	_map:		ColorTilemap;
		protected var 	_logic:		PlayState;
		public var 		subClass:	String 		= null;
		public var 		canUse:		Boolean 	= false;
		public var 		blocksSight:Boolean		= false;
		public var		bulletsHit: Boolean 	= false;
		public var 		heat:		Boolean 	= false;
		public var 		flashPoint:	Number		= 3;
		public var colTrans: ColorTransform;
		
		// __________________________________________ CONSTRUCTOR
		
		public function BasicObject(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null) {
			super(X, Y, SimpleGraphic);
			_map = K4G.gameMap;
			_logic = K4G.logic;
		}
		
		// __________________________________________ EVENT HANDLERS
		// __________________________________________ METHODS
		
		public function ray(RayS:FlxPoint, RayE:FlxPoint, Normal:FlxPoint):FlxPoint {
			var t1p1:FlxPoint, t1p2:FlxPoint, t2p1:FlxPoint, t2p2:FlxPoint;
			if (RayS.x < x) {
				t1p1 = new FlxPoint(x, y-2);
				t1p2 = new FlxPoint(x, y + height+2);
			}else { 
				t1p1 = new FlxPoint(x+width, y-2);
				t1p2 = new FlxPoint(x+width, y+height+2);
			}
			
			if (RayS.y <  y) {
				t2p1 = new FlxPoint(x, y);
				t2p2 = new FlxPoint(x+width, y);
			}else {
				t2p1 = new FlxPoint(x, y+height);
				t2p2 = new FlxPoint(x+width,y+height);
			}

			var ret:FlxPoint = intersect(RayS, RayE, t1p1, t1p2, Normal, new FlxPoint(1,0));
			if (ret) { 
				//_logic.mark(ret.x, ret.y);
				return ret;
			}
			ret = intersect(RayS, RayE, t2p1, t2p2, Normal, new FlxPoint(0,1));
			if (ret) {
				//_logic.mark(ret.x, ret.y);
				return ret;
			}
			return null;
		}
		// __________________________________________ CALLBACK FUNCTIONS
		// __________________________________________ GETTER/SETTERS
		
		
		// __________________________________________ UTILITY FUNCTIONS
		
		public function intersect(a1:FlxPoint, a2:FlxPoint, b1:FlxPoint, b2:FlxPoint, aNorm:FlxPoint, bNorm:FlxPoint):FlxPoint {
			var c1:FlxPoint = new FlxPoint(a1.x, a1.y);
			var c2:FlxPoint = new FlxPoint(b1.x, b1.y);
			var aSlope:FlxPoint = new FlxPoint(a2.x-a1.x,a2.y-a1.y); 
			if ((aNorm.x == bNorm.x && aNorm.y == bNorm.y) || (aNorm.x == -bNorm.x && aNorm.y == -bNorm.y)){
				return null;
			}else{
				var t:Number = perP(new FlxPoint(c2.x-c1.x,c2.y-c1.y),new FlxPoint(b2.x-b1.x,b2.y-b1.y)) / perP(aSlope,new FlxPoint(b2.x-b1.x,b2.y-b1.y));
			}
			var tx:Number = a1.x + aSlope.x * t;
			var ty:Number = a1.y + aSlope.y * t;
			
			if ( tx < FlxU.min(a1.x, a2.x) || tx > FlxU.max(a1.x, a2.x) || tx < FlxU.min(b1.x, b2.x) || tx > FlxU.max(b1.x, b2.x) ) { return null; }
			if ( ty < FlxU.min(a1.y, a2.y) || ty > FlxU.max(a1.y, a2.y) || ty < FlxU.min(b1.y, b2.y) || ty > FlxU.max(b1.y, b2.y) ) { return null; }
			
			return new FlxPoint(tx, ty);
		}
		
		// takes two slopes and returns the Per Product
		public function perP(v1:FlxPoint,v2:FlxPoint):Number {
			return v1.x * v2.y - v1.y * v2.x;
		}
		
		public function getSimpleDist(Arg:FlxObject):Number {
			var dx:Number = Arg.x - x+origin.x;
			var dy:Number = Arg.y - y+origin.y;
			return sqrt(dx * dx + dy * dy);
		}
		
		override public function draw():void {
			_colorTransform = K4G.map.colTrans;//copyColor(K4G.map.colTrans);
			checkCloseLights();
			//calcFrame();
			
			super.draw();
		}
		
	
		public function checkCloseLights():void {
			var lightAr:FlxGroup = K4G.lights;
			var dst:Number = 0;
			var amt:Number = 0;
			var tmpLight:Light;
			for (var i:int = 0; i < lightAr.members.length;++i) {
				if (lightAr.members[i].alive) {
					tmpLight = lightAr.members[i];
					dst = getSimpleDist(tmpLight);
					if (dst < tmpLight.radius) {
						if (_colorTransform == _map.colTrans) {
							_colorTransform=copyColor(_map.colTrans);
						}
						amt = 1 - (dst /tmpLight.radius);
						_colorTransform.redMultiplier += tmpLight.color.redMultiplier * amt;
						_colorTransform.greenMultiplier += tmpLight.color.greenMultiplier * amt;
						_colorTransform.blueMultiplier += tmpLight.color.blueMultiplier * amt;
					}
				}
			}
			dirty = true;
		}
		
		public function getDist(Arg:FlxSprite):Number {
			var dx:Number = (Arg.x+Arg.origin.x) - (x+origin.x);
			var dy:Number = (Arg.y+Arg.origin.y) - (y+origin.y);
			return sqrt(dx * dx + dy * dy);
		}
		
		public function sqrt(val:Number):Number{
			if (isNaN(val))
			{
				return NaN;
			}
			
			var thresh:Number = 0.002;
			var b:Number = val * 0.25;
			var a:Number;
			var c:Number;
			
			if (val == 0)
			{
				return 0;
			}
			
			do {
				c = val / b;
				b = (b + c) * 0.5;
				a = b - c;
				if (a < 0) a = -a;
			}
			while (a > thresh);
			
			return b;
		}
		
		public function copyColor(Color:ColorTransform):ColorTransform {
			return new ColorTransform(Color.redMultiplier,Color.greenMultiplier,Color.blueMultiplier);
		}
		
		public function getK():Number {
			return (0.3*_colorTransform.redMultiplier) + (0.59*_colorTransform.greenMultiplier) + (_colorTransform.blueMultiplier*0.11);
		}
		
		public function abs(Value:Number):Number {
			return Value > 0?Value: -Value;
		}
		
	}

}