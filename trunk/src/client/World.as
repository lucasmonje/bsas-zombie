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
	import client.entities.Player;
	import client.definitions.ItemDefinition;
	import client.entities.Trash;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import client.enum.PlayerStatesEnum;
	import client.utils.MathUtils;
	import client.AssetLoader;
	import client.utils.DisplayUtil;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class World extends Sprite
	{
		[Embed (source = "resources\\assets\\stage01.swf", mimeType = "application/octet-stream")] private var _cAssets:Class;
		
		private var _world:b2World=new b2World(new b2Vec2(0,10),true);
		private var _worldScale:int = 30;
		
		private var customContact:b2ContactListener = new b2ContactListener()
		
		private var _assets:Loader;
		
		private var _background:MovieClip;
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
		
		private var _player:Player;
		
		public function World() 
		{
		}
		
		public function init():void {
			_world.SetContactListener(customContact);
			_power = 0;
			_trashList = new Vector.<Trash>();
			_assets = new Loader();
			_player = new Player();
			_assets.loadBytes(new _cAssets());
			_assets.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoded);
		}
		
		private function onAssetLoded(e:Event):void {
			// Carga el background
			var _cBackground:Class = _assets.contentLoaderInfo.applicationDomain.getDefinition("stage01") as Class;
			_background = new _cBackground();
			_poweringArrow = _background.getChildByName("mcPoweringContainer") as MovieClip;
			_mcTrashCont = _background.getChildByName("mcTrashCont") as MovieClip;
			_mcPlayer = _background.getChildByName("mcPlayer") as MovieClip;
			
			addChild(_background);

			Trash.initialPosition = new Point(_poweringArrow.x, _poweringArrow.y);
			
			var floor:MovieClip = _background.getChildByName("mcFloor") as MovieClip;
			addWall(floor.width, floor.height, floor.x, floor.y);
			
			addChild(_background);
			var newTrash:Trash = createTrash();
			_mcTrashCont.addChild(newTrash);
			
			DisplayUtil.bringToFront(_poweringArrow);
			_player.state = PlayerStatesEnum.READY;
			
			addPlayerListeners();
			addEventListener(Event.ENTER_FRAME, updateWorld);
			dispatchEvent(new Event(Event.COMPLETE));	
		}
		
		private function getThrowItemByType(type:String):ItemDefinition {
			var items:Array = ApplicationModel.instance.getItems().concat();
			var itemsFiltered:Array = [];
			for each(var itemDef:ItemDefinition in items) {
				if (itemDef.type == type) {
					itemsFiltered.push(itemDef);
				}
			}
			
			return itemsFiltered[MathUtils.getRandomInt(1, itemsFiltered.length) - 1];
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
				_player.state = PlayerStatesEnum.SHOOTING;
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
			_player.state = PlayerStatesEnum.READY;
			addPlayerListeners();
		}
		
		private function addWall(w:Number,h:Number,px:Number,py:Number):void {
			var floorShape:b2PolygonShape = new b2PolygonShape();
			floorShape.SetAsBox(w/_worldScale,h/_worldScale);
			
			var floorFixture:b2FixtureDef = new b2FixtureDef();
			floorFixture.density=0;
			floorFixture.friction=10;
			floorFixture.restitution=0.1;
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
			
			var items:Array = ApplicationModel.instance.getItems();
			var itemDef:ItemDefinition = getThrowItemByType('battable');
			var trash:Trash = new Trash(itemDef);
			trash.init(_world, _worldScale);
			_trashList.push(trash);
			_power = 0;
			_currentTrash = trash;
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
			_currentTrash.destroy();
		}
	}
}