package com.sevenbrains.trashingDead.display {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import com.sevenbrains.trashingDead.b2.Box;
	import com.sevenbrains.trashingDead.b2.BoxBuilder;
	import com.sevenbrains.trashingDead.b2.Clientb2ContactListener;
	import com.sevenbrains.trashingDead.b2.PhysicInformable;
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.definitions.PhysicDefinition;
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.definitions.WorldEntitiesDefinition;
	import com.sevenbrains.trashingDead.entities.Floor;
	import com.sevenbrains.trashingDead.entities.Item;
	import com.sevenbrains.trashingDead.entities.Trash;
	import com.sevenbrains.trashingDead.entities.Zombie;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.enum.ClassStatesEnum;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.enum.PlayerStatesEnum;
	import com.sevenbrains.trashingDead.events.PlayerEvents;
	import com.sevenbrains.trashingDead.interfaces.Screenable;
	import com.sevenbrains.trashingDead.managers.AssetLoader;
	import com.sevenbrains.trashingDead.managers.DamageAreaManager;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.managers.ItemManager;
	import com.sevenbrains.trashingDead.models.ApplicationModel;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	import com.sevenbrains.trashingDead.utils.MathUtils;
	import com.sevenbrains.trashingDead.utils.StageReference;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	/*
	* ...
	* @author Fulvio Crescenzi
	*/
	public class World extends Sprite implements Screenable {
		
		private var _props:WorldDefinition;
		
		private var _assetLoader:AssetLoader;
		private var _gameTimer:GameTimer;
		private var _userModel:UserModel;
		private var _worldModel:WorldModel;
		private var _damageArea:DamageAreaManager;
		private var _itemManager:ItemManager;
		
		private var _trashLayer:Sprite;
		private var _zombiesLayer:Sprite;
		private var _debugLayer:Sprite;
		private var _playerLayer:Sprite;
		private var _backgroundLayer:Sprite;
		private var _uiLayer:Sprite;
		
		private var _bg:MovieClip;
		private var _player:MovieClip;
		private var _physicWorld:b2World;
		private var _customContact:b2ContactListener;
		private var _stageInitialBounds:Rectangle;
		
		private var _state:String;
		private var _data:String;
		
		private var _currentTrash:Trash;
		private var _currentTrashZooming:Trash;
		
		private var _worldWidth:Number;
		private var _worldHeight:Number;
		
		public function World(props:WorldDefinition) {
			_props = props;
			_backgroundLayer = createLayer();
			_playerLayer = createLayer();
			_debugLayer = createLayer();
			_zombiesLayer = createLayer();
			_trashLayer = createLayer();
			_uiLayer = createLayer();
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
			_worldModel = WorldModel.instance;
		}
		
		public function init():void {
			_physicWorld = new b2World(new b2Vec2(0, 10), true);
			_customContact = new Clientb2ContactListener();
			_physicWorld.SetContactListener(_customContact);
			_itemManager = new ItemManager();
			// Carga el Stage
			var stageClass:Class = _assetLoader.getAssetDefinition(_props.background, "Asset") as Class;
			_bg = new stageClass();
			_backgroundLayer.addChild(_bg);
			_stageInitialBounds = _bg.getBounds(null);
			//add floor
			var floor:MovieClip = _bg.getChildByName("mcFloor") as MovieClip;
			_worldModel.floorRect = new Rectangle(floor.x, floor.y, floor.width, floor.height);
			var floorData:Object = new Object();
			floorData.assetSprite = null;
			floorData.entity = new Floor("C", [], PhysicObjectType.FLOOR);
			var box:Box = BoxBuilder.build(_worldModel.floorRect, _physicWorld, GameProperties.WORLD_SCALE, false, new PhysicDefinition(0, 10, 0.1), floorData);
			box.SetActive(true);
			_physicWorld.registerBox(box);
			DisplayUtil.remove(floor);
			
			_userModel.player.initPlayer();
			_playerLayer.addChild(_userModel.player);
			
			_damageArea.init();
			addChild(_damageArea.content);
			_currentTrash = _itemManager.createRandomTrash(_userModel.player.trashPosition);
			_trashLayer.addChild(_currentTrash);
			_userModel.player.state = PlayerStatesEnum.READY;
			_userModel.player.addEventListener(PlayerEvents.TRASH_HIT, onShootTrash);
			_userModel.player.addEventListener(PlayerEvents.THREW_ITEM, onThrewItem);
			_gameTimer.callMeEvery(GameProperties.TIMER_UPDATE, updateWorld);
			_gameTimer.callMeEvery(_props.zombieTimeCreation, makeZombie);
			_gameTimer.start();
			if (GameProperties.DEBUG_MODE) {
				setDebugMode();
			}
			
			_uiLayer.addChild(UserModel.instance.player.throwingArea); 
			
			_worldWidth = this.width;
			_worldHeight = this.height;
			
			_state = ClassStatesEnum.RUNNING;
			
			StageReference.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ESCAPE) {
				_state = ClassStatesEnum.DESTROYING;
			}
		}
		
		private function zooming(out:Boolean):void {
			var v:Number = GameProperties.ZOOM_VAR;
			if (out && (this.width - v >= StageReference.stage.stageWidth)) {
				this.scaleX -= v;
				this.scaleY -= v;
			}else if (!out && this.scaleX < 1){
				this.scaleX += v;
				this.scaleY += v;
			}
		}
		
		private function makeZombie():void {
			if (_itemManager.getZombieAmount() < _props.zombieMaxInScreen) {
				var wzd:WorldEntitiesDefinition;
				var code:uint;
				var weight:uint = 1;
				for each (wzd in _props.zombies) {
					weight += wzd.weight;
				}
				var rnd:Number = MathUtils.getRandom(1, weight);
				weight = 1;
				for each (wzd in _props.zombies) {
					weight += wzd.weight;
					if (rnd <= weight) {
						code = wzd.code;
						break;
					}
				}
				var zombieProps:ItemDefinition = ApplicationModel.instance.getZombieByCode(code);
				var pos:Point = new Point(_stageInitialBounds.width / 2, _worldModel.floorRect.y - (_worldModel.floorRect.height / 2));
				var z:Zombie = _itemManager.createZombie(zombieProps, pos);
				_zombiesLayer.addChild(z);
			}
		}
		
		private function setDebugMode():void {
			var debug:b2DebugDraw = new b2DebugDraw();
			var sprite:Sprite = new Sprite();
			debug.SetSprite(sprite);
			var scale:Number = 1 / GameProperties.WORLD_SCALE;
			debug.SetDrawScale(1 / scale);
			debug.SetFlags(b2DebugDraw.e_shapeBit);
			_physicWorld.SetDebugDraw(debug);
			_debugLayer.addChild(sprite);
		}
		
		private function onShootTrash(e:PlayerEvents):void {
			var power:Number = _userModel.player.power;
			var angle:Number = _userModel.player.angle;
			_currentTrash.shot(new b2Vec2((power * Math.cos(angle)) / 4, (power * Math.sin(angle)) / 4));
			_userModel.player.state = PlayerStatesEnum.READY;
			_currentTrashZooming = _currentTrash;
			_currentTrash = _itemManager.createRandomTrash(_userModel.player.trashPosition);
			_trashLayer.addChild(_currentTrash);
		}
		
		private function onThrewItem(e:PlayerEvents):void {
			var power:Number = UserModel.instance.player.power;
			var angle:Number = UserModel.instance.player.angle;
			var item:Item = _itemManager.createItem(e.newValue, _userModel.player.trashPosition);
			item.shot(new b2Vec2((power * Math.cos(angle)) / 4, (power * Math.sin(angle)) / 4));
			addChild(item);
			_userModel.player.state = PlayerStatesEnum.READY;
		}
		
		private function updateWorld():void {
			if (_currentTrashZooming && !_currentTrashZooming.isDestroyed()) {
				zooming(true);
			}else {
				zooming(false);
			}
			
			if (_currentTrashZooming && (_currentTrashZooming.getItemPosition().x > _worldWidth || _currentTrashZooming.getItemPosition().y > _worldHeight)) {
				_currentTrashZooming.destroy();
				_currentTrashZooming = null;
			}
			
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
		
		public function get physicWorld():b2World {
			return _physicWorld;
		}
		
		public function get state():String {
			return _state;
		}
		
		public function get data():String {
			return _data;
		}
		
		public function destroy():void {
			for (var currentBody:b2Body = _physicWorld.GetBodyList(); currentBody; currentBody = currentBody.GetNext()) {
				_physicWorld.DestroyBody(currentBody);
			}
			_currentTrash.destroy();
			_damageArea.destroy();
			_itemManager.destroy();
			while (numChildren > 0) {
				removeChildAt(0);
			}
		}
	}
}