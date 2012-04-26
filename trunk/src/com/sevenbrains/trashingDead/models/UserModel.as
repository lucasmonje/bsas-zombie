package com.sevenbrains.trashingDead.models 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.entities.Item;
	import com.sevenbrains.trashingDead.entities.Player;
	
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
		
		public function UserModel() 
		{
			if (!_instanciable) {
				throw new Error("This is a singleton class!");
			}
		}
		
		public function init():void {
			
			var weapons:Vector.<Item> = new Vector.<Item>();
			for each (var weaponDef:ItemDefinition in ApplicationModel.instance.getWeapons()) {
				weapons.push(new Item(weaponDef));
			}
			
			_player = new Player(weapons);
		}
		
		public function get player():Player 
		{
			return _player;
		}
	}

}