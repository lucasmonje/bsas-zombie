package com.sevenbrains.trashingDead.interfaces 
{
	
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public interface Configurable 
	{
		function init():void;
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		function hasEventListener(type:String):Boolean;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
	}
	
}