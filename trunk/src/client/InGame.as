package client 
{
	import flash.display.Sprite;
	import flash.events.Event;
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
		
		public function InGame() 
		{
			_oldState = NONE;
			_state = WORLD;
			
			_world = new World();
			
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
			_world.init();
		}
		
		private function onWorldLoaded(e:Event):void {
			addChild(_world);
		}
		
		/* Escucha evento del mapa y le llega que nivel seleccionó
		private function levelSelecetd():void {
			
		}
		*/
	}

}