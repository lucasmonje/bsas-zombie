package com.sevenbrains.trashingDead.display.popup.nodes
{
	import com.sevenbrains.trashingDead.exception.ASSERT;
	import com.sevenbrains.trashingDead.display.popup.IPopup;
	import com.sevenbrains.trashingDead.display.popup.Popup;
	
	import flash.display.DisplayObject;
	
	/**
	 * Node that hides a DisplayObject
	 * @author Ariel
	 * <br>modified by matias.munoz
	 * 
	 */
	public final class PopupHideNode implements IPopupNode
	{
		private var _path:String;
		
		private var _callback:Function;
		
		public function PopupHideNode(path:String)
		{
			_path = path;
		}
		
		public function get path():String
		{
			return _path;
		}

		
		public function applyTo(popup:Popup):void
		{
			getObject(popup).visible = false;
			if(_callback != null) _callback(true, this);
		}
		
		public function removeFrom(popup:Popup):void
		{
			getObject(popup).visible = true;
		}

		private function getObject(popup:Popup):DisplayObject
		{
			var obj:DisplayObject = popup.getByPath(path);
			ASSERT(obj, 'object not found at '+path);
			return obj;
		}
		
		public function setCallback(value:Function):void
		{
			_callback = value;
		}
	}
}