package org.lemonparty {
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import flash.utils.getDefinitionByName;
	import org.lemonparty.units.*;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class K4Map {
		
		// contains functions for loading the map, actors, and various map functions
		
		public var logic:PlayState;
		public var layerMain:ColorTilemap;
		public var backLayer:ColorTilemap;
		
		public var colTrans:ColorTransform;
		protected var _oldTrans:ColorTransform;
		protected var _newTrans:ColorTransform;
		public var fadeTimes:Array;
		protected var _doFade:Boolean;
		protected var _fadeTime:Number=0;
		protected var _fadeMax:Number = 5;
		
		public var fades:Vector.<ColorTransform>=new Vector.<ColorTransform>();
		public var mapString:String;
		
		
		// __________________________________________ CONSTRUCTOR
		public function K4Map(){
			colTrans = new ColorTransform();
			layerMain = new ColorTilemap();
			K4G.gameMap = layerMain;
			logic = K4G.logic;
			layerMain.immovable = true;
			setupFades();
			correctFade();
			K4G.calendar.addEventListener(TimeKeeper.ONHOUR, startFade);
			K4G.calendar.addEventListener(TimeKeeper.MIDNIGHT, newDay);
		}
		
		// __________________________________________ EVENT HANDLERS
		public function update():void {
			if (_doFade) {
				if (_fadeTime < _fadeMax) {
					_fadeTime += FlxG.elapsed;
					colTrans = tweenColor(_oldTrans, _newTrans, _fadeTime/_fadeMax);
				}else {
					colTrans = _newTrans;
					_fadeTime = 0;
					_doFade = false;
				}
			}
		}
		
		// __________________________________________ METHODS
		
		public function blank():void {
			Wizard;
			Hero;
		}
		
		public function loadSprites(Data:String):void {
			var lines:Array = Data.split("\n");
			var entry:Array;
			var rta:Array = new Array(); //rta= ready to add;
			for each(var a:String in lines) {
				if (a.length>1) {
					entry = a.split(" ");
					if (entry[1] == "units.Hero") {
						logic.curSel = new Hero(Number(entry[2]), Number(entry[3]));
						break;
					}
				}
			}
			
			var df:Class;
			for each(a in lines) {
				if (a.length>1) {
					entry = a.split(" ");
					if (entry[1] == "units.Hero")
						continue;
					
					df= getDefinitionByName("org.lemonparty."+entry[1]) as Class;
					findGroup(entry[0]).add(new df(Number(entry[2]), Number(entry[3])));
					
				}
			}
		}
		
		public function findGroup(Name:String):FlxGroup {
			switch(Name) {
				case "enemies":
					return logic.enemies;
				case "items":
					return logic.items;
				case "player":
					return logic.player;
				case "miscObjects":
					return logic.miscObjects;
				//case "searchables":
					//return logic.searchables;
				default:
					return null;
			}
		}
		
		public function correctFade():void {
			while (fadeTimes[fadeTimes.length - 1] < TimeKeeper.time) {
				fadeTimes.pop();
				fades.pop();
			}
			startFade(new Event(""));
		}
		
		public function setupFades():void {
			fadeTimes=[1380,1200,1140,1080,1020,960,720,420,360,300,180,0];
			fades.push(new ColorTransform(.5, .5, .8, 1, 0, 0, 0, 0));			//11pm
			fades.push(new ColorTransform(.3, .3, .5, 1, 0, 0, 0, 0));		//8pm
			fades.push(new ColorTransform(.7, .5, .8, 1, 0, 0, 0, 0));		//7pm
			fades.push(new ColorTransform(1.3, 1, 1.2, 1, 0, 0, 0, 0));		//6pm
			fades.push(new ColorTransform(.9, .5, .8, 1, 0, 0, 0, 0));		//5pm
			fades.push(new ColorTransform(1.2, .6, 1, 1, 0, 0, 0, 0));			//4pm
			fades.push(new ColorTransform(1.2, 1.2, 1.2, 1, 0, 0, 0, 0));	//12pm
			fades.push(new ColorTransform());								//7am
			fades.push(new ColorTransform(1.5, 1.2, .8, 1, 0, 0, 0, 0));		//6am
			fades.push(new ColorTransform(.3, .2, .4, 1, 0, 0, 0, 0));		//5am
			fades.push(new ColorTransform(.5, .5, .8, 1, 0, 0, 0, 0));	//3am
			fades.push(new ColorTransform(.5, .5, .8, 1, 0, 0, 0, 0));	//1am
		}
		
		public function startFade(ev:Event):void {
			if(TimeKeeper.time>=fadeTimes[fadeTimes.length-1]){
				_oldTrans = colTrans;
				_newTrans = fades[fadeTimes.length - 1];
				_doFade = true;
				fadeTimes.pop();
			}
		}
		
		public function newDay(ev:Event):void {
			setupFades();
		}
		
		public function tweenColor(start:ColorTransform, end:ColorTransform, t:Number):ColorTransform {
			return new ColorTransform(start.redMultiplier + (end.redMultiplier - start.redMultiplier) * t, start.greenMultiplier + (end.greenMultiplier - start.greenMultiplier) * t, start.blueMultiplier + (end.blueMultiplier - start.blueMultiplier) * t);
		}
		
	}

}