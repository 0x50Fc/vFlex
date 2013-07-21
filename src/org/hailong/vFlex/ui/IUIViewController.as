package org.hailong.vFlex.ui
{
	
	import flash.events.Event;
	
	import spark.components.SkinnableContainer;
	
	import org.hailong.vFlex.URL;

	public interface IUIViewController
	{
	
		function get context():IUIContext;
		
		function set context(context:IUIContext):void;
		
		function get title():String;
		
		function set title(title:String):void;
		
		function get config():Object;
		
		function set config(config:Object):void;
		
		function get url():URL;
		
		function set url(url:URL):void;
	
		function get basePath():String;
		
		function set basePath(basePath:String):void;
		
		function get alias():String;
		
		function set alias(alias:String):void;
		
		function action(action:IUIAction):void;
		
		function doAction(event:Event):void;
		
		function canOpenUrl(url:URL):Boolean;
		
		function openUrl(url:URL):Boolean;
	
		function get view():SkinnableContainer;
	
		function reloadURL():void;
		
		function get parentController():IUIViewController;
		
		function set parentController(controller:IUIViewController):void;
		
		
	}
}