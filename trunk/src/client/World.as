package client 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import client.entities.Trash;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class World extends Sprite
	{
		[Embed (source = "resources\\assets\\index.swf", mimeType = "application/octet-stream")] private var _cAssets:Class;
		
		
		private var _world:b2World=new b2World(new b2Vec2(0,10),true);
		private var _worldScale:int = 30;
		
		private var customContact:b2ContactListener = new b2ContactListener()
		
		private var _assets:Loader;
		
		private var _angleDrawing:Sprite;
		private var _powerDrawing:Sprite;
		private var _background:MovieClip;		
		private var _trash:Trash;
		
		private var _following:Boolean = false;
		private var _powering:Boolean = false;
		
		private var _power:Number;
		
		public function World() 
		{
			
		}
		
		public function init():void {
			_world.SetContactListener(customContact);
			
			_assets = new Loader();
			_assets.loadBytes(new _cAssets());
			_assets.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoded);
		}
		
		private function onAssetLoded(e:Event):void {
			// Carga el background
			var _cBackground:Class = _assets.contentLoaderInfo.applicationDomain.getDefinition("backgroundMc") as Class;
			_background = new _cBackground();
			addChild(_background);

			// Basura a lanzar
			_trash = new Trash(null);
			//_trash.x = GameProperties.TRASH_BATTING_POISTION.x;
			//_trash.y = GameProperties.TRASH_BATTING_POISTION.y;
			_trash.init(_world, _worldScale);
			addEventListener(MouseEvent.MOUSE_MOVE, trashMoved);
			addEventListener(MouseEvent.MOUSE_DOWN, trashMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, trashMouseUp);
			addChild(_trash);
			
			// Agrega suelo
			addWall(800, 50, 0, 430);
			
			// Angulo de disparo
			_angleDrawing = new Sprite();
			addChild(_angleDrawing);
			
			// Barra de power
			_powerDrawing = new Sprite();
			_powerDrawing.x = GameProperties.TRASH_BATTING_POISTION.x;
			_powerDrawing.y = GameProperties.TRASH_BATTING_POISTION.y + 50;
			addChild(_powerDrawing);
			
			_power = 0;
			
			addEventListener(Event.ENTER_FRAME, updateWorld);
			
			dispatchEvent(new Event(Event.COMPLETE));			
		}
		
		private function trashMoved(e:MouseEvent):void {
			
			var originPoint:Point = new Point(_trash.position.x, _trash.position.y);
			var destPoint:Point = new Point(mouseX, mouseY);
			
			_angleDrawing.graphics.clear();
			_angleDrawing.graphics.lineStyle(1);
			_angleDrawing.graphics.moveTo(originPoint.x, originPoint.y);
			_angleDrawing.graphics.lineTo(destPoint.x, destPoint.y);
		}
		
		private function trashMouseDown(e:MouseEvent):void {
			_powering = true;
		}
		
		private function trashMouseUp(e:MouseEvent):void {
			_powering = false;
			
			_powerDrawing.graphics.clear();
			_angleDrawing.graphics.clear();
			removeEventListener(MouseEvent.MOUSE_MOVE, trashMoved);
			removeEventListener(MouseEvent.MOUSE_DOWN, trashMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, trashMouseUp);

			
			var originPoint:Point = new Point(_trash.position.x, _trash.position.y);
			var destPoint:Point = new Point(mouseX, mouseY);
			
			var distanceX:Number=destPoint.x-originPoint.x;
			var distanceY:Number=destPoint.y-originPoint.y;
			var trashAngle:Number = Math.atan2(distanceY, distanceX);
			
			_trash.shot(new b2Vec2(_power*Math.cos(trashAngle)/4,_power*Math.sin(trashAngle)/4));
		}
		
		private function addWall(w:Number,h:Number,px:Number,py:Number):void {
			
			var floorShape:b2PolygonShape = new b2PolygonShape();
			floorShape.SetAsBox(w/_worldScale,h/_worldScale);
			
			var floorFixture:b2FixtureDef = new b2FixtureDef();
			floorFixture.density=0;
			floorFixture.friction=10;
			floorFixture.restitution=0.5;
			floorFixture.shape=floorShape;
		
			var floorBodyDef:b2BodyDef = new b2BodyDef();
			floorBodyDef.position.Set(px/_worldScale,py/_worldScale);
			floorBodyDef.userData={assetName:"wall",assetSprite:null,remove:false};
			
			var floor:b2Body=_world.CreateBody(floorBodyDef);
			floor.CreateFixture(floorFixture);
		}
		
		public function get worldScale():int 
		{
			return _worldScale;
		}
		
		private function updateWorld(e:Event):void {
			//trace(_trash.trashSphere.GetPosition().x , _trash.trashSphere.GetPosition().y);
			
			if (_powering) {
				_power += GameProperties.POWER_INCREMENT;
				if (_power > 100) {
					_power = 100;
				}
				
				_powerDrawing.graphics.clear();
				_powerDrawing.graphics.beginFill(0xffff00);
				_powerDrawing.graphics.drawRect(0, 0, _power, 20);
				_powerDrawing.graphics.endFill();
			}
			
			// Chequea que la basura se fue de pantalla y la resetea
			if (_trash.position.x > 800 || _trash.position.y > 600) {
				_trash.reset();
				addEventListener(MouseEvent.MOUSE_MOVE, trashMoved);
				addEventListener(MouseEvent.MOUSE_DOWN, trashMouseDown);
				addEventListener(MouseEvent.MOUSE_UP, trashMouseUp);
				_power = 0;
			}
			
			_world.Step(1/30,10,10);
			for (var currentBody:b2Body=_world.GetBodyList(); currentBody; currentBody=currentBody.GetNext()) {
				if (currentBody.GetUserData()) {
					if (currentBody.GetUserData().assetSprite!=null) {
						currentBody.GetUserData().assetSprite.x=currentBody.GetPosition().x*_worldScale;
						currentBody.GetUserData().assetSprite.y=currentBody.GetPosition().y*_worldScale;
						currentBody.GetUserData().assetSprite.rotation=currentBody.GetAngle()*(180/Math.PI);
					}
					if (currentBody.GetUserData().remove) {
						if (currentBody.GetUserData().assetSprite!=null) {
							removeChild(currentBody.GetUserData().assetSprite);
						}
						_world.DestroyBody(currentBody);
					}
				}
			}
			if (_following) {
				var posX:Number=_trash.x;
				posX=stage.stageWidth/2-posX;
				if (posX>0) {
					posX=0;
				}
				if (posX<-800) {
					posX=-800;
				}
				x=posX;
			}
			_world.ClearForces();
			_world.DrawDebugData();
		}
	}

}