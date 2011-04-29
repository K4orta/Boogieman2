package org.lemonparty.aiNodes.leafs 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BL_Turn extends Node {
		
		public function BL_Turn(Parent:Unit = null) {
			super(Parent);
		}
		
		override public function run():uint{
			if (parent.facing == FlxObject.LEFT) {
				parent.facing = FlxObject.RIGHT;
			}else {
				parent.facing = FlxObject.LEFT;
			}
			
			return SUCCESS;
		}
	}

}