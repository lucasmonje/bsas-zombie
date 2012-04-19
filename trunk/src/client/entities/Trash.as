package client.entities 
{
	import Box2D.Collision.Shapes.b2CircleShape;
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
		private var _trashSphere:b2Body;
		
		private var _world:b2World;
		private var _worldScale:int;
		
		public function Trash(props:ItemDefinition) 
		{
			_props = props;
		}
		
		public function init(world:b2World, worldScale:int):void {
			createMc();
			
			_world = world;
			_worldScale = worldScale;
			
			var sphereShape:b2CircleShape=new b2CircleShape(15/worldScale);
			
			var sphereFixture:b2FixtureDef = new b2FixtureDef();
			sphereFixture.density=_props.physicProps.density;
			sphereFixture.friction=_props.physicProps.friction;
			sphereFixture.restitution=_props.physicProps.restitution;
			sphereFixture.shape = sphereShape;
			
			var sphereBodyDef:b2BodyDef = new b2BodyDef();
			sphereBodyDef.type=b2Body.b2_dynamicBody;
			sphereBodyDef.userData={assetName:_props.name, assetSprite:_mc, remove:false};
			sphereBodyDef.position.Set(initialPosition.x / worldScale, initialPosition.y / worldScale);
			
			_trashSphere=world.CreateBody(sphereBodyDef);
			_trashSphere.CreateFixture(sphereFixture);
			
			_trashSphere.SetActive(false);
			
		}
		
		public function reset():void {
			_trashSphere.SetActive(false);
			_trashSphere.SetPosition(new b2Vec2(initialPosition.x / _worldScale, initialPosition.y / _worldScale));
		}

		public function get position():Point {
			return new Point(_trashSphere.GetPosition().x * _worldScale, _trashSphere.GetPosition().y * _worldScale);
		}
		
		private function createMc():void {
			var cAsset:Class = AssetLoader.instance.getAssetDefinition(_props.name);
			
			_mc = new cAsset();
			addChild(_mc);
		}
		
		public function shot(vel:b2Vec2):void {
			_trashSphere.SetActive(true);
			_trashSphere.SetLinearVelocity(vel);
		}
		
		public function get trashSphere():b2Body 
		{
			return _trashSphere;
		}
		
		public function destroy():void {
			_world.DestroyBody(_trashSphere);
		}
	}

}