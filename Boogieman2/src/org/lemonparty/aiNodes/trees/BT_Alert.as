package org.lemonparty.aiNodes.trees 
{
	import org.lemonparty.aiNodes.leafs.BL_hasAttTar;
	import org.lemonparty.aiNodes.leafs.BL_Wait;
	import org.lemonparty.aiNodes.leafs.BL_pathTo;
	import org.lemonparty.btree.Sequence;
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BT_Alert extends Sequence 
	{
		
		public function BT_Alert(Parent:Unit = null) {
			super(Parent);
			addChild(new BL_hasAttTar());
			addChild(new BL_pathTo());
			addChild(new BL_Wait(5));
		}
		
	}

}