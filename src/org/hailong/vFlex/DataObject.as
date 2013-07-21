package org.hailong.vFlex
{
	public class DataObject
	{
		public function DataObject()
		{
		}
		
		public static function dataObjectForKeyPath(dataObject:Object,keyPath:String):Object{
			if(dataObject){
				var keys:Array = keyPath.split(".");
				var key:String = keys.shift();
				var value:Object = dataObject;
				
				while(key){
					value = dataObjectForKey(value,key);
					key = keys.shift();
				}
				
				return value;
			}
			return null;
		}
		
		public static function setDataObjectForKeyPath(dataObject:Object,keyPath:String,value:Object):void{
			if(dataObject){
				var keys:Array = keyPath.split(".");
				var lastKey:String = keys.pop();
				var key:String = keys.shift();
				var data:Object = dataObject;
				
				while(key){
					data = dataObjectForKey(data,key);
					key = keys.shift();
				}
				
				if(data && lastKey){
					data[lastKey] = value;
				}
	
			}
		}
		
		public static function dataObjectForKey(dataObject:Object,key:String):Object{
			if(dataObject){
				return dataObject[key];
			}
			return null;
		}
		
		public static function setDataObjectForKey(dataObject:Object,key:String,value:Object):void{
			if(dataObject){
				dataObject[key] = value;
			}
		}
	}
}