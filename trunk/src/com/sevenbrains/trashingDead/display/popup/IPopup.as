package com.sevenbrains.trashingDead.display.popup
{
	import flash.events.IEventDispatcher;
	
	
	[Event(name = "initClose", type = "com.sevenbrains.trashingDead.events.PopupEvent")]
	[Event(name = "endClose", type = "com.sevenbrains.trashingDead.events.PopupEvent")]
	[Event(name = "initOpen", type = "com.sevenbrains.trashingDead.events.PopupEvent")]
	[Event(name = "endOpen", type = "com.sevenbrains.trashingDead.events.PopupEvent")]

	public interface IPopup extends IEventDispatcher
	{
		function open():void;
		function close():void;
		function destroy():void
		function get client():Object;	
		function set client(v:Object):void; 
		function get data():Object;	
		function set data(d:Object):void; 
		function set showing(value:Boolean):void; 
	}
}