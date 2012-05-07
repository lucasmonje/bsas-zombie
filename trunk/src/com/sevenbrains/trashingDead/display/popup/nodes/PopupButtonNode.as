package com.sevenbrains.trashingDead.display.popup.nodes {
	
	import com.sevenbrains.trashingDead.display.button.GenericButton;
	import com.sevenbrains.trashingDead.exception.ASSERT;
	import com.sevenbrains.trashingDead.display.popup.IPopup;
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import com.sevenbrains.trashingDead.display.popup.nodes.Util;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public final class PopupButtonNode implements IPopupNode {
		
		private static const POPUP:String = 'popup';
		private static const EVENT:String = 'event';
		private var map:Dictionary = new Dictionary();
		private var _path:String;
		private var _handler:String;
		private var _arg:String;
		private var _key:String;
		private var _button:GenericButton;
		private var _buttonMc:MovieClip;
		private var _callback:Function;
		
		public function PopupButtonNode(path:String, handler:String, key:String, arg:String=null) {
			_path = path;
			_handler = handler;
			_arg = arg;
			_key = key;
		}
		
		public function get key():String {
			return _key;
		}
		
		public function set key(value:String):void {
			_key = value;
		}
		
		public function get arg():String {
			return _arg;
		}
		
		public function get handler():String {
			return _handler;
		}
		
		public function get path():String {
			return _path;
		}
		
		public function applyTo(popup:Popup):void {
			_buttonMc = popup.getByPath(path) as MovieClip;
			ASSERT(_buttonMc);
			_button = new GenericButton(_buttonMc);
			_button.addEventListener(MouseEvent.CLICK, runHandler);
			map[_button] = popup;
			if (_callback != null)
				_callback(true, this);
		}
		
		public function removeFrom(popup:Popup):void {
			ASSERT(map[_button] === popup);
			_button.destroy();
			delete map[_buttonMc];
		}
		
		private function runHandler(e:Event):void {
			var popup:Popup = map[e.currentTarget] as Popup;
			runFunction(popup, handler, e, arg);
		}
		
		public function runFunction(popup:Popup, handler:String, e:Event, arg:String=null):void {
			Util.runFunction(popup, handler, e, arg);
		}
		
		public function getAttr(popup:Popup, attr:String):* {
			var client:Object = popup.client;
			if (client && attr in client) {
				return client[attr];
			}
			if (attr in popup) {
				return popup[attr];
			}
			throw new Error('"' + attr + '" is not defined on this popup or its client');
		}
		
		public function setCallback(value:Function):void {
			_callback = value;
		}
	}
}