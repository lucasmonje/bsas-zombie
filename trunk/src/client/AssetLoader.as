package client 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class AssetLoader extends EventDispatcher
	{
		[Embed (source = "resources\\assets\\index.swf", mimeType = "application/octet-stream")] private var _cAssets:Class;
		
		private static var _instanciable:Boolean;
		private static var _instance:AssetLoader;
		
		private var _assets:Loader;
		
		public function AssetLoader() 
		{
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
			_assets = new Loader();
			_assets.loadBytes(new _cAssets());
			_assets.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoded);
		}
		
		private function onAssetLoded(e:Event):void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function getAssetDefinition(name:String):Class {
			var cAsset:Class = _assets.contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
			
			return cAsset;
		}
	}

}