package com.sevenbrains.trashingDead.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Fulvio
	 */
	public class ThrowingAreaEvent extends Event 
	{
		public static const MOUSE_UP:String = "mouse_up";
		
		public function ThrowingAreaEvent(type:String) 
		{ 
			super(type);
			
		} 
		
		
	}
	
}