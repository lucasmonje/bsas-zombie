package client 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import client.b2.Clientb2ContactListener;
	import client.definitions.ItemPhysicDefinition;	import client.definitions.ItemDefinition;
	import client.entities.Trash;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import client.utils.B2Utils;
	import flash.geom.Point;
	import client.enum.PlayerStatesEnum;
	import client.utils.MathUtils;
	import client.AssetLoader;
	import client.utils.DisplayUtil;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class World extends Sprite
	{
		[Embed (source = "resources\\assets\\stage01.swf", mimeType = "application/octet-stream")] private var _cAssets:Class;
		
		private var _world:b2World=new b2World(new b2Vec2(0,10),true);
		private var _worldScale:int = 30;
		private static var PHYSICS_SCALE:Number = 1 / 30;

		
		private var customContact:b2ContactListener;
		
		private var _assets:Loader;
		
		private var mcStage:MovieClip;
		private var _poweringArrow:MovieClip;
		private var _mcTrashCont:MovieClip;
		private var _mcPlayer:MovieClip;
		private var _currentTrash:Trash;
		private var _trashList:Vector.<Trash>;
		
		private var _shotReset:Sprite;
		
		private var _following:Boolean = false;
		
		private var _powering:Boolean = false;
		
		private var _power:Number;
		
		private var _angle:Number;
		
		private var b2BodyTrashMap:Dictionary;
		
		public function World() 
		{
		}
		
		public function init():void {
			customContact = new Clientb2ContactListener();
			_world.SetContactListener(customContact);
			b2BodyTrashMap = new Dictionary();
			_power = 0;
			_trashList = new Vector.<Trash>();
			_assets = new Loader();
			_assets.loadBytes(new _cAssets());
			_assets.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoded);
			
			if (!ApplicationModel.instance.stage.hasEventListener(KeyboardEvent.KEY_UP)) {
				ApplicationModel.instance.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			}
		}
		
		private function onAssetLoded(e:Event):void {
			// Carga el background
			var _cBackground:Class = _assets.contentLoaderInfo.applicationDomain.getDefinition("stage01") as Class;
			mcStage = new _cBackground();
			_poweringArrow = mcStage.getChildByName("mcPoweringContainer") as MovieClip;
			_mcTrashCont = mcStage.getChildByName("mcTrashCont") as MovieClip;
			_mcPlayer = mcStage.getChildByName("mcPlayer") as MovieClip;
			
			Trash.initialPosition = new Point(_poweringArrow.x, _poweringArrow.y);
			
			
			
			
			var body3:b2Body = B2Utils.createBox(new Rectangle(485, 400, 15, 100), _world, _worldScale, true, new ItemPhysicDefinition(1, 0.3, 0.1));
			var body4:b2Body = B2Utils.createBox(new Rectangle(520, 400, 15, 100), _world, _worldScale, true, new ItemPhysicDefinition(1, 0.3, 0.1));
			var body2:b2Body = B2Utils.createBox(new Rectangle(500, 300, 50, 100), _world, _worldScale, true, new ItemPhysicDefinition(1, 0.3, 0.1));
			var body1:b2Body = B2Utils.createBox(new Rectangle(500, 250, 40, 50), _world, _worldScale, true, new ItemPhysicDefinition(1, 0.3, 0.1));
			
			
			B2Utils.setRevoluteJoint(body1, body2, _world, -0.25, -0.25);
			B2Utils.setRevoluteJoint(body2, body3, _world, -0.75, 1);
			B2Utils.setRevoluteJoint(body2, body4, _world, -0.75, 1);
			
			
			var floor:MovieClip = mcStage.getChildByName("mcFloor") as MovieClip;
			addFloor(floor.width, floor.height, floor.x, floor.y);
			
			addChild(mcStage);
			var newTrash:Trash = createTrash();
			_mcTrashCont.addChild(newTrash);
			
			DisplayUtil.bringToFront(_poweringArrow);
			UserModel.instance.player.state = PlayerStatesEnum.READY;
			
			var debug:b2DebugDraw = new b2DebugDraw();
			var sprite:Sprite = new Sprite();
			addChild(sprite);
			debug.SetSprite(sprite);
			debug.SetDrawScale(1 / PHYSICS_SCALE);
			debug.SetFlags(b2DebugDraw.e_shapeBit);
			_world.SetDebugDraw(debug);
			
			addPlayerListeners();
			addEventListener(Event.ENTER_FRAME, updateWorld);
			dispatchEvent(new Event(Event.COMPLETE));	
		}
		
		private function getTrash():ItemDefinition {
			var items:Array = ApplicationModel.instance.getTrashes().concat();
			return items[MathUtils.getRandomInt(1, items.length) - 1];
		}
		
		private function trashMoved(e:MouseEvent):void {
			setNewAngle();
			_poweringArrow.rotation = _angle * 75;
		}
		
		private function setNewAngle():void {
			var destPoint:Point = new Point(mouseX, mouseY);
			var distanceX:Number = destPoint.x - Trash.initialPosition.x;
			var distanceY:Number = destPoint.y - Trash.initialPosition.y;
			var newAngle:Number = Math.atan2(distanceY, distanceX);	
			if (newAngle <= GameProperties.ANGLE_TOP)  {
				_angle = GameProperties.ANGLE_TOP;
			} else if (newAngle >= GameProperties.ANGLE_BOTTOM) {
				_angle = GameProperties.ANGLE_BOTTOM;
			} else {
				_angle = newAngle;
			}
		}
		
		private function trashMouseDown(e:MouseEvent):void {
			_powering = true;
		}
		
		private function trashMouseUp(e:MouseEvent):void {
			if (_powering) {
				_powering = false;
				updatePowerBar();
				setNewAngle();
				removePlayerListeners();			
				UserModel.instance.player.state = PlayerStatesEnum.SHOOTING;
				_mcPlayer.addEventListener('player_hit', onPlayerHit);
				_mcPlayer.addEventListener('player_ready', onPlayerReady);
				_mcPlayer.gotoAndPlay(1);	
			}			
		}
		
		private function onPlayerHit(e:Event):void {
			_mcPlayer.removeEventListener('player_hit', onPlayerHit);
			_poweringArrow.visible = false;
			_currentTrash.shot(new b2Vec2((_power * Math.cos(_angle)) / 4, (_power * Math.sin(_angle)) / 4));
		}
		
		private function onPlayerReady(e:Event):void {
			_mcPlayer.removeEventListener('player_ready', onPlayerHit);
			_mcTrashCont.addChild(createTrash());
			DisplayUtil.bringToFront(_poweringArrow);
			_poweringArrow.visible = true;
			UserModel.instance.player.state = PlayerStatesEnum.READY;
			addPlayerListeners();
		}
		
		private function addFloor(w:Number,h:Number,px:Number,py:Number):void {
			var floorShape:b2PolygonShape = new b2PolygonShape();
			floorShape.SetAsBox(w/_worldScale,h/_worldScale);
			
			var floorFixture:b2FixtureDef = new b2FixtureDef();
			floorFixture.density=0;
			floorFixture.friction=10;
			floorFixture.restitution=0.1;
			floorFixture.shape=floorShape;
		
			var floorBodyDef:b2BodyDef = new b2BodyDef();
			px = px / worldScale;
			py = (py + h) / worldScale;
			floorBodyDef.position.Set(px,py);
			floorBodyDef.userData={assetName:"wall",assetSprite:null,remove:false};
			
			var floor:b2Body=_world.CreateBody(floorBodyDef);
			floor.CreateFixture(floorFixture);
		}
		
		public function keyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.RIGHT) {
				UserModel.instance.changeWeapon(e.charCode == Keyboard.LEFT);
			}
		}
		
		public function get worldScale():int 
		{
			return _worldScale;
		}
		
		private function updateWorld(e:Event):void {
			updatePowerBar();
			
			_world.Step(1 / 30, 6, 2);
			/*
			// Chequea que la basura se fue de pantalla y la resetea
			if (_trash.position.x > 800 || _trash.position.y > 600) {
				destroyTrash();
				createTrash();

				_power = 0;
			}
			*/
			
			for (var currentBody:b2Body = _world.GetBodyList(); currentBody; currentBody = currentBody.GetNext()) {
				if (currentBody.GetUserData()) {
					if (currentBody.GetUserData().assetSprite != null) {
						currentBody.GetUserData().assetSprite.x=currentBody.GetPosition().x*_worldScale;
						currentBody.GetUserData().assetSprite.y = currentBody.GetPosition().y * _worldScale;
						currentBody.GetUserData().assetSprite.rotation = currentBody.GetAngle() * (180 / Math.PI);
					}
					if (currentBody.GetUserData().remove) {
						if (currentBody.GetUserData().assetSprite!=null) {
							removeChild(currentBody.GetUserData().assetSprite);
						}
						_world.DestroyBody(currentBody);
					}
					
					if (currentBody.GetUserData().hits != null) {
						var hits:int = currentBody.GetUserData().hits;
						if (hits == 0) {
							if (Boolean(b2BodyTrashMap[currentBody])) {
								destroyTrash(b2BodyTrashMap[currentBody] as Trash);								
							}
						}
					}
				}
			}
			if (_following) {
				var posX:Number=_currentTrash.x;
				posX=stage.stageWidth/2-posX;
				if (posX>0) {
					posX=0;
				}
				if (posX<-800) {
					posX=-800;
				}
				x=posX;
			}
			/*
			World.ClearForces();
			World.DrawDebugData();
			*/
			_world.ClearForces();
			_world.DrawDebugData();
		}
		
		private function updatePowerBar():void {
			if (_powering) {
				_power += GameProperties.POWER_INCREMENT;
				if (_power > 100) {
					_power = 100;
				}
				_poweringArrow.gotoAndStop(_power);
			} else {
				_poweringArrow.gotoAndStop(1);
			}
		}
		
		private function addPlayerListeners():void {
			if (!this.hasEventListener(MouseEvent.MOUSE_MOVE)) {
				addEventListener(MouseEvent.MOUSE_MOVE, trashMoved);				
			}
			if (!this.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				addEventListener(MouseEvent.MOUSE_DOWN, trashMouseDown);
			}
			if (!this.hasEventListener(MouseEvent.MOUSE_UP)) {
				addEventListener(MouseEvent.MOUSE_UP, trashMouseUp);
			}
		}

		private function removePlayerListeners():void {
			removeEventListener(MouseEvent.MOUSE_MOVE, trashMoved);
			removeEventListener(MouseEvent.MOUSE_DOWN, trashMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, trashMouseUp);
			
		}
		
		private function createTrash():Trash {
			
			var itemDef:ItemDefinition = getTrash();
			var trash:Trash = new Trash(itemDef);
			trash.init(_world, _worldScale);
			_trashList.push(trash);
			_power = 0;
			_currentTrash = trash;
			b2BodyTrashMap[trash.getb2Body()] = trash;
			return trash;
		}
		
		private function destroyTrash(trash:Trash):void {
			if (Boolean(trash.parent)) {
				trash.parent.removeChild(trash);
			}
			var i:int = _trashList.indexOf(trash);
			if (i > -1) {
				_trashList.slice(i, 1);
			}
			delete b2BodyTrashMap[trash];
			trash.destroy();
		}
	}
}