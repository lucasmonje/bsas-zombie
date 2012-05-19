package com.sevenbrains.trashingDead.configuration {

	import com.sevenbrains.trashingDead.configuration.core.AbstractConfig;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.interfaces.IClassifiable;
	
	import flash.utils.Dictionary;
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class ItemsConfig extends AbstractConfig {
			
		public function ItemsConfig(map:Dictionary) {
			super(map);
		}
		
		override public function init():void {
			notifyEnd();			
		}
		
		public function getTrashes():Array {
			return _configMap[ConfigNodes.TRASHES];
		}

		public function getById(id:uint):IClassifiable {
			return _configMap[ConfigNodes.IDS][id];
		}
		
		public function getTrashesByType(type:String):Array {
			var list:Array = [];
			for each (var def:ItemDefinition in getTrashes()) {
				if (def.type == type) {
					list.push(def);
				}
			}
			return list;
		}
		
		public function getTrashByCode(code:Number):ItemDefinition {
			for each (var def:ItemDefinition in getTrashes()) {
				if (def.code == code) {
					return def;
				}
			}
			return null;
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
		
		public function getStuffs():Array {
			return _configMap[ConfigNodes.STUFFS];
		}
		
		public function getStuffByCode(code:uint):ItemDefinition {
			for each (var def:ItemDefinition in getStuffs()) {
				if (def.code == code) {
					return def;
				}
			}
			return null;
		}
	}
}