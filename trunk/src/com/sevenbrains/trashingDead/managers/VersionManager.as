package com.sevenbrains.trashingDead.managers
{
	import com.sevenbrains.trashingDead.net.URLLoader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.utils.Dictionary;
    
    public class VersionManager extends EventDispatcher
    {
        private static var _instance:VersionManager;
        private static var instanciationEnabled:Boolean;
        
        public static function get instance():VersionManager
        {
            if (!_instance) {
                instanciationEnabled = true;
                _instance = new VersionManager();
                instanciationEnabled = false;
            }
            return _instance;
        }
        
        private var _loaded:Boolean;
        private var _defaultVersion:String = "0.0";
        private var _urlMap:Dictionary = new Dictionary();
        
        public function VersionManager()
        {
            if (!instanciationEnabled) throw new Error("VersionManager is a singleton class, use instance instead");
        }
        
        public function load(url:String):void
        {
            var loader:URLLoader = new URLLoader(url, 1, false);
            loader.addEventListener(Event.COMPLETE, onLoadComplete);
            loader.load();
        }
        
        public function get defaultVersion():String { return _defaultVersion; }
        
        public function getVersionedUrl(url:String):String
        {
            //TODO: check this, sometimes url comes empty, case of pictures
            if(!url || url=='') return url;
            var version :String = _urlMap[url] || _defaultVersion;
            return url + "?v=" + version;
        }
        
        /**
         * shortcut method to use instead of VersionManager.instance.getVersionedUrl
         * @return String   versioned url
         */
        public static function getUrl(url:String):String
        {
            return instance.getVersionedUrl(url);
        }
        
        private function deserialize(xml:XML):void
        {
            var defVer :String = xml.versions.@default;
            if (defVer) {
                _defaultVersion = defVer;
            }
            
            var paths:XMLList = xml.versions.path;
            for each(var path:XML in paths){
                var files:XMLList = path.file;
                for each(var file:XML in files){
                    var url:String = path.@url + file.@url;
                    _urlMap[url] = file.@version.toString();
                }
            }
        }
        
        private function onLoadComplete(e:Event):void
        {
            var loader:URLLoader = e.target as URLLoader;
            loader.removeEventListener(Event.COMPLETE, onLoadComplete);
            deserialize(new XML(loader.data));
            _loaded = true;
            dispatchEvent(e.clone());
        }
    }
}