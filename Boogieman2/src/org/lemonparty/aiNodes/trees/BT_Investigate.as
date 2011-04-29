package org.lemonparty.aiNodes.trees 
{
	import org.lemonparty.aiNodes.leafs.BL_HasSOb;
	import org.lemonparty.aiNodes.leafs.BL_RecheckSusOb;
	import org.lemonparty.aiNodes.leafs.BL_Wait;
	import org.lemonparty.btree.Sequence;
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BT_Investigate extends Sequence {
		
		public function BT_Investigate(Parent:Unit = null) {
			super(Parent);
			addChild(new BL_HasSOb());
			addChild(new BL_Wait(.6));
			addChild(new BL_RecheckSusOb());
		}
		
	}

}