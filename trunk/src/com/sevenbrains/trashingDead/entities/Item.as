package com.sevenbrains.trashingDead.entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.definitions.EntityDefinition;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	import com.sevenbrains.trashingDead.managers.DamageAreaManager;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Item extends Trash 
	{
		
		public function Item(props:EntityDefinition, initialPosition:Point) 
		{
			super(props, initialPosition);
			_type = PhysicObjectType.ITEM;
		}
		
		override public function collide(who:Collisionable):void {
			super.collide(who);
			
			if (isDestroyed()){
				DamageAreaManager.instance.addDamageArea(getBodyPosition(), props.damageAreaProps);
			}
		}
		
	}

}