package com.sevenbrains.trashingDead.entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import com.sevenbrains.trashingDead.b2.Box;
	import com.sevenbrains.trashingDead.b2.BoxBuilder;
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	import com.sevenbrains.trashingDead.managers.AssetLoader;
	import com.sevenbrains.trashingDead.managers.DamageAreaManager;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Trash extends Sprite implements Destroyable, Collisionable {
		
		public var _initPos:Point;
		
		private var _props:ItemDefinition;
		
		private var _mc:MovieClip;
		private var _box:Box;
		
		private var _physicWorld:b2World;
		private var _worldScale:int;
		
		private var _hits:int;
		private var _life:int;
		
		public function Trash(props:ItemDefinition, initialPosition:Point) {
			_props = props;
			_initPos = initialPosition;
			_hits = props.itemProps.hits;
			_life = props.itemProps.life;
		}
		
		public function init():void {
			_physicWorld = WorldModel.instance.currentWorld.physicWorld;
			_worldScale = GameProperties.WORLD_SCALE;
			
			var cAsset:Class = AssetLoader.instance.getAssetDefinition(AssetsEnum.COMMONS, _props.name);
			_mc = new cAsset();
			addChild(_mc);
			
			_box = BoxBuilder.build(new Rectangle(_initPos.x + _mc.x, _initPos.y + _mc.y, _mc.width, _mc.height),  _physicWorld, _worldScale, true, _props.physicProps, getUserData(_mc) );
			_box.SetActive(false);
			_physicWorld.registerBox(_box);
		}
		
		private function getUserData(asset:MovieClip):Object {
			var obj:Object = new Object();
			obj.assetName = _props.name;
			obj.assetSprite = asset;
			obj.remove = false;
			obj.type = PhysicObjectType.TRASH;
			obj.entity = this;
			return obj;
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
		
		public function get hits():int 
		{
			return _hits;
		}
		
		public function get props():ItemDefinition 
		{
			return _props;
		}
		
		public function shot(vel:b2Vec2):void {
			_box.SetActive(true);
			_box.SetLinearVelocity(vel);
			_box.SetAngularDamping(10);
		}
		
		public function isDestroyed():Boolean {
			return _life == 0;
		}
		
		public function destroy():void {
			
			if (Boolean(this.parent)) {
				this.parent.removeChild(this);
			}
			
			_physicWorld.DestroyBody(_box);
		}
		
		public function getCollisionId():String {
			return _props.itemProps.collisionId;
		}
		
		public function getCollisionAccept():Array {
			return _props.itemProps.collisionAccepts.concat();
		}
		
		public function collide(who:Collisionable):void {
			if (_life > 0) {
				_life--;
				if (_life == 0 && props.type == 'handable') {
					DamageAreaManager.instance.addDamageArea(new Point(_box.GetPosition().x, _box.GetPosition().y), props.damageAreaProps);
				}
			}
		}
		
		public function isCollisioning(who:Collisionable):Boolean {
			return getCollisionAccept().indexOf(who.getCollisionId()) > -1;
		}
	}

}