package com.sevenbrains.trashingDead.models 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.entities.FatGuy;
	import com.sevenbrains.trashingDead.entities.Item;
	import com.sevenbrains.trashingDead.entities.Player;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import flash.geom.Point;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class UserModel 
	{
		private static var _instance:UserModel;
		private static var _instanciable:Boolean;
		
		public static function get instance():UserModel 
		{
			if (!_instance){
				_instanciable = true;
				_instance = new UserModel();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		private var _player:Player;
		private var _fatGuy:FatGuy;
		
		public function UserModel() 
		{
			if (!_instanciable) {
				throw new Error("This is a singleton class!");
			}
		}
		
		public function init():void {
			
			var weapons:Vector.<Item> = new Vector.<Item>();
			for each (var weaponDef:ItemDefinition in ConfigModel.entities.getWeapons()) {
				weapons.push(new Item(weaponDef, new Point()));
			}
			
			_player = new Player(weapons);
			_fatGuy = new FatGuy();
		}
		
		public function get player():Player 
		{
			return _player;
		}
		
		public function get fatGuy():FatGuy 
		{
			return _fatGuy;
		}
	}

}