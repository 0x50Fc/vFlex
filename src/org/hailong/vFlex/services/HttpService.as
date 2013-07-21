package org.hailong.vFlex.services
{
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequestHeader;
	
	import org.hailong.vFlex.ITask;
	import org.hailong.vFlex.Service;
	import org.hailong.vFlex.tasks.IHttpTask;
	
	public class HttpService extends Service
	{
		private var _loadingLoaders:Array;
		private var _loaders:Array;
		
		public function HttpService()
		{
			super();
			_loadingLoaders = new Array();
			_loaders = new Array();
		}
		
		protected function setNeedRequest():void{
			
			var maxCount:int = this.config["maxThreadCount"] as int;
			
			if(maxCount <=0){
				maxCount = 1;
			}
			
			while(_loadingLoaders.length < maxCount){
				
				var loader:HttpLoader = _loaders.shift();
				
				if(loader){
					_loadingLoaders.push(loader);
					loader.load(loader.task.request);
				}
				else{
					break;
				}
				
			}
			
		}
		
		protected function removeLoading(loader:HttpLoader):void{
			var index:int = 0;
			var length:int = _loadingLoaders.length;
			
			while(index < length){
				if(_loadingLoaders[index] == loader){
					break;
				}
				index ++;
			}
			
			if(index < length){
				length --;
			}
			
			while(index < length){
				_loadingLoaders[index] = _loadingLoaders[index + 1];
				index ++;
			}
			
			_loadingLoaders.length = length;
		}
		
		protected function onComplete(event:Event):void{
			var loader:HttpLoader = event.target as HttpLoader;
			
			removeLoading(loader);
			
			loader.task.didLoaded();
			
			setNeedRequest();
		}
		
		protected function onIOError(event:IOErrorEvent):void{
			
			var loader:HttpLoader = event.target as HttpLoader;
			
			removeLoading(loader);
			
			loader.task.didError(new Error(event.text,event.errorID));
			
			setNeedRequest();
			
		}
		
		protected function onSecurityError(event:SecurityErrorEvent):void{
			
			var loader:HttpLoader = event.target as HttpLoader;
			
			removeLoading(loader);
			
			loader.task.didError(new Error(event.text,event.errorID));
			
			setNeedRequest();
			
		}
		
		protected function onResponse(event:HTTPStatusEvent):void{
			
			var loader:HttpLoader = event.target as HttpLoader;
			var httpTask:IHttpTask = loader.task;
			var headers:Object = {};
			
			for each(var header:URLRequestHeader in event.responseHeaders){
				headers[header.name] = header.value;
			}
			
			httpTask.responseHeaders = headers;
			httpTask.responseStatusCode = event.status;
			httpTask.didResponse();
			
		}
		
		override public function handle(taskType:Class, task:ITask, priority:int):Boolean
		{
			
			if(task is IHttpTask){
				
				var loader:HttpLoader = new HttpLoader();
				
				loader.task = task as IHttpTask;
				loader.taskType = taskType;
				loader.priority = priority;
				loader.addEventListener(Event.COMPLETE,onComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
				loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,onResponse);
				
				var index:int = 0;
				var http:HttpLoader;
				
				while(index < _loaders.length){
					
					http = _loaders[index];
					
					if(http.priority < priority){
						break;
					}
					
					index ++;
				}
				
				var i:int = length;
				
				if(i > index){
					
					_loaders[i] = _loaders[i -1];
					
					i --;
				}
				
				_loaders[index] = loader;
				
				setNeedRequest();
				
				return true;
			}
			return false;
		}
		
		override public function cancelHandle(taskType:Class, task:ITask):Boolean
		{
			
			var loaders:Array = new Array();
			var loader:HttpLoader;
			
			for each( loader in _loadingLoaders){
				if(loader.taskType == taskType && loader.task == task){
					loader.removeEventListener(Event.COMPLETE,onComplete);
					loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,onResponse);
					loader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
					loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
					loader.close();
				}
				else{
					loaders.push(loader);
				}
			}
			
			_loadingLoaders = loaders;
			
			loaders = new Array();
			
			for each(loader in _loaders){
				if(loader.taskType == taskType && loader.task == task){
					loader.removeEventListener(Event.COMPLETE,onComplete);
					loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,onResponse);
					loader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
					loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
				}
				else{
					loaders.push(loader);
				}
			}
			
			_loaders = loaders;
			
			return true;
		}
		
		override public function cancelHandleForSource(source:Object):Boolean
		{
			var loaders:Array = new Array();
			var loader:HttpLoader;
			
			for each( loader in _loadingLoaders){
				if(loader.task.source == source){
					loader.removeEventListener(Event.COMPLETE,onComplete);
					loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,onResponse);
					loader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
					loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
					loader.close();
				}
				else{
					loaders.push(loader);
				}
			}
			
			_loadingLoaders = loaders;
			
			loaders = new Array();
			
			for each(loader in _loaders){
				if(loader.task.source == source){
					loader.removeEventListener(Event.COMPLETE,onComplete);
					loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,onResponse);
					loader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
					loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
				}
				else{
					loaders.push(loader);
				}
			}
			
			_loaders = loaders;
			
			return false;
		}
		
	}
}