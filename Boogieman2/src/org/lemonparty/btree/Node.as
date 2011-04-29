package org.lemonparty.btree 
{

	import org.lemonparty.Unit;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class Node {
		public static const FAILURE:int = 0; 
		public static const SUCCESS:int = 1;
		public static const MORE_TIME:int = 2;
		
		protected var _failIfChildFailed:Boolean;
		protected var _successIfChildSucceed:Boolean;
		protected var _resultIfNoMoreChilden:int = FAILURE;
		
		protected var _currentChild:Node=null;
		protected var _childIndex:int=-1;	// -1 for never run before
		protected var _children:Vector.<Node>;
		
		public var parent:Unit=null;
	
		//public var condition:Function;	// used to store a custom function
		
		public function Node(Parent:Unit=null) {
			if(Parent!==null)
				parent = Parent;
			//_children = new Vector.<Node>();
		}
		
		public function run():uint {
			var result:uint;
			
			if (_currentChild == null) {
				if (_children[0]) {
					_currentChild = _children[0];
					_childIndex = 0;
				}else {
					return _resultIfNoMoreChilden;
				}
			}
			
			result = _currentChild.run();
			
			if (result === SUCCESS) {
				if (_successIfChildSucceed) {
					_currentChild = null;
					return SUCCESS;
				}else {
					return nextChild();
				}
			}else if (result === FAILURE) {
				if (_failIfChildFailed) {
					_currentChild = null;
					return FAILURE;
				}else {
					return nextChild();
				}
			}else {
				return MORE_TIME;
			}
		}
		
		public function addChild(Child:Node):void {
			if (_children == null) {
				_children = new Vector.<Node>();
			}
			_children.push(Child);
			if (parent&&!Child.parent) {
				Child.parent = parent;
				//_children[_children.length - 1].parent = parent;
			}
		}
		
		
		public function nextChild():int {
			if (_childIndex < 0) {
				_currentChild = _children[0];
				_childIndex = 0;
				return MORE_TIME;
			}else if (_childIndex+1>=_children.length) {
				_currentChild = null;
				return _resultIfNoMoreChilden;
			}else {
				_currentChild = _children[++_childIndex];
				return MORE_TIME;
			}
		}
		
		public function terminate():void {
			if (_currentChild) {
				_currentChild.terminate();
				_currentChild = null;
			}
		}
		
		public function get children():Vector.<Node> {
			return _children;
		}
		
		public function get firstChild():Node {
			return _children[0];
		}
		
		public function get secondChild():Node {
			return _children[1];
		}
	}

}