package com.sevenbrains.trashingDead.display 
{
	import com.sevenbrains.trashingDead.interfaces.Screenable;
	import com.sevenbrains.trashingDead.models.UserModel;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.models.ApplicationModel;
	import com.sevenbrains.trashingDead.enum.ClassStatesEnum;
	import com.sevenbrains.trashingDead.utils.StageReference;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
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
		
		private var _world:World;
		private var _hud:Hud;
		
		private var _currentLevel:int;
		
		public function InGame() 
		{
		}
		
		public function init():void {
			_oldState = NONE;
			_state = WORLD;
			
			UserModel.instance.init();
			
			_currentLevel = 0;
			
			_world = new World(ApplicationModel.instance.getWorlds()[_currentLevel]);
			_hud = new Hud();
			
			changeState();
			
			StageReference.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);			
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ESCAPE) {
				_state = ClassStatesEnum.DESTROYING;
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
			_hud.init();
			
			addChild(_world);
			addChild(_hud);
		}
		
		public function destroy():void {
			StageReference.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_world.removeEventListener(Event.COMPLETE, onWorldLoaded);
			removeChild(_world);
			removeChild(_hud);
			_world.destroy();
		}
		
		public function get state():String 
		{
			return _state;
		}
	}

}