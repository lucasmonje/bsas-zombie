package com.sevenbrains.trashingDead.display.popup.nodes 
{
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.events.GameTimerEvent;
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class PopupAutoCloseNode implements IPopupNode 
	{
		private var _callback:Function;
		private var _time:uint;
		private var _timer:Timer;
		private var _popup:Popup;
		
		public function PopupAutoCloseNode(time:uint) {
			_time = time;
		}
		
		public function applyTo(popup:Popup):void {
			_popup = popup;
			//GameTimer.instance.pause();
			_timer = new Timer(_time, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start();
			
			if (_callback != null) {
				_callback(true, this);
			}
		}
		
		public function onTimerComplete(e:TimerEvent):void {
			_popup.close();
			destroyTimer();
			_popup = null;
		}
		
		public function removeFrom(popup:Popup):void {
			destroyTimer();
			_popup = null;
		}
		
		public function setCallback(value:Function):void {
			_callback = value;
		}
		
		private function destroyTimer():void {
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer.stop();
				_timer = null;				
			}
			//GameTimer.instance.resume();
		}
	}

}