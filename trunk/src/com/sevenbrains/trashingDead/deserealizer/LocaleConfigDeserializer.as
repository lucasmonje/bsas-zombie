package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.definitions.WorldEntitiesDefinition;
	import com.sevenbrains.trashingDead.deserealizer.core.BuilderDeserealizer;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.interfaces.Buildable;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class LocaleConfigDeserializer extends BuilderDeserealizer {
		
		public static const TYPE:String = "localeConfigDeserializer";

		private var _idsMap:Dictionary;
		
		public function LocaleConfigDeserializer(source:String) {
			super(source);
		}
		
		override public function deserialize(source:String):* {
			_idsMap = new Dictionary();
			_map = new Dictionary();
			decodeLocale(_source);
			_map[ConfigNodes.IDS] = _idsMap;
			return _map;
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