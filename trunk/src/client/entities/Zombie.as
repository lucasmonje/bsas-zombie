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
	import client.definitions.PhysicDefinition;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import client.utils.B2Utils;
	
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class Zombie extends Sprite {
		
		private var _zombieName:String;
		
		private var _physicMapView:MovieClip;
		
		private var _physicProps:PhysicDefinition;
		
		private var _hits:uint;
		
		private var _compositionMap:Dictionary;
		
		private var _world:b2World;
		
		private var _worldScale:int;
		
		private var _assetsList:Vector.<MovieClip>;
		
		public function Zombie(zombieName:String, physicProps:PhysicDefinition, hits:uint = 0) {
			_zombieName = zombieName;
			_physicProps = physicProps;
			_hits = hits;
		}
		
		public function init(world:b2World, worldScale:int, initialPosition:Point):void {
			_world = world;
			_worldScale = worldScale;
			_compositionMap = new Dictionary();
			_compositionMap.arrayMode = new Array();
			_assetsList = new Vector.<MovieClip>();
			
			var PhysicMapViewClass:Class = AssetLoader.instance.getAssetDefinition(_zombieName, "PhysicDefinition");
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
						bounds = new Rectangle(dispObj.x + initialPosition.x, dispObj.y + initialPosition.y, dispObj.width, dispObj.height);
						trace(mc.name + " " +bounds.toString());
						assetClass = AssetLoader.instance.getAssetDefinition(_zombieName, mc.name);
						asset = new assetClass();
						addChild(asset);
						_assetsList.push(asset);
						
						var box:Box = BoxBuilder.build(bounds, _world, _worldScale, true, _physicProps, getUserData(asset));
						box.SetActive(false);
						_world.registerBox(box);
						_compositionMap[mc.name] = box;
						_compositionMap.arrayMode.push(box);
						
					} else if (type.indexOf("circle") > -1) {
						bounds = new Rectangle(dispObj.x + initialPosition.x, dispObj.y + initialPosition.y, dispObj.width, dispObj.height);
						assetClass = AssetLoader.instance.getAssetDefinition(_zombieName, mc.name);
						asset = new assetClass();
						addChild(asset);
						_assetsList.push(asset);
						
						var circle:Circle = CircleBuilder.build(bounds, _world, _worldScale, true, _physicProps, getUserData(asset));
						circle.SetActive(false);
						_world.registerCircle(circle);
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
				
				B2Utils.setRevoluteJoint(body1, body2, new b2Vec2((anchor.x + initialPosition.x)/_worldScale, (anchor.y + initialPosition.y)/_worldScale), _world);	
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
			obj.assetName = _zombieName;
			obj.assetSprite = asset;
			obj.remove = false;
			if (_hits > 0) {
				obj.hits = _hits;
			}
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
		/*
		public function get position():Point {
			return new Point(_box.GetPosition().x * _worldScale, _box.GetPosition().y * _worldScale);
		}
		*/
	}

}