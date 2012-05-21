package com.sevenbrains.trashingDead.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class AnimationsEvent extends Event 
	{
		public static const ANIMATION_ENDED:String = "animation_ended";
		
		private var _value:String;
		
		public function AnimationsEvent(type:String, value:String) 
		{ 
			super(type);
			_value = value;
		} 
		
		public function get value():String 
		{
			return _value;
		}
		
	}
	
}