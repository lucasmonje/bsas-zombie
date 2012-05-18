package com.sevenbrains.trashingDead.events 
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
		public static const THREW_TRASH:String = "threw_trash";
		public static const DROP_TRASH:String = "drop_trash";
		
		private var _value1:*;
		private var _value2:*;
		private var _value3:*;
		
		public function PlayerEvents(type:String, value1:* = null, value2:* = null, value3:* = null) 
		{ 
			super(type);
			_value1 = value1;
			_value2 = value2;
			_value3 = value3;
		} 
		
		public function get value1():* 
		{
			return _value1;
		}
		
		public function get value2():*
		{
			return _value2;
		}
		
		public function get value3():* 
		{
			return _value3;
		}
		
	}
	
}