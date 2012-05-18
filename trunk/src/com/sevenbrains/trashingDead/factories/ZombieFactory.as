//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.factories {
	
	import com.sevenbrains.trashingDead.definitions.EntityDefinition;
	import com.sevenbrains.trashingDead.entities.Entity;
	import com.sevenbrains.trashingDead.entities.FlyingZombie;
	import com.sevenbrains.trashingDead.entities.Zombie;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Fulvio
	 */
	public class ZombieFactory {
		private static var _instance:ZombieFactory = null;
		private static var _instanciable:Boolean = false;
		
		public static function get instance():ZombieFactory {
			if (!_instance) {
				_instanciable = true;
				_instance = new ZombieFactory();
				_instanciable = false;
			}
			return _instance;
		}
		
		public function ZombieFactory() {
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
		}
		
		public function createZombie(def:EntityDefinition, pos:Point):Entity {
			var zombie:Entity;
			
			switch (def.type) {
				case PhysicObjectType.ZOMBIE:  {
					zombie = new Zombie(def, pos, def.type, WorldModel.instance.barricade);
					break;
				}
				case PhysicObjectType.FLYING_ZOMBIE:  {
					zombie = new FlyingZombie(def, pos, def.type, WorldModel.instance.barricade);
					break;
				}
			}
			zombie.init();
			return zombie;
		}
	}

}