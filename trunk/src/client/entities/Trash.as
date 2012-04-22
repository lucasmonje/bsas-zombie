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
		public var _initPos:Point;
		
		private var _props:ItemDefinition;
		
		private var _mc:MovieClip;
		private var _box:Box;
		
		private var _world:b2World;
		private var _worldScale:int;
		
		public function Trash(props:ItemDefinition, initialPosition:Point) {
			_props = props;
			_initPos = initialPosition;
		}
		
		public function init(world:b2World, worldScale:int):void {
			_world = world;
			_worldScale = worldScale;
			
			var cAsset:Class = AssetLoader.instance.getAssetDefinition("commonAssets", _props.name);
			_mc = new cAsset();
			addChild(_mc);
		
			_box = BoxBuilder.build(new Rectangle(_initPos.x + _mc.x - (_mc.width / 2), _initPos.y + _mc.y - (_mc.height/2), _mc.width, _mc.height),  _world, _worldScale, true, _props.physicProps, { assetName:_props.name, assetSprite:_mc, remove:false, props: _props} );
			_box.SetActive(false);
			_world.registerBox(_box);
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