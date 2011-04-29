package org.lemonparty.aiNodes.leafs 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BL_Wait extends Node {
		public var tos:Number;
		public var limit:Number;
		public function BL_Wait(Limit:Number, Parent:Unit = null){
			super(Parent);
			limit = Limit;
			tos = 0;
		}
		
		override public function run():uint {
			if (tos<limit) {
				tos += FlxG.elapsed;
				return MORE_TIME;
			}else {
				tos = 0;
				return SUCCESS;
			}
		}
		
		override public function terminate():void {
			tos = 0;
			super.terminate();
		}
	}

}