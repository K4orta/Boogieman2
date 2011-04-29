package org.lemonparty 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class TimeKeeper extends EventDispatcher{	
		public static var time:int=0; 
		protected var _minuteLen:Number = .1;
		protected var _sand:Number = 0;
		protected var _minutes:int = 0;
		protected var _hours:int = 0;
		protected var _days:uint = 0;
		
		public static const MIDNIGHT:String = "midnight";
		public static const NOON:String = "noon";
		public static const ONHOUR:String = "onHour";
		
		public function TimeKeeper(){
			time = 360;
			_minutes = time-(int(time / 60) * 60);
			_hours = int(time / 60);
			FlxG.watch(this, "hours");
		}
		
		public function update() :void{
			_sand += FlxG.elapsed;
			if (_sand > _minuteLen) {
				++_minutes;
				++time;
				_sand -= _minuteLen;
				if (_minutes > 59) {
					++_hours;
					_minutes = 0;
					if (_hours > 23) {
						time = 0;
						_hours = 0;
						++_days;
					}
					onHour();
				}
			}
		}
		
		public function onHour():void {
			if (time==0) {
				//midnight
				dispatchEvent(new Event(MIDNIGHT));
			}else if (time == 720) {
				dispatchEvent(new Event(NOON));
			}
			dispatchEvent(new Event(ONHOUR));
		}
		
		public function formatTime() :String {
			return String(String(_hours>12?_hours-12:_hours) + ":" + (_minutes < 10?"0" + String(_minutes):String(_minutes))+String(_hours<12?"AM":"PM"));
		}
		
		public function formatMilitary():String {
			return String(String(_hours) + ":" + (_minutes < 10?"0" + String(_minutes):String(_minutes)));
		}
		
		public function get hours():int {
			return _hours;
		}
	}
}