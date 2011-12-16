package org.lemonparty 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class K4Dialog extends FlxGroup 
	{
		protected var cpm:int;
		protected var prog:Number;
		protected var totalTime:Number;
		protected var step:Number;
		public var finalText:FlxText;
		public var targetText:String;
		
		
		public function K4Dialog(ShowText:String, TextSpeed:Number=2) {
			super();
			finalText = new FlxText((FlxG.width*.5)-(ShowText.length*11*.5), 0, ShowText.length*11, "");
			finalText.scrollFactor.x = finalText.scrollFactor.y = 0;
			add(finalText);
			targetText = ShowText;
			
		}
		
		override public function update():void {
			super.update();
			if (finalText.text.length < targetText.length) {
				finalText.text += targetText.charAt(finalText.text.length);
			}
		}
	}

}