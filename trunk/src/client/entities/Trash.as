package client.entities 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import client.World;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import client.GameProperties;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Trash extends Sprite
	{
		private var _props:Object;
		
		private var _mc:MovieClip;
		private var _trashSphere:b2Body;
		
		private var _worldScale:int;
		
		public function Trash(props:Object) 
		{
			_props = props;
		}
		
		public function init(world:b2World, worldScale:int):void {
			createMc();
			
			_worldScale = worldScale;
			
			var sphereShape:b2CircleShape=new b2CircleShape(15/worldScale);
			
			var sphereFixture:b2FixtureDef = new b2FixtureDef();
			sphereFixture.density=1;
			sphereFixture.friction=3;
			sphereFixture.restitution=0.1;
			sphereFixture.shape = sphereShape;
			
			var sphereBodyDef:b2BodyDef = new b2BodyDef();
			sphereBodyDef.type=b2Body.b2_dynamicBody;
			sphereBodyDef.userData={assetName:"trash",assetSprite:_mc,remove:false};
			sphereBodyDef.position.Set(GameProperties.TRASH_BATTING_POISTION.x / worldScale, GameProperties.TRASH_BATTING_POISTION.y / worldScale);
			
			_trashSphere=world.CreateBody(sphereBodyDef);
			_trashSphere.CreateFixture(sphereFixture);
			
			_trashSphere.SetActive(false);
			
		}
		
		public function reset():void {
			_trashSphere.SetActive(false);
			_trashSphere.SetPosition(new b2Vec2(GameProperties.TRASH_BATTING_POISTION.x / _worldScale, GameProperties.TRASH_BATTING_POISTION.y / _worldScale));
		}

		public function get position():Point {
			return new Point(_trashSphere.GetPosition().x * _worldScale, _trashSphere.GetPosition().y * _worldScale);
		}
		
		private function createMc():void {
			_mc = new MovieClip();
			_mc.graphics.beginFill(0xff0000);
			_mc.graphics.drawCircle(0, 0, 20);
			_mc.graphics.endFill();
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
	}

}