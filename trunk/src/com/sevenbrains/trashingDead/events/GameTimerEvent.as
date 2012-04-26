package com.sevenbrains.trashingDead.events
{
	import flash.events.Event;

	public class GameTimerEvent extends Event
	{
		public static const TIME_UPDATE_SECOND:String = "timeUpdateSecond";
		public static const TIME_UPDATE_MINUTE:String = "timeUpdateMinute";
		public static const TIME_UPDATE:String = "timeUpdate";
		public static const PAUSE:String = "pause";
		public static const RESUME:String = "resume";
		
		private var _elapsedTime:int;
		private var _totalTime:int;
		
		public function GameTimerEvent(type:String, elapsedTime:int=0, totalTime:int=0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_elapsedTime = elapsedTime;
			_totalTime = totalTime;
		}
		
		public function get elapsedTime():int { return _elapsedTime; }
		
		public function get totalTime():int { return _totalTime; }
		
		
		
	}
}