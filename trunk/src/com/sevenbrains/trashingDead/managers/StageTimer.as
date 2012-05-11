//------------------------------------------------------------------------------
//
//	This software is the confidential and proprietary information of   
//	7 Brains. You shall not disclose such Confidential Information and   
//	shall use it only in accordance with the terms of the license   
//	agreement you entered into with 7 Brains.  
//	Copyright 2012 - 7 Brains. 
//	All rights reserved.  
//
//------------------------------------------------------------------------------
package com.sevenbrains.trashingDead.managers {
	
	import com.sevenbrains.trashingDead.events.GameTimerEvent;
	import com.sevenbrains.trashingDead.events.StageTimerEvent;
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	import com.sevenbrains.trashingDead.interfaces.ITimer;
	import com.sevenbrains.trashingDead.interfaces.IUpdateable;
	
	import flash.events.EventDispatcher;
	
	
	public class StageTimer extends EventDispatcher implements ITimer, Destroyable {
		
		private var _destroyed:Boolean;
		
		private var _elapsedTime:int;
		
		private var _isStarted:Boolean;
		
		private var _remainingTime:int;
		
		private var _totalTime:int;

		private var _intermediateTime:int;

		private var _finalTime:int;
		
		private var _updateables:Vector.<IUpdateable>;
		
		public function StageTimer(totalTime:int) {
			_updateables = new Vector.<IUpdateable>();
			_destroyed = false;
			_totalTime = totalTime;
			_remainingTime = _totalTime;
			_elapsedTime = 0;
			_intermediateTime = int(_totalTime*0.66);
			_finalTime = int(_totalTime*0.33);
		}
		
		public function destroy():void {
			GameTimer.instance.removeEventListener(GameTimerEvent.TIME_UPDATE_SECOND, updateSecond);
			_updateables = null;
			_isStarted = false;
			_totalTime = 0;
			_remainingTime = 0;
			_elapsedTime = 0;
			_destroyed = true;
		}
		
		public function get elapsedTime():int {
			return _elapsedTime;
		}
		
		public function isDestroyed():Boolean {
			return _destroyed;
		}
		
		public function get isStarted():Boolean {
			return _isStarted;
		}
		
		public function get isStopped():Boolean {
			return !_isStarted;
		}
		
		public function pauseFor(seconds:int):void {
			stop();
			GameTimer.instance.callMeIn(seconds, start);
		}
		
		public function registerUpdateable(obj:IUpdateable):void {
			if (!contains(obj)) {
				_updateables.push(obj);
			}
		}
		
		public function get remainingTime():int {
			return _remainingTime;
		}
		
		public function start():void {
			GameTimer.instance.addEventListener(GameTimerEvent.TIME_UPDATE_SECOND, updateSecond);
			_isStarted = true;
		}
		
		public function stop():void {
			GameTimer.instance.removeEventListener(GameTimerEvent.TIME_UPDATE_SECOND, updateSecond);
			_isStarted = false;
		}
		
		public function get totalTime():int {
			return _totalTime;
		}
		
		public function unregisterUpdateable(obj:IUpdateable):void {
			if (contains(obj)) {
				_updateables.splice(getIndex(obj), 1);
			}
		}
		
		private function contains(obj:IUpdateable):Boolean {
			return getIndex(obj) > -1;
		}
		
		private function getIndex(obj:IUpdateable):int {
			return _updateables.indexOf(obj);
		}
		
		private function updateSecond(e:GameTimerEvent):void {
			_elapsedTime++;
			_remainingTime--;
			
			for each (var u:IUpdateable in _updateables) {
				u.update(_remainingTime);
			}
			
			if (_remainingTime == _intermediateTime) {
				dispatchEvent(new StageTimerEvent(StageTimerEvent.SECOND_ROUND));
			} else if (_remainingTime == _finalTime) {				
				dispatchEvent(new StageTimerEvent(StageTimerEvent.FINAL_ROUND));
			} else if (_remainingTime == 0) {
				destroy();
			}
		}
	}
}