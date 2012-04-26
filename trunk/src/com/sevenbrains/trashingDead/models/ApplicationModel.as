package com.sevenbrains.trashingDead.models 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ApplicationModel 
	{
		
		private static var _instanciable:Boolean;
		private static var _instance:ApplicationModel;
		
		public function ApplicationModel() 
		{
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
			
			_map = new Dictionary();
		}
		
		public static function get instance():ApplicationModel {
			if (!_instance) {
				_instanciable = true;
				_instance = new ApplicationModel();
				_instanciable = false;
			}
			
			return _instance;
		}
				
		private var _map:Dictionary;
		
		public function addMap(key:String, list:Array):void {
			_map[key] = list.concat();
		}
		
		public function getTrashes():Array {
			return _map[ConfigNodes.TRASHES];
		}
		
		public function getWorlds():Array {
			return _map[ConfigNodes.WORLDS];
		}
		
		public function getWeapons():Array {
			return _map[ConfigNodes.WEAPONS];
		}
		
		public function getWeaponByName(name:String):ItemDefinition {
			var items:Array = _map[ConfigNodes.WEAPONS];
			for each(var def:ItemDefinition in items) {
				if (def.name == name) {
					return def;
				}
			}
			
			return null;
		}
		
		public function getZombies():Array {
			return _map[ConfigNodes.ZOMBIES];
		}
		
		public function getZombieByCode(code:uint):ItemDefinition {
			var zombies:Array = _map[ConfigNodes.ZOMBIES];
			for each(var def:ItemDefinition in zombies) {
				if (def.code == code) {
					return def;
				}
			}
			
			return null;
		}
	}

}