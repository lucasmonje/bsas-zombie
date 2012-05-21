package com.sevenbrains.trashingDead.events
{
	import com.sevenbrains.trashingDead.display.popup.IPopup;
	import flash.events.Event;
	
	public class PopupEvent extends Event
	{
			
		public static const INIT_CLOSE:String = "initClose";
		public static const END_CLOSE:String = "endClose";
		
		public static const INIT_OPEN:String = "initOpen";
		public static const END_OPEN:String = "endOpen";
		
		
		
		
		private var _popup:IPopup;
		
		public function PopupEvent(type:String, popup:IPopup)
		{
			super(type);
			_popup = popup;
		}
		
		public function get popup():IPopup{
			return _popup;
		}
			
	}
}