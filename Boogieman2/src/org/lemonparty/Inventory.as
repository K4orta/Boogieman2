package org.lemonparty 
{
	import org.lemonparty.units.Hero;
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class Inventory
	{
		protected var inv:Array = new Array();
		public var curSel:uint=0;
		public var invSize:int = 6;
		protected var _logic:PlayState;
		protected var _owner:Hero;
		public function Inventory(Owner:Hero) {
			_owner = Owner;
			_logic = K4G.logic;
		}
		
		public function getFreeSlot(NoCur:Boolean=false):int {
			for (var i:int = 0; i < invSize;++i ) {
				if (!inv[i]) {
					if (NoCur) {
						if (i != curSel ) {
							return i;
						}
					}else {
						return i;
					}
				}
			}
			return -1;
		}
		
		public function add(Item:GameObject):int{
			//search for a slot to combine with
			for (var i:int = 0; i < inv.length;++i ) {
				if (!inv[i]) continue;
				if (inv[i].subClass==Item.subClass) {
					if(inv[i].numItems + Item.numItems <= inv[i].maxStack){
						inv[i].numItems += Item.numItems;
						Item.kill();
						_logic.gui.redrawInvNumbers();
						return i;
					}else {
						//var holdi:int;// = Item.numItems;
						Item.numItems = inv[i].numItems + Item.numItems - inv[i].maxStack;
						inv[i].numItems = inv[i].maxStack;//Item.numItems;
						if (Item.numItems < 1) {
							Item.kill();
						}
						_logic.gui.redrawInvNumbers();
					}
				}
			}
			
			var sl:int = getFreeSlot();
			if (sl > -1) {
				inv[sl] = Item;
				if (sl == curSel) {
					
				}else{
					Item.onPack(_owner);
				}
				_logic.gui.redrawInv();
				return sl;
			}
			
			//search for an open slot
			//fail search
			return -1;
		}
		
		public function drop():GameObject {
			var ret:GameObject = inv[curSel];
			inv[curSel] = null;
			_logic.gui.redrawInv();
			_logic.gui.redrawInvNumbers()
			return ret;
		}
		
		public function pack():void {
			if(inv[curSel])
				inv[curSel].onPack(_owner);
		}
		
		public function unpack(Slot:uint):void {
			if(!_owner.carrying){
				if(inv[Slot])
					inv[Slot].onUnpack();
			}
		}
		
		public function nextSlot():uint {
			pack();
			if (++curSel >= invSize) {
				curSel = 0;
			}
			unpack(curSel);
			_logic.gui.redrawInv();
			return curSel;
		}
		
		public function prevSlot():uint {
			pack();
			if (--curSel < 0) {
				curSel = invSize-1;
			}
			unpack(curSel);
			_logic.gui.redrawInv();
			return curSel;
		}
		//recheck this code later, might not work now
		public function removeAllOf(Name:String):int {
			var cnt:int = 0;
			for (var i:int = 0; i < invSize;++i) {
				if (inv[i]&&inv[i].subClass == Name) {
					inv[i].kill();
					_logic.items.remove(inv[i], true);
					cnt+=inv[i].numItems;
					inv[i] = null;
				}
			}
			if (_owner.carrying && _owner.carrying.subClass == Name) {
				var gi:GameObject = _owner.dropItem(false);
				gi.kill();
				_logic.items.remove(gi, true);
				cnt+=gi.numItems;
			}
			_logic.gui.redrawInv();
			return cnt;
		}
		
		public function hold(Item:GameObject):void {
			inv[curSel] = Item;
		}
		
		public function hasItem(Name:String, CheckHands:Boolean=false):GameObject {
			if (CheckHands) {
				if (_owner.carrying && _owner.carrying.subClass == Name) {
					return _owner.carrying;
				}
			}
			for (var i:int = 0; i < invSize;++i) {
				if (inv[i]&&inv[i].subClass == Name) {
					return inv[i];
				}
			}
			return null;
		}
		
		public function inInv(Item:GameObject):Boolean {
			for (var i:int = 0; i < invSize;++i) {
				if (inv[i] == Item) {
					return true;
				}
			}
			return false;
		}
		
		public function removeItem(Item:GameObject):void {

			for (var i:int = 0; i < invSize;++i) {
				if (inv[i] == Item) {
					if (i == curSel) {
						pack();
					}
					inv[i].kill();
					_logic.items.remove(inv[i], true);
					inv[i] = null;
				}
			}
			_logic.gui.redrawInv();
		}
		
		public function get slot():Array {
			return inv;
		}
		
	}

}