package client.managers
{
	import client.utils.StageReference;
	import client.events.GameTimerEvent;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.System;
	import flash.utils.getTimer;

	[Event(name="timeUpdateSecond",type="client.events.GameTimerEvent")]
	[Event(name="timeUpdate",type="client.events.GameTimerEvent")]
	[Event(name="pause",type="client.events.GameTimerEvent")]
	[Event(name="resume",type="client.events.GameTimerEvent")]
	public class GameTimer extends EventDispatcher
	{
		private static const MAX_ELAPSED_IN_ONE_FRAME:uint = 5000;
		private static const PERFORMANCE_TRACK_INTERVAL:uint = (60000) * 3;//3 minutes
		
		private static var _instance:GameTimer;
		public static function get instance():GameTimer	{
			return _instance || (_instance = new GameTimer());
		}
		
		private var _currentTime:Number = 0;
		private var _lastMillis:Number;
		private var _lastSecond:Number;
		private var _lastMinute:Number;
		private var _fps:int;
		private var _speedMultiplier:Number = 1;
		private var _delayedCalls:Vector.<DelayedCall>;
		private var _uid:int = 1;
		private var _running:Boolean = false;
		
		public function GameTimer() {
			init();
		}
		
		private function init():void {
			_delayedCalls = new Vector.<DelayedCall>;
			
			var performanceDelay:DelayedCall = new DelayedCall();
			performanceDelay.id = _uid++;
			performanceDelay.timelapse = PERFORMANCE_TRACK_INTERVAL;
			performanceDelay.remainingTime = PERFORMANCE_TRACK_INTERVAL;
			performanceDelay.callback = trackPerformance;
			performanceDelay.repeat = true;
			_delayedCalls.push(performanceDelay);
			resetTime();
		}
		private function resetTime():void {
			_lastMinute = _lastSecond = _lastMillis = now;
		}
		
		public function get speedMultiplier():Number {
			return _speedMultiplier;
		}

		public function set speedMultiplier(value:Number):void {
			_speedMultiplier = value;
			resetTime();
		}

		private function get stage():Stage {
			return StageReference.stage;
		}

		public function get currentTime():Number {
			return _currentTime;
		}
		
		private function get now():Number {
			return getTimer();
		}
		
		public function start():void {
			resetTime();
			_running = true;
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function isRunning():Boolean {
			return _running;
		}
			
		public function pause():void {
			_running = false;
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			dispatchEvent(new GameTimerEvent(GameTimerEvent.PAUSE));
		}
		
		public function debugPause():void{
			pause();
		}
		
		public function debugResume():void{
			resume();
		}
		
		public function resume():void {
			start();
			dispatchEvent(new GameTimerEvent(GameTimerEvent.RESUME));
		}
		
		/**
		 * register a function to be called in <code>timelapse</code> (in milliseconds)
		 * @return an int to identify the specific delayedCall. Use it to cancel it with cancelCall method
		 */
		public function callMeIn(timelapse:int, callback:Function, ...rest):int {
			var delay:DelayedCall = new DelayedCall();
			delay.id = _uid++;
			delay.timelapse = timelapse;
			delay.remainingTime = timelapse;
			delay.callback = callback;
			delay.parameters = rest;
			delay.repeat = false;
			_delayedCalls.push(delay);
			return delay.id;
		}
		
		public function callMeEvery(timelapse:int, callback:Function, ...rest):int	{
			var delay:DelayedCall = new DelayedCall();
			delay.id = _uid++;
			delay.timelapse = timelapse;
			delay.remainingTime = timelapse;
			delay.callback = callback;
			delay.parameters = rest;
			delay.repeat = true;
			_delayedCalls.push(delay);
			return delay.id;
		}
		
		public function cancelCall(id:int):void {
			var start:int = _delayedCalls.length -1;
			for (var i:int = start; i >= 0; i--) {
				if (_delayedCalls[i].id == id){
					var call:DelayedCall = _delayedCalls[i];
					call.cancelled = true;
					_delayedCalls.splice(i,1);
				}
			}
		}
		
		private function onEnterFrame(e:Event):void {
			var curTime:Number = now;
			var elapsedTime:Number = curTime - _lastMillis;
			_lastMillis = curTime;
			
			_running = true;
			_fps = 1000/elapsedTime;
			
			// Speed multiplier was reduced or backwards speed hack
			if (elapsedTime <= 0 || elapsedTime > MAX_ELAPSED_IN_ONE_FRAME) return;
			
			_currentTime += elapsedTime;
			
			dispatchEvent(new GameTimerEvent(GameTimerEvent.TIME_UPDATE, elapsedTime, _currentTime));
			var secondElapseTime:Number = curTime - _lastSecond;
			if (secondElapseTime >= 1e3) {
				_lastSecond = curTime;
				dispatchEvent(new GameTimerEvent(GameTimerEvent.TIME_UPDATE_SECOND, secondElapseTime, _currentTime));
			}

			var minuteElapseTime:Number = curTime - _lastMinute;
			if (minuteElapseTime >= 6e4) {
				_lastMinute = curTime;
				dispatchEvent(new GameTimerEvent(GameTimerEvent.TIME_UPDATE_MINUTE, minuteElapseTime, _currentTime));
			}
			
			var executeCalls:Vector.<DelayedCall> = new Vector.<DelayedCall>();
			
			var start:int = _delayedCalls.length -1;			
			for (var i:int = start; i >= 0; i--) {
				var call:DelayedCall = _delayedCalls[i];
				call.remainingTime -= elapsedTime;
				if (call.remainingTime < 0) {
					executeCalls.push(call);
					if (call.repeat) {
						call.remainingTime += call.timelapse;
					} else {
						_delayedCalls.splice(i, 1);
					}
				}
			}
			
			for each (call in executeCalls) {
				if (!call.cancelled) {
					call.execute();
				}
			}
		}
		
		public function get fps():int{
			return _fps;
		}
		
		private function trackPerformance():void {
			
			var mem:int = System.totalMemory;//totalMemory is in bytes.
			mem /= 1024;//bytes to Kbytes.
			mem /= 1024//Kbytes to Mbytes.
		}
		
		/** Clears all pending calls */
		public function clearAll():void {
			_delayedCalls.length = 0;
		}
		
	}
}
internal class DelayedCall {
	
	public var id:int;
	public var repeat:Boolean;
	public var timelapse:int;
	public var remainingTime:int;
	public var callback:Function;
	public var parameters:Array;
	public var cancelled:Boolean = false;
	
	public function execute():void{
		callback.apply(this, parameters);
	}
}
