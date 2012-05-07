package com.sevenbrains.trashingDead.display.popup.nodes {
	
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import com.sevenbrains.trashingDead.utils.StringUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	internal final class Util {
		
		private static const POPUP:String = 'popup';
		private static const EVENT:String = 'event';
		
		public static function getAttr(popup:Popup, attr:String):* {
			var client:Object = popup.client;
			if (client && attr in client) {
				return client[attr];
			}
			if (attr in popup) {
				return popup[attr];
			}
			throw new Error('"' + attr + '" is not defined on this popup or its client');
		}
		
		public static function getPopup(object:DisplayObject):Popup {
			var container:DisplayObjectContainer = object.parent;
			while (container) {
				if (container is Popup) {
					return container as Popup;
				}
				container = container.parent;
			}
			return null;
		}
		
		public static function runFunction(popup:Popup, handler:String, e:Event, arg:String=null):void {
			var fn:Function = getAttr(popup, handler);
			var args:Array = [];
			if (arg) {
				for each (arg in getArrayAttr(popup, arg)) {
					switch (arg) {
						case EVENT: 
							args.push(e);
							break;
						case POPUP: 
							args.push(popup);
							break;
						default: 
							args.push(arg);
							break;
					}
				}
			}
			fn.apply(null, args);
		}
		
		public static function addVars(popup:Popup, template:String):String {
			return StringUtil.format(template, popup.client || popup);
		}
		
		public static function getArrayAttr(popup:Popup, args:String):Array {
			return addVars(popup, args).split(',');
		}
	}
}