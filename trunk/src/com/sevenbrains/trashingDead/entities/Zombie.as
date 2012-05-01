package com.sevenbrains.trashingDead.entities {
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	import flash.geom.Point;
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class Zombie extends Entity {
		public function Zombie(props:ItemDefinition, initialPosition:Point) {
			super(props, initialPosition, PhysicObjectType.ZOMBIE, -1);
		}
		
		override public function collide(who:Collisionable):void 
		{
			super.collide(who);
			if (life > 0) {
				destroyJoint("anchor4_box2_box3");
				destroyJoint("anchor3_box2_box3");
			}
		}
	}
}