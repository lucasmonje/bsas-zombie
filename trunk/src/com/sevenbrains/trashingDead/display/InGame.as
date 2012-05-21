package com.sevenbrains.trashingDead.display 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.sevenbrains.trashingDead.controller.event.ToggleMusicEvent;
	import com.sevenbrains.trashingDead.display.canvas.GameCanvas;
	import com.sevenbrains.trashingDead.enum.ClassStatesEnum;
	import com.sevenbrains.trashingDead.events.GameTimerEvent;
	import com.sevenbrains.trashingDead.interfaces.Screenable;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.managers.PopupManager;
	import com.sevenbrains.trashingDead.managers.SoundManager;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.utils.StageReference;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class InGame extends Sprite implements Screenable
	{	
		private static const STATE_LOADING:String = "loading";
		private static const STATE_MAP:String = "map";
		private static const STATE_LOAD_WORLD:String = "load_world";
		private static const STATE_WORLD:String = "world";
		
		private static const MINIMUM_LOADING_TIME:int = 100;
		
		private var _state:String;
		
		private var _worldMap:MapWorld;
		private var _world:World;
		private var _loading:Loading;
		private var _hud:Hud;
		
		private var _actualScreen:Screenable;
		private var _data:String;
		
		private var _map:Dictionary;
		
		private var _callId:int;
		
		private var _timeLoading:int;
		private var _worldIsLoaded:Boolean;
		
		public function InGame() 
		{
		}
		
		public function init():void {
			SoundManager.instance.setup();
			UserModel.instance.init();
			
			addChild(GameCanvas.instance.world);
			addChild(GameCanvas.instance.hud);
			addChild(GameCanvas.instance.popup);
			addChild(GameCanvas.instance.loading);
			
			CairngormEventDispatcher.getInstance().dispatchEvent(new ToggleMusicEvent());
			
			_world = null;
			
			_hud = new Hud();
			_hud.init();
			
			_worldMap = new MapWorld();
			_worldMap.init();
			
			_loading = new Loading();
			_loading.init();
			GameCanvas.instance.loading.addChild(_loading);
			GameCanvas.instance.loading.visible = false;
			
			_actualScreen = _worldMap;
			GameCanvas.instance.world.addChild(_actualScreen as DisplayObject);
			
			_state = STATE_MAP;
			
			PopupManager.instance.setLayer(GameCanvas.instance.popup);
			
			GameTimer.instance.addEventListener(GameTimerEvent.TIME_UPDATE, update);
		}

		private function update(e:GameTimerEvent):void {
			switch(_state) {
				case STATE_MAP:
					if (_actualScreen.state == ClassStatesEnum.DESTROYING) {
						GameCanvas.instance.loading.visible = true;
						_loading.activate(true);
						_timeLoading = 0;
						_worldIsLoaded = false;
						
						_state = STATE_LOAD_WORLD;
					}
					break;
				case STATE_LOAD_WORLD:
						_world = new World(ConfigModel.worlds.getWorldById(_actualScreen.data));
						WorldModel.instance.currentWorld = _world;
						_world.addEventListener(Event.COMPLETE, onWorldLoaded);
						_world.init();
						
						GameCanvas.instance.hud.addChild(_hud);
						
						_state = STATE_LOADING;
					break;
				case STATE_WORLD:
					if (_actualScreen.state == ClassStatesEnum.DESTROYING) {
						_worldMap = new MapWorld();
						_worldMap.init();
						changeScreen(_worldMap);
						
						GameCanvas.instance.hud.removeChild(_hud);
						
						_state = STATE_MAP;
					}
					break;
				case STATE_LOADING:
					_timeLoading++;
					if (_timeLoading >= MINIMUM_LOADING_TIME && _worldIsLoaded) {
						GameCanvas.instance.loading.visible = false;
						_loading.activate(false);
						_state = STATE_WORLD;
					}
					break;
			}
		}
		
		private function changeScreen(newScreen:Screenable):void {
			GameCanvas.instance.world.removeChild(_actualScreen as DisplayObject);
			_actualScreen.destroy();
			_actualScreen = newScreen;
			GameCanvas.instance.world.addChild(_actualScreen as DisplayObject);
		}
		
		private function onWorldLoaded(e:Event):void {
			changeScreen(_world);
			
			_worldIsLoaded = true;
		}
		
		public function destroy():void {
			GameTimer.instance.removeEventListener(GameTimerEvent.TIME_UPDATE, update);
			_world.removeEventListener(Event.COMPLETE, onWorldLoaded);
			
			if (_world.parent != null){
				removeChild(_world);
			}
			
			if (_worldMap.parent != null) {
				removeChild(_worldMap);
			}
			
			_worldMap.destroy();
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function get data():String 
		{
			return _data;
		}
	}

}