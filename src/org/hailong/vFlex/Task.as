package org.hailong.vFlex
{
	import flash.events.EventDispatcher;
	
	public class Task extends EventDispatcher implements ITask
	{
		private var _source:Object;
		
		public function Task()
		{
			
		}
		
		public function get source():Object
		{
			return _source;
		}
		
		public function set source(value:Object):void
		{
			_source = value;
		}
	}
}