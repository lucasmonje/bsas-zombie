//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models {
	
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.entities.Item;
	import com.sevenbrains.trashingDead.entities.Players;
	import com.sevenbrains.trashingDead.models.user.Stats;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class UserModel {
		
		private static var _instance:UserModel;
		private static var _instanciable:Boolean;
		
		public static function get instance():UserModel {
			if (!_instance) {
				_instanciable = true;
				_instance = new UserModel();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		private var _players:Players;
		
		private var _stats:Stats;
		
		public function UserModel() {
			if (!_instanciable) {
				throw new Error("This is a singleton class!");
			}
		}
		
		public function init():void {
			var weapons:Vector.<Item> = new Vector.<Item>();
			
			for each (var weaponDef:ItemDefinition in ConfigModel.entities.getWeapons()) {
				weapons.push(new Item(weaponDef, new Point()));
			}
			
			_players = new Players();
		}
		
		public function get players():Players {
			return _players;
		}
		
		public function get stats():Stats {
			return _stats;
		}
	}

}