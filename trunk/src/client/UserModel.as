package client 
{
	import client.definitions.ItemDefinition;
	import client.entities.Item;
	import client.entities.Player;
	
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
		
		private var _weapons:Vector.<Item>;
		private var _player:Player;
		private var _actualWeapon:uint;
		
		public function UserModel() 
		{
			if (!_instanciable) {
				throw new Error("This is a singleton class!");
			}
		}
		
		public function init():void {
			_player = new Player();
			_weapons = new Vector.<Item>();
			for each (var weaponDef:ItemDefinition in ApplicationModel.instance.getWeapons()) {
				_weapons.push(new Item(weaponDef));
			}
			
			_actualWeapon = 0;
		}
		
		public function changeWeapon(left:Boolean):void {
			var len:int = _weapons.length;
			if (left) {
				_player.actualWeapon = _player.actualWeapon == 0? len - 1: _player.actualWeapon-1;
			}else {
				_player.actualWeapon = _player.actualWeapon == len -1? 0: _player.actualWeapon+1;
			}
		}
		
		public function get weapons():Vector.<Item> {
			return _weapons;
		}
		
		public function get player():Player 
		{
			return _player;
		}
	}

}