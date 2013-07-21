package org.hailong.vFlex
{

	public interface IService
	{
		
		function get config():Object;
		
		function set config(config:Object):void;
		
		function get context():IServiceContext;
		
		function set context(context:IServiceContext):void;
		
		function handle(taskType:Class,task:ITask,priority:int):Boolean;
		
		function cancelHandle(taskType:Class,task:ITask):Boolean;
		
		function cancelHandleForSource(source:Object):Boolean;
		
		function didReceiveMemoryWarning():void;
		
		function destory():void;
		
	}
}