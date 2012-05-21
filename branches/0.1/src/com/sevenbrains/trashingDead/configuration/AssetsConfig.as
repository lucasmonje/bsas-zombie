package com.sevenbrains.trashingDead.configuration {
	
	import com.sevenbrains.trashingDead.configuration.core.AbstractConfig;
	import com.sevenbrains.trashingDead.definitions.AssetDefinition;
	import com.sevenbrains.trashingDead.display.loaders.DefaultAssetLoader;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.net.AbstractLoader;
	import com.sevenbrains.trashingDead.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.Dictionary;
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class AssetsConfig extends AbstractConfig {
		
		private var _autoLoadCounter:int;
		private var _autoLoadTotal:int;
		private var _assetMap:Dictionary;
		
		public function AssetsConfig(map:Dictionary) {
			super(map);
		}
		
		override public function init():void {
			_assetMap = new Dictionary();
			loadList(_configMap[ConfigNodes.AUTO_LOAD] as Array);		
		}
		
		private function loadList(list:Array):void {
			_autoLoadCounter = 0;
			_autoLoadTotal = list.length;
			for each (var assetDef:AssetDefinition in list) {
				var loader:AbstractLoader = makeAsset(assetDef);
				loadAsset(loader);
			}
		}
		
		private function makeAsset(assetDef:AssetDefinition):AbstractLoader {
			var asset:AbstractLoader = (assetDef.type == ConfigNodes.SWFS) ? new DefaultAssetLoader(assetDef.path) : new URLLoader(assetDef.path, 1, true, URLLoaderDataFormat.BINARY);
			_assetMap[assetDef.id] = asset;
			return asset;
		}		
		
		private function loadAsset(asset:AbstractLoader):void {
			asset.addEventListener(Event.COMPLETE, loaderComplete);
			asset.addEventListener(IOErrorEvent.IO_ERROR, loaderError);
			asset.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderError);
			asset.load();
		}
		
		public function get(assetId:String):AbstractLoader {
			return _assetMap[assetId] || makeAsset(getDefById(assetId));
		}
		
		private function getDefById(assetId:String):AssetDefinition {
			return _configMap[ConfigNodes.IDS][assetId];
		}
		
		public function getDefinition(assetId:String, definitionName:String):Class {
			var asset:AbstractLoader = get(assetId);
			if (asset && asset is DefaultAssetLoader && asset.isLoaded() && (asset as DefaultAssetLoader).contentLoaderInfo.applicationDomain.hasDefinition(definitionName)) {
				var classAsset:Class = (asset as DefaultAssetLoader).contentLoaderInfo.applicationDomain.getDefinition(definitionName) as Class;
				return classAsset;
			}
			return null;
		}
		
		private function loaderError(e:*):void {
			if (e.hasOwnProperty("errorMessage")) {
				trace(e.errorMessage);
			}
		}
		
		private function loaderComplete(e:Event):void {
			var asset:AbstractLoader = e.currentTarget as AbstractLoader;
			asset.removeEventListener(Event.COMPLETE, loaderComplete);
			asset.removeEventListener(IOErrorEvent.IO_ERROR, loaderError);
			asset.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderError);
			if (_autoLoadTotal == ++_autoLoadCounter) {
				notifyEnd();
			}
		}
	}
}