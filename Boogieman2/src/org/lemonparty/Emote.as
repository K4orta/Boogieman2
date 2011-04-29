package org.lemonparty 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class Emote extends FlxSprite {
		[Embed(source = "data/guardEmotes.png")] protected var ImgEmote:Class;
		
		public static const QUESTION:String="Question";
		public static const EXCLAMATION:String = "Exclamation";
		
		public var follow:FlxSprite;
		public var tos:Number; // Number of seconds to show before hiding. 
		public var fadeOut:Boolean=true;
		
		public function Emote(X:Number = 0, Y:Number = 0){
			super(X, Y);
			loadGraphic(ImgEmote, true,false,8,8);
			addAnimation("Question", [0], 0);
			addAnimation("Exclamation", [1], 0);
			//visible = false;
		}
		
		override public function update():void {
			if(fadeOut) 
				tos -= FlxG.elapsed;
			if (tos <= 0) {
				visible = false;
				kill();
			}
			if (follow) {
				x = follow.x;
				y = follow.y - 16;
			}
			super.update();
		}
		
		public function emote(Emot:String, Time:Number, Follow:FlxSprite):Emote {
			visible = true;
			tos = Time;
			follow = Follow;
			play(Emot);
			return this;
		}
		
	}

}