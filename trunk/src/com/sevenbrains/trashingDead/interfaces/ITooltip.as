package com.sevenbrains.trashingDead.interfaces
{
	import flash.display.DisplayObjectContainer;

	public interface ITooltip extends Destroyable
	{
		function open():void;
		function close():void;
		function set target(value:DisplayObjectContainer):void;
		function set title(value:String):void;
		function set message(value:String):void;
		function get width():Number;
		function get height():Number;
		function get x():Number;
		function get y():Number;
		function get scaleY():Number;
		function get scaleX():Number;
	}
}