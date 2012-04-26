package com.sevenbrains.trashingDead.managers 
{
	import com.sevenbrains.trashingDead.utils.ArrayUtil;
	import com.sevenbrains.trashingDead.utils.ClassUtil;
	import com.sevenbrains.trashingDead.utils.CustomLoader;
	import com.sevenbrains.trashingDead.utils.Subscription;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 * 
	 */
	public class AssetLoader extends EventDispatcher {
		
		[Embed(source = '..\\..\\..\\..\\..\\resources\\assets-config.xml', mimeType = "application/octet-stream")]
		private var cXml:Class;

		private static var _instanciable:Boolean;
		
		private static var _instance:AssetLoader;
		
		private var _map:Dictionary;
		
		private var _counter:int;
		private var _total:int;
		
		public function AssetLoader() {
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
		}
		
		public static function get instance():AssetLoader {
			if (!_instance) {
				_instanciable = true;
				_instance = new AssetLoader();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		public function init():void {
			var byteArray:ByteArray = new cXml() as ByteArray;
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			
			_map = new Dictionary();
			_total = 0;
			_counter = 0;
			
			decodeSwfs("swfs", xml.swfs);
		}
		
		private function decodeSwfs(key:String, xml:XMLList):void {
			var swfs:Dictionary = new Dictionary();
			
			for each(var element:XML in xml.elements()) {
				_total++;
				var loader:CustomLoader = new CustomLoader(swfs, element.@id);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderEvent);
				//loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderEvent);
				//loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderEvent);
				
				loader.load(new URLRequest("../assets/" + element.@path));
			}
			
			_map[key] = swfs;
		}
		
		public function getAssetDefinition(assetName:String, definitionName:String):Class {
			var swfs:Dictionary = _map["swfs"];
			var loader:CustomLoader = swfs[assetName];
			if (loader && loader.contentLoaderInfo.applicationDomain.hasDefinition(definitionName)) {
				var classAsset:Class = loader.contentLoaderInfo.applicationDomain.getDefinition(definitionName) as Class;
				return classAsset;
			}
			/*
			var loader:Loader = getLoader(assetName);
			if (loader && loader.contentLoaderInfo.applicationDomain.hasDefinition(definitionName)) {
				var classAsset:Class = loader.contentLoaderInfo.applicationDomain.getDefinition(definitionName) as Class;
				return classAsset;
			}
			*/
			return null;
		}
		
		private function loaderEvent(e:Event):void {
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:CustomLoader = loaderInfo.loader as CustomLoader;
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderEvent);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderEvent);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderEvent);
				
			if (e.hasOwnProperty("errorMessage")) {
				//trace(e.errorMessage);
			}else {
				var map:Dictionary = loader.map;
				map[loader.assetName] = loader;
				if (_total == ++_counter){
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
	}

}