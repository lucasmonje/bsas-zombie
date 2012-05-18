package com.sevenbrains.trashingDead.configuration {

	import com.sevenbrains.trashingDead.configuration.core.AbstractConfig;
	import com.sevenbrains.trashingDead.definitions.EntityDefinition;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	
	import flash.utils.Dictionary;
	
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
		
		public function getTrashesByType(type:String):Array {
			var list:Array = [];
			for each (var def:EntityDefinition in getTrashes()) {
				if (def.type == type) {
					list.push(def);
				}
			}
			return list;
		}
		
		public function getTrashByCode(code:Number):EntityDefinition {
			for each (var def:EntityDefinition in getTrashes()) {
				if (def.code == code) {
					return def;
				}
			}
			return null;
		}
		
		public function getWeapons():Array {
			return _configMap[ConfigNodes.WEAPONS];
		}
		
		public function getWeaponByName(name:String):EntityDefinition {
			for each (var def:EntityDefinition in getWeapons()) {
				if (def.name == name) {
					return def;
				}
			}
			return null;
		}
		
		public function getZombies():Array {
			return _configMap[ConfigNodes.ZOMBIES];
		}
		
		public function getZombieByCode(code:uint):EntityDefinition {
			for each (var def:EntityDefinition in getZombies()) {
				if (def.code == code) {
					return def;
				}
			}
			return null;
		}
		
		public function getStuffs():Array {
			return _configMap[ConfigNodes.STUFFS];
		}
		
		public function getStuffByCode(code:uint):EntityDefinition {
			for each (var def:EntityDefinition in getStuffs()) {
				if (def.code == code) {
					return def;
				}
			}
			return null;
		}
	}
}