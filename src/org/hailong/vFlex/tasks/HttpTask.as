package org.hailong.vFlex.tasks
{

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.hailong.vFlex.ITask;
	import org.hailong.vFlex.Task;
	
	[Event(name="onLoaded", type="flash.events.Event")]
	[Event(name="onError", type="flash.events.ErrorEvent")]
	[Event(name="onResponse", type="flash.events.Event")]
	public class HttpTask extends Task implements IHttpTask
	{
		public static const EVENT_ONLOADED:String = "onLoaded";
		public static const EVENT_ONERROR:String = "onError";
		public static const EVENT_ONRESPONSE:String = "onResponse";
		
		private var _request:URLRequest;
		private var _responseBody:Object;
		private var _responseType:uint;
		private var _responseStatusCode:int;
		private var _responseStatus:String;
		private var _responseHeaders:Object;
		private var _task:ITask;
		private var _taskType:Class;
		
		public function HttpTask()
		{
			super();
	
		}
		
		public function get request():URLRequest{
			return _request;
		}
		
		public function set request(request:URLRequest):void{
			_request = request;
		}
		
		public function get responseBody():Object{
			return _responseBody;
		}
		
		public function set responseBody(body:Object):void{
			_responseBody = body;
		}
		
		public function get responseType():uint{
			return _responseType;
		}
		
		public function set responseType(type:uint):void{
			_responseType = type;
		}
		
		public function get responseStatusCode():int{
			return _responseStatusCode;	
		}
		
		public function set responseStatusCode(code:int):void{
			_responseStatusCode = code;
		}
		
		public function get responseStatus():String{
			return _responseStatus;
		}
		public function set responseStatus(status:String):void{
			_responseStatus = status;
		}
		
		public function get responseHeaders():Object{
			return _responseHeaders;
		}
		public function set responseHeaders(headers:Object):void{
			_responseHeaders = headers;
		}
		
		public function get task():ITask{
			return _task;
		}
		
		public function set task(task:ITask):void{
			_task = task;
		}
		
		public function get taskType():Class{
			return _taskType;
		}
		
		public function set taskType(taskType:Class):void{
			_taskType = taskType;	
		}
		
		public function didLoaded():void{
			dispatchEvent(new Event(EVENT_ONLOADED));
		}
		
		public function didError(error:Error):void{
			dispatchEvent(new ErrorEvent(EVENT_ONERROR,false,false,error.message,error.errorID));
		}
		
		public function didResponse():void{
			dispatchEvent(new Event(EVENT_ONRESPONSE));
		}
		
	}
}