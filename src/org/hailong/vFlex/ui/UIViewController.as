package org.hailong.vFlex.ui
{
	
	import flash.events.Event;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	import org.hailong.vFlex.URL;
	
	public class UIViewController extends SkinnableContainer implements IUIViewController{
		
		private var _context:IUIContext;
		private var _title:String;
		private var _config:Object;
		private var _url:URL;
		private var _basePath:String;
		private var _alias:String;
		private var _parentController:IUIViewController;
		
		public function UIViewController()
		{
			super();
		}
		
		public function get title():String{
			return _title;
		}
		
		public function set title(title:String):void{
			_title = title;
		}
		
		public function get config():Object{
			return _config;
		}
		
		public function set config(config:Object):void{
			_config = config;
		}
		
		public function get url():URL{
			return _url;
		}
		
		public function set url(url:URL):void{
			_url = url;
		}
		
		public function get basePath():String{
			return _basePath;
		}
		
		public function set basePath(basePath:String):void{
			_basePath = basePath;
		}
		
		public function action(action:IUIAction):void{
			var name:String = action.actionName;
			var userInfo:Object = action.userInfo;
			
			if(name == "url"){
				if(userInfo is String){
					openUrl(new URL(userInfo as String,this.url));
				}
			}
		}
		
		public function doAction(event:Event):void{
			
			var target:Object = event.target;
			
			if(target is IUIAction){
				action(target as IUIAction);
			}
			
		}
		
		public function canOpenUrl(url:URL):Boolean{
			
			if(parentController){
				return parentController.canOpenUrl(url);
			}
			
			return false;
		}
		
		public function openUrl(url:URL):Boolean{
			if(parentController){
				return parentController.openUrl(url);
			}
			return false;
		}
		
		public function get view():SkinnableContainer{
			return this;
		}
		
		public function get context():IUIContext{
			return _context;
		}
		
		public function set context(context:IUIContext):void{
			_context = context;	
		}
		
		public function get alias():String{
			return _alias;
		}
		
		public function set alias(alias:String):void{
			_alias = alias;
		}
		
		public function reloadURL():void{
			
		}
		
		public function get parentController():IUIViewController{
			return _parentController;
		}
		
		public function set parentController(controller:IUIViewController):void{
			_parentController = controller;
		}
		
	}
}