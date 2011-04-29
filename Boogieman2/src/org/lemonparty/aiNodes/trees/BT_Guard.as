package org.lemonparty.aiNodes.trees {

	import org.lemonparty.btree.Selector;
	import org.lemonparty.btree.Decorator;
	import org.lemonparty.btree.Sequence;
	import org.lemonparty.aiNodes.leafs.*;
	import org.lemonparty.aiNodes.decorators.*;
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BT_Guard extends BD_Look{
		public function BT_Guard(Parent:Unit=null){
			super(Parent);
			addChild(new Sequence());
			firstChild.addChild(new BL_Wait(5));
			firstChild.addChild(new BL_Turn());
		}
		
	}

}