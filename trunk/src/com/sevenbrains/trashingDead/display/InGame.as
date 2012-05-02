package com.sevenbrains.trashingDead.display 
{
	import com.sevenbrains.trashingDead.display.MapWorld;
	import com.sevenbrains.trashingDead.enum.ClassStatesEnum;
	import com.sevenbrains.trashingDead.interfaces.Screenable;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.utils.StageReference;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.managers.SoundManager;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class InGame extends Sprite implements Screenable
	{	
		private static const NONE:String = "none";
		private static const MAP:String = "map";
		private static const WORLD:String = "world";
		
		private var _oldState:String;
		private var _state:String;
		
		private var _worldMap:MapWorld;
		private var _world:World;
		
		private var _currentLevel:int;
		private var _data:String;
		private var _actualScreen:String;
		
		private var _map:Dictionary;
		
		public function InGame() 
		{
		}
		
		public function init():void {
			_oldState = NONE;
			_state = WORLD;
			SoundManager.instance.setup();
			SoundManager.instance.play("intro");
			UserModel.instance.init();
			
			_worldMap = new MapWorld();
			_world = null;
			
			_worldMap.init();
			addChild(_worldMap);
			
			_map = new Dictionary();
			_map['world'] = new Dictionary();
			_map['world']['actual'] = null;
			_map['world'][ClassStatesEnum.DESTROYING] = 'worldMap';
			
			_map['worldMap'] = new Dictionary();
			_map['worldMap']['actual'] = _worldMap;
			_map['worldMap'][ClassStatesEnum.DESTROYING] = 'world';
			
			_actualScreen = 'worldMap';
			
			StageReference.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void {
			var screen:Screenable = _map[_actualScreen]['actual'];
			if (screen.state == ClassStatesEnum.DESTROYING) {
				_actualScreen = _map[_actualScreen][screen.state];
				if (_actualScreen == 'world') {
					_world = new World(ConfigModel.worlds.getWorldById(screen.data));
					WorldModel.instance.currentWorld = _world;
					_map['world']['actual'] = _world;
				}
				removeChild(Sprite(screen));
				screen.destroy();
				screen = _map[_actualScreen]['actual'];
				screen.init();
				addChild(Sprite(screen));
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ESCAPE) {
				if (_actualScreen == 'worldMap'){
					_state = ClassStatesEnum.DESTROYING;
				}
			}
		}
		
		private function changeState():void {
			switch(_state) {
				case WORLD:
					initWorld();
				break;
			}
		}
		
		private function initWorld():void {
			_world.addEventListener(Event.COMPLETE, onWorldLoaded);
			WorldModel.instance.currentWorld = _world;
			_world.init();
		}
		
		private function onWorldLoaded(e:Event):void {
			addChild(_worldMap);
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