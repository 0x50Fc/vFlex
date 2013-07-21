package org.hailong.vFlex
{
	import mx.utils.URLUtil;

	public class URL
	{
		private var _scheme:String;
		private var _host:String;
		private var _port:int;
		private var _path:String;
		private var _queryString:String;
		private var _queryValues:Object;
		private var _token:String;
		private var _absoluteString:String;
		
		public function URL(url:String,baseUrl:URL = null,queryValues:Object = null)
		{
			
			var i:int;
			
			if(baseUrl){
				i = url.indexOf("://");
				if(i >=0){
					_absoluteString = url;
				}
				else {
					_absoluteString = baseUrl.scheme+"://"+baseUrl.host;
					if(baseUrl.port){
						_absoluteString += ":" + baseUrl.port;
					}
					if(url.indexOf("/") == 0){
						_absoluteString += url;
					}
					else {
					
						var paths:Array = baseUrl.path.split("/");
						
						i = url.indexOf("?");
						var queryString:String = "";
						
						if(i >=0){
							queryString = url.substr(i);
							url = url.substr(0,i);
						}
						else{
							i = url.indexOf("#");
							if(i >=0){
								queryString = url.substr(i);
								url = url.substr(0,i);
							}
						}
						
						var ps:Array = url.split("/");
						
						if(ps.length >0){
							paths.pop();
							for each(var p:String in ps){
								if(p == "."){
									
								}
								else if(p == ".."){
									paths.pop();
								}
								else{
									paths.push(p);
								}
							}
						}
						
						_absoluteString += paths.join("/") + queryString;
						
					}
				}
			}
			else{
				_absoluteString = url;
			}
			
			if(queryValues){
				if(_absoluteString.indexOf("?") >=0){
					_absoluteString += "&" + URLUtil.objectToString(queryValues,"&",true);
				}
				else{
					_absoluteString += "?" + URLUtil.objectToString(queryValues,"&",true);
				}
			}
			
			var index:int = 0;
			i = _absoluteString.indexOf("://",index);
			
			if(i >= 0){
				
				_scheme = _absoluteString.substr(index,i);
				index = i + 3;
				
				i = _absoluteString.indexOf("/",index);
				
				if(i >=0){
					_host = _absoluteString.substr(index,i - index);
					index = i;
					
					i = _host.indexOf(":");
					
					if(i >=0){
						_port = parseInt(_host.substr(i + 1));
						_host = _host.substr(0,i);
					}
					
					i = _absoluteString.indexOf("?",index);
					
					if(i >=0){
						_path = _absoluteString.substr(index,i - index);
						_queryString = _absoluteString.substr(i + 1);
						
						index = i + 1;
						
						i = _queryString.indexOf("#");
						
						if(i >=0){
							_token = _queryString.substr(0,i);
							_queryString = _queryString.substr(i + 1);
						}
						_queryValues = URLUtil.stringToObject(_queryString,"&",true);
					}
					else{
						_path = _absoluteString.substr(index);
					}
				}
				else{
					_path = "/";
				}
			}
			else{
				_path = "/";
			}
			
		}
		
		public function get absoluteString():String{
			return _absoluteString;
		}
		
		public function get lastPathComponent():String{
			var vs:Array = _path.split("/");
			if(vs.length>0){
				return vs[vs.length - 1];
			}
			return null;
		}
		
		public function firstPathComponent(basePath:String=null):String{
			var path:String = _path;
			
			if(basePath){
				if(path.indexOf(basePath) == 0){
					path = path.substr(basePath.length);
				}
				else{
					return null;
				}
			}
			
			var vs:Array = path.split("/");
			
			if(vs.length >0){
				return vs[0];
			}
			
			return null;
		}
		
		public function pathComponents(basePath:String=null):Array{
			
			var path:String = _path;
			
			if(basePath){
				if(path.indexOf(basePath) == 0){
					path = path.substr(basePath.length);
				}
				else{
					return null;
				}
			}
			
			return path.split("/");	
		}
		
		public function get scheme():String{
			return _scheme;
		}
		
		public function get port():int{
			return _port;
		}
		
		public function get host():String{
			return _host;
		}
		
		public function get path():String{
			return _path;
		}
		
		public function get queryString():String{
			return _queryString;
		}
		
		public function get token():String{
			return _token;
		}
		
		public function get queryValues():Object{
			return _queryValues;
		}
	
	}
}