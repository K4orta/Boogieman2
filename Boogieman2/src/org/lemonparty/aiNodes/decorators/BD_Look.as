package org.lemonparty.aiNodes.decorators 
{
	import org.lemonparty.BasicObject;
	import org.lemonparty.btree.Decorator;
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class BD_Look extends Decorator {
		
		public function BD_Look(Parent:Unit=null){
			super(Parent);
		}
		
		override public function run():uint {
			var sus:BasicObject = parent.lineOfSight(parent.hostileGroup);
			if (sus) {
				parent.susOb = sus;
				terminate();
				return FAILURE;
			}else {
				return _children[0].run();
			}
		}
		
	}

}