package org.hailong.vFlex
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class ServiceContext implements IServiceContext
	{
		private var _containers:Array;
		
		private var _logger:ILogger;
		
		public function get logger():ILogger{
			if(_logger == null){
				_logger = Log.getLogger("ServiceContext");
			}
			return _logger;
		}
		
		public function ServiceContext(config:Array)
		{
			_containers = new Array();
			
			if(config){
				
				var className:String;
				var clazz:Class;
				var container:ServiceContainer;
				var taskTypes:Array;
				
				for each(var item:Dictionary in config){
					className = item["class"] as String;
					if(className){
						clazz = flash.utils.getDefinitionByName(className) as Class;
						if(clazz){
							container = new ServiceContainer(clazz);
							container.context = this;
							
							if(item["inherit"]){
								container.inherit = true;
							}
							
							taskTypes= item["taskTypes"] as Array;
							
							if(taskTypes){
								for each(var taskType:String in taskTypes){
									clazz = flash.utils.getDefinitionByName(taskType) as Class;
									if(clazz){
										container.addTaskType(clazz);
									}
									else{
										this.logger.debug("Not Found taskType " + taskType);
									}
								}
							}
							
							container.config = item["config"];
						}
					}
					else{
						this.logger.debug("Not Found Service " + className);
					}
					
				}
				
			}
		}
		
		public function handle(taskType:Class, task:ITask, priority:int):Boolean
		{
			
			for each(var container:IServiceContainer in _containers){
				
				if(container.hasTaskType(taskType)){
					
					if(container.instance.handle(taskType,task,priority)){
						return true;
					}
					
				}
				
			}
			
			return false;
		}
		
		public function cancelHandle(taskType:Class, task:ITask):Boolean
		{
			for each(var container:IServiceContainer in _containers){
				
				if(container.hasTaskType(taskType)){
					
					if(container.instance.cancelHandle(taskType,task)){
						return true;
					}
					
				}
				
			}
			
			return false;
		}
		
		public function cancelHandleForSource(source:Object):Boolean
		{
			for each(var container:IServiceContainer in _containers){
				
				if(container.instance.cancelHandleForSource(source)){
					return true;
				}
	
			}
			
			return false;
		}
		
		public function destory():void
		{
			
			for each(var container:IServiceContainer in _containers){
				
				container.destory();
			}
			
			_containers = null;
			
		}
		
		public function didReceiveMemoryWarning():void{
			for each(var container:IServiceContainer in _containers){
				container.didReceiveMemoryWarning()
			}
		}
	}
}