package com.sevenbrains.trashingDead.managers {
	import com.sevenbrains.trashingDead.display.loaders.Asset;
	import com.sevenbrains.trashingDead.utils.BooleanUtils;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	
	/**
	* ...
	* @author Fulvio Crescenzi
	*
	*/
	public class AssetLoader extends EventDispatcher {
		
		private var _map:Dictionary;
		private var _counter:int;
		private var _total:int;
		
		public function AssetLoader() {
		}
		
		public function init():void {
			/*
			var byteArray:ByteArray = new EmbedAsset.assetsConfigClass() as ByteArray;
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			_map = new Dictionary();
			_total = 0;
			_counter = 0;
			decodeaAssets(ConfigNodes.SWFS, xml.swfs);
			decodeaAssets(ConfigNodes.SOUNDS, xml.sounds);
			*/
		}
		
		private function decodeaAssets(key:String, xmlNodes:XMLList):void {
			var assets:Dictionary = new Dictionary();
			var folderPath:String = XML(xmlNodes[0]).@folderPath.toString();
			for each (var element:XML in xmlNodes.elements()) {
				var asset:Asset = new Asset(folderPath + element.@path);
				assets[element.@id.toString()] = asset;
				if (BooleanUtils.fromString(element.@autoLoad.toString())) {
					_total++;
					asset.addEventListener(Event.COMPLETE, loaderComplete);
					asset.addEventListener(IOErrorEvent.IO_ERROR, loaderError);
					asset.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderError);
					asset.load();
				}
			}
			_map[key] = assets;
		}
		
		public function getAssetDefinition(swfId:String, definitionName:String):Class {
			var asset:Asset = getAssetSWF(swfId);
			if (asset && asset.isLoaded() && asset.hasDefinition(definitionName)) {
				var classAsset:Class = asset.getDefinition(definitionName) as Class;
				return classAsset;
			}
			return null;
		}
		
		public function getAssetSWF(assetName:String):Asset {
			var swfs:Dictionary = _map[ConfigNodes.SWFS];
			return swfs[assetName];
		}
		
		private function loaderError(e:*):void {
			if (e.hasOwnProperty("errorMessage")) {
				trace(e.errorMessage);
			}
		}
		
		private function loaderComplete(e:Event):void {
			var asset:Asset = e.currentTarget as Asset;
			asset.removeEventListener(Event.COMPLETE, loaderComplete);
			asset.removeEventListener(IOErrorEvent.IO_ERROR, loaderError);
			asset.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderError);
			if (_total == ++_counter) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}