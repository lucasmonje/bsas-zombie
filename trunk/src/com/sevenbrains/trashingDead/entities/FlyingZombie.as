package com.sevenbrains.trashingDead.entities {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.sevenbrains.trashingDead.definitions.EntityDefinition;
	import flash.geom.Point;
	import com.sevenbrains.trashingDead.models.WorldModel;
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class FlyingZombie extends Zombie {
		
		public function FlyingZombie(props:EntityDefinition, initialPosition:Point, zombieType:String, target:Entity) {
			super(props, initialPosition, zombieType, target);
		}
		
		override public function updatePosition():void 
		{
			super.updatePosition();
			
			if (_state == STATE_WALKING){
		  
				//dont do anything if too far above ground
				for each (var currentBody:b2Body in _compositionMap.arrayMode) {
					var distanceAboveGround:Number = (WorldModel.instance.floorRect.y - getItemPosition().y);
					if ( distanceAboveGround < _initialPosition.y ) {
						var distanceAwayFromTargetHeight:Number = _initialPosition.y - distanceAboveGround;
						currentBody.ApplyForce(new b2Vec2(0.0, -distanceAwayFromTargetHeight * props.physicProps.density / 3), currentBody.GetWorldCenter());
					}
				}
			}
		}
		
		override protected function attack():void 
		{
			// Tira algo?
		}
	}
}