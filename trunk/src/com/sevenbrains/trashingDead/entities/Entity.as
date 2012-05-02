package com.sevenbrains.trashingDead.entities 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.managers.AssetLoader;
	import com.sevenbrains.trashingDead.b2.BoxBuilder;
	import com.sevenbrains.trashingDead.b2.CircleBuilder;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.utils.MathUtils;
	import com.sevenbrains.trashingDead.b2.PhysicInformable;
	import com.sevenbrains.trashingDead.b2.Box;
	import com.sevenbrains.trashingDead.b2.Circle;
	import com.sevenbrains.trashingDead.utils.B2Utils;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Entity extends Sprite implements Destroyable, Collisionable
	{
		private var _physicWorld:b2World;
		private var _worldScale:int;
		
		protected var _compositionMap:Dictionary;
		private var _assetsList:Vector.<MovieClip>;
		private var _physicMapView:MovieClip;
		private var _joints:Dictionary;
		
		private var _props:ItemDefinition;
		
		protected var _type:String;
		protected var _groupIndex:int;
		protected var _initialPosition:Point;
		protected var _speed:Number;
		protected var _hits:uint;
		protected var _life:int;
		protected var _bounds:Rectangle;
		
		public function Entity(props:ItemDefinition, initialPosition:Point, type:String, groupIndex:int = 1) 
		{
			_props = props;
			_type = type;
			_groupIndex = groupIndex;
			_initialPosition = initialPosition;
			_speed = MathUtils.getRandom(_props.itemProps.speedMin, _props.itemProps.speedMax);
			_hits = _props.itemProps.hits;
			_life = _props.itemProps.life;
		}
		
		public function init():void {
			_physicWorld = WorldModel.instance.currentWorld.physicWorld;
			_worldScale = GameProperties.WORLD_SCALE;
			
			_compositionMap = new Dictionary();
			_compositionMap.arrayMode = new Array();
			_assetsList = new Vector.<MovieClip>();
			
			var PhysicMapViewClass:Class = ConfigModel.assets.getAssetDefinition(_props.name, "PhysicDefinition");
			_physicMapView = new PhysicMapViewClass();
			
			var anchors:Vector.<MovieClip> = new Vector.<MovieClip>();
			var assetClass:Class;
			var bounds:Rectangle;
			var asset:MovieClip;
			for (var i:uint = 0; i < _physicMapView.numChildren; i++) {
					
				var dispObj:DisplayObject = _physicMapView.getChildAt(i);
				
				if (dispObj is MovieClip) {
					
					var mc:MovieClip = dispObj as MovieClip;
					var type:String = mc.name.split("_").shift().toString().toLowerCase();
					bounds = new Rectangle(_initialPosition.x + dispObj.x, _initialPosition.y + dispObj.y, dispObj.width, dispObj.height);
					
					if (type.indexOf("box") > -1) {
						assetClass = ConfigModel.assets.getAssetDefinition(_props.name, mc.name);
						if (Boolean(assetClass)) {
							asset = new assetClass();
							addChild(asset);							
							_assetsList.push(asset);
						} else {
							//trace("[WARM] DEFINITION NOT FOUND: '" + mc.name + "' IN " + _zombieName)
						}
						
						var box:Box = BoxBuilder.build(bounds, _physicWorld, _worldScale, true, _props.physicProps, getUserData(asset), _groupIndex);
						box.SetActive(false);
						_physicWorld.registerBox(box);
						_compositionMap[mc.name] = box;
						_compositionMap.arrayMode.push(box);
						
					} else if (type.indexOf("circle") > -1) {
						assetClass = ConfigModel.assets.getAssetDefinition(_props.name, mc.name);
						if (Boolean(assetClass)) {
							asset = new assetClass();
							addChild(asset);							
							_assetsList.push(asset);
						}
						
						var circle:Circle = CircleBuilder.build(bounds, _physicWorld, _worldScale, true, _props.physicProps, getUserData(asset), _groupIndex);
						circle.SetActive(false);
						_physicWorld.registerCircle(circle);
						_compositionMap[mc.name] = circle;
						_compositionMap.arrayMode.push(circle);
						
					} else if (type.indexOf("anchor") > -1) {
						anchors.push(mc);
					}
				}
			}
			
			_joints = new Dictionary();
			for each (var anchor:MovieClip in anchors) {
				var bodies:Array = anchor.name.split("_");
				if (!Boolean(_compositionMap[bodies[1]]) || !Boolean(_compositionMap[bodies[2]])) { 
					throw new Error("anchor mal hecho: " + anchor.name);
				}
						
				var body1:b2Body = _compositionMap[bodies[1]];
				var body2:b2Body = _compositionMap[bodies[2]];
				
				_joints[anchor.name] = B2Utils.setRevoluteJoint(body1, body2, new b2Vec2((anchor.x + _initialPosition.x)/_worldScale, (anchor.y + _initialPosition.y)/_worldScale), _physicWorld);	
			}

			
			for each (var physicObj:b2Body in _compositionMap.arrayMode) {
				physicObj.SetActive(true);
			}
		}
		
		public function destroyJoint(name:String):void {
			if (_joints[name]){
				_physicWorld.DestroyJoint(_joints[name]);
				delete _joints[name];
			}
		}
		
		public function get props():ItemDefinition 
		{
			return _props;
		}
		
		/**
		 * Devuelve si el arma esta activa.
		 * Corresponde a los locks que tenga.
		 */
		public function isEnabled():Boolean {
			return true;
		}
		
		private function getUserData(asset:MovieClip):Object {
			var obj:Object = new Object();
			obj.assetSprite = asset;
			obj.entity = this;
			return obj;
		}
		
		public function get compositionMap():Dictionary {
			return _compositionMap;
		}
		
		public function get life():int 
		{
			return _life;
		}
		
		public function get hits():uint 
		{
			return _hits;
		}
		
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function getItemPosition():Point {
			var body:b2Body = _compositionMap.arrayMode[0];
			return new Point(body.GetPosition().x * _worldScale, body.GetPosition().y * _worldScale);
		}
		
		public function getBodyPosition():Point {
			var body:b2Body = _compositionMap.arrayMode[0];
			return new Point(body.GetPosition().x, body.GetPosition().y);
		}
		
		public function destroy():void {
			for each (var body:PhysicInformable in _compositionMap.arrayMode) {
				_physicWorld.DestroyBody(body as b2Body);				
			}
			
			if (Boolean(this.parent)) {
				this.parent.removeChild(this);
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
			var whoHits:int = who is Entity?Entity(who).hits:1;

			if ((_life - whoHits) >= 0){
				_life-=whoHits;
			}else {
				_life = 0;
			}
		}
		
		public function isCollisioning(who:Collisionable):Boolean {
			return getCollisionAccept().indexOf(who.getCollisionId()) > -1;
		}
		
		public function updatePosition():void {
			for each (var currentBody:b2Body in _compositionMap.arrayMode) {
				var bodyInfo:PhysicInformable = currentBody as PhysicInformable;
				var view:DisplayObject = bodyInfo.userData.assetSprite;
				var pos:b2Vec2 = currentBody.GetPosition();
				var rotation:Number = currentBody.GetAngle() * (180 / Math.PI);
				view.rotation = rotation;
				view.x = pos.x * GameProperties.WORLD_SCALE;
				view.y = pos.y * GameProperties.WORLD_SCALE;
			}
		}
	}

}