package org.lemonparty.btree.decorators 
{
	import org.lemonparty.btree.Decorator;
	import org.lemonparty.btree.Node;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class Wait extends Decorator {
		public var timer:Number;
		public var waitTill:Number;
		
		public function Wait(Child:Node, Timer:Number){
			super(Child);
			timer = 0;
			waitTill = Timer;
		}
		
		override public function run():uint {
			if (timer < waitTill) {
				timer += FlxG.elapsed;
				return MORE_TIME;
			}else {
				var ret = firstChild.run();
				return ret;
			}
		}
		
		public function terminate() {
			timer = 0;
			waitTill = 0;
			super.terminate();
		}
	}

}