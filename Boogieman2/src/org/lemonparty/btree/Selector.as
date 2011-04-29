package org.lemonparty.btree{
	import org.lemonparty.Unit;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class Selector extends Node 
	{
		public function Selector(Parent:Unit=null){
			super(Parent);
			_successIfChildSucceed = true;
			_failIfChildFailed = false;
			_resultIfNoMoreChilden = FAILURE;
		}
		
	}

}