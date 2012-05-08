package com.sevenbrains.trashingDead.models 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.entities.Batter;
	import com.sevenbrains.trashingDead.entities.FatGuy;
	import com.sevenbrains.trashingDead.entities.Girl;
	import com.sevenbrains.trashingDead.entities.Item;
	import com.sevenbrains.trashingDead.entities.Players;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	
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
		
		public function get players():Players 
		{
			return _players;
		}
		
		private var _players:Players;
		
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
			
			_players = new Players();
		}
		
	}

}