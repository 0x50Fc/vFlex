package org.hailong.vFlex
{
	import mx.logging.ILogger;

	public interface IServiceContext
	{
		
		function get logger():ILogger;
		
		function handle(taskType:Class,task:ITask,priority:int):Boolean;
		
		function cancelHandle(taskType:Class,task:ITask):Boolean;
		
		function cancelHandleForSource(source:Object):Boolean;
	
		function didReceiveMemoryWarning():void;
		
		function destory():void;
		
	}
}