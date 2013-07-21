package org.hailong.vFlex
{

	public interface IServiceContainer
	{
		
		function get instance():IService;
	
		function get config():Object;
		
		function set config(config:Object):void;
		
		function get context():IServiceContext;
		
		function set context(context:IServiceContext):void;
		
		function get inherit():Boolean;
		
		function set inherit(inherit:Boolean):void;
		
		function hasTaskType(taskType:Class):Boolean;
		
		function addTaskType(taskType:Class):void;
		
		function didReceiveMemoryWarning():void;
		
		function destory():void;
	}
}