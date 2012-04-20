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
		
		private var _newValue:String;
		private var _oldValue:String;
		
		public function PlayerEvents(type:String, newValue:String, oldValue:String) 
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