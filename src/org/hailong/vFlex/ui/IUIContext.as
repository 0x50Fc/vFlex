package org.hailong.vFlex.ui
{
	import org.hailong.vFlex.IServiceContext;
	import org.hailong.vFlex.URL;

	public interface IUIContext extends IServiceContext
	{
		function getController(url:URL,basePath:String):IUIViewController;
	}
}