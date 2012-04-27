package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class Zombie extends Entity {
		
		public function Zombie(props:ItemDefinition, initialPosition:Point) {
			super(props, initialPosition, PhysicObjectType.ZOMBIE, -1);
		}
		
	}

}