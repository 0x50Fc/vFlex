package org.hailong.vFlex
{
	
	public class Service implements IService
	{
		private var _config:Object;
		private var _context:IServiceContext;
		
		public function Service()
		{
		}
		
		public function get config():Object
		{
			return _config;
		}
		
		public function set config(config:Object):void
		{
			_config = config;
		}
		
		public function get context():IServiceContext
		{
			return null;
		}
		
		public function set context(context:IServiceContext):void
		{
			_context = context;
		}
		
		public function handle(taskType:Class, task:ITask, priority:int):Boolean
		{
			return false;
		}
		
		public function cancelHandle(taskType:Class, task:ITask):Boolean
		{
			return false;
		}
		
		public function cancelHandleForSource(source:Object):Boolean
		{
			return false;
		}
		
		public function didReceiveMemoryWarning():void
		{
		}
		
		public function destory():void
		{
			_context = null;
			_config = null;
		}
	}
}