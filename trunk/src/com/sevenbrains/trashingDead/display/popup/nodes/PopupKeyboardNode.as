package com.sevenbrains.trashingDead.display.popup.nodes
{
	import com.sevenbrains.trashingDead.display.popup.IPopup;
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import com.sevenbrains.trashingDead.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * @author Ariel
	 * <br>modified by matias.munoz
	 */
	public final class PopupKeyboardNode implements IPopupNode
	{
		private static const POPUP:String = 'popup';
		private static const EVENT:String = 'event';
		
		private var stage:Stage;
		private var popups:Array = [];
		
		// Used to avoid many calls when holding the key down
		private var locked:Boolean = false;
		
		private var code:uint;
		private var handler:String;
		private var arg:String;
		
		private var _callback:Function;
		
		public function PopupKeyboardNode(code:uint, handler:String, arg:String=null)
		{
			this.code = code;
			this.handler = handler;
			this.arg = arg;
		}
		
		public function applyTo(popup:Popup):void
		{
			if (!popups.length) {
				stage = popup.stage;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onInput);
				stage.addEventListener(KeyboardEvent.KEY_UP, unlockInput);
			}
			popups.push(popup);
			if(_callback != null) _callback(true, this);
		}
		
		public function removeFrom(popup:Popup):void
		{
			ArrayUtil.remove(popups, popup);
			
			if (!popups.length) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onInput);
				stage.removeEventListener(KeyboardEvent.KEY_UP, unlockInput);
				stage = null;
				locked = false;
			}
		}
		
		private function isOwnCode(e:KeyboardEvent):Boolean 
		{
			return e.keyCode === code || e.charCode === code;
		}
		
		private function onInput(e:KeyboardEvent):void
		{
			if (!isOwnCode(e)) return;

			locked = true;
			
			var target:DisplayObject = e.target as DisplayObject;
			
			for each (var popup:Popup in popups.concat()) {
				if (target === stage || popup.contains(target)) {
					runFunction(popup, handler, e, arg);
				}
			}
		}
		
		public function runFunction(popup:Popup, handler:String, e:Event, arg:String=null):void 
		{
			var fn:Function = getAttr(popup, handler);
			
			switch (arg) {
				case ''   :
				case null : fn(); break;
				case EVENT: fn(e); break;
				case POPUP: fn(popup); break;
				default   : fn(arg); break;
			}
		}
		
		private function unlockInput(e:KeyboardEvent):void
		{
			if (isOwnCode(e)) {
				locked = false;
			}
		}
	
		// Static methods
		
		public static function getCode(key:String):uint
		{
			if (key.length === 1) {
				return key.charCodeAt(0);
			}
			
			var upper:String = key.toUpperCase();
			if (upper in Keyboard) {
				return Keyboard[upper];
			}
			
			throw new Error('PopupKeyboardNode::"'+key+'" is not a valid keyboard key');
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