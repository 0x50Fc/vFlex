package org.hailong.vFlex.ui
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.SkinnableContainer;
	
	import org.hailong.vFlex.DataObject;
	import org.hailong.vFlex.URL;

	public class UITabBarController extends UIViewController
	{
		private var _viewControllers:Array;
		private var _selectedIndex:int;
		
		public function UITabBarController()
		{
			super();
			
			addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE,function(event:FlexEvent):void{
				
				if(contentView){	
					onResize(event);
					contentView.addEventListener(ResizeEvent.RESIZE,onResize);
				}
				
				_reloadURL();
			});
		}
		
		protected function onResize(event:Event):void{
			
			var contentView:SkinnableContainer = this.contentView;
			
			if(contentView == null){
				return;
			}
			
			var width:int = contentView.width;
			var height:int = contentView.height;
			
			var controller:IUIViewController = selectedViewController;
			
			if(controller){
				var view:SkinnableContainer = controller.view;
				view.width = width;
				view.height = height;
			}
		}
		
		public function get viewControllers():Array{
			return _viewControllers;
		}
		
		public function set viewControllers(viewControllers:Array):void{
			
			var contentView:SkinnableContainer = this.contentView;
			var controller:IUIViewController;
			var width:int = contentView.width;
			var height:int = contentView.height;
			
			for each(controller in _viewControllers){
				controller.parentController = null;
				if(controller.view.parent == contentView){
					contentView.removeElement(controller.view);
				}
			}
			
			_viewControllers = viewControllers;
			
			var index:int = 0;
			
			for each(controller in _viewControllers){
				controller.parentController = this;
				if(index == _selectedIndex){
					
					var view:SkinnableContainer = controller.view;
					
					view.width = width;
					view.height = height;
					view.x = 0;
					view.y = 0;
					
					contentView.addElement(view);
				}
				index ++;
			}
			
		}
		
		public function get contentView():SkinnableContainer{
			return this;
		}
		
		public function get selectedIndex():int{
			return _selectedIndex;
		}
		
		public function get selectedViewController():IUIViewController{
			
			if(_viewControllers && _selectedIndex < _viewControllers.length){
				return _viewControllers[_selectedIndex];
			}
			
			return null;
		}
		
		public function set selectedIndex(selectedIndex:int):void{
			
			if(_selectedIndex != selectedIndex){
				var contentView:SkinnableContainer = this.contentView;
				var controller:IUIViewController = selectedViewController;
				var width:int = contentView.width;
				var height:int = contentView.height;
				
				if(controller && controller.view.parent){
					contentView.removeElement(controller.view);
				}
				
				_selectedIndex = selectedIndex;
				
				controller = selectedViewController;
				
				var view:SkinnableContainer = controller.view;
				
				view.width = width;
				view.height = height;
				view.x = 0;
				view.y = 0;
				
				contentView.addElement(view);
			}
		}
		
		override public function doAction(event:Event):void{
			
			var target:Object = event.target;
			
			if(target is IUIAction){
				var name:String = (target as IUIAction).actionName;
				var userInfo:Object = (target as IUIAction).userInfo;
				
				if(name == "tab"){
					if(userInfo is String){
						selectedIndex = parseInt(userInfo as String);
					}
					else{
						selectedIndex = userInfo as int;
					}
				}
				else{
					super.doAction(event);
				}
			}
			else{
				super.doAction(event);
			}
			
		}
		
		
		override public function canOpenUrl(url:URL):Boolean{
			
			var scheme:String = DataObject.dataObjectForKey(config,"scheme") as String;
			
			if(!scheme){
				scheme = "tab";
			}
			
			if(url.scheme == scheme){
				
				return true;
			}
			
			if(parentController){
				return parentController.canOpenUrl(url);
			}
			
			return false;
		}
		
		protected function _reloadURL():void{
			
			var items:Array = DataObject.dataObjectForKey(config,"items") as Array;
			
			var viewControllers:Array = [];
			
			if(items){
				for each(var item:Object in items){
					var url:String = DataObject.dataObjectForKey(item,"url") as String;
					if(url){
						var viewController:IUIViewController = context.getController(new URL(url),"/");
						if(viewController){
							viewControllers.push(viewController);
						}
					}
				}
			}
			this.viewControllers = viewControllers;
			
		}
		
		override public function reloadURL():void{
			
		}
		
		override public function openUrl(url:URL):Boolean{
			
			var scheme:String = DataObject.dataObjectForKey(config,"scheme") as String;
			
			if(!scheme){
				scheme = "tab";
			}
			
			if(url.scheme == scheme){
				
				context.logger.debug(url.absoluteString);
				
				var alias:String = this.url.firstPathComponent("/");
				
				if(alias && _viewControllers){
					var index:int = 0;
					for each(var viewController :IUIViewController in _viewControllers){
						if(viewController.alias == alias){
							break;
						}
						index ++;
					}
					selectedIndex = index;
				}
				
				return true;
			}
			
			if(parentController){
				return parentController.openUrl(url);
			}
			
			return false;
		}
	}
}