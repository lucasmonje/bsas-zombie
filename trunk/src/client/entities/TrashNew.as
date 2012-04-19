package client.entities 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
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
	public class TrashNew extends Sprite
	{
		private var _props:Object;
		
		private var _mc:MovieClip;
		
		private var _trashSphere:b2Body;
		
		private var _trashBox:b2Body;
		
		private var _worldScale:int;
		
		public function TrashNew(props:Object) 
		{
			_props = props;
		}
		
		public function init(world:b2World, worldScale:int):void {
			createMc();
			
			_worldScale = worldScale;
			
			var box:b2PolygonShape = new b2PolygonShape();
			box.SetAsBox(20/worldScale, 20/worldScale);
		
			var boxBody:b2BodyDef = new b2BodyDef();
			boxBody.type=b2Body.b2_dynamicBody;
			boxBody.userData={assetName:"trash",assetSprite:_mc,remove:false};
			boxBody.position.Set(GameProperties.TRASH_BATTING_POSITION.x / worldScale, GameProperties.TRASH_BATTING_POSITION.y / worldScale);
			
			var boxFixture:b2FixtureDef = new b2FixtureDef();
			boxFixture.density=10;
			boxFixture.friction=10;
			boxFixture.restitution = 0.1;
			boxFixture.shape = box;
			
			_trashBox = world.CreateBody(boxBody);
			_trashBox.CreateFixture(boxFixture);
			_trashBox.SetActive(false);
			/*
			var sphereShape:b2CircleShape=new b2CircleShape(15/worldScale);
			
			var sphereFixture:b2FixtureDef = new b2FixtureDef();
			sphereFixture.density=1;
			sphereFixture.friction=3;
			sphereFixture.restitution=0.1;
			sphereFixture.shape = sphereShape;
			
			var sphereBodyDef:b2BodyDef = new b2BodyDef();
			sphereBodyDef.type=b2Body.b2_dynamicBody;
			sphereBodyDef.userData={assetName:"trash",assetSprite:_mc,remove:false};
			sphereBodyDef.position.Set(GameProperties.TRASH_BATTING_POSITION.x / worldScale, GameProperties.TRASH_BATTING_POSITION.y / worldScale);
			
			_trashSphere=world.CreateBody(sphereBodyDef);
			_trashSphere.CreateFixture(sphereFixture);
			
			_trashSphere.SetActive(false);
			*/
		}
		
		public function reset():void {
			_trashBox.SetActive(false);
			_trashBox.SetPosition(new b2Vec2(GameProperties.TRASH_BATTING_POSITION.x / _worldScale, GameProperties.TRASH_BATTING_POSITION.y / _worldScale));
		}

		public function get position():Point {
			return new Point(_trashBox.GetPosition().x * _worldScale, _trashBox.GetPosition().y * _worldScale);
		}
		
		private function createMc():void {
			_mc = new MovieClip();
			_mc.graphics.beginFill(0xff0000);
			_mc.graphics.drawRect(-10, -10, 20, 20);
			_mc.graphics.endFill();
			addChild(_mc);
		}
		
		public function shot(vel:b2Vec2):void {
			_trashBox.SetActive(true);
			_trashBox.SetFixedRotation(true);
			_trashBox.SetLinearVelocity(vel);
		}
		
		public function get trashSphere():b2Body 
		{
			return _trashSphere;
		}
	}

}