//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.builders {
	
	import com.sevenbrains.trashingDead.interfaces.Configurable;
	import com.sevenbrains.trashingDead.interfaces.Deserealizable;
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	import com.sevenbrains.trashingDead.interfaces.IConfigBuilder;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Dispatched when data has loaded successfully.
	 * @eventType flash.events.Event
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class ConfigBuilder implements IConfigBuilder, Destroyable {
		
		private var _config:Configurable;
		private var _configClass:Class;
		private var _deserializer:Deserealizable;
		private var _deserializerClass:Class;
		private var _destroyed:Boolean;
		private var _dispacher:EventDispatcher;
		private var _model:String;
		private var _xmlClassName:String;
		
		public function ConfigBuilder() {
			_dispacher = new EventDispatcher();
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_dispacher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function build():void {
			var xmlClass:Class = EmbedAsset[_xmlClassName] as Class;
			var byteArray:ByteArray = new xmlClass() as ByteArray;
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			_deserializer = new _deserializerClass(xml);
			_deserializer.addEventListener(Event.COMPLETE, deserializeCompleted);
			_deserializer.init();
		}
		
		public function set configClass(value:String):void {
			_configClass = getDefinitionByName(value) as Class;
		}
		
		public function set deserializerClass(value:String):void {
			_deserializerClass = getDefinitionByName(value) as Class;
		}
		
		public function destroy():void {
			_xmlClassName = null;
			_deserializerClass = null;
			_configClass = null;
			_model = null;
			_destroyed = true;
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return _dispacher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return _dispacher.hasEventListener(type);
		}
		
		public function isDestroyed():Boolean {
			return _destroyed;
		}
		
		public function set model(value:String):void {
			_model = value;
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_dispacher.removeEventListener(type, listener, useCapture);
		}
		
		public function set xmlClassName(value:String):void {
			_xmlClassName = value;
		}
		
		private function configCompleted(e:Event):void {
			_config.removeEventListener(Event.COMPLETE, configCompleted);
			ConfigModel[_model] = _config;
			dispatchEvent(new Event(Event.COMPLETE));
			destroy();
		}
		
		private function deserializeCompleted(e:Event):void {
			_deserializer.removeEventListener(Event.COMPLETE, deserializeCompleted);
			_config = new _configClass(_deserializer.map);
			_config.addEventListener(Event.COMPLETE, configCompleted);
			_config.init();
		}
	}
}