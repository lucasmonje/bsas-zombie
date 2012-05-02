package com.sevenbrains.trashingDead.configuration {

	import com.sevenbrains.trashingDead.configuration.core.AbstractConfig;
	import flash.utils.Dictionary;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class EntitiesConfig extends AbstractConfig {
		
		public function EntitiesConfig(map:Dictionary) {
			super(map);
		}
		
		override public function init():void {
			notifyEnd();			
		}
		
		public function getTrashes():Array {
			return _configMap[ConfigNodes.TRASHES];
		}
		
		public function getWeapons():Array {
			return _configMap[ConfigNodes.WEAPONS];
		}
		
		public function getWeaponByName(name:String):ItemDefinition {
			for each (var def:ItemDefinition in getWeapons()) {
				if (def.name == name) {
					return def;
				}
			}
			return null;
		}
		
		public function getZombies():Array {
			return _configMap[ConfigNodes.ZOMBIES];
		}
		
		public function getZombieByCode(code:uint):ItemDefinition {
			for each (var def:ItemDefinition in getZombies()) {
				if (def.code == code) {
					return def;
				}
			}
			return null;
		}
	}
}