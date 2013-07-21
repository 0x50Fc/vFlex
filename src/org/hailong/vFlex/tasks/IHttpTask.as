package org.hailong.vFlex.tasks
{
	import flash.utils.Dictionary;
	
	import org.hailong.vFlex.ITask;
	import flash.net.URLRequest;
	
	public interface IHttpTask extends ITask
	{
		
		function get request():URLRequest;
		function set request(request:URLRequest):void;
		
		function get responseBody():Object;
		function set responseBody(body:Object):void;
		
		function get responseType():uint;
		function set responseType(type:uint):void;
		
		function get responseStatusCode():int;
		function set responseStatusCode(code:int):void;
		
		function get responseStatus():String;
		function set responseStatus(status:String):void;
		
		function get responseHeaders():Object;
		function set responseHeaders(headers:Object):void;
		
		function get task():ITask;
		function set task(task:ITask):void;
		
		function get taskType():Class;
		function set taskType(taskType:Class):void;
		
		function didLoaded():void;
		function didError(error:Error):void;
		function didResponse():void;
		
	}
}