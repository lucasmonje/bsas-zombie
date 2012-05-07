package com.sevenbrains.trashingDead.entities {
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.sevenbrains.trashingDead.b2.PhysicInformable;
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.utils.Animation;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	import com.sevenbrains.trashingDead.enum.EntitiesAnimsEnum;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class Zombie extends Entity {
		
		public function Zombie(props:ItemDefinition, initialPosition:Point) {
			super(props, initialPosition, PhysicObjectType.ZOMBIE, -1);
		}
		
		override public function updatePosition():void {
			for each (var currentBody:b2Body in _compositionMap.arrayMode) {
				var bodyInfo:PhysicInformable = currentBody as PhysicInformable;
				var view:DisplayObject = bodyInfo.userData.assetSprite;
				var pos:b2Vec2 = currentBody.GetPosition();
				var rotation:Number = currentBody.GetAngle() * (180 / Math.PI);

				if ((pos.x * GameProperties.WORLD_SCALE) > UserModel.instance.players.wagonPosition.x) {
					pos.x = pos.x - bodyInfo.speed;
					currentBody.SetPosition(pos);
				}
				
				if (Boolean(view)) {
					view.rotation = rotation;
					view.x = pos.x * GameProperties.WORLD_SCALE;
					view.y = pos.y * GameProperties.WORLD_SCALE;					
				}
			}
		}

		override public function hit(value:int):void 
		{
			super.hit(value);
			
			if (life > 0) {
				playAnim(EntitiesAnimsEnum.HIT);
			}else {
				_enabled = true;
				playAnim(EntitiesAnimsEnum.DEAD);
			}
		}
		
		override protected function updateAnimation(e:Event):void 
		{
			super.updateAnimation(e);
			if (animations.currentAnimName == EntitiesAnimsEnum.DEAD) {
				_enabled = false;
			}
		}
		
	}
}