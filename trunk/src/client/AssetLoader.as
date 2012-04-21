package client 
{
	import client.utils.Subscription;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;
	import client.utils.ArrayUtil;
	import client.utils.ClassUtil;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 * 
	 */
	public class AssetLoader extends EventDispatcher {
		
		[Embed (source = "resources\\assets\\common.swf", mimeType = "application/octet-stream")] 
		private var commonAssets:Class;
		
		[Embed (source = "resources\\assets\\stage01.swf", mimeType = "application/octet-stream")] 
		private var stage01:Class;
		
		[Embed (source = "resources\\assets\\zombie01.swf", mimeType = "application/octet-stream")] 
		private var zombie01:Class;

		private static var _instanciable:Boolean;
		
		private static var _instance:AssetLoader;
		
		private var _suscriptionsMap:Dictionary;
		
		private var _allClass:Vector.<Class>;
		
		private var _loaderMap:Dictionary;
		
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
			initializeVars();
			buildClassList();
			loadAllClass();
		}
		
		public function getAssetDefinition(assetName:String, definitionName:String):Class {
			var loader:Loader = getLoader(assetName);
			if (loader) {
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
			_allClass.push(stage01);
			_allClass.push(zombie01);
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