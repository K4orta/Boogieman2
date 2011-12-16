package org.lemonparty {
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import flash.events.Event;
	import org.lemonparty.units.Hero;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.FlxText;
	import flash.geom.Point;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class K4GUI extends FlxGroup {
		[Embed(source = "data/invBoxes.png")] private var ImgBoxes:Class;
		[Embed(source = "data/blockSelect.png")] private var ImgBlockSelect:Class;
		public var invBoxWidth:int = 26;
		public var hpBMD:BitmapData = new BitmapData(53, 5, false, 0xFF000000);
		public var invBMD:BitmapData = new BitmapData(208, 24, true, 0x00000000);
		public var ammoBMD:BitmapData = new BitmapData(60, 5, true, 0x00000000);
		public var boxGfx:BitmapData;
		public var hpBar:FlxSprite;
		public var ammoBar:FlxSprite;
		public var magSelect:FlxSprite;
		public var invBar:FlxSprite;
		
		
		protected var _invOff:Rectangle = new Rectangle(0, 0, 24,24 ) ;
		protected var _invOn:Rectangle = new Rectangle(24, 0, 24, 24) ;
		protected var _inv:Inventory;
		protected var _itemNumbers:Vector.<FlxText> 
		
		public function K4GUI(){
			super();
			invBar = new FlxSprite(460, 440);
			//x = 152;
			//y = 220;
			//add(hpBar);
			//add(ammoBar);
			boxGfx = (new ImgBoxes).bitmapData;
			invBar.scrollFactor.x = invBar.scrollFactor.y = 0;
			add(invBar)
			
		}
		
		// Inventory
		
		/*public function updateHp(ev:Event):void {
			staBMD.fillRect(staBMD.rect, 0xFF000000);
			staBMD.fillRect(new Rectangle(1, 1, int(51*ev.currentTarget.restStamina / ev.currentTarget.maxStamina), 3), 0xFF273b6e);
			staBMD.fillRect(new Rectangle(1, 1, int(51*ev.currentTarget.stamina / ev.currentTarget.maxStamina), 3), 0xFF5C8CFF);
			staminaBar.pixels = staBMD;
		}*/
		
		public function setupInv(He:Hero):void {
			_inv = He.inv;
			_itemNumbers = new Vector.<FlxText>();
			for (var i:int = 0;i<_inv.invSize;++i) {
				_itemNumbers[i] = new FlxText((i * invBoxWidth)+119, 6, 32, "0");
				add(_itemNumbers[i]);
				_itemNumbers[i].scrollFactor.x = _itemNumbers[i].scrollFactor.y = 0;
				_itemNumbers[i].visible = false;
			}
			redrawInv();
		}
		
		public function redrawInvNumbers():void {
			for (var i:int = 0; i < _inv.invSize;++i ) {
				if (_inv.slot[i]) {
					if (_inv.slot[i].numItems>1) {
						_itemNumbers[i].visible = true;
						_itemNumbers[i].text = String(_inv.slot[i].numItems);
					}else {
						_itemNumbers[i].visible = false;
					}
				}else {
					_itemNumbers[i].visible = false;
				}
			}
		}
		
		public function redrawInv():void {
			invBMD.fillRect(invBMD.rect, 0x00000000);
			var tg:BitmapData;
			for (var i:int = 0;i<_inv.invSize;++i ) {
				if (_inv.curSel == i){
					invBMD.copyPixels(boxGfx, _invOn, new Point(i * invBoxWidth, 0));
				}else{
					invBMD.copyPixels(boxGfx, _invOff, new Point(i * invBoxWidth, 0));
				}
				if (_inv.slot[i]) {
					tg = (new _inv.slot[i].cameo).bitmapData;
					invBMD.copyPixels(tg, _invOff, new Point(i * invBoxWidth, 0), null, null, true);
					if (_inv.slot[i].numItems>1) {
						_itemNumbers[i].visible = true;
						_itemNumbers[i].text = String(_inv.slot[i].numItems);
					}else {
						_itemNumbers[i].visible = false;
					}
				}
				
			}
			invBar.pixels = invBMD;
		}
		
	}

}