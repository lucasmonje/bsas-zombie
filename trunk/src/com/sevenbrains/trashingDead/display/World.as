//------------------------------------------------------------------------------
//
//	This software is the confidential and proprietary information of   
//	7 Brains. You shall not disclose such Confidential Information and   
//	shall use it only in accordance with the terms of the license   
//	agreement you entered into with 7 Brains.  
//	Copyright 2012 - 7 Brains. 
//	All rights reserved.  
//
//------------------------------------------------------------------------------
package com.sevenbrains.trashingDead.display {
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import com.sevenbrains.trashingDead.b2.Box;
	import com.sevenbrains.trashingDead.b2.BoxBuilder;
	import com.sevenbrains.trashingDead.b2.GamePhysicWorld;
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.definitions.PhysicDefinition;
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import com.sevenbrains.trashingDead.entities.Floor;
	import com.sevenbrains.trashingDead.enum.ClassStatesEnum;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.enum.PopupType;
	import com.sevenbrains.trashingDead.events.StageTimerEvent;
	import com.sevenbrains.trashingDead.genetators.ZombieGenerator;
	import com.sevenbrains.trashingDead.interfaces.Screenable;
	import com.sevenbrains.trashingDead.managers.DamageAreaManager;
	import com.sevenbrains.trashingDead.managers.EntityPathManager;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.managers.PanZoom;
	import com.sevenbrains.trashingDead.managers.PopupManager;
	import com.sevenbrains.trashingDead.managers.SoundManager;
	import com.sevenbrains.trashingDead.managers.StageTimer;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	import com.sevenbrains.trashingDead.utils.StageReference;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	
	/*
	* ...
	* @author Fulvio Crescenzi
	*/
	public class World extends Sprite implements Screenable {

		private var _backgroundLayer:Sprite;
		
		private var _callId:int;
		
		private var _damageArea:DamageAreaManager;
		
		private var _damageLayer:Sprite;
		
		private var _debugLayer:Sprite;
		
		private var _entityPathManager:EntityPathManager;
		
		private var _gameTimer:GameTimer;
		
		private var _physicWorld:GamePhysicWorld;
		
		private var _playerLayer:Sprite;
		
		private var _props:WorldDefinition;
		
		private var _state:String;
		
		private var _traceLayer:Sprite;
		
		private var _userModel:UserModel;
		
		private var _worldModel:WorldModel;
		
		private var _zombieGenerator:ZombieGenerator;
		
		private var _zombiesLayer:Sprite;
		
		public function World(props:WorldDefinition) {
			_props = props;
			_backgroundLayer = createLayer();
			_zombiesLayer = createLayer();
			_playerLayer = createLayer();
			_damageLayer = createLayer();
			_traceLayer = createLayer();
			_debugLayer = createLayer();
			initModels();
		}
		
		// Por interfaz screenable
		public function get data():String {
			return null;
		}
		
		public function destroy():void {
			for (var currentBody:b2Body = _physicWorld.GetBodyList(); currentBody; currentBody = currentBody.GetNext()) {
				_physicWorld.DestroyBody(currentBody);
			}
			_damageArea.destroy();
			_entityPathManager.destroy();
			
			while (numChildren > 0) {
				removeChildAt(0);
			}
			StageReference.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_gameTimer.cancelCall(_callId);
		}
		
		public function get entityPathManager():EntityPathManager {
			return _entityPathManager;
		}
		
		public function init():void {
			var gravivy:b2Vec2 = new b2Vec2(0, 10)
			_worldModel.gravity = gravivy;
			_physicWorld = new GamePhysicWorld(gravivy, true);
			// Carga el Stage
			var stageClass:Class = ConfigModel.assets.getDefinition(_props.background, "Asset") as Class;
			var bg:MovieClip = new stageClass();
			_backgroundLayer.addChild(bg);
			
			_worldModel.stageTimer = new StageTimer(_props.stageTime);
			_worldModel.panZoom = new PanZoom(this);
			//add floor
			var floor:MovieClip = bg.getChildByName("mcFloor") as MovieClip;
			_worldModel.floorRect = new Rectangle(floor.x, floor.y, floor.width, floor.height);
			var floorData:Object = new Object();
			floorData.assetSprite = null;
			floorData.entity = new Floor("C", [], PhysicObjectType.FLOOR);
			var box:Box = BoxBuilder.build(_worldModel.floorRect, _physicWorld, GameProperties.WORLD_SCALE, false, new PhysicDefinition(0, 10, 0.1), floorData);
			box.SetActive(true);
			_physicWorld.registerBox(box);
			DisplayUtil.remove(floor);
			// Inicializa los players
			_userModel.players.init();
			_playerLayer.addChild(_userModel.players);
			_entityPathManager = new EntityPathManager();
			_entityPathManager.init();
			_traceLayer.addChild(_entityPathManager.content);
			_damageArea.init();
			_damageLayer.addChild(_damageArea.content);
			_zombieGenerator = new ZombieGenerator();
			_zombieGenerator.init(_props.zombieTimeCreation, _props.zombieMaxInScreen, _props.zombies);
			_zombieGenerator.activate(true);
			
			if (GameProperties.DEBUG_MODE) {
				setDebugMode();
			}
			_state = ClassStatesEnum.RUNNING;
			StageReference.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_callId = _gameTimer.callMeEvery(GameProperties.TIMER_UPDATE, updateWorld);
			
			if (Boolean(_props.soundId)) {
				SoundManager.instance.play(_props.soundId);
			}
			_worldModel.stageTimer.addEventListener(StageTimerEvent.SECOND_ROUND, onSecondRound);
			_worldModel.stageTimer.addEventListener(StageTimerEvent.FINAL_ROUND, onFinalRound);
			_worldModel.stageTimer.start();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onSecondRound(e:StageTimerEvent):void {
			PopupManager.instance.addPopup(new Popup(PopupType.SECOND_ROUND), null, true, false);
		}
		
		private function onFinalRound(e:StageTimerEvent):void {
			PopupManager.instance.addPopup(new Popup(PopupType.FINAL_ROUND), null, true, false);
		}
		
		public function get physicWorld():b2World {
			return _physicWorld;
		}
		
		public function get playerLayer():Sprite {
			return _playerLayer;
		}
		
		public function get state():String {
			return _state;
		}
		
		public function get traceLayer():Sprite {
			return _traceLayer;
		}
		
		public function get zombiesLayer():Sprite {
			return _zombiesLayer;
		}
		
		private function createLayer():Sprite {
			var layer:Sprite = new Sprite();
			layer.mouseEnabled = false;
			addChild(layer);
			return layer;
		}
		
		private function initModels():void {
			_damageArea = DamageAreaManager.instance;
			_userModel = UserModel.instance;
			_gameTimer = GameTimer.instance;
			_worldModel = WorldModel.instance;
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ESCAPE) {
				_state = ClassStatesEnum.DESTROYING;
			}
		}
		
		private function setDebugMode():void {
			var debug:b2DebugDraw = new b2DebugDraw();
			var sprite:Sprite = new Sprite();
			debug.SetSprite(sprite);
			var scale:int = 1 / GameProperties.WORLD_SCALE;
			debug.SetDrawScale(1 / scale);
			debug.SetFlags(b2DebugDraw.e_shapeBit);
			_physicWorld.SetDebugDraw(debug);
			_debugLayer.addChild(sprite);
		}
		
		private function updateWorld():void {
			_physicWorld.Step(1 / GameProperties.WORLD_SCALE, 6, 2);
			_physicWorld.ClearForces();
			_physicWorld.DrawDebugData();
		}
	}
}