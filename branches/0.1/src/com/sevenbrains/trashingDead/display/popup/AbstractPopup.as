package com.sevenbrains.trashingDead.display.popup {
	
	import com.sevenbrains.trashingDead.display.loaders.DefaultAssetLoader;
	import com.sevenbrains.trashingDead.events.PopupEvent;
	import com.sevenbrains.trashingDead.interfaces.ILoader;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	public class AbstractPopup extends Sprite implements IPopup {
		
		protected var _props:PopupProperties;
		protected var _loader:DefaultAssetLoader;
		protected var _destroyed:Boolean;
		protected var _client:Object;
		protected var _data:Object;
		protected var _showing:Boolean;
		
		public function AbstractPopup() {
			_destroyed = false;
		}

		/**
		* Set the loader as a clone of the asset
		* Everytime it's loaded we make sure that is onother <code>Asset</code> intance.
		*
		* @param value
		*
		*/
		protected function set loader(value:DefaultAssetLoader):void {
			_loader = value;
		}
		
		protected function get loader():DefaultAssetLoader {
			return _loader;
		}
		
		/**
		* loads the asset
		*
		*/
		public function open():void {
			if (!this._loader)
				throw new IllegalOperationError("Loader required to open the popup" + this);
			startLoading();
		}
		
		/**
		* Handler to close the popup and dispatch a PopupEvent
		* Every event is catched by the manager and perform the action.
		* General configuration usage
		*
		*/
		public function close():void {
			dispatchEvent(new PopupEvent(PopupEvent.END_CLOSE, this));
		}
		
		/**
		* Start loading the Asset and confirm error or load complete.
		*
		*/
		protected function startLoading():void {
			dispatchEvent(new PopupEvent(PopupEvent.INIT_OPEN, this));
			if (!this._loader.isLoaded()) {
				this._loader.addEventListener(Event.COMPLETE, onComplete);
				this._loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				this._loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
				this._loader.load();			
			} else {
				onComplete();
			}
		}
		
		// Client, based on LocalConnection's client attribute
		// All the methods and properties will be search on it
		public function get client():Object {
			return _client;
		}
		
		public function set client(v:Object):void {
			_client = v;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(d:Object):void {
			_data = d;
		}
		
		/**
		*	Destroy loader and loaderContent Container
		*  Should be overwritten to destroy components added by inheritance
		*
		*/
		public function destroy():void {
			if (this._loader) {
				this._loader.removeEventListener(Event.COMPLETE, onComplete);
				this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				this._loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				// remove loader
				_loader = null;
			}
			_destroyed = true;
		}
		
		public function get destroyed():Boolean {
			return _destroyed;
		}
		
		public function set showing(value:Boolean):void  {
			_showing = value;
		}
		
		// ----------------------------
		// Events
		// ----------------------------
		/**
		* Loading finished event, add the loadContent to the display list
		* @param e
		*
		*/
		protected function onComplete(e:Event = null):void {
			dispatchEvent(new PopupEvent(PopupEvent.END_OPEN, this));
		}
		
		protected function onError(e:*):void {
			throw new Error("iErrorEvent: " + e);
			dispatchEvent(e);
		}
		
		protected function onProgress(e:ProgressEvent):void {
			// TODO:to be defined
		}
	}
}