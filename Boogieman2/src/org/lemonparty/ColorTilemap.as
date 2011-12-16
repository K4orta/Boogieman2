package org.lemonparty {
	import flash.geom.ColorTransform;
	import org.flixel.FlxCamera;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	import org.flixel.system.FlxTilemapBuffer;
	
	/**
	 * Extends the flxTilemap with day/night cycles and camo
	 * @author Erik Wong
	 */
	public class ColorTilemap extends FlxTilemap{
		protected var _map:K4Map;
		public var colTrans:ColorTransform;
		
		public function ColorTilemap() {
			super();
			colTrans = new ColorTransform();
		}
		
		override public function update():void {
			super.update();
			if (colTrans!=K4G.map.colTrans) {
				setDirty();
				colTrans = K4G.map.colTrans;
			}
		}
		
		/*
		override public function render():void {
			if (colTrans!=K4G.map.colTrans) {
				refresh = true;
				colTrans = K4G.map.colTrans;
			}
			super.render();
		}
		*/
		override protected function drawTilemap(Buffer:FlxTilemapBuffer, Camera:FlxCamera):void {
			super.drawTilemap(Buffer, Camera);
			Buffer.pixels.colorTransform(Buffer.pixels.rect, colTrans);
		}
		
		public function simplePath(Arg:Array):void {
			try{
			simplifyPath(Arg);
			}catch (er:Error) {
				trace("Hi Hi");
			}
			
		}
		
		public function blocked(Point:FlxPoint):Boolean {
			return _tileObjects[_data[uint(uint(Point.y/_tileHeight)*widthInTiles + Point.x/_tileWidth)]].allowCollisions>0
		}
		
		
	}

}