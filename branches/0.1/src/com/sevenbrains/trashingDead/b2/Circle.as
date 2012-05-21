package com.sevenbrains.trashingDead.b2 
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	import com.sevenbrains.trashingDead.definitions.PhysicDefinition;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author lmonje
	 */
	public class Circle extends b2Body implements PhysicInformable
	{
		private var _initialStageBounds:Rectangle;
		private var _initialWorldBounds:Rectangle;
		private var _isDynamic:Boolean;
		private var _physicProps:PhysicDefinition;
		private var _userData:Object;
		
		public function Circle(bd:b2BodyDef, world:b2World) {
			super(bd, world);
		}
		
		public function get initialStageBounds():Rectangle 
		{
			return _initialStageBounds;
		}
		
		public function set initialStageBounds(value:Rectangle):void 
		{
			_initialStageBounds = value;
		}
		
		public function get initialWorldBounds():Rectangle 
		{
			return _initialWorldBounds;
		}
		
		public function set initialWorldBounds(value:Rectangle):void 
		{
			_initialWorldBounds = value;
		}
		
		public function get isDynamic():Boolean 
		{
			return _isDynamic;
		}
		
		public function set isDynamic(value:Boolean):void 
		{
			_isDynamic = value;
		}
		
		public function get physicProps():PhysicDefinition 
		{
			return _physicProps;
		}
		
		public function set physicProps(value:PhysicDefinition):void 
		{
			_physicProps = value;
		}
		
		public function get userData():Object 
		{
			return _userData;
		}
		
		public function set userData(value:Object):void 
		{
			_userData = value;
		}
	
		public function get type():String 
		{
			return _userData.entity.type;
		}
		
		public function get speed():Number {
			return _userData.entity.speed;
		}
	}

}