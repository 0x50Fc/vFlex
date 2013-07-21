package org.hailong.vFlex.ui
{
	import flash.utils.getDefinitionByName;
	
	import org.hailong.vFlex.DataObject;
	import org.hailong.vFlex.ServiceContext;
	import org.hailong.vFlex.URL;
	
	public class UIShell extends ServiceContext implements IUIContext
	{
		private var _config:Object;
		private var _rootViewController:IUIViewController;
		
		public function UIShell(config:Object)
		{
			super(config["services"]);
			_config = config;
		}
		
		public function getController(url:URL,basePath:String):IUIViewController{
			
			var alias:String = url.firstPathComponent(basePath);
			var cfg:Object = DataObject.dataObjectForKey(DataObject.dataObjectForKey(config,"ui") ,alias);

			if(cfg){
				
				var className:Object = cfg["class"];
				
				if(className){
					
					var clazz:Class;
					
					if(className is Class){
						clazz = className as Class;
					}
					else {
						clazz = getDefinitionByName(className as String) as Class;
					}
	
					if(clazz){
						var viewController:IUIViewController = new clazz();
						
						if(viewController is IUIViewController){
							viewController.context = this;
							viewController.alias = alias;
							viewController.basePath = basePath;
							viewController.url = url;
							viewController.config = cfg;
							viewController.reloadURL();
							return viewController;
						}
					}
				}
			}
				
			return null;
		}
		
		public function get rootViewController():IUIViewController{
			if(!_rootViewController){
				var url:String = _config["url"] as String;
				if(url){
					_rootViewController = getController(new URL(url),"/");
				}
			}
			return _rootViewController;
		}
		
		public function get config():Object{
			return _config;
		}
		 
	}
}