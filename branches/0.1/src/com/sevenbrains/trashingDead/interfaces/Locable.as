package com.sevenbrains.trashingDead.interfaces
{
	public interface Locable
	{
		function get(key:String, params:Array=null):String;
		function getWithoutKey(key:String, params:Array=null):String;
	}
}