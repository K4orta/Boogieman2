package org.lemonparty 
{
	import org.flixel.FlxTilemap;
	import org.flixel.FlxObject;
	import org.flixel.*;
	import org.flixel.system.*;
	import org.flixel.FlxRect;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Island extends ColorTilemap
	{
		
		public function Island(){
			super();
			immovable = false;
			moves = true;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			
		}
		
		override public function update():void {
			super.update();
		}
		
		override public function postUpdate():void {
			super.postUpdate();
			
	
		}
		
		static public function separateMasses(Object1:FlxObject, Object2:FlxObject):Boolean{
			
			if (Object1 is FlxTilemap && Object2 is FlxTilemap) {
				var ret:Boolean = false
				//trace("yep");
				if (Object1 is Island) {
					ret= (Object2 as FlxTilemap).overlapsWithCallback(Object1);
				}else {
					ret =(Object1 as FlxTilemap).overlapsWithCallback(Object2);
				}
				if (ret) {
					//trace("klapow");
				}
				
				return ret;
				//return Object1.overlaps(Object2);
				
			}else{
				var separatedX:Boolean = separateX(Object1,Object2);
				var separatedY:Boolean = separateY(Object1, Object2);
			
				if (separatedX || separatedY) {
					//Object2.acceleration.x = Object1.acceleration.x;
					Object2.x += Object1.x - Object1.last.x;
				}
				return separatedX || separatedY;
			}
			
		}
		
		
		
		
		
	}	

}