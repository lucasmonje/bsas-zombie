package client 
{
	import adobe.utils.CustomActions;
	import Box2D.Collision.IBroadPhase;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2Contact;
	import client.b2.Box;
	import client.b2.BoxBuilder;
	import client.b2.Circle;
	import client.b2.Clientb2ContactListener;
	import client.b2.PhysicInformable;
	import client.definitions.ItemAffectingAreaDefinition;
	import client.definitions.ItemDefinition;
	import client.definitions.PhysicDefinition;
	import client.definitions.PhysicDefinition;
	import client.entities.AffectingArea;
	import client.entities.Trash;
	import client.entities.Zombie;
	import client.enum.PlayerStatesEnum;
	import client.events.PlayerEvents;
	import client.utils.B2Utils;
	import client.utils.MathUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import client.b2.CircleBuilder;
	import client.utils.DisplayUtil;
	import client.enum.AssetsEnum;
	/*
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class World extends Sprite {
		
		private static const DEBUG_MODE:Boolean = true;
		private static var PHYSICS_SCALE:Number = 1 / 30;
		
		private var _world:b2World;
		private var _worldScale:int = 30;
		private var customContact:b2ContactListener;
		private var mcStage:MovieClip;
		private var _mcTrashCont:MovieClip;
		private var _mcZombieCont:MovieClip;
		private var _mcDebug:MovieClip;
		private var _currentTrash:Trash;
		private var _currentItem:Trash;
		private var _trashList:Vector.<Trash>;		
		private var _zombieList:Vector.<Zombie>;		
		private var _following:Boolean;
		private var b2BodyTrashMap:Dictionary;
		private var _affectingAreas:Vector.<AffectingArea>;
		private var _trashPosition:Point;
		
		public function World() {
		}
		
		public function init():void {
			_world =  new b2World(new b2Vec2(0, 10), true);
			customContact = new Clientb2ContactListener();
			_world.SetContactListener(customContact);
			b2BodyTrashMap = new Dictionary();
			_trashList = new Vector.<Trash>();
			_zombieList = new Vector.<Zombie>();
			_affectingAreas = new Vector.<AffectingArea>();
			
			// Carga el Stage
			var stageClass:Class = AssetLoader.instance.getAssetDefinition(AssetsEnum.STAGE01, "stage01") as Class;
			mcStage = new stageClass();
			
			_mcTrashCont = mcStage.getChildByName("mcTrashCont") as MovieClip;
			_mcZombieCont = mcStage.getChildByName("mcZombieCont") as MovieClip;
			_mcDebug = mcStage.getChildByName("mcDebug") as MovieClip;
			UserModel.instance.player.initPlayer(mcStage);
			
			//add floor
			var floor:MovieClip = mcStage.getChildByName("mcFloor") as MovieClip;
			var box:Box = BoxBuilder.build(new Rectangle(floor.x, floor.y,floor.width, floor.height), _world, _worldScale, false, new PhysicDefinition(0, 10, 0.1), {assetName:"wall",assetSprite:null,remove:false});
			box.SetActive(true);
			_world.registerBox(box);
						
			var mcTrashPosition:MovieClip = mcStage.getChildByName("mcTrashPosition") as MovieClip;
			_trashPosition = new Point(mcTrashPosition.x, mcTrashPosition.y);
			DisplayUtil.remove(mcTrashPosition);
			
			createTrash(_trashPosition);
			createZombie();
			
			UserModel.instance.player.state = PlayerStatesEnum.READY;
			
			addChild(mcStage);
			
			addEventListener(Event.ENTER_FRAME, updateWorld);
			UserModel.instance.player.addEventListener(PlayerEvents.TRASH_HIT, onShootTrash);
			UserModel.instance.player.addEventListener(PlayerEvents.THREW_ITEM, onThrewItem);
			dispatchEvent(new Event(Event.COMPLETE));
			
			if (DEBUG_MODE) {
				setDebugMode();
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
			
			_currentItem = createItem(e.newValue);
			_currentItem.shot(new b2Vec2((power * Math.cos(angle)) / 4, (power * Math.sin(angle)) / 4));
			UserModel.instance.player.state = PlayerStatesEnum.READY;
		}
		
		public function get worldScale():int {
			return _worldScale;
		}
		
		private function updateWorld(e:Event):void {
			_world.Step(1 / _worldScale, 6, 2);
			
			for (var currentBody:b2Body = _world.GetBodyList(); currentBody; currentBody = currentBody.GetNext()) {
				
				var data:Object = currentBody.GetUserData();
				if (Boolean(data)) {
					if (data.assetSprite != null && currentBody is PhysicInformable) {						
						var bodyInfo:PhysicInformable = currentBody as PhysicInformable;
						var pos:b2Vec2 = currentBody.GetPosition();
						data.assetSprite.rotation = currentBody.GetAngle() * (180 / Math.PI);
						data.assetSprite.x = pos.x * _worldScale;
						data.assetSprite.y = pos.y * _worldScale;
					}
					if (data.remove) {
						if (currentBody.GetUserData().assetSprite!=null) {
							removeChild(currentBody.GetUserData().assetSprite);
						}
						_world.DestroyBody(currentBody);
					}
					
					if (data.hits != null) {
						var hits:int = data.hits;
						if (hits == 0) {
							if (Boolean(b2BodyTrashMap[currentBody])) {
								destroyTrash(b2BodyTrashMap[currentBody] as Trash);								
							}
						}
					}
				}
			}
			
			// Chequea las colisiones
			checkCollisions();
			
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
		
		/**
		 * Chequea las colisiones entre los objetos fisicos
		 */
		private function checkCollisions():void {
			if (_world.GetContactCount() > 0) {
				var contact:b2Contact = _world.GetContactList();
				
				if (!contact) {
					return;
				}
				
				// Colision de un item con affecting area. Lo agrega a la lista de areas afectadas
				var bodyCollided:b2Body;
				var areaAffectedDef:ItemAffectingAreaDefinition;
				var areaAffected:AffectingArea;
				
				var userDataA:Object = contact.GetFixtureA().GetBody().GetUserData();
				var userDataB:Object = contact.GetFixtureB().GetBody().GetUserData();
				if ((userDataA && ItemDefinition(userDataA.props) && ItemDefinition(userDataA.props).type == 'handable') &&
				   !(userDataB && ItemDefinition(userDataB.props) && ItemDefinition(userDataB.props).type == 'battable')) {
					trace("Objeto A es un item! " + ItemDefinition(userDataA.props).name);
					bodyCollided = contact.GetFixtureA().GetBody();
					areaAffectedDef = ItemDefinition(userDataA.props).areaAffecting;
					areaAffected = new AffectingArea(new Point(bodyCollided.GetPosition().x, bodyCollided.GetPosition().y), areaAffectedDef.radius, areaAffectedDef.times, areaAffectedDef.hit, _worldScale);
					_affectingAreas.push(areaAffected);
					addChild(areaAffected.content);
					destroyTrash(_currentItem);
				}else if ((userDataB && ItemDefinition(userDataB.props) && ItemDefinition(userDataB.props).type == 'handable') &&
				   !(userDataA && ItemDefinition(userDataA.props) && ItemDefinition(userDataA.props).type == 'battable')) {
					trace("Objeto B es un item! " + ItemDefinition(userDataB.props).name);
					bodyCollided = contact.GetFixtureB().GetBody();
					areaAffectedDef = ItemDefinition(userDataB.props).areaAffecting;
					areaAffected = new AffectingArea(new Point(bodyCollided.GetPosition().x, bodyCollided.GetPosition().y), areaAffectedDef.radius, areaAffectedDef.times, areaAffectedDef.hit, _worldScale);
					_affectingAreas.push(areaAffected);
					addChild(areaAffected.content);
					destroyTrash(_currentItem);
				}
			}
		}
			
		private function createItem(itemName:String):Trash {
			var itemDef:ItemDefinition = ApplicationModel.instance.getWeaponByName(itemName);
			if (!itemDef) {
				throw new Error("No existe el item a arrojar");
			}
			
			var item:Trash = new Trash(itemDef, _trashPosition);
			item.init(_world, _worldScale);
			_trashList.push(item);
			b2BodyTrashMap[item.box] = item;
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
			_trashList.push(trash);
			_currentTrash = trash;
			b2BodyTrashMap[trash.box] = trash;
			_mcTrashCont.addChild(trash);
		}
		
		private function createZombie():void {
			var zombie:Zombie = new Zombie("zombie01", new PhysicDefinition(10, 0.3, 0.1));
			zombie.init(_world, _worldScale, new Point(500, 350));
			_zombieList.push(zombie);
			_mcZombieCont.addChild(zombie);
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