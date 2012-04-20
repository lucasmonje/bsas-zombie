package client.entities 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2MassData;
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
		private var _b2Body:b2Body;
		
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
			
			
			var shape:b2PolygonShape = new b2PolygonShape();
			var hx:Number = (_mc.width / 2) * (1 / _worldScale);
			var hy:Number = (_mc.height / 2) * (1 / _worldScale);
			hx = parseFloat(hx.toString().slice(0, 4));
			hy = parseFloat(hy.toString().slice(0, 4));
			trace("hx: " + hx + " hy: " + hy);
			shape.SetAsBox(hx, hy);
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.density=_props.physicProps.density;
			fixture.friction=_props.physicProps.friction;
			fixture.restitution = _props.physicProps.restitution;
			fixture.shape = shape;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type=b2Body.b2_dynamicBody;

			bodyDef.userData={assetName:_props.name, assetSprite:_mc, remove:false, hits: _props.itemProps.hits};
			bodyDef.position.Set(initialPosition.x / worldScale, initialPosition.y / worldScale);
			
			_b2Body = world.CreateBody(bodyDef);
			//_b2Body.SetMassData(new b2MassData());
			_b2Body.CreateFixture(fixture);
			_b2Body.ResetMassData();
			
			_b2Body.SetActive(false);
			
		}
		private function onSplit(e:*):void {
			trace("");
		}
		
		public function reset():void {
			_b2Body.SetActive(false);
			_b2Body.SetPosition(new b2Vec2(initialPosition.x / _worldScale, initialPosition.y / _worldScale));
		}

		public function get position():Point {
			return new Point(_b2Body.GetPosition().x * _worldScale, _b2Body.GetPosition().y * _worldScale);
		}
		
		private function createMc():void {
			var cAsset:Class = AssetLoader.instance.getAssetDefinition(_props.name);
			_mc = new cAsset();
			_mc.width = _mc.width;
			_mc.height = _mc.height;
		}
		
		public function shot(vel:b2Vec2):void {
			_b2Body.SetActive(true);
			_b2Body.SetLinearVelocity(vel);
			_b2Body.SetAngularDamping(10);
		}

		public function getb2Body():b2Body 
		{
			return _b2Body;
		}
		
		public function destroy():void {
			_world.DestroyBody(_b2Body);
		}
	}

}