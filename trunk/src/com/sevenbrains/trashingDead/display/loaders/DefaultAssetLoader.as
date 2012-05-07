package com.sevenbrains.trashingDead.display.loaders {
	import com.sevenbrains.trashingDead.net.AbstractLoader;
	import com.sevenbrains.trashingDead.managers.GraphicLoaderCache;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	public class DefaultAssetLoader extends AbstractLoader {
		private var _cache:GraphicLoaderCache;
		private var _loader:Loader;
		private var _ba:ByteArray;
		
		public function DefaultAssetLoader(url:String, retries:uint=1) {
			super(url, retries);
			_cache = GraphicLoaderCache.getInstance();
		}
		
		public function get content():DisplayObject {
			return _loader.content;
		}
		
		public function get contentLoaderInfo():LoaderInfo {
			return _loader.contentLoaderInfo;
		}
		
		/**
		* Loads a ByteArray and converts it into a bitmap. This is used to load a zip png. The
		* loading flow is the same as using the load() method but you must use isContentLoaded()
		* instead of isLoaded() to know when the asset is loaded.
		* <p/>
		* @see DefaultAssetLoader#isContentLoaded()
		*
		* @param ba an image as a ByteArray.
		*/
		public function loadBytes(ba:ByteArray):void {
			_ba = ba;
			load();
		}
		
		/**
		* Checks if the bytes are loaded. Note that this method checks only the existance of the loader content.
		* <p/>
		* Use this method if you are loading a byte chunk using the <code>loadByte()</code> method.
		* <p/>
		* @see DefaultAssetLoader#loadBytes(ByteArray)
		*
		* @return <code>true</code> if the bytes has been loaded. <code>false</code> otherwise.
		*/
		public function isContentLoaded():Boolean {
			if (!_loader) {
				return false;
			}
			return _loader.content != null;
		}
		
		/**
		* @inheritDoc
		*/
		override public function clone():AbstractLoader {
			return new DefaultAssetLoader(_url, _retries);
		}
		
		/**
		* @inheritDoc
		*/
		override public function isLoaded():Boolean {
			if (!_loader) {
				return false;
			}
			var info:LoaderInfo = _loader.contentLoaderInfo;
			if (!info || !info.bytes) {
				return false;
			}
			var bytesLoaded:uint = info.bytesLoaded;
			var bytesTotal:uint = info.bytesTotal;
			var bytesInArray:uint = info.bytes.length;
			return bytesLoaded > 0 && bytesLoaded == bytesTotal && bytesInArray > 0 && info.content != null && info.bytes.length > 0;
		}
		
		/**
		* @inheritDoc
		*/
		override protected function doLoad():void {
			if (_ba) {
				doLoadBytes();
			} else {
				doLoadGraphic();
			}
		}
		
		/**
		* @inheritDoc
		*/
		override protected function onError(event:Event):void {
			_cache.remove(_request);
			super.onError(event);
		}
		
		/**
		* @inheritDoc
		*/
		override public function destroy():void {
			removeEventListeners();
			_cache = null;
			_ba = null;
			_loader = null;
			super.destroy();
		}
		
		private function doLoadBytes():void {
			_loader = _cache.loadBytes(_request, _ba);
			if (isContentLoaded()) {
				onComplete(new Event(Event.COMPLETE));
			} else {
				addEventListeners();
			}
		}
		
		private function doLoadGraphic():void {
			_loader = _cache.loadGraphic(_request);
			if (isLoaded()) {
				onComplete(new Event(Event.COMPLETE));
			} else {
				addEventListeners();
			}
		}
		
		private function addEventListeners():void {
			var info:LoaderInfo = _loader.contentLoaderInfo;
			info.addEventListener(ProgressEvent.PROGRESS, onProgress);
			info.addEventListener(Event.COMPLETE, onComplete);
			info.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			info.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		private function removeEventListeners():void {
			if (!_loader) {
				return;
			}
			var info:LoaderInfo = _loader.contentLoaderInfo;
			if (!info) {
				return;
			}
			info.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			info.removeEventListener(Event.COMPLETE, onComplete);
			info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			info.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}

		public function getMCByDef(definition:String):MovieClip {
			if (!hasDefinition(definition)) {
				return null;
			}
			var clazz:Class = applicationDomain.getDefinition(definition) as Class;
			return new clazz() as MovieClip;
		}
		
		public function getDefinition(name:String):Object {
			if (!hasDefinition(name)) {
				return null;
			}
			return applicationDomain.getDefinition(name);
		}
		
		public function hasDefinition(name:String):Boolean {
			return applicationDomain.hasDefinition(name);
		}
		
		private function get applicationDomain():ApplicationDomain {
			return _loader.contentLoaderInfo.applicationDomain;
		}
	}
}