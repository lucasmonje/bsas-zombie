package com.sevenbrains.trashingDead.configuration {

	import com.sevenbrains.trashingDead.configuration.core.AbstractConfig;
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import flash.utils.Dictionary;
	/**
	* ...
	* @author Lucas Monje
	*/
	public class WorldsConfig extends AbstractConfig {
		
		public function WorldsConfig(map:Dictionary) {
			super(map);
		}
		
		override public function init():void {
			notifyEnd();
		}
		
		public function getWorlds():Array {
			return _configMap[ConfigNodes.WORLDS];
		}
		
		public function getWorldById(id:String):WorldDefinition {
			return _configMap[ConfigNodes.IDS][id];
		}
		
	}
}