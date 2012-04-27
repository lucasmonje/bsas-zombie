package com.sevenbrains.trashingDead.managers 
{
	import com.sevenbrains.trashingDead.utils.ArrayUtil;
	import com.sevenbrains.trashingDead.utils.ClassUtil;
	import com.sevenbrains.trashingDead.utils.Subscription;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 * 
	 */
	public class AssetLoaderBK extends EventDispatcher {
		
		[Embed (source = "..\\..\\..\\..\\..\\assets\\common.swf", mimeType = "application/octet-stream")] 
		private var commonAssets:Class;
		
		[Embed (source = "..\\..\\..\\..\\..\\assets\\backgrounds\\background01.swf", mimeType = "application/octet-stream")] 
		private var background01:Class;
		
		[Embed (source = "..\\..\\..\\..\\..\\assets\\zombies\\zombie01.swf", mimeType = "application/octet-stream")] 
		private var zombie01:Class;

		[Embed (source = "..\\..\\..\\..\\..\\assets\\players\\player01.swf", mimeType = "application/octet-stream")]
		private var player01:Class;
		
		[Embed (source = "..\\..\\..\\..\\..\\assets\\trash\\trashTv.swf", mimeType = "application/octet-stream")]
		private var trashTv:Class;

		[Embed (source = "..\\..\\..\\..\\..\\assets\\item\\itemMolotov.swf", mimeType = "application/octet-stream")]
		private var itemMolotov:Class;

		private static var _instanciable:Boolean;
		
		private static var _instance:AssetLoaderBK;
		
		private var _suscriptionsMap:Dictionary;
		
		private var _allClass:Vector.<Class>;
		
		private var _loaderMap:Dictionary;
		
		public function AssetLoaderBK() {
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
		}
		
		public static function get instance():AssetLoaderBK {
			if (!_instance) {
				_instanciable = true;
				_instance = new AssetLoaderBK();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		public function init():void {
			initializeVars();
			buildClassList();
			loadAllClass();
		}
		
		public function getAssetDefinition(assetName:String, definitionName:String):Class {
			var loader:Loader = getLoader(assetName);
			if (loader && loader.contentLoaderInfo.applicationDomain.hasDefinition(definitionName)) {
				var classAsset:Class = loader.contentLoaderInfo.applicationDomain.getDefinition(definitionName) as Class;
				return classAsset;
			}
			return null;
		}
		
		private function initializeVars():void {
			_allClass = new Vector.<Class>();
			_suscriptionsMap = new Dictionary();
			_suscriptionsMap.arrayMode = new Array();
			_loaderMap = new Dictionary();
		}
			
		private function buildClassList():void {
			_allClass.push(commonAssets);
			_allClass.push(background01);
			_allClass.push(zombie01);
			_allClass.push(player01);
			_allClass.push(trashTv);
			_allClass.push(itemMolotov);
		}
		
		private function loadAllClass():void {
			for each (var clazz:Class in _allClass) {
				loadClass(clazz);
			}
		}
			
		private function loadClass(clazz:Class):void {
			var loader:Loader = new Loader();
			var className:String = ClassUtil.getName(clazz);
			className = className.split("_").pop();
			_loaderMap[className] = loader;
			var suscriptions:Vector.<Subscription> = new Vector.<Subscription>();
			suscriptions.push(new Subscription(loader.contentLoaderInfo, Event.COMPLETE, loaderEvent, false));
			suscriptions.push(new Subscription(loader.contentLoaderInfo, IOErrorEvent.IO_ERROR, loaderEvent, false));
			suscriptions.push(new Subscription(loader.contentLoaderInfo, SecurityErrorEvent.SECURITY_ERROR, loaderEvent, false));
			_suscriptionsMap[loader] = suscriptions;
			_suscriptionsMap.arrayMode.push(suscriptions);
			loader.loadBytes(new clazz());
		}
		
		private function cancelSuscriptions(suscriptions:Vector.<Subscription>):void {
			for each (var suscription:Subscription in suscriptions) {
				suscription.cancel();
				suscription = null;
			}
			ArrayUtil.remove(_suscriptionsMap.arrayMode as Array, suscriptions);
		}
		
		private function loaderEvent(e:*):void {
			var loader:Loader = e.currentTarget as Loader;
			var suscriptions:Vector.<Subscription> = _suscriptionsMap[e.currentTarget.loader];
			cancelSuscriptions(suscriptions);
			delete _suscriptionsMap[e.currentTarget];
			
			if (e.hasOwnProperty("errorMessage")) {
				trace(e.errorMessage);
			}
			
			if (_suscriptionsMap.arrayMode.length == 0) {
				dispatchEvent(new Event(Event.COMPLETE));				
			}
		}
		
		private function getLoader(className:String):Loader {
			return _loaderMap[className] as Loader;
		}
	}

}