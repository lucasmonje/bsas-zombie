package com.sevenbrains.trashingDead.interfaces 
{
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public interface Screenable 
	{
		function get state():String;
		function destroy():void;
		function init():void;
	}
	
}