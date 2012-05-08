package com.sevenbrains.trashingDead.factories 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.entities.Entity;
	import com.sevenbrains.trashingDead.entities.FlyingZombie;
	import com.sevenbrains.trashingDead.entities.Trash;
	import com.sevenbrains.trashingDead.entities.Zombie;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio
	 */
	public class ZombieFactory 
	{
		private static var _instance:ZombieFactory=null;
		private static var _instanciable:Boolean=false;
		
		public static function get instance():ZombieFactory {
			if (!_instance) {
				_instanciable = true;
				_instance = new ZombieFactory();
				_instanciable = false;
			}			
			return _instance;
		}
		
		public function ZombieFactory() 
		{
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
		}
		
		public function createZombie(def:ItemDefinition, pos:Point):Entity {
			var zombie:Entity;
			switch(def.type) {
				case PhysicObjectType.ZOMBIE:
					zombie = new Zombie(def, pos);
					break;
				case PhysicObjectType.FLYING_ZOMBIE:
					zombie = new FlyingZombie(def, pos);
					break;
			}
			zombie.init();
			return zombie;
		}
	}

}