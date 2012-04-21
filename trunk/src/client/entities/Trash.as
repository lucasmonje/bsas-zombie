package client.entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import client.AssetLoader;
	import client.b2.Box;
	import client.b2.BoxBuilder;
	import client.definitions.ItemDefinition;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Trash extends Sprite
	{
		public static var initialPosition:Point = new Point(250, 300);
		
		private var _props:ItemDefinition;
		
		private var _mc:MovieClip;
		private var _box:Box;
		
		private var _world:b2World;
		private var _worldScale:int;
		
		public function Trash(props:ItemDefinition) {
			_props = props;
		}
		
		public function init(world:b2World, worldScale:int):void {
			_world = world;
			_worldScale = worldScale;
			
			var cAsset:Class = AssetLoader.instance.getAssetDefinition("commonAssets", _props.name);
			_mc = new cAsset();
			addChild(_mc);
		
			var bounds:Rectangle = _mc.getBounds(null);
			bounds.x = initialPosition.x;
			bounds.y = initialPosition.y;
			_box = BoxBuilder.build(bounds, _world, _worldScale, true, _props.physicProps, { assetName:_props.name, assetSprite:_mc, remove:false, hits: _props.itemProps.hits } );
			_box.SetActive(false);
		}
		
		public function reset():void {
			_box.SetActive(false);
			_box.SetPosition(new b2Vec2(_box.initialWorldBounds.x, _box.initialWorldBounds.y));
		}

		public function get position():Point {
			return new Point(_box.GetPosition().x * _worldScale, _box.GetPosition().y * _worldScale);
		}
		
		public function get box():Box {
			return _box;
		}
		
		public function shot(vel:b2Vec2):void {
			_box.SetActive(true);
			_box.SetLinearVelocity(vel);
			_box.SetAngularDamping(10);
		}

		public function destroy():void {
			_world.DestroyBody(_box);
		}
	}

}