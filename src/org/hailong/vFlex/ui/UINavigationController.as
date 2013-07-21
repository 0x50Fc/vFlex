package org.hailong.vFlex.ui
{
	
	import flash.events.Event;
	
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.SkinnableContainer;
	import spark.effects.Move;
	
	import org.hailong.vFlex.DataObject;
	import org.hailong.vFlex.URL;

	public class UINavigationController extends UIViewController
	{
		private var _viewControllers:Array;
		private var _animateDuration:Number;
		
		public function UINavigationController()
		{
			super();
			
			_animateDuration = 600;
			
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
			
			var controller:IUIViewController = topViewController;
			
			var width:int = contentView.width;
			var height:int = contentView.height;
			
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
			var topController:IUIViewController = this.topViewController;
			var width:int = contentView.width;
			var height:int = contentView.height;
			
			var controller:IUIViewController;
			
			if(_viewControllers){
				for each(controller in _viewControllers){
					controller.parentController = null;
					if(controller.view.parent == contentView){
						contentView.removeElement(controller.view);
					}
				}
			}
			
			_viewControllers = viewControllers;
			
			if(_viewControllers){
				for each(controller in _viewControllers){
					controller.parentController = this;
				}
			}
			
			if(topController){
				contentView.removeElement(topController.view);
			}
			topController = this.topViewController;
			if(topController){
				var view:SkinnableContainer = topController.view;
				view.width = width;
				view.height = height;
				view.x = 0;
				view.y = 0;
				contentView.addElement(view);
			}
			
		}
		
		public function pushViewController(viewController:IUIViewController,animated:Boolean):void{
			
			var topController:IUIViewController = topViewController;
			var contentView:SkinnableContainer = this.contentView;
			var width:int = contentView.width;
			var height:int = contentView.height;
			
			if(!_viewControllers){
				_viewControllers = new Array();
			}
			
			_viewControllers.push(viewController);
			viewController.parentController = this;
			
			var controller:IUIViewController = topViewController;
			var view:SkinnableContainer = controller.view;
			
			if(animated){
			
				mouseEnabled = false;
				
				if(topController){
					
					var anim:Move = new Move(topController.view);
					
					anim.xFrom = 0;
					anim.xTo = - this.width;
					anim.duration = _animateDuration;
					
					anim.play();
					
				}
				
				view.height = height;
				view.width = width;
				view.x = this.width;
				view.y = 0;
				contentView.addElement(view);
				
				anim = new Move(view);
	
				anim.xFrom = this.width;
				anim.xBy = this.width / 100;
				anim.xTo = 0;
				anim.duration = _animateDuration;
				
				anim.addEventListener(EffectEvent.EFFECT_END,function(event:EffectEvent):void{
					
					if(topController){
						contentView.removeElement(topController.view);
						topController = null;
					}
					mouseEnabled = true;
					
				});
				
				anim.play();
				
			}
			else{
				
				if(topController){
					contentView.removeElement(topController.view);
				}
				
				view.height = height;
				view.width = width;
				view.x = 0;
				view.y = 0;
				contentView.addElement(view);
			}
			
		}
		
		public function popViewController(animated:Boolean):void{
			if(_viewControllers && _viewControllers.length >1){
				
				var topController:IUIViewController = topViewController;
				var contentView:SkinnableContainer = this.contentView;
				var view:SkinnableContainer;
				var width:int = contentView.width;
				var height:int = contentView.height;
				
				if(animated){
				
					mouseEnabled = false;
					
					_viewControllers.pop();
					
					var anim:Move = new Move(topController.view);
					
					anim.duration = _animateDuration;
					anim.xFrom = 0;
					anim.xTo = this.width;
					
					anim.play();
					
					var controller:IUIViewController = topViewController;
					view = controller.view;
					
					view.height = height;
					view.width = width;
					view.x = - this.width;
					view.y = 0;
					
					contentView.addElement(view);
					
					anim = new Move(view);
					
					anim.duration = _animateDuration;
					anim.xFrom = - this.width;
					anim.xTo = 0;
					
					anim.addEventListener(EffectEvent.EFFECT_END,function(event:EffectEvent):void{
						if(topController){
							topController.parentController = null;
							contentView.removeElement(topController.view);
							topController = null;
						}
						mouseEnabled = true;
					});
					
					anim.play();
				
				}
				else{
					
					if(topController){
						contentView.removeElement(topController.view);
						topController.parentController = null;
					}
					
					_viewControllers.pop();
					
					topController = topViewController;
					
					if(topController){
						view = topController.view;
						view.height = height;
						view.width = width;
						view.x = 0;
						view.y = 0;
						contentView.addElement(view);
					}
				
				}
			}
		}
		
		public function get topViewController():IUIViewController{
			if(_viewControllers && _viewControllers.length >0){
				return _viewControllers[_viewControllers.length -1];
			}
			return null;
		}
		
		public function get contentView():SkinnableContainer{
			return this;
		}
		
	    override public function canOpenUrl(url:URL):Boolean{
			
			var scheme:String = DataObject.dataObjectForKey(config,"scheme") as String;
			
			if(!scheme){
				scheme = "nav";
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
			var basePath:String = this.basePath + this.alias + "/";
			var viewController:IUIViewController = this.context.getController(this.url,basePath);
			if(viewController){
				this.viewControllers = [viewController];
			}
		}
		
		override public function reloadURL():void{
			
			
		}
		
		override public function openUrl(url:URL):Boolean{
			
			var scheme:String = DataObject.dataObjectForKey(config,"scheme") as String;
			
			if(!scheme){
				scheme = "nav";
			}
			
			if(url.scheme == scheme){
				
				context.logger.debug(url.absoluteString);
				
				var basePath:String = this.basePath + this.alias + "/";
				
				for each(var controller:IUIViewController in _viewControllers){
					basePath += controller.alias + "/";
				}
				
				var alias:String = url.firstPathComponent(basePath);
				
				if(alias){
					var viewController:IUIViewController = context.getController(url,basePath);
					if(viewController){
						pushViewController(viewController,true);
					}
				}
				else{
					popViewController(true);
				}

				return true;
			}
			
			if(parentController){
				return parentController.canOpenUrl(url);
			}
			
			return false;
		}
		
		public function get animateDuration():Number{
			return _animateDuration;
		}
		
		public function set animateDuration(animateDuration:Number):void{
			_animateDuration = animateDuration;
		}
		
	}
}