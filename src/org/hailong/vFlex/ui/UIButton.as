package org.hailong.vFlex.ui
{
	import mx.controls.Button;
	
	public class UIButton extends Button implements IUIAction
	{
		private var _actionName:String;
		private var _userInfo:Object;
		
		public function UIButton()
		{
			super();
		}
		
		public function get actionName():String
		{
			return _actionName;
		}
		
		public function get userInfo():Object
		{
			return _userInfo;
		}
		
		public function set actionName(actionName:String):void{
			_actionName = actionName;
		}
		
		public function set userInfo(userInfo:Object):void{
			_userInfo = userInfo;
		}
	}
}