package org.lemonparty.aiNodes.leafs 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	import org.lemonparty.Emote;
	import org.lemonparty.K4G;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BL_HasSOb extends Node {
		
		public function BL_HasSOb(Parent:Unit = null) {
			super(Parent);
		}
		
		override public function run():uint {
			if (parent.susOb) {
				K4G.logic.emote(Emote.QUESTION, .6, parent);
				return SUCCESS;
			}else {
				return FAILURE;
			}
		}
		
	}

}