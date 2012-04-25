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
	import client.definitions.ItemDefinition;
	import client.definitions.PhysicDefinition;
	import client.entities.Floor;
	import client.entities.Trash;
	import client.entities.Zombie;
	import client.enum.AssetsEnum;
	import client.enum.PhysicObjectType;
	import client.enum.PlayerStatesEnum;
	import client.events.PlayerEvents;
	import client.managers.GameTimer;
	import client.managers.ItemManager;
	import client.utils.DisplayUtil;
	import client.utils.MathUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/*
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class World extends Sprite {
		
		private static const DEBUG_MODE:Boolean = false;
		private static const PHYSICS_SCALE:Number = 1 / 30;
		private static const TIMER_UPDATE:int = 1000 / 30;
		private static const ZOMBIE_MAKE_TIME:Number = 2000;
		private static const MAX_ZOMBIES_IN_SCREEN:Number = 12;
		
		private var _world:b2World;
		private var _worldScale:int = 30;
		private var _customContact:b2ContactListener;
		private var _mcStage:MovieClip;
		private var _mcTrashCont:MovieClip;
		private var _mcZombieCont:MovieClip;
		private var _mcDebug:MovieClip;
		private var _currentTrash:Trash;
		private var _trashList:Vector.<Trash>;		
		private var _zombieList:Vector.<Zombie>;		
		private var _following:Boolean;
		private var _bodiesMap:Dictionary;
		private var _trashPosition:Point;
		private var _wagonPosition:Point;
		private var _stageInitialBounds:Rectangle;
		
		private var _itemManager:ItemManager;
		
		public function World() {
		}
		
		public function init():void {
			_world =  new b2World(new b2Vec2(0, 10), true);
			_customContact = new Clientb2ContactListener();
			_world.SetContactListener(_customContact);
			_bodiesMap = new Dictionary();
			_trashList = new Vector.<Trash>();
			_zombieList = new Vector.<Zombie>();
			_itemManager = new ItemManager(_world, _worldScale);
			
			// Carga el Stage
			var stageClass:Class = AssetLoader.instance.getAssetDefinition(AssetsEnum.STAGE01, "stage01") as Class;
			_mcStage = new stageClass();
			_stageInitialBounds = _mcStage.getBounds(null);
			
			_mcTrashCont = _mcStage.getChildByName("mcTrashCont") as MovieClip;
			_mcZombieCont = _mcStage.getChildByName("mcZombieCont") as MovieClip;
			_mcDebug = _mcStage.getChildByName("mcDebug") as MovieClip;
			UserModel.instance.player.initPlayer(_mcStage);
			
			//add floor
			var floor:MovieClip = _mcStage.getChildByName("mcFloor") as MovieClip;
			var box:Box = BoxBuilder.build(new Rectangle(floor.x, floor.y, floor.width, floor.height), _world, _worldScale, false, new PhysicDefinition(0, 10, 0.1), { assetName:"wall", assetSprite:null, remove:false, type: PhysicObjectType.FLOOR, entity:new Floor("C", [])} );
			box.SetActive(true);
			_world.registerBox(box);
						
			var mcTrashPosition:MovieClip = _mcStage.getChildByName("mcTrashPosition") as MovieClip;
			_trashPosition = new Point(mcTrashPosition.x, mcTrashPosition.y);
			DisplayUtil.remove(mcTrashPosition);
			
			var mcWagonPosition:MovieClip = _mcStage.getChildByName("mcWagonPosition") as MovieClip;
			_wagonPosition = new Point(mcWagonPosition.x, mcWagonPosition.y);
			DisplayUtil.remove(mcWagonPosition);
			
			createTrash(_trashPosition);
			
			UserModel.instance.player.state = PlayerStatesEnum.READY;
			
			addChild(_mcStage);
			
			UserModel.instance.player.addEventListener(PlayerEvents.TRASH_HIT, onShootTrash);
			UserModel.instance.player.addEventListener(PlayerEvents.THREW_ITEM, onThrewItem);
			dispatchEvent(new Event(Event.COMPLETE));
			
			if (DEBUG_MODE) {
				setDebugMode();
			}
			GameTimer.instance.callMeEvery(TIMER_UPDATE, updateWorld);
			GameTimer.instance.callMeEvery(ZOMBIE_MAKE_TIME, makeZombie);
			GameTimer.instance.start();
		}
		
		private function makeZombie():void {
			if (_zombieList.length < MAX_ZOMBIES_IN_SCREEN) {
				createZombie(new Point(_stageInitialBounds.width/2, 350));				
			}
		}
		
		private function setDebugMode():void {
			var debug:b2DebugDraw = new b2DebugDraw();
			var sprite:Sprite = new Sprite();
			debug.SetSprite(sprite);
			debug.SetDrawScale(1 / PHYSICS_SCALE);
			debug.SetFlags(b2DebugDraw.e_shapeBit);
			_world.SetDebugDraw(debug);
			_mcDebug.addChild(sprite);
		}
		
		private function onShootTrash(e:PlayerEvents):void {
			
			var power:Number = UserModel.instance.player.power;
			var angle:Number = UserModel.instance.player.angle;
			
			_currentTrash.shot(new b2Vec2((power * Math.cos(angle)) / 4, (power * Math.sin(angle)) / 4));
			UserModel.instance.player.state = PlayerStatesEnum.READY;
			createTrash(_trashPosition);
		}
		
		private function onThrewItem(e:PlayerEvents):void {
			var power:Number = UserModel.instance.player.power;
			var angle:Number = UserModel.instance.player.angle;
			
			var item:Trash = createItem(e.newValue);
			item.shot(new b2Vec2((power * Math.cos(angle)) / 4, (power * Math.sin(angle)) / 4));
			UserModel.instance.player.state = PlayerStatesEnum.READY;
		}
		
		public function get worldScale():int {
			return _worldScale;
		}
		
		private function updateWorld():void {
			_world.Step(1 / _worldScale, 6, 2);
			
			// Chequea por items destruidos
			for each(var trash:Trash in _trashList) {
				if (trash.isDestroyed()) {
					trash.destroy();
				}
			}
			
			for each(var zombie:Zombie in _zombieList) {
				if (zombie.isDestroyed()) {
					destroyZombie(zombie);
				}
			}
			
			for (var currentBody:b2Body = _world.GetBodyList(); currentBody; currentBody = currentBody.GetNext()) {
				
				var bodyInfo:PhysicInformable = currentBody as PhysicInformable;
				
				if (bodyInfo && bodyInfo.userData) {
					if (bodyInfo.userData.assetSprite != null) {						

						var pos:b2Vec2 = currentBody.GetPosition();
						var rotation:Number = currentBody.GetAngle() * (180 / Math.PI);
						
						
						if (bodyInfo.type == PhysicObjectType.ZOMBIE) {
							if (rotation > 90 || rotation < -90) {
								destroyZombie(_bodiesMap[currentBody] as Zombie);
								return;
							}
							if ((pos.x * _worldScale) > _wagonPosition.x) {
								pos.x = pos.x - bodyInfo.speed;
								currentBody.SetPosition(pos);								
							}
						}
						bodyInfo.userData.assetSprite.rotation = rotation;
						bodyInfo.userData.assetSprite.x = pos.x * _worldScale;
						bodyInfo.userData.assetSprite.y = pos.y * _worldScale;
					}
					
					
					if (bodyInfo.userData.remove) {
						if (bodyInfo.userData.assetSprite != null) {
							removeChild(currentBody.GetUserData().assetSprite);
						}
						_world.DestroyBody(currentBody);
					}
					
				}
			}
			
			if (_following) {
				var posX:Number = _currentTrash.x;
				posX = stage.stageWidth / 2 - posX;
				if (posX > 0) {
					posX = 0;
				}
				if (posX < -800) {
					posX = -800;
				}
				x = posX;
			}
			_world.ClearForces();
			_world.DrawDebugData();
		}
		
		private function createItem(itemName:String):Trash {
			var itemDef:ItemDefinition = ApplicationModel.instance.getWeaponByName(itemName);
			if (!itemDef) {
				throw new Error("No existe el item a arrojar");
			}
			
			var item:Trash = new Trash(itemDef, _trashPosition);
			item.init(_world, _worldScale);
			_trashList.push(item);
			_bodiesMap[item.box] = item;
			_mcTrashCont.addChild(item);
			
			return item;
		}
		
		private function getTrash():ItemDefinition {
			var items:Array = ApplicationModel.instance.getTrashes().concat();
			return items[MathUtils.getRandomInt(1, items.length) - 1];
		}
		
		private function createTrash(initialPosition:Point):void {
			var itemDef:ItemDefinition = getTrash();
			var trash:Trash = new Trash(itemDef, initialPosition);
			trash.init(_world, _worldScale);
			_currentTrash = trash;
			_mcTrashCont.addChild(trash);
			_trashList.push(trash);
		}
		
		private function createZombie(initialPosition:Point):void {
			var itemDef:ItemDefinition = ApplicationModel.instance.getZombies()[0];
			
			var zombie:Zombie = new Zombie(itemDef);
			zombie.init(_world, _worldScale, initialPosition);
			_zombieList.push(zombie);
			
			for each (var body:PhysicInformable in zombie.compositionMap.arrayMode) {
				_bodiesMap[body] = zombie;
			}
			_mcZombieCont.addChild(zombie);
		}
		
		private function destroyZombie(zombie:Zombie):void {
			if (!zombie) {
				return;
			}
			
			if (Boolean(zombie.parent)) {
				zombie.parent.removeChild(zombie);
			}
			var i:int = _zombieList.indexOf(zombie);
			if (i > -1) {
				_zombieList.splice(i, 1);
			}
			
			for each (var body:PhysicInformable in zombie.compositionMap.arrayMode) {
				delete _bodiesMap[body];
			}
			zombie.destroy();
		}
	}
}