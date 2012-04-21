package client.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class PlayerEvents extends Event 
	{
		
		public static const CHANGE_WEAPON:String = "change_weapon";
		public static const TRASH_HIT:String = "trash_hit";
		public static const STATE_CHANGED:String = "state_changed";
		public static const THREW_ITEM:String = "threw_item";
		
		private var _newValue:String;
		private var _oldValue:String;
		
		public function PlayerEvents(type:String, newValue:String = '', oldValue:String = '') 
		{ 
			super(type);
			_newValue = newValue;
			_oldValue = oldValue;
		} 
		
		public function get newValue():String 
		{
			return _newValue;
		}
		
		public function get oldValue():String 
		{
			return _oldValue;
		}
		
	}
	
}