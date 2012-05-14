package com.sevenbrains.trashingDead.entities 
{
	import Box2D.Collision.b2AABB;
	import com.sevenbrains.trashingDead.b2.Box;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.models.ConfigModel; 
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Barricade extends Entity
	{
		private const BARRICADE_CODE:uint = 400001;
		
		public function Barricade() 
		{
			var _worldModel:WorldModel = WorldModel.instance;
			var props:ItemDefinition = ConfigModel.entities.getStuffByCode(BARRICADE_CODE);
			var initialPosition:Point = new Point();
			initialPosition.x = 500;
			initialPosition.y = (_worldModel.floorRect.y * _worldModel.panZoom.currentZoom) - (50 * _worldModel.panZoom.currentZoom) - (_worldModel.floorRect.height * 3);
			
			super(props, initialPosition, PhysicObjectType.BARRICADE, 1);
		}
		
		override public function init():void 
		{
			super.init();
		}
		
		override public function collide(who:Collisionable):void 
		{
			if (!(who is Floor)){
				super.collide(who);
			}
		}
		
		override public function hit(value:int):void 
		{
			super.hit(value);
			trace(_life);
			if (_life == (props.itemProps.life >> 1)) {
				playAnim("half");
			}else if (_life == 0) {
				playAnim("destroy");
			}
		}
	}

}