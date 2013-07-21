package org.hailong.vFlex.ui
{
	public class UIAction implements IUIAction
	{
		private var _actionName:String;
		private var _userInfo:Object;
		
		public function UIAction(actionName:String=null,userInfo:Object=null)
		{
			_actionName = actionName;
			_userInfo = userInfo;
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