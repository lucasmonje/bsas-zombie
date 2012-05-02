package com.sevenbrains.trashingDead.interfaces {
	import flash.utils.Dictionary;
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public interface Deserealizable {
		function init():void;
		function deserialize(source:XML):void;
		function get map():Dictionary;
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		function hasEventListener(type:String):Boolean;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
	}
}