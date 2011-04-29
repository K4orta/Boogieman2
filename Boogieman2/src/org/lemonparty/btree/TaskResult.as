package org.lemonparty.btree 
{
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class TaskResult{
		public static var SUCCESS:TaskResult = new TaskResult();
		public static var FAILURE:TaskResult = new TaskResult();
		public static var MORE_TIME:TaskResult = new TaskResult();
		
		public function TaskResult(){
		}

	}

}