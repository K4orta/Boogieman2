package org.lemonparty.aiNodes.leafs 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.BasicObject;
	import org.lemonparty.Unit;
	import org.lemonparty.K4G;
	import org.lemonparty.Emote;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BL_RecheckSusOb extends Node {
		public function BL_RecheckSusOb(Parent:Unit=null){
			super(Parent);
		}
		
		override public function run():uint {
			var sus:BasicObject = parent.lineOfSight(parent.hostileGroup);
			if (sus) {
				parent.attTar = sus;
				parent.susOb = null;
				return SUCCESS;
			}else {
				parent.susOb = null;
				return FAILURE;
			}
		}
	}

}