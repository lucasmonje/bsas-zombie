package com.sevenbrains.trashingDead.display.popup.nodes
{
	import com.sevenbrains.trashingDead.display.popup.Popup;
	
	/**
	 * @author Ariel
	 * <br>modified by matias.munoz
	 */
	public interface IPopupNode
	{
		function applyTo(popup:Popup):void;
		function removeFrom(popup:Popup):void;
		function setCallback(value:Function):void;
	}
}