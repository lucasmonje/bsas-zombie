package com.sevenbrains.trashingDead.controller.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class ToggleMusicEvent extends CairngormEvent
	{
		public static const EVENT:String = "toggleMusicEvent";
		
		public function ToggleMusicEvent()
		{
			super(EVENT);
		}
	}
}