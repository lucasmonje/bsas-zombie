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
	import client.b2.Box;
	import client.b2.BoxBuilder;
	import client.b2.Clientb2ContactListener;
	import client.definitions.ItemDefinition;
	import client.definitions.PhysicDefinition;
	import client.definitions.PhysicDefinition;
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
	import client.utils.DisplayUtil;
	/*
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class World extends Sprite {
		
		private var _world:b2World;
		private var _worldScale:int = 30;
		private static var PHYSICS_SCALE:Number = 1 / 30;
		private var customContact:b2ContactListener;
		private var mcStage:MovieClip;
		private var _mcTrashCont:MovieClip;
		private var _currentTrash:Trash;
		private var _currentItem:Trash;
		private var _trashList:Vector.<Trash>;		
		private var _zombieList:Vector.<Zombie>;		
		private var _following:Boolean;
		private var b2BodyTrashMap:Dictionary;
		
		public function World() {
		}
		
		public function init():void {
			_world =  new b2World(new b2Vec2(0, 10), true);
			customContact = new Clientb2ContactListener();
			_world.SetContactListener(customContact);
			b2BodyTrashMap = new Dictionary();
			_trashList = new Vector.<Trash>();
			_zombieList = new Vector.<Zombie>();
			// Carga el background
			var _cBackground:Class = AssetLoader.instance.getAssetDefinition('stage01', "stage01") as Class;
			mcStage = new _cBackground();
			_mcTrashCont = mcStage.getChildByName("mcTrashCont") as MovieClip;
			
			UserModel.instance.player.initPlayer(mcStage);
			/*
			var body3:Box = BoxBuilder.build(new Rectangle(485, 400, 15, 100), _world, _worldScale, true, new PhysicDefinition(1, 0.3, 0.1));
			var body4:Box = BoxBuilder.build(new Rectangle(520, 400, 15, 100), _world, _worldScale, true, new PhysicDefinition(1, 0.3, 0.1));
			var body2:Box = BoxBuilder.build(new Rectangle(500, 300, 50, 100), _world, _worldScale, true, new PhysicDefinition(1, 0.3, 0.1));
			var box1:Box = BoxBuilder.build(new Rectangle(500, 250, 40, 50), _world, _worldScale, true, new PhysicDefinition(1, 0.3, 0.1));
			
			B2Utils.setRevoluteJoint(box1, body2, new b2Vec2(box1.initialWorldBounds.x + box1.initialWorldBounds.width/2, box1.initialWorldBounds.y + box1.initialWorldBounds.height), _world, -0.25, -0.25);
			B2Utils.setRevoluteJoint(body2, body3, new b2Vec2(body3.initialWorldBounds.x + body3.initialWorldBounds.width/2, body2.initialWorldBounds.y + body2.initialWorldBounds.height), _world, -0.75, 1);
			B2Utils.setRevoluteJoint(body2, body4, new b2Vec2(body4.initialWorldBounds.x + body4.initialWorldBounds.width/2, body2.initialWorldBounds.y + body2.initialWorldBounds.height), _world, -0.75, 1);
			*/
			
			var floor:MovieClip = mcStage.getChildByName("mcFloor") as MovieClip;
			addFloor(floor.width, floor.height, floor.x, floor.y);
			
			addChild(mcStage);
			var newTrash:Trash = createTrash();
			_mcTrashCont.addChildAt(newTrash, 0);
			
			var zombie:Zombie = createZombie();
			_mcTrashCont.addChild(zombie);
			
			UserModel.instance.player.state = PlayerStatesEnum.READY;
			
			var debug:b2DebugDraw = new b2DebugDraw();
			var sprite:Sprite = new Sprite();
			addChild(sprite);
			debug.SetSprite(sprite);
			debug.SetDrawScale(1 / PHYSICS_SCALE);
			debug.SetFlags(b2DebugDraw.e_shapeBit);
			_world.SetDebugDraw(debug);
			
			addEventListener(Event.ENTER_FRAME, updateWorld);
			
			UserModel.instance.player.addEventListener(PlayerEvents.TRASH_HIT, onShootTrash);
			UserModel.instance.player.addEventListener(PlayerEvents.THREW_ITEM, onThrewItem);
			
			dispatchEvent(new Event(Event.COMPLETE));	
		}
		
		private function onShootTrash(e:PlayerEvents):void {
			
			var power:Number = UserModel.instance.player.power;
			var angle:Number = UserModel.instance.player.angle;
			
			_currentTrash.shot(new b2Vec2((power * Math.cos(angle)) / 4, (power * Math.sin(angle)) / 4));
			UserModel.instance.player.state = PlayerStatesEnum.READY;
			createTrash();
		}
		
		private function onThrewItem(e:PlayerEvents):void {
			var power:Number = UserModel.instance.player.power;
			var angle:Number = UserModel.instance.player.angle;
			
			_currentItem = createItem(e.newValue);
			_currentItem.shot(new b2Vec2((power * Math.cos(angle)) / 4, (power * Math.sin(angle)) / 4));
			UserModel.instance.player.state = PlayerStatesEnum.READY;
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
		
		public function get worldScale():int {
			return _worldScale;
		}
		
		private function updateWorld(e:Event):void {
			_world.Step(1 / _worldScale, 6, 2);
			
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
			var itemDef:ItemDefinition;
			var items:Array = ApplicationModel.instance.getWeapons().concat();
			for each(var def:ItemDefinition in items) {
				if (def.name == itemName) {
					itemDef = def;
					break;
				}
			}
			
			if (!itemDef) {
				throw new Error("No existe el item a arrojar");
			}
			
			var trash:Trash = new Trash(itemDef);
			trash.init(_world, _worldScale);
			_trashList.push(trash);
			
			return trash;
		}
		
		
		private function getTrash():ItemDefinition {
			var items:Array = ApplicationModel.instance.getTrashes().concat();
			return items[MathUtils.getRandomInt(1, items.length) - 1];
		}
		
		private function createTrash():Trash {
			
			var itemDef:ItemDefinition = getTrash();
			var trash:Trash = new Trash(itemDef);
			trash.init(_world, _worldScale);
			_trashList.push(trash);
			_currentTrash = trash;
			b2BodyTrashMap[trash.box] = trash;
			return trash;
		}
		
		private function createZombie():Zombie {
			var zombie:Zombie = new Zombie("zombie01", new PhysicDefinition(10, 0.3, 0.1), 10);
			zombie.init(_world, _worldScale);
			_zombieList.push(zombie);
			return zombie;
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