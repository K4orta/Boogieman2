package org.lemonparty 
{
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class GameObject extends BasicObject {
		
		public var 		canPickup:	Boolean 	= false;
		public var 		directInv:	Boolean 	= false;
		public var 		canPack:	Boolean		= false;
		public var 		owner:		Unit;
		public var 		numItems:	int			= 1; // used for inventory stuff
		public var		maxStack:	int 		= 1; // another inv variable
		public var 		cameo:		Class;

		public function GameObject(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null) {
			super(X, Y, SimpleGraphic);
			
		}
		
		public function onPickup():void {
			if (owner&&owner.carrying==this) {
				onEquip();
			}
		}
		
		public function onUse():void {
			owner.dropItem(true);
		}
		
		// Inventory Management Stuff
		public function onPack(He:Unit):void {	
			onUnequip();
			visible = false;
			solid = false;
			acceleration.y = 0;
			active = false;
			x = -100;
			y = -100;
			if (owner&&owner.carrying==this) {
				owner.carrying = null;
			}
			owner = He;
		}
		
		public function onUnpack():void {
			visible = true;
			solid = false;
			active = true;
			acceleration.y = 0;
			x = owner.x;
			y = owner.y;
			owner.carrying = this;
			onEquip();
		}
		
		public function onEquip():void {
			
		}
		
		public function onUnequip():void {
			
		}
		
		public function onDrop():void {
			onUnequip();
		}
		
		public function removeFromInv():void {
			
		}
		
		public function forceDrop():void {
			
		}
		
	}

}