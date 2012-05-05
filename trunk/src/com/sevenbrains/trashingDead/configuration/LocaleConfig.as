package com.sevenbrains.trashingDead.configuration {

	import com.sevenbrains.trashingDead.configuration.core.AbstractConfig;
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.interfaces.Locable;
	import flash.utils.Dictionary;
	/**
	* ...
	* @author Lucas Monje
	*/
	public class LocaleConfig extends AbstractConfig implements Locable {
		
		private var _params:Array;
		
		public function LocaleConfig(map:Dictionary) {
			super(map);
		}
		
		override public function init():void {
			notifyEnd();
		}
		
		public function getWithoutKey(id:String, params:Array = null):String {
			var result:String = get(id, params);
			return result == id ? "" : result;
		}
		
		public function get(id:String, params:Array = null):String {
			_params = params;
			var result:String = _configMap[ConfigNodes.IDS][id];
			if (Boolean(result)) {	
				var r:RegExp = /\{(\S+?)\}/g;
				result = result.replace(r, parse);
			} else {
				return id;
			}
			return result;
		}
		
		private function parse(all:String, index:String, ...args):String{
			return _params[index] || '{?'+index+'}';
		}
	}
}