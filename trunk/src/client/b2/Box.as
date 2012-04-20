package client.b2 
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	import client.definitions.ItemPhysicDefinition;
	import client.utils.B2Utils;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author lmonje
	 */
	public class Box extends b2Body 
	{
		private var _stageBounds:Rectangle;
		private var _worldBounds:Rectangle;
		private var _isDynamic:Boolean;
		private var _physicProps:ItemPhysicDefinition;
		private var _userData:Object;
		
		public function Box(bd:b2BodyDef, world:b2World) {
			super(bd, world);
		}
		
		public function get stageBounds():Rectangle 
		{
			return _stageBounds;
		}
		
		public function set stageBounds(value:Rectangle):void 
		{
			_stageBounds = value;
		}
		
		public function get worldBounds():Rectangle 
		{
			return _worldBounds;
		}
		
		public function set worldBounds(value:Rectangle):void 
		{
			_worldBounds = value;
		}
		
		public function get isDynamic():Boolean 
		{
			return _isDynamic;
		}
		
		public function set isDynamic(value:Boolean):void 
		{
			_isDynamic = value;
		}
		
		public function get physicProps():ItemPhysicDefinition 
		{
			return _physicProps;
		}
		
		public function set physicProps(value:ItemPhysicDefinition):void 
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

	}

}