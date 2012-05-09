package com.sevenbrains.trashingDead.display.popup.nodes
{
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import com.sevenbrains.trashingDead.utils.ArrayUtil;
	
	public final class PopupI18nNode implements IPopupNode
	{

		private var _path:String;
		private var _key:String;
		private var _argsName:String;
		
		private var _callback:Function;

		public function PopupI18nNode(path:String, key:String, argsName:String=null)
		{
			_path = path;
			_key = key;
			_argsName = argsName;
		}

		public function get argsName():String
		{
			return _argsName;
		}
		
		public function get key():String
		{
			return _key;
		}
		
		public function get path():String
		{
			return _path;
		}
		
		public function applyTo(popup:Popup):void
		{
			if (this.argsName) 
			{
				var args:Array = ArrayUtil.makeArray(getAttr(popup, this.argsName));//Util.getArrayAttr(popup, argsName);
			}
			
			var fullKey:String = popup.i18n + '.' + key;
			popup.localizeByPath(path, fullKey, args);
			if(_callback != null) _callback(true, this);
		}
		
		public function removeFrom(popup:Popup):void
		{
			//TODO: not implemented
		}
		
		public function getAttr(popup:Popup, attr:String):* 
		{
			var client:Object = popup.client;
			if (client && attr in client) {
				return client[attr];	
			}
			
			if (attr in popup) {
				return popup[attr];
			}
			
			throw new Error('"' + attr + '" is not defined on this popup or its client');
		}
		
		public function setCallback(value:Function):void
		{
			_callback = value;
		}

	}
}