package client.entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import client.AssetLoader;
	import client.b2.Box;
	import client.b2.BoxBuilder;
	import client.b2.Circle;
	import client.b2.CircleBuilder;
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
		
		public function Zombie(zombieName:String, physicProps:PhysicDefinition, hits:uint) {
			_zombieName = zombieName;
			_physicProps = physicProps;
			_hits = hits;
		}
		
		public function init(world:b2World, worldScale:int):void {
			_world = world;
			_worldScale = worldScale;
			_compositionMap = new Dictionary();
			_compositionMap.arrayMode = new Array();
			
			var PhysicMapViewClass:Class = AssetLoader.instance.getAssetDefinition(_zombieName, "PhysicDefinition");
			_physicMapView = new PhysicMapViewClass();
			var defBounds:Rectangle = _physicMapView.getBounds(null);
			
			var anchors:Vector.<MovieClip> = new Vector.<MovieClip>();
			var assetClass:Class;
			for (var i:uint = 0; i < _physicMapView.numChildren; i++) {
					
				var dispObj:DisplayObject = _physicMapView.getChildAt(i);
				
				if (dispObj is MovieClip) {
					
					var mc:MovieClip = dispObj as MovieClip;
					var bounds:Rectangle = mc.getBounds(null);
					bounds.x -= defBounds.x ;
					bounds.y -= defBounds.y;
					
					if (mc.name.substr(0, 3) == "box") {
					
						assetClass = AssetLoader.instance.getAssetDefinition(_zombieName, mc.name);
						var box:Box = BoxBuilder.build(bounds, _world, _worldScale, true, _physicProps, { assetName:_zombieName, assetSprite:new assetClass(), remove:false, hits: _hits } );
						box.SetActive(false);
						_compositionMap[mc.name] = box;
						_compositionMap.arrayMode.push(box);
						
					} else if (mc.name.substr(0, 6) == "circle") {
						
						assetClass = AssetLoader.instance.getAssetDefinition(_zombieName, mc.name);
						var circle:Circle = CircleBuilder.build(bounds, _world, _worldScale, true, _physicProps, { assetName:_zombieName, assetSprite:new assetClass(), remove:false, hits: _hits } );
						circle.SetActive(false);
						_compositionMap[mc.name] = circle;
						_compositionMap.arrayMode.push(circle);
						
					} else if (mc.name.substr(0, 6) == "anchor") {
						anchors.push(mc);
					}
				}
			}
			
			for each (var anchor:MovieClip in anchors) {
				var bodies:Array = anchor.name.split("_");
				if (!Boolean(_compositionMap[bodies[1]]) || !Boolean(_compositionMap[bodies[2]])) { 
					throw new Error("anchor mal hecho: " + anchor.name);
				}
				B2Utils.setRevoluteJoint(_compositionMap[bodies[1]], _compositionMap[bodies[2]], new b2Vec2(anchor.x, anchor.y), _world, -1, 1);	
			}
			
			
		}
		/*
		public function get position():Point {
			return new Point(_box.GetPosition().x * _worldScale, _box.GetPosition().y * _worldScale);
		}
		*/
	}

}