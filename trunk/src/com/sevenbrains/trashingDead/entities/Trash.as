package com.sevenbrains.trashingDead.entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.sevenbrains.trashingDead.b2.Box;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	import com.sevenbrains.trashingDead.managers.DamageAreaManager;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Trash extends Entity {
		
		public function Trash(props:ItemDefinition, initialPosition:Point) {
			super(props, initialPosition, PhysicObjectType.TRASH);
		}
		
		override public function init():void 
		{
			super.init();
			
			for each(var body:b2Body in _compositionMap.arrayMode){
				body.SetActive(false);
			}
		}
		
		public function shot(vel:b2Vec2):void {
			for each(var body:b2Body in _compositionMap.arrayMode){
				body.SetActive(true);
				body.SetLinearVelocity(vel);
				body.SetAngularDamping(10);
			}
		}
		
		override public function collide(who:Collisionable):void {
			if (_life > 0) {
				_life--;
				if (_life == 0 && props.type == 'handable') {
					DamageAreaManager.instance.addDamageArea(getBodyPosition(), props.damageAreaProps);
				}
			}
		}
	}

}