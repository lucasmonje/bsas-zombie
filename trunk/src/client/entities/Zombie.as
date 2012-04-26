package client.entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import client.AssetLoader;
	import client.b2.Box;
	import client.b2.BoxBuilder;
	import client.b2.Circle;
	import client.b2.CircleBuilder;
	import client.b2.PhysicInformable;
	import client.definitions.ItemDefinition;
	import client.enum.PhysicObjectType;
	import client.GameProperties;
	import client.interfaces.Collisionable;
	import client.utils.B2Utils;
	import client.utils.MathUtils;
	import client.WorldModel;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import client.interfaces.Destroyable;
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class Zombie extends Sprite implements Destroyable, Collisionable {
		
		private var _physicMapView:MovieClip;
		private var _compositionMap:Dictionary;
		private var _physicWorld:b2World;
		private var _worldScale:int;
		private var _assetsList:Vector.<MovieClip>;
		private var _props:ItemDefinition;
		private var _speed:Number;
		private var _hits:uint;
		private var _life:int;
		private var _initialPosition:Point;
		
		public function Zombie(props:ItemDefinition, initialPosition:Point) {
			_props = props;
			_hits = _props.itemProps.hits;
			_life = _props.itemProps.life;
			_initialPosition = initialPosition;
			_speed = MathUtils.getRandom(_props.itemProps.speedMin, _props.itemProps.speedMax);
		}
		
		public function init():void {
			_physicWorld = WorldModel.instance.currentWorld.physicWorld;
			_worldScale = GameProperties.WORLD_SCALE;
			
			_compositionMap = new Dictionary();
			_compositionMap.arrayMode = new Array();
			_assetsList = new Vector.<MovieClip>();
			
			var PhysicMapViewClass:Class = AssetLoader.instance.getAssetDefinition(_props.name, "PhysicDefinition");
			_physicMapView = new PhysicMapViewClass();
			var defBounds:Rectangle = _physicMapView.getBounds(null);
			
			var anchors:Vector.<MovieClip> = new Vector.<MovieClip>();
			var assetClass:Class;
			var bounds:Rectangle;
			var asset:MovieClip;
			for (var i:uint = 0; i < _physicMapView.numChildren; i++) {
					
				var dispObj:DisplayObject = _physicMapView.getChildAt(i);
				
				if (dispObj is MovieClip) {
					
					var mc:MovieClip = dispObj as MovieClip;
					var type:String = mc.name.split("_").shift().toString().toLowerCase();
					
					if (type.indexOf("box") > -1) {
						bounds = new Rectangle(dispObj.x + _initialPosition.x, dispObj.y + _initialPosition.y, dispObj.width, dispObj.height);
						assetClass = AssetLoader.instance.getAssetDefinition(_props.name, mc.name);
						if (Boolean(assetClass)) {
							asset = new assetClass();
							addChild(asset);							
							_assetsList.push(asset);
						} else {
							//trace("[WARM] DEFINITION NOT FOUND: '" + mc.name + "' IN " + _zombieName)
						}
						
						var box:Box = BoxBuilder.build(bounds, _physicWorld, _worldScale, true, _props.physicProps, getUserData(asset), -1);
						box.SetActive(false);
						_physicWorld.registerBox(box);
						_compositionMap[mc.name] = box;
						_compositionMap.arrayMode.push(box);
						
					} else if (type.indexOf("circle") > -1) {
						bounds = new Rectangle(dispObj.x + _initialPosition.x, dispObj.y + _initialPosition.y, dispObj.width, dispObj.height);
						assetClass = AssetLoader.instance.getAssetDefinition(_props.name, mc.name);
						if (Boolean(assetClass)) {
							asset = new assetClass();
							addChild(asset);							
							_assetsList.push(asset);
						}
						
						var circle:Circle = CircleBuilder.build(bounds, _physicWorld, _worldScale, true, _props.physicProps, getUserData(asset));
						circle.SetActive(false);
						_physicWorld.registerCircle(circle);
						_compositionMap[mc.name] = circle;
						_compositionMap.arrayMode.push(circle);
						
					} else if (type.indexOf("anchor") > -1) {
						anchors.push(mc);
					}
				}
			}
			
			for each (var anchor:MovieClip in anchors) {
				var bodies:Array = anchor.name.split("_");
				if (!Boolean(_compositionMap[bodies[1]]) || !Boolean(_compositionMap[bodies[2]])) { 
					throw new Error("anchor mal hecho: " + anchor.name);
				}
						
				var body1:b2Body = _compositionMap[bodies[1]];
				var body2:b2Body = _compositionMap[bodies[2]];
				
				B2Utils.setRevoluteJoint(body1, body2, new b2Vec2((anchor.x + _initialPosition.x)/_worldScale, (anchor.y + _initialPosition.y)/_worldScale), _physicWorld);	
			}

			
			for each (var physicObj:PhysicInformable in _compositionMap.arrayMode) {
				if (physicObj is Box) {
					Box(physicObj).SetActive(true);
				} else {
					Circle(physicObj).SetActive(true);
				}
			}
			
		}
		
		private function getUserData(asset:MovieClip):Object {
			var obj:Object = new Object();
			obj.assetName = _props.name;
			obj.assetSprite = asset;
			obj.remove = false;
			obj.type = PhysicObjectType.ZOMBIE;
			obj.speed = _speed;
			obj.entity = this;
			return obj;
		}
		
		private function sortByPosition(obj1:PhysicInformable, obj2:PhysicInformable):int {
			
			if (obj1.initialStageBounds.y > obj2.initialStageBounds.y) {
				return -1;
			} else if (obj1.initialStageBounds.y < obj2.initialStageBounds.y) {
				return 1;
			}
			return 0; 
		}
		
		public function get compositionMap():Dictionary {
			return _compositionMap;
		}
		
		
		public function destroy():void {
			for each (var body:PhysicInformable in _compositionMap.arrayMode) {
				_physicWorld.DestroyBody(body as b2Body);				
			}
		}
		
		public function isDestroyed():Boolean {
			return _life == 0;
		}
		
		public function getCollisionId():String {
			return _props.itemProps.collisionId;
		}
		
		public function getCollisionAccept():Array {
			return _props.itemProps.collisionAccepts.concat();
		}
		
		public function collide(who:Collisionable):void {
			if (Trash(who)){
				if ((_life - Trash(who).hits) >= 0){
					_life-=Trash(who).hits;
				}else {
					_life = 0;
				}
			}
		}
		
		public function isCollisioning(who:Collisionable):Boolean {
			return getCollisionAccept().indexOf(who.getCollisionId()) > -1;
		}

	}

}