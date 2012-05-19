package com.sevenbrains.trashingDead.entities {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.enum.TrashAnimsEnum;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	import flash.events.Event;
	import flash.geom.Point;
	import com.sevenbrains.trashingDead.managers.DamageAreaManager;
	
	/**
	* ...
	* @author Fulvio Crescenzi
	*/
	public class Trash extends Entity {
		
		public function Trash(props:ItemDefinition, initialPosition:Point) {
			super(props, initialPosition, PhysicObjectType.TRASH, 2);
		}
		
		override public function init():void {
			super.init();
			
			for each (var body:b2Body in _compositionMap.arrayMode) {
				body.SetActive(false);
			}
		}
		
		public function shot(force:b2Vec2):void {
			for each (var body:b2Body in _compositionMap.arrayMode) {
				body.SetActive(true);
				body.ApplyForce(force, body.GetPosition());
			}
			playAnim(TrashAnimsEnum.HIT);
		}
		
		override public function collide(who:Collisionable):void 
		{
			super.collide(who);
			
			if (life == 0) {
				_enabled = true;
				playAnim(TrashAnimsEnum.DESTROY);
				if (this.props.damageAreaProps){
					DamageAreaManager.instance.addDamageArea(this.getItemPosition(), this.props.damageAreaProps);
				}
			}
		}
	
		override protected function updateAnimation(e:Event):void 
		{
			super.updateAnimation(e);
			if (animations.currentAnimName == TrashAnimsEnum.DESTROY) {
				_enabled = false;
			}
		}
	}

}