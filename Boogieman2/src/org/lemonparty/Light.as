package org.lemonparty 
{
	import flash.geom.ColorTransform;
	import org.flixel.FlxPoint;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Light extends FlxObject{
		public var radius:	Number;
		public var color:	ColorTransform;
		public var life:	Number;
		public var burnout:	Number;
		public var burnTime:Number;
		public var r:		Number	= 0;
		public var g:		Number	= 0;
		public var b:		Number	= 0;
		public var _logic:PlayState;
		
		public function Light(X:Number = 0, Y:Number = 0, R:Number=0, G:Number=0, B:Number=0, Radius:Number=64){
			super(X, Y);
			color = new ColorTransform(R, G, B);
			r = R;
			g = G;
			b = B;
			radius = Radius;
		}
		
		public function setBurn(Life:Number=1,Burn:Number=1):void {
			active = true;
			burnout = 0;
			life = Life;
			burnTime = Burn;
		}
		
		override public function update():void {
			life-= FlxG.elapsed;
			
			if (life<=0) {
				burnout += FlxG.elapsed;
				var amt:Number=1 - (burnout / burnTime);
				color.redMultiplier = amt * r;
				color.greenMultiplier = amt * g;
				color.blueMultiplier = amt * b;
				if (burnout>=burnTime) {
					kill();
				}
			}
		}
		
		
		
		override public function kill():void {
			//K4G.logic.lights.remove(this, true);
			super.kill();
		}
	}

}