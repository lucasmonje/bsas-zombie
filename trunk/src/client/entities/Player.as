package client.entities 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import client.enum.PlayerStatesEnum;
	/**
	 * ...
	 * @author lmonje
	 */
	public class Player extends EventDispatcher 
	{
		
		private var _state:String;
		
		public function Player() {
			_state = PlayerStatesEnum.WAITING;
		}
		
		public function get state():String {
			return _state;
		}
		
		public function set state(value:String):void {
			if (_state != value) {
				_state = value;	
				dispatchEvent(new Event("state_changed"));
			}
		}
		
	}

}