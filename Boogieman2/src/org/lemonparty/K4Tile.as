package org.lemonparty {
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class K4Tile{
		public var hp:Number = 5;
		public var x:int;
		public var y:int;
		public var tIndex:uint;
		public var lit:Number=0;
		public var top:Boolean = false;
		
		public function K4Tile(X:int,Y:int,Index:uint){
			x = X; 
			y = Y;
			tIndex = Index;
		}
		
		public function hurt(Damage:Number):void {
			hp -= Damage;
			if (hp <= 0) {
				K4G.gameMap.setTile(x,y,0);
			}
		}
		
		
	}

}