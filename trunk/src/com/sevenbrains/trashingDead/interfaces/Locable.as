package com.sevenbrains.trashingDead.interfaces
{
	public interface Locable
	{
		function getMessage(key:String,bundleId:String=null, params:Array=null):String;
		function getMessageWithoutKey(key:String,bundleId:String=null, params:Array=null):String;
	}
}