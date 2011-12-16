package org.lemonparty 
{
	import flash.geom.Point;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class Unit extends GameObject implements IEventDispatcher{
		protected var _maxRunSpeed:Number;
		public var attTar:BasicObject;
		public var moveTarget:Point;
		public var susOb:BasicObject;
		public var cortex:FlxObject;
		public var sightRange:Number = 600;
		public var hostileGroup:FlxGroup;
		protected var evd:EventDispatcher = new EventDispatcher(this as IEventDispatcher);
		public var ptf:FlxPath;
		public var climbingLadder:Boolean = false;
		public var fallingCloud:Boolean = false;
		public var fallPlatform:int = 0;
		
		public var Timers:Array=new Array();
		
		public var carrying:GameObject;
		public static const HEALTH_CHANGED:String = "healthChanged";
		public static const GRABBED_ITEM:String = "grabItem";
		public static const GOT_ITEM:String = "gotItem";
		public static const DROPPED_ITEM:String = "dropItem";
		
		public var faction:uint = 0;
		
		public var hasMeleeAttack:Boolean;
		public var meleeRange:Number;
		public var onPathFinish:Function;
		public var inCombat:Boolean;
		
		public function Unit(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null){
			super(X, Y, SimpleGraphic);
			acceleration.y = K4G.gravity;
			_maxRunSpeed = 120;
			immovable = false;
			drag.x = _maxRunSpeed * 10;
			drag.y = 500;
		}
		
		override public function update():void {
			super.update();
		}
		
		override protected function updatePathMotion():void {
			//trace(_pathNodeIndex);
			
			super.updatePathMotion();
			/*var node:FlxPoint = path.nodes[_pathNodeIndex];
			var deltaX:Number = node.x - _point.x;
			var deltaY:Number = node.y - _point.y;
			trace("DeltaX: " +deltaX + " Delta Y: " +deltaY);
		
			if (abs(deltaX) < 5) {
				_pathMode = PATH_VERTICAL_ONLY;
			}else {
				_pathMode = PATH_HORIZONTAL_ONLY;
			}*/
			if (onPathFinish && path && pathSpeed == 0) {
				onPathFinish();
			}
			
			if(pathSpeed>1&&path.nodes[_pathNodeIndex].y<(y+height-32)){
				if(nearLadder()&&!climbingLadder){
					_pathMode = PATH_VERTICAL_ONLY;
					startClimb();
				}else if (isTouching(DOWN)) {
					velocity.y -= 360;
				}
			}else if (pathSpeed > 1 && climbingLadder) {
				_pathMode = PATH_HORIZONTAL_ONLY;
				stopClimb();
			}
			
		}
		
		//___________________________________________ METHODS
		
		public function nearLadder():Boolean {
			var ladderTile:int = _map.getTile(int(x / 16 ), int(y / 16));
			if (ladderTile != 18) {
				ladderTile = _map.getTile(int(x / 16), int((y+height) / 16));
			}
			if(ladderTile == 18)
				return true;
			else
				return false;
		}
		
		public function checkClimb():void {
			var ladderTile:int = _map.getTile(int(x / 16 ), int(y / 16));
			if (ladderTile != 18) {
				ladderTile = _map.getTile(int(x / 16), int((y+height) / 16));
			}
			
			if (ladderTile == 18) {
				if(!climbingLadder)
				startClimb();
			}else if(climbingLadder){
				stopClimb();
			}
		}
		
		public function startClimb():void {
			climbingLadder = true;
			trace("startClimb");
			x = (int(x/16)*16)+1;
			acceleration.y = 0;
			velocity.y = 0;
			velocity.x = 0;
		}
		
		public function stopClimb():void {
			climbingLadder = false;
			trace("stopping climb");
			acceleration.y = K4G.gravity;
		}
		
		public function cleanPath(Nodes:Array):Array {
			if (Nodes.length < 3) {
				return Nodes;
			}
			var cur:FlxPoint;
			
			var next:FlxPoint;
			var clean:Array = new Array();
			clean[0] = Nodes[0];
			var last:FlxPoint = clean[0];
			
			var i:int = 1;
			var l:int = Nodes.length -1;
			
			var ld:Number;
			var nd:Number;
		
			while (i < l) {
				cur = Nodes[i];
				next = Nodes[i + 1];
				
				ld = (last.x-cur.x) / (last.y-cur.y);
				nd = (cur.x - next.x) / (cur.y - last.y);
				if (ld != nd) {
					clean.push(cur);
					last = cur;
				}
				++i;
			}
			clean.push(Nodes[Nodes.length-1]);
			return clean;
		}
		
		public function enterCombat(Target:Unit):void {
			
		}
		
		public function lostSightOfTarget():void{
		
		}
		
		public function standDown():void {
			
		}
		
		public function dumbPathing():void {
			
		}
		
		public function yipe():void {
			trace("Yipe!");
		}
		
		public function moveOrder(Dest:FlxPoint, OnFinish:Function=null):void {
			var path:FlxPath = new FlxPath(_logic._pf.findPath(new FlxPoint(int(x/16),int((y+height-8)/16)),new FlxPoint(int(Dest.x/16),int(Dest.y/16))));
			if (path) {
				path.nodes=cleanPath(path.nodes);
				//_map.simplePath(path.nodes);
				ptf = path;
				for (var i:int = 0; i < path.nodes.length;++i) {
					path.nodes[i].y -= 14.5;
				}
				followPath(path, _maxRunSpeed, PATH_HORIZONTAL_ONLY);
				onPathFinish=OnFinish;
			}
		}
		
		public function grabItem(Ob1:FlxObject, Ob2:FlxObject):GameObject{
			var ti:GameObject=Ob2 as GameObject
			//carrying = ;
			if (ti.canPickup&&!carrying) {
				carrying = ti;
				carrying.solid = false;
				carrying.acceleration.y = 0;
				carrying.owner = this;
				carrying.onPickup();
				//addToInv(ti,true);
				dispatchEvent(new Event(GRABBED_ITEM));
			}else if (!ti.canPickup && ti.canUse) {
				ti.onUse();
			}
			
			return ti;
		}
		
		public function dropItem(Thrown:Boolean=false):GameObject {
			carrying.onDrop();
			carrying.solid = true;
			carrying.acceleration.y = K4G.gravity;
			
			if (Thrown) {
				carrying.velocity.x = velocity.x+(facing?150:-150);
			}else {
				carrying.velocity.y += velocity.y;
				carrying.velocity.x += velocity.x;
			}
			dispatchEvent(new Event(DROPPED_ITEM));
			var tc:GameObject = carrying;
			carrying.owner = null;
			carrying = null;
			return tc;
		}
		
		public function combatSight(a:BasicObject):BasicObject {
			//check against attTar;
			var rayPnt:FlxPoint = new FlxPoint();
			if(_map.ray(new FlxPoint(x+origin.x, y),new FlxPoint(a.x+a.origin.x, a.y+a.origin.y),rayPnt)){
				return a;
			}
			return null;
		}
		
		public function lineOfSight(Group:FlxGroup):BasicObject {
			var rayPnt:FlxPoint = new FlxPoint();
			var rp2:FlxPoint = new FlxPoint();
			for each(var a:BasicObject in Group.members) {
				if (a && a.alive) {
					if ((facing == LEFT && a.x > x) || (facing == RIGHT && a.x < x))
						continue;
					if (abs(a.getDist(this)) < sightRange) {
						if(_map.ray(new FlxPoint(x+origin.x, y),new FlxPoint(a.x+a.origin.x, a.y+a.origin.y),rayPnt)){
							
							// put a check here to look at miscItems and make sure they don't block 
							/*for each(var b:GameObject in _logic.miscObjects.members) {
								if (b.solid||b.blocksSight) {
									rayPnt.x = x + origin.x;
									rayPnt.y = y+3;
									rp2.x = a.x + a.origin.x;
									rp2.y = a.y + a.origin.y;
									if (K4G.rayAABB(rayPnt, rp2, b)) {
										return null;
									}
								}
							}*/
							return a;
						}
					}
				}
			}
			return null;
		}
		
		override public function hurt(Damage:Number):void {
			super.hurt(Damage);
			flicker(.6);
		}
		
		// __________________________________________ GETTER/SETTERS
		public function get inv():Inventory {
			return null;
		}
		//___________________________________________ EVENT INTERFACE
		
		public function unselect():void { }
		public function select():void { }
		
		
		public function addEventListener(Type:String, Listener:Function, UseCapture:Boolean = false, Priority:int = 0, UseWeak:Boolean=false):void{
			evd.addEventListener(Type, Listener, UseCapture, Priority);
		}
           
		public function dispatchEvent(Evt:Event):Boolean{
			return evd.dispatchEvent(Evt);
		}
    
		public function hasEventListener(Type:String):Boolean{
			return evd.hasEventListener(Type);
		}
    
		public function removeEventListener(Type:String, Listener:Function, UseCapture:Boolean = false):void{
			evd.removeEventListener(Type, Listener, UseCapture);
		}
                   
		public function willTrigger(Type:String):Boolean {
			return evd.willTrigger(Type);
		}	
		
	}

}