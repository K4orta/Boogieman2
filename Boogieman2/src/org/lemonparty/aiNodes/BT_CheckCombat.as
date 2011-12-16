package org.lemonparty.aiNodes 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BT_CheckCombat extends Node {		
		public function BT_CheckCombat(){
			super();
		}
		
		override public function run():uint {
			if (parent.attTar) {
				if (parent.attTar.x<parent.x) {
					parent.facing = FlxObject.LEFT;
				}else {
					parent.facing = FlxObject.RIGHT;
				}
				return SUCCESS;
			}else {
				return FAILURE;
			}
		}
		
	}

}