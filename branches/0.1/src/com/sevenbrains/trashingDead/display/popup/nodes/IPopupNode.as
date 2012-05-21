package com.sevenbrains.trashingDead.display.popup.nodes
{
	import com.sevenbrains.trashingDead.display.popup.Popup;
	
	public interface IPopupNode
	{
		function applyTo(popup:Popup):void;
		function removeFrom(popup:Popup):void;
		function setCallback(value:Function):void;
	}
}