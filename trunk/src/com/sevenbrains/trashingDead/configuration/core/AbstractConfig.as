package com.sevenbrains.trashingDead.configuration.core {
	import com.sevenbrains.trashingDead.interfaces.Configurable;
	import com.sevenbrains.trashingDead.utils.ClassUtil;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	* Dispatched when data has loaded successfully.
	* @eventType flash.events.Event
	*/
	[Event(name="complete",type="flash.events.Event")]
	/**
	* @eventType flash.events.Event
	*/
	[Event(name="init",type="flash.events.Event")]
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class AbstractConfig implements Configurable {
		
		protected var _configMap:Dictionary;
		protected var _dispacher:EventDispatcher;
		
		public function AbstractConfig(map:Dictionary) {
			_dispacher = new EventDispatcher();
			notifyInit();
			_configMap = map;
		}
		
		public function init():void {
			
		}
		
		public function notifyInit():void {
			trace(ClassUtil.getName(this) + "> INIT.");
			dispatchEvent(new Event(Event.INIT));
		}
		
		public function notifyEnd():void {
			trace(ClassUtil.getName(this) + "> END.");
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/* DELEGATE flash.events.EventDispatcher */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_dispacher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return _dispacher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return _dispacher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			_dispacher.removeEventListener(type, listener, useCapture);
		}
	}
}