//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.display.iconList {
	
	import com.sevenbrains.trashingDead.display.button.GenericButton;
	import com.sevenbrains.trashingDead.display.loaders.DefaultAssetLoader;
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	import com.sevenbrains.trashingDead.interfaces.Locable;
	import com.sevenbrains.trashingDead.managers.VersionManager;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	public class Icon implements Destroyable, IEventDispatcher {
		
		//public var tooltipManager:TooltipManager;
		
		private var _arrow:MovieClip;
		
		private var _asset:DefaultAssetLoader;
		
		private var _button:GenericButton;
		
		private var _content:MovieClip;
		
		private var _destroyed:Boolean;
		
		private var _dispacher:EventDispatcher;
		
		private var _hasArrow:Boolean;
		
		private var _msgKey:String;
		
		private var _url:String;
		
		public function Icon(url:String, msgKey:String, hasArrow:Boolean) {
			_dispacher = new EventDispatcher(this);
			_url = url;
			_msgKey = msgKey;
			_hasArrow = hasArrow;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_dispacher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function destroy():void {
			destroyAsset();
			destroyView();
			_destroyed = true;
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return _dispacher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return _dispacher.hasEventListener(type);
		}
		
		public function init():void {
			_asset = new DefaultAssetLoader(VersionManager.getUrl(_url));
			_asset.addEventListener(Event.COMPLETE, onAssetComplete);
			_asset.load();
		}
		
		public function isDestroyed():Boolean {
			return _destroyed;
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_dispacher.removeEventListener(type, listener, useCapture);
		}
		
		public function toString():String {
			return _dispacher.toString();
		}
		
		public function get view():MovieClip {
			return _content;
		}
		
		public function willTrigger(type:String):Boolean {
			return _dispacher.willTrigger(type);
		}
		
		protected function getMessenger():String {
			return _msgKey;
		}
		
		private function destroyAsset():void {
			if (_asset) {
				_asset.removeEventListener(Event.COMPLETE, onAssetComplete);
				_asset.destroy();
				_asset = null;
			}
		}
		
		private function destroyView():void {
			if (_button) {
				_button.destroy();
				_button = null;
				_asset = null;
			}
		}
		
		private function onAssetComplete(e:Event):void {
			var iconClass:Class = _asset.getDefinition("icon") as Class;
			_content = new iconClass() as MovieClip;
			_button = new GenericButton(_content["mcIcon"] as MovieClip);
			_button.addEventListener(MouseEvent.CLICK, onClick);
			_button.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_button.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			
			if (_hasArrow) {
				var balloonClass:Class = getDefinitionByName("commons.orangeArrowRight") as Class;
				_arrow = new balloonClass() as MovieClip;
				_arrow.y = view.height / 2;
				var arrowText:String = ConfigModel.messages.get(_msgKey + ".arrow");
				TextField(_arrow["label"]["txtLabel"]).text = arrowText;
				_content.addChild(_arrow);
			}
			destroyAsset();
			/*
			var tooltipDef:TooltipDefinition = tooltipManager.addByDisplay(_button.display, getMessenger, false, null, false, "commons.tooltipBar", BalloonTooltip);
			tooltipDef.alignment = new Point(-1.25, 1);
			_dispacher.dispatchEvent(new Event(Event.COMPLETE));
			*/
		}
		
		private function onClick(e:MouseEvent):void {
			_dispacher.dispatchEvent(new Event(Event.SELECT));
		}
		
		private function onOut(e:MouseEvent):void {
			if (_arrow) {
				_arrow.visible = true;
			}
		}
		
		private function onOver(e:MouseEvent):void {
			if (_arrow) {
				_arrow.visible = false;
			}
		}
	}
}