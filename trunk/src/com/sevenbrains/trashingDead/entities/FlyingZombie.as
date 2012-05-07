package com.sevenbrains.trashingDead.entities {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.sevenbrains.trashingDead.b2.PhysicInformable;
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.models.UserModel;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import com.sevenbrains.trashingDead.models.WorldModel;
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class FlyingZombie extends Entity {
		
		public function FlyingZombie(props:ItemDefinition, initialPosition:Point) {
			super(props, initialPosition, PhysicObjectType.FLYING_ZOMBIE, -1);
		}
		
		override public function updatePosition():void {
			for each (var currentBody:b2Body in _compositionMap.arrayMode) {
				var bodyInfo:PhysicInformable = currentBody as PhysicInformable;
				var view:DisplayObject = bodyInfo.userData.assetSprite;
				var pos:b2Vec2 = currentBody.GetPosition();
				var rotation:Number = currentBody.GetAngle() * (180 / Math.PI);

				var difX:Number = (pos.x * GameProperties.WORLD_SCALE) - UserModel.instance.players.wagonPosition.x;
				var difY:Number = (pos.y * GameProperties.WORLD_SCALE) - WorldModel.instance.floorRect.y;
				if (difX > 0) {
					var tForce:b2Vec2 = WorldModel.instance.gravity;
					var forceX:Number = -0.001 * difX;
					var forceY:Number = -0.00005 * difY;
					var multityFor:Number = forceX + forceY;
					tForce.Multiply(multityFor);
					//tForce.Multiply(-currentBody.GetMass());
					currentBody.ApplyImpulse(tForce, currentBody.GetWorldCenter());
					
					pos.x = pos.x - bodyInfo.speed;
					//pos.y = pos.y - bodyInfo.speed; 
					currentBody.SetPosition(pos);
				}
				
				view.rotation = rotation;
				view.x = pos.x * GameProperties.WORLD_SCALE;
				view.y = pos.y * GameProperties.WORLD_SCALE;
			}
		}
	}
}