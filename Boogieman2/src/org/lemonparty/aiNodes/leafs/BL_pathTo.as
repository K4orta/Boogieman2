package org.lemonparty.aiNodes.leafs 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxObject;
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	import org.lemonparty.K4G;
	import org.flixel.FlxG;
	import org.lemonparty.Emote;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BL_pathTo extends Node 
	{
		
		public function BL_pathTo(Parent:Unit = null) {
			super(Parent);
		}
		
		override public function run():uint {
			
			parent.facing = parent.attTar.x < parent.x?FlxObject.LEFT:FlxObject.RIGHT;
			parent.moveOrder(K4G.map.dropToGround(new FlxPoint(parent.attTar.x, parent.attTar.y + parent.attTar.height - 6)), function():void {
				parent.dumbPathing();
				parent.yipe();
			});

			return SUCCESS;
		}
		
	}

}