package client.entities 
{
	import client.events.PlayerEvents;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import client.enum.PlayerStatesEnum;
	/**
	 * ...
	 * @author lmonje
	 */
	public class Player extends EventDispatcher 
	{
		private var _actualWeapon:int;
		
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
		
		public function get actualWeapon():int 
		{
			return _actualWeapon;
		}
		
		public function set actualWeapon(value:int):void 
		{
			var old:int = _actualWeapon;
			_actualWeapon = value;
			dispatchEvent(new PlayerEvents(PlayerEvents.CHANGE_WEAPON, _actualWeapon.toString(), old.toString()));
		}
		
	}

}