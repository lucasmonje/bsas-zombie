package com.sevenbrains.trashingDead.builders {
	
	import com.sevenbrains.trashingDead.interfaces.Configurable;
	import com.sevenbrains.trashingDead.interfaces.Buildable;
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	import com.sevenbrains.trashingDead.interfaces.IConfigBuilder;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.net.URLLoader;
	import com.sevenbrains.trashingDead.utils.StageReference;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.getDefinitionByName;
	
	/**
	* Dispatched when data has loaded successfully.
	* @eventType flash.events.Event
	*/
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class LocaleBuilder implements IConfigBuilder, Destroyable {
		
		private var _localePath:String;
		private var _deserializerClass:Class;
		private var _configClass:Class;
		private var _model:String;
		private var _destroyed:Boolean;
		private var _deserializer:Buildable;
		private var _config:Configurable;
		private var _dispacher:EventDispatcher;
		
		public function LocaleBuilder() {
			_dispacher = new EventDispatcher();
		}
		
		public function destroy():void {
			_localePath = null;
			_deserializerClass = null;
			_configClass = null;
			_model = null;
			_destroyed = true;
		}
		
		public function isDestroyed():Boolean {
			return _destroyed;
		}
		
		public function build():void {
			var baseURL:String = StageReference.baseURL;
			var localePath:String = _localePath;
			var r:RegExp = /\${(\S+?)\}/g;
			_localePath = _localePath.replace(r, parse);
			loadMessages();
		}
		
		private function parse(all:String, name:String, ...args):String{
			return StageReference.flashVars[name] || '${'+name+'}';
		}
		
		private function loadMessages():void {
			var loader:URLLoader = new URLLoader(_localePath, 1, true, URLLoaderDataFormat.TEXT);
			loader.addEventListener(Event.COMPLETE, loaderMessageComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderMessageError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderMessageError);
			loader.load();
		}
		
		private function loaderMessageError(e:*):void {
			if (e.hasOwnProperty("errorMessage")) {
				trace(e.errorMessage);
			}
		}
		
		private function loaderMessageComplete(e:Event):void {
			var loader:URLLoader = e.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, loaderMessageComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loaderMessageError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderMessageError);
			_deserializer = new _deserializerClass(String(loader.data));
			_deserializer.addEventListener(Event.COMPLETE, deserializeCompleted);
			_deserializer.init();
		}
		
		private function deserializeCompleted(e:Event):void {
			_deserializer.removeEventListener(Event.COMPLETE, deserializeCompleted);
			_config = new _configClass(_deserializer.map);
			_config.addEventListener(Event.COMPLETE, configCompleted);
			_config.init();
		}
		
		private function configCompleted(e:Event):void {
			_config.removeEventListener(Event.COMPLETE, configCompleted);
			ConfigModel[_model] = _config;
			dispatchEvent(new Event(Event.COMPLETE));
			destroy();
		}
		
		public function set localePath(value:String):void {
			_localePath = value;
		}
		
		public function set deserializerClass(value:String):void {
			_deserializerClass = getDefinitionByName(value) as Class;
		}
		
		public function set configClass(value:String):void {
			_configClass = getDefinitionByName(value) as Class;
		}
		
		public function set model(value:String):void {
			_model = value;
		}
		
		/* DELEGATE flash.events.EventDispatcher */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_dispacher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return _dispacher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return _dispacher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			_dispacher.removeEventListener(type, listener, useCapture);
		}
	}
}