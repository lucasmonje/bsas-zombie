package com.sevenbrains.trashingDead.interfaces {
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public interface IConfigBuilder {
		function build():void;
		function set xmlClassName(value:String):void;
		function set deserializerClass(value:String):void;
		function set configClass(value:String):void;
		function set model(value:String):void;
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		function hasEventListener(type:String):Boolean;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
	
	}
}