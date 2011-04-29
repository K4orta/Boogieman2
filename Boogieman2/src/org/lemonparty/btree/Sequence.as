package org.lemonparty.btree{
	import org.lemonparty.Unit;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class Sequence extends Node 
	{
		public function Sequence(Parent:Unit=null){
			super(Parent);
			_successIfChildSucceed = false;
			_failIfChildFailed = true;
			_resultIfNoMoreChilden = SUCCESS;
		}
		
	}

}