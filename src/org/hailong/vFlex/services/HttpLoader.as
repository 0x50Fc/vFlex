package org.hailong.vFlex.services
{
	import flash.net.URLLoader;
	import org.hailong.vFlex.tasks.IHttpTask;

	internal class HttpLoader extends URLLoader
	{
		private var _task:IHttpTask;
		private var _taskType:Class;
		private var _priority:int;
		
		public function HttpLoader()
		{
		}
		
		public function get task():IHttpTask{
			return _task;
		}
		
		public function set task(task:IHttpTask):void{
			_task = task;
		}
		
		public function get taskType():Class{
			return _taskType;
		}
		
		public function set taskType(taskType:Class):void{
			_taskType = taskType;
		}
		
		public function get priority():int{
			return _priority;
		}
		
		public function set priority(priority:int):void{
			_priority = priority;
		}
		
	}
}