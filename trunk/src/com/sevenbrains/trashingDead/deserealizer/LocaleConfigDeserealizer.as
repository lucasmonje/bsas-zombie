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
		}
		
		override public function deserialize():void {
			_idsMap = new Dictionary();
			_map = new Dictionary();
			_map[ConfigNodes.LOCALE] = decodeLocale(_source);
			_map[ConfigNodes.IDS] = _idsMap;
		}
		
		private function decodeLocale(source:String):void {
			trace("");
		}
		
	}
}