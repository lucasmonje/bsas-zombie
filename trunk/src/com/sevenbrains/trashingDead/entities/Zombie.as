package com.sevenbrains.trashingDead.entities {
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.sevenbrains.trashingDead.b2.PhysicInformable;
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.definitions.EntityDefinition;
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
		
		protected static const STATE_WALKING:String = "walking";
		protected static const STATE_ATTACKING:String = "attacking";

		private static const OFFSET_NEAR_TARGET:Number = -10;
		
		protected var _state:String;
		
		private var _target:Entity;
		
		public function Zombie(props:EntityDefinition, initialPosition:Point, zombieType:String, target:Entity) {
			_target = target;
			super(props, initialPosition, zombieType, -1);
			_state = STATE_WALKING;
		}
		
		override public function updatePosition():void {
			switch (_state) {
				case STATE_WALKING:
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
					
					if (isNearToTarget()) {
						stopMoving();
						playAnim(EntitiesAnimsEnum.ATTACK);
						_state = STATE_ATTACKING;
					}
					
					break;
				case STATE_ATTACKING:
					if (animations.currentAnimName == EntitiesAnimsEnum.ATTACK && animations.currentFrame == animations.totalFrames) {
						attack();
						if (_target.isDestroyed()) {
							_state = STATE_WALKING;
							playAnim(EntitiesAnimsEnum.WALK);
							setSpeed();
						}else {
							playAnim(EntitiesAnimsEnum.ATTACK);
						}
					}
					break;
			}
		}
		
		protected function attack():void {
			_target.hit(this.hits);
		}
		
		private function isNearToTarget():Boolean {
			if (!_target || (_target && _target.isDestroyed())) {
				return false;
			}
			var radius:Number = (_target.getBodyDimension().x >> 1) + (this.getBodyDimension().x >> 1) + OFFSET_NEAR_TARGET;
			var distance:Number = Math.abs(_target.getItemPosition().x - this.getItemPosition().x);
			return (distance < radius);
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