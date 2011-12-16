package org.lemonparty.aiNodes.leafs 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	import org.lemonparty.K4G;
	import org.lemonparty.Emote;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BL_hasAttTar extends Node 
	{
		
		public function BL_hasAttTar(Parent:Unit = null) {
			super(Parent);
		}
		
		override public function run():uint {
			if (parent.attTar) {
				//K4G.logic.emote(Emote.EXCLAMATION, 3, parent);
				return SUCCESS;
			}else {
				return FAILURE;
			}
		}
		
	}

}