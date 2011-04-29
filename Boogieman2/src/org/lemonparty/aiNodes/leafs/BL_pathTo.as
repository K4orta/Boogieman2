package org.lemonparty.aiNodes.leafs 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxObject;
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	import org.lemonparty.K4G;
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
			parent.path = null;
			parent.facing = parent.attTar.x < parent.x?FlxObject.LEFT:FlxObject.RIGHT; 
			/*parent.ptf = K4G.gameMap.findPath(new FlxPoint(parent.x, parent.y), new FlxPoint(K4G.logic.curSel.x, K4G.logic.curSel.y));
			if(parent.ptf)
				parent.followPath(parent.ptf, 100, FlxObject.PATH_HORIZONTAL_ONLY);
			if (parent.ptf) {
				for (var i:int = 0; i < parent.ptf.nodes.length;++i) {
					K4G.logic.mark(parent.ptf.nodes[i].x, parent.ptf.nodes[i].y);
				}
			}*/
			return SUCCESS;
		}
		
	}

}