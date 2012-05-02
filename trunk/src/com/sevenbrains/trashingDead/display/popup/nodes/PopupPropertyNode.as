package com.sevenbrains.trashingDead.display.popup.nodes
{
	import com.sevenbrains.trashingDead.display.popup.IPopup;
	import com.sevenbrains.trashingDead.display.popup.Popup;
	
	
	/**
	 * @author Ariel
	 * <br>modified by matias.munoz
	 */
	public final class PopupPropertyNode implements IPopupNode
	{
		private var key:String;
		private var value:Object;
		
		private var _callback:Function;
		
		// TODO: Parse value from original String ?
		public function PopupPropertyNode(key:String, value:Object)
		{
			this.key = key;
			this.value = value;
		}
		
		public function applyTo(popup:Popup):void
		{
			var client:Object = popup.client || popup;
			client[key] = value;
			if(_callback != null) _callback(true, this);
		}
		
		public function removeFrom(popup:Popup):void
		{
			// TODO: Set to null?
		}
		
		public function setCallback(value:Function):void
		{
			_callback = value;
		}
	}
}