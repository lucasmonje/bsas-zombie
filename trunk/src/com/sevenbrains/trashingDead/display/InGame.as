package com.sevenbrains.trashingDead.display 
{
	import com.sevenbrains.trashingDead.models.UserModel;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.sevenbrains.trashingDead.models.WorldModel;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class InGame extends Sprite
	{	
		private static const NONE:String = "none";
		private static const MAP:String = "map";
		private static const WORLD:String = "world";
		
		private var _oldState:String;
		private var _state:String;
		
		private var _world:World;
		private var _hud:Hud;
		
		public function InGame() 
		{
			_oldState = NONE;
			_state = WORLD;
			
			UserModel.instance.init();
			
			_world = new World();
			_hud = new Hud();
			
			changeState();
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
	}

}