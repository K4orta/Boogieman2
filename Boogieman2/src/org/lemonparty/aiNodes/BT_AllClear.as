package org.lemonparty.aiNodes 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	import org.lemonparty.Emote;
	import org.lemonparty.K4G;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BT_AllClear extends Node {
		public function BT_AllClear() {
			super();
		}
		
		override public function run():uint {
			if (!parent.lineOfSight(K4G.logic.player)) {
				return MORE_TIME;
			}else {
				parent.attTar = K4G.logic.curSel;
				K4G.logic.emote(Emote.QUESTION, 1, parent);
				return FAILURE;
			}
			
		}
		
	}

}