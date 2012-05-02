package com.sevenbrains.trashingDead.display.popup.nodes
{
	import com.sevenbrains.trashingDead.display.loaders.Asset;
	import com.sevenbrains.trashingDead.exception.ASSERT;
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import com.sevenbrains.trashingDead.net.ILoader;
	import com.sevenbrains.trashingDead.utils.ArrayUtil;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	import com.sevenbrains.trashingDead.utils.StringUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Dictionary;
	
	public class PopupAsynchronicNode implements IPopupNode
	{
		protected var _callback:Function;
		
		protected var map:Dictionary = new Dictionary();
		
		protected var _path:String;
		protected var _url:String;
		protected var _argsName:String;
		
		protected var _loader:ILoader;
		
		public function PopupAsynchronicNode()
		{
		}
		
		public function get argsName():String
		{
			return _argsName;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get path():String
		{
			return _path;
		}
		
		public function applyTo(popup:Popup):void
		{
			var url:String = this.url;
			
			if (this.argsName) 
			{
				var args:Array = ArrayUtil.makeArray(getAttr(popup, this.argsName));//Util.getArrayAttr(popup, argsName);
				url = StringUtil.format(url, args);
			}
			
			//url = VersionManager.getUrl(url);
			//TODO: solve Asset in order to avoid Loader() and VersionManager
			
			_loader = createLoader();
			addListeners();
			
			var container:Sprite = popup.getByPath(path) as Sprite;
			container.addChild(_loader as Asset);
			
			map[popup] = _loader;
			
			_loader.load();
		}
		
		protected function createLoader():ILoader{
			throw new Error("PopupAsynchronicNode::createLoader must be override");
		}
		
		protected function onLoaded(e:Event):void{
			removeListeners();
			if(_callback != null) _callback(true, this, (e.target as Asset).url);
		}
		
		private function addListeners():void{
			_loader.addEventListener(Event.COMPLETE, onLoaded);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		private function removeListeners():void{
			_loader.removeEventListener(Event.COMPLETE, onLoaded);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		protected function onError(e:Event):void{
			trace("asset: " + url + " could not be loaded");
			removeListeners();
			if(_callback != null) _callback(false, this, (e.target as Asset).url);
		}
		
		public function removeFrom(popup:Popup):void
		{
			var asset:Asset = map[popup];
			ASSERT(asset, url);
			DisplayUtil.remove(asset);
			delete map[popup];
		}
		
		public function setCallback(value:Function):void
		{
			_callback = value;
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
	}
}
