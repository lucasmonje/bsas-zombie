package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.definitions.WorldEntitiesDefinition;
	import com.sevenbrains.trashingDead.deserealizer.core.AbstractDeserealizer;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class LocaleConfigDeserealizer extends AbstractDeserealizer {
		
		private var _idsMap:Dictionary;
		
		public function LocaleConfigDeserealizer(source:String) {
			super(source);
			trace(source)
		}
		
		override public function deserialize():void {
			_idsMap = new Dictionary();
			_map = new Dictionary();
			decodeLocale(_source);
			_map[ConfigNodes.IDS] = _idsMap;
		}
		
		private function decodeLocale(source:String):void {
			var pairs:Array = source.split("\n");
			for each (var pairString:String in pairs) {
				if (pairString.substr(0,1) != "#") {
					var pair:Array = pairString.split("=");
					if (pair.length > 0) {
						var key:String = pair[0];
						var value:String = pair[1] || new String();
						_idsMap[key] = value;
					}					
				}
			}
		}		
	}
}