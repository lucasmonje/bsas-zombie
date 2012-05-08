package com.sevenbrains.trashingDead.display 
{
	import com.sevenbrains.trashingDead.display.MapWorld;
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import com.sevenbrains.trashingDead.enum.ClassStatesEnum;
	import com.sevenbrains.trashingDead.interfaces.Screenable;
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
	import com.sevenbrains.trashingDead.enum.PopupType;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class InGame extends Sprite implements Screenable
	{	
		private static const STATE_LOADING:String = "loading";
		private static const STATE_MAP:String = "map";
		private static const STATE_WORLD:String = "world";
		
		private var _state:String;
		
		private var _worldMap:MapWorld;
		private var _world:World;
		
		private var _gameLayer:Sprite;
		private var _loadingLayer:Sprite;
		private var _popupLayer:Sprite;
		
		private var _actualScreen:Screenable;
		private var _data:String;
		
		private var _map:Dictionary;
		
		private var _callId:int;
		
		public function InGame() 
		{
		}
		
		public function init():void {
			SoundManager.instance.setup();
			SoundManager.instance.play("intro");
			UserModel.instance.init();
			
			_gameLayer = new Sprite();
			_popupLayer = new Sprite();
			_loadingLayer = new Sprite();
			
			addChild(_gameLayer);
			addChild(_popupLayer);
			addChild(_loadingLayer);
			
			_world = null;
			
			_worldMap = new MapWorld();
			_worldMap.init();
			
			_actualScreen = _worldMap;
			_gameLayer.addChild(_actualScreen as DisplayObject);
			
			_state = STATE_MAP;
			
			_popupLayer = new Sprite();
			_popupLayer.mouseEnabled = false;
			
			PopupManager.instance.setLayer(_popupLayer);
			PopupManager.instance.addPopup(new Popup(PopupType.POPUP_MINUTES));
			
			StageReference.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_callId = GameTimer.instance.callMeEvery(1, update);
		}

		private function update():void {
			switch(_state) {
				case STATE_MAP:
					if (_actualScreen.state == ClassStatesEnum.DESTROYING) {
						_loadingLayer.visible = true;
						
						_world = new World(ConfigModel.worlds.getWorldById(_actualScreen.data));
						WorldModel.instance.currentWorld = _world;
						_world.addEventListener(Event.COMPLETE, onWorldLoaded);
						
						changeScreen(_world);
						
						_state = STATE_LOADING;
					}
					break;
				case STATE_WORLD:
					if (_actualScreen.state == ClassStatesEnum.DESTROYING) {
						_worldMap = new MapWorld();
						
						changeScreen(_worldMap);
						
						_state = STATE_MAP;
					}
					break;
			}
		}
		
		private function changeScreen(newScreen:Screenable):void {
			_gameLayer.removeChild(_actualScreen as DisplayObject);
			_actualScreen.destroy();
			_actualScreen = newScreen;
			_actualScreen.init();
			_gameLayer.addChild(_actualScreen as DisplayObject);
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ESCAPE) {
			}
		}
		
		private function onWorldLoaded(e:Event):void {
			_loadingLayer.visible = false;
			_state = STATE_WORLD;
		}
		
		public function destroy():void {
			StageReference.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_world.removeEventListener(Event.COMPLETE, onWorldLoaded);
			
			if (_world.parent != null){
				removeChild(_world);
			}
			
			if (_worldMap.parent != null) {
				removeChild(_worldMap);
			}
			
			_worldMap.destroy();
			
			GameTimer.instance.cancelCall(_callId);
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