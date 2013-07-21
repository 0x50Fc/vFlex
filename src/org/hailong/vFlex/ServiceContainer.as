package org.hailong.vFlex
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;
	
	internal class ServiceContainer implements IServiceContainer
	{
		private var _instanceClass:Class;
		private var _instance:IService;
		private var _context:IServiceContext;
		private var _config:Object;
		private var _inherit:Boolean;
		private var _taskTypes:Array;
		
		public function ServiceContainer(instanceClass:Class)
		{
			_instanceClass = instanceClass;
		}
		
		public function get instance():IService
		{
			if(_instance == null){
				_instance = new _instanceClass();
				_instance.context = _context;
				_instance.config = _config;
			}
			return _instance;
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
			return _context;
		}
		
		public function set context(context:IServiceContext):void
		{
			_context = context;
		}
		
		public function get inherit():Boolean
		{
			return _inherit;
		}
		
		public function set inherit(inherit:Boolean):void
		{
			_inherit = inherit;
		}
		
		public function hasTaskType(taskType:Class):Boolean
		{
			if(_taskTypes){
				
				for each (var type:Class in _taskTypes) 
				{
					if(_inherit){
						var c:Class = type;
						while(c){
							
							if(c == taskType){
								return true;
							}
							
							var superName:String =  flash.utils.getQualifiedSuperclassName(c);
							c = flash.utils.getDefinitionByName( superName ) as Class;
							if(c == Object){
								break;
							}
						}
						return false;
					}
					else{
						if(type == taskType){
							return true;
						}
					}
				}
				
			}
			return false;
		}
		
		public function addTaskType(taskType:Class):void
		{
			if(_taskTypes == null){
				_taskTypes = new Array();
			}
			_taskTypes.push(taskType);
		}
		
		public function didReceiveMemoryWarning():void
		{
			if(_instance){
				_instance.didReceiveMemoryWarning();
			}
		}
		
		public function destory():void
		{
			_context = null;
			if(_instance){
				_instance.context = null;
				_instance = null;
			}
			_taskTypes = null;
		}
	}
}