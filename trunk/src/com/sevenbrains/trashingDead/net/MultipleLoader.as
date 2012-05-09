package com.sevenbrains.trashingDead.net {
	
	import com.sevenbrains.trashingDead.interfaces.ILoader;
	import com.sevenbrains.trashingDead.interfaces.IMultipleLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	public class MultipleLoader extends EventDispatcher implements IMultipleLoader {
		protected var _loadedCount:int = 0;
		
		protected var _loaderList:Vector.<ILoader>;
		
		protected var _isLoading:Boolean = false;
		
		private var _destroyed:Boolean;
		
		public function MultipleLoader(loaderList:Object=null) {
			_destroyed=false;
			init(loaderList);
		}
		
		/**
		 * @inheritDoct
		 */
		public function destroy():void {
			_loadedCount=0;
			_loaderList=null;
			_destroyed=true;
		}
		
		/**
		 * @inheritDoct
		 */
		public function isDestroyed():Boolean {
			return _destroyed;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get loadedCount():int {
			return _loadedCount;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get loadersAmount():int {
			return _loaderList.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get loaderList():Vector.<ILoader> {
			return _loaderList.concat();
		}
		
		/**
		 * @inheritDoc
		 */
		public function addLoader(loader:ILoader):void {
			_loaderList.push(loader);
		}
		
		/**
		 * @inheritDoc
		 */
		public function load():void {
			if (_loaderList.length < 1) {
				throw new Error("There aren't any loader to load");
			}
			
			if (!_isLoading) {
				_isLoading=true;
				loadNext();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function isLoaded():Boolean {
			return _loadedCount >= loadersAmount;
		}
		
		protected function loadNext():void {
			var loader:ILoader = _loaderList[_loadedCount];
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.load();
		}
		
		protected function onLoadComplete(e:Event):void {
			_loadedCount++;
			
			if (isLoaded()) {
				_isLoading=false;
				dispatchEvent(new Event(Event.COMPLETE, true));
			} else {
				loadNext();
			}
		}
		
		protected function onLoadError(event:IOErrorEvent):void {
			dispatchEvent(event);
		}
		
		protected function onProgress(event:ProgressEvent):void {
			var total:Number = loadersAmount * event.bytesTotal;
			var loaded:Number = _loadedCount * event.bytesTotal + event.bytesLoaded;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, true, false, loaded, total));
		}
		
		private function init(loaderList:Object):void {
			_loaderList=new Vector.<ILoader>();
			
			for each (var loader:ILoader in loaderList) {
				_loaderList.push(loader);
			}
		}
	}
}
