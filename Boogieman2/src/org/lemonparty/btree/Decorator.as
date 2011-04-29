package org.lemonparty.btree 
{
	import org.lemonparty.Unit;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class Decorator extends Node {
		
		public function Decorator(Parent:Unit=null) {
			super(Parent);
		}
		
		override public function run():uint {
			var ret:uint = _children[0].run();
			return ret;
		}
		
		override public function addChild(Child:Node):void {
			if (_children == null) {
				_children = new Vector.<Node>();
			}
			
			if (_children.length < 1) {
				super.addChild(Child);
			}else {
				trace("ERROR: Can't add more than one child to decorator");
			}
			
		}
		
		override public function terminate():void {
			_children[0].terminate();
		}
		
	}

}