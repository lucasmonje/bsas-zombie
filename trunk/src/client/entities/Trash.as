package client.entities 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import client.definitions.ItemDefinition;
	import client.World;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import client.GameProperties;
	import client.AssetLoader;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Trash extends Sprite
	{
		public static var initialPosition:Point;
		
		private var _props:ItemDefinition;
		
		private var _mc:MovieClip;
		private var _trashBody:b2Body;
		
		private var _world:b2World;
		private var _worldScale:int;
		
		public function Trash(props:ItemDefinition) 
		{
			_props = props;
		}
		
		public function init(world:b2World, worldScale:int):void {
			
			_world = world;
			_worldScale = worldScale;
			
			createMc();
			addChild(_mc);
			
			
			var shape:b2PolygonShape=new b2PolygonShape();
			shape.SetAsBox(_mc.width / (_worldScale*2), _mc.height / (_worldScale*2));
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.density=_props.physicProps.density;
			fixture.friction=_props.physicProps.friction;
			fixture.restitution = _props.physicProps.restitution;
			fixture.shape = shape;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type=b2Body.b2_dynamicBody;

			bodyDef.userData={assetName:_props.name, assetSprite:_mc, remove:false};
			bodyDef.position.Set(initialPosition.x / worldScale, initialPosition.y / worldScale);
			_trashBody = world.CreateBody(bodyDef);
			_trashBody.CreateFixture(fixture);
			_trashBody.ResetMassData();
			
			_trashBody.SetActive(false);
			
		}
		
		public function reset():void {
			_trashBody.SetActive(false);
			_trashBody.SetPosition(new b2Vec2(initialPosition.x / _worldScale, initialPosition.y / _worldScale));
		}

		public function get position():Point {
			return new Point(_trashBody.GetPosition().x * _worldScale, _trashBody.GetPosition().y * _worldScale);
		}
		
		private function createMc():void {
			var cAsset:Class = AssetLoader.instance.getAssetDefinition(_props.name);
			_mc = new cAsset();
			_mc.width = _mc.width;
			_mc.height = _mc.height;
		}
		
		public function shot(vel:b2Vec2):void {
			_trashBody.SetActive(true);
			_trashBody.SetLinearVelocity(vel);
			_trashBody.SetAngularDamping(10);
		}
		
		public function get trashSphere():b2Body 
		{
			return _trashBody;
		}
		
		public function destroy():void {
			_world.DestroyBody(_trashBody);
		}
	}

}