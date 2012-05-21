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
	import com.sevenbrains.trashingDead.models.user.Inventory;
	import com.sevenbrains.trashingDead.models.user.SocialUser;
	import com.sevenbrains.trashingDead.models.user.Stats;
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class UserModel {
		
		private static var _instance:UserModel;
		private static var _instanciable:Boolean;
		
		public function get user():SocialUser
		{
			return _user;
		}

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

		private var _inventory:Inventory;

		private var _user:SocialUser;
		
		public function UserModel() {
			if (!_instanciable) {
				throw new Error("This is a singleton class!");
			}
			_players = new Players();
			_stats = new Stats();
			_user = new SocialUser();
			_user.name = "Lalo Landa";
			_user.socialId = "01";
			_user.imagePath = "http://bp3.blogger.com/_974y4_tWkUw/R3ALDUjwJ4I/AAAAAAAAAK4/IV0sL8Rs9O0/s400/36_jigsaw_saw_2.jpg";
		}
		
		public function init():void {
			var weapons:Vector.<Item> = new Vector.<Item>();
			
			for each (var weaponDef:ItemDefinition in ConfigModel.items.getWeapons()) {
				weapons.push(new Item(weaponDef, new Point()));
			}
		}
		
		public function get players():Players {
			return _players;
		}
		
		public function get stats():Stats {
			return _stats;
		}

		public function get inventory():Inventory {
			return _inventory;
		}
	}

}