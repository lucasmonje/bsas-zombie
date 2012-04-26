package client 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import client.b2.Box;
	import client.b2.BoxBuilder;
	import client.b2.Clientb2ContactListener;
	import client.b2.PhysicInformable;
	import client.definitions.PhysicDefinition;
	import client.entities.Floor;
	import client.entities.Trash;
	import client.entities.Zombie;
	import client.enum.AssetsEnum;
	import client.enum.PhysicObjectType;
	import client.enum.PlayerStatesEnum;
	import client.events.PlayerEvents;
	import client.managers.DamageAreaManager;
	import client.managers.ItemManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import client.managers.GameTimer;
	/*
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class World extends Sprite {
		
		private var _assetLoader:AssetLoader;
		private var _damageArea:DamageAreaManager;
		private var _userModel:UserModel;
		private var _gameTimer:GameTimer;
		
		private var _trashLayer:Sprite;
		private var _zombiesLayer:Sprite;
		private var _debugLayer:Sprite;
		private var _playerLayer:Sprite;
		private var _backgroundLayer:Sprite;
		
		private var _bg:MovieClip;
		private var _player:MovieClip;
		private var _physicWorld:b2World;
		private var _currentTrash:Trash;
		private var _customContact:b2ContactListener;
		private var _stageInitialBounds:Rectangle;
		
		private var _itemManager:ItemManager;
		
		public function World() {
			_backgroundLayer = createLayer();
			_playerLayer = createLayer();
			_debugLayer = createLayer();
			_zombiesLayer = createLayer();
			_trashLayer = createLayer();
			initModels();
		}
		
		private function createLayer():Sprite {
			var layer:Sprite = new Sprite();
			layer.mouseEnabled = false;
			addChild(layer);
			return layer;
		}
		
		private function initModels():void {
			_assetLoader = AssetLoader.instance;
			_damageArea = DamageAreaManager.instance;
			_userModel = UserModel.instance;
			_gameTimer = GameTimer.instance;
		}
		
		public function init():void {
			_physicWorld =  new b2World(new b2Vec2(0, 10), true);
			_customContact = new Clientb2ContactListener();
			_physicWorld.SetContactListener(_customContact);
			_itemManager = new ItemManager();
			
			// Carga el Stage
			var stageClass:Class = _assetLoader.getAssetDefinition(AssetsEnum.BACKGROUND_01, "Asset") as Class;
			_bg = new stageClass();
			_backgroundLayer.addChild(_bg);
			_stageInitialBounds = _bg.getBounds(null);
		
			//add floor
			var floor:MovieClip = _bg.getChildByName("mcFloor") as MovieClip;
			var box:Box = BoxBuilder.build(new Rectangle(floor.x, floor.y, floor.width, floor.height), _physicWorld, GameProperties.WORLD_SCALE, false, new PhysicDefinition(0, 10, 0.1), { assetName:"wall", assetSprite:null, remove:false, type: PhysicObjectType.FLOOR, entity:new Floor("C", [])} );
			box.SetActive(true);
			_physicWorld.registerBox(box);
			
			var playerClass:Class = _assetLoader.getAssetDefinition(AssetsEnum.PLAYER_01, "Asset") as Class;
			_player = new playerClass();
			_userModel.player.initPlayer(_player);
			_playerLayer.addChild(_player);
			
			_damageArea.init();
			addChild(_damageArea.content);
			
			_currentTrash = _itemManager.createRandomTrash(_userModel.player.trashPosition);
			_trashLayer.addChild(_currentTrash);
			
			_userModel.player.state = PlayerStatesEnum.READY;
			
			_userModel.player.addEventListener(PlayerEvents.TRASH_HIT, onShootTrash);
			_userModel.player.addEventListener(PlayerEvents.THREW_ITEM, onThrewItem);
			
			_gameTimer.callMeEvery(GameProperties.TIMER_UPDATE, updateWorld);
			_gameTimer.callMeEvery(GameProperties.ZOMBIE_MAKE_TIME, makeZombie);
			_gameTimer.start();			
			
			if (GameProperties.DEBUG_MODE) {
				setDebugMode();
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function makeZombie():void {
			var z:Zombie = _itemManager.createZombie(new Point(_stageInitialBounds.width/2, 350));
			if (z) {
				_zombiesLayer.addChild(z);
			}
		}
		
		private function setDebugMode():void {
			var debug:b2DebugDraw = new b2DebugDraw();
			var sprite:Sprite = new Sprite();
			debug.SetSprite(sprite);
			debug.SetDrawScale( 1 / GameProperties.WORLD_SCALE);
			debug.SetFlags(b2DebugDraw.e_shapeBit);
			_physicWorld.SetDebugDraw(debug);
			_debugLayer.addChild(sprite);
		}
		
		private function onShootTrash(e:PlayerEvents):void {
			var power:Number = _userModel.player.power;
			var angle:Number = _userModel.player.angle;
			
			_currentTrash.shot(new b2Vec2((power * Math.cos(angle)) / 4, (power * Math.sin(angle)) / 4));
			_userModel.player.state = PlayerStatesEnum.READY;
			_currentTrash = _itemManager.createRandomTrash(_userModel.player.trashPosition);
			_trashLayer.addChild(_currentTrash);
		}
		
		private function onThrewItem(e:PlayerEvents):void {
			var power:Number = UserModel.instance.player.power;
			var angle:Number = UserModel.instance.player.angle;
			
			var item:Trash = _itemManager.createItem(e.newValue, _userModel.player.trashPosition);
			item.shot(new b2Vec2((power * Math.cos(angle)) / 4, (power * Math.sin(angle)) / 4));
			_userModel.player.state = PlayerStatesEnum.READY;
		}
		
		private function updateWorld():void {
			_physicWorld.Step(1 / GameProperties.WORLD_SCALE, 6, 2);
			_itemManager.update();
			
			for (var currentBody:b2Body = _physicWorld.GetBodyList(); currentBody; currentBody = currentBody.GetNext()) {
				
				var bodyInfo:PhysicInformable = currentBody as PhysicInformable;
				
				if (bodyInfo && bodyInfo.userData) {
					var view:DisplayObject = bodyInfo.userData.assetSprite;
					if (view != null) {						
						var pos:b2Vec2 = currentBody.GetPosition();
						var rotation:Number = currentBody.GetAngle() * (180 / Math.PI);
						
						if (bodyInfo.type == PhysicObjectType.ZOMBIE) {
							if ((pos.x * GameProperties.WORLD_SCALE) > _userModel.player.wagonPosition.x) {
								pos.x = pos.x - bodyInfo.speed;
								currentBody.SetPosition(pos);								
							}
						}
						view.rotation = rotation;
						view.x = pos.x * GameProperties.WORLD_SCALE;
						view.y = pos.y * GameProperties.WORLD_SCALE;
					}
				}
			}
			_physicWorld.ClearForces();
			_physicWorld.DrawDebugData();
		}
		
		public function get physicWorld():b2World  {
			return _physicWorld;
		}
	}
}