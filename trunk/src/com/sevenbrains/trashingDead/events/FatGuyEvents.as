package com.sevenbrains.trashingDead.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class FatGuyEvents extends Event 
	{
		
		public static const THREW_TRASH:String = "threw_trash";
		
		private var _newValue:Object;
		private var _oldValue:Object;
		
	public function FatGuyEvents(type:String, newValue:Object = null, oldValue:Object = null) 
		{ 
			super(type);
			_newValue = newValue;
			_oldValue = oldValue;
		} 
		
		public function get newValue():Object
		{
			return _newValue;
		}
		
		public function get oldValue():Object
		{
			return _oldValue;
		}
		
	}
	
}