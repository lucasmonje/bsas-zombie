package com.sevenbrains.trashingDead.managers
{
    import com.sevenbrains.trashingDead.utils.FunctionUtils;
    import com.sevenbrains.trashingDead.utils.Subscription;
    
    import flash.display.Loader;
    import flash.errors.IllegalOperationError;
    import flash.events.AsyncErrorEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.system.System;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    public class GraphicLoaderCache
    {
        private static var instance:GraphicLoaderCache;
        private static var allow:Boolean = false;
        
        //static
        {
            GraphicLoaderCache.allow = true;
            GraphicLoaderCache.instance = new GraphicLoaderCache();
            GraphicLoaderCache.allow = false;
        }
        
        private var caches:Dictionary;
        private var _subscriptions:Array;
        
        public function GraphicLoaderCache()
        {
            if (!allow) {
                throw new IllegalOperationError("GraphicLoaderCache is a singleton class");
            }
            
            caches = new Dictionary();
        }
        
        static public function getInstance():GraphicLoaderCache {
            return instance; 
        }
        
        /**
         * Removes a request from the cache.
         * 
         * @param request the request to remove from cache.
         * @return <code>true</code> if the request is removed. <code>false</code> otherwise.
         * 
         */
        public function remove(request:URLRequest):Boolean
        {
            if (request == null) {
                return false;
            }
            return delete caches[request.url];
        }
        
        /**
         * Creates a loader, and starts loading a graphic, based on the given request.
         * If the grpahic has already been requested, then the same loader is used instead.
         * 
         * @param request The URL Request.
         * @param context A specific context to load the graphic. If no context is passed, then the default context is used.
         * @return The loader used to load the graphic.
         */
        public function loadGraphic(request:URLRequest, context:LoaderContext = null):Loader
        {
            var loader:Loader;
            if (request.url in caches) {
                loader = caches[request.url] as Loader;
            }
            else {
                loader = new flash.display.Loader();
                caches[request.url] = loader;
                addEventListeners(loader, request);
                loader.load(request, context);
            }
            return loader;
        }
        
        /**
         * Creates a loader, and starts loading a byte array.
         * If the byte array has already been requested, then the same loader is used instead.
         * 
         * @param request The url request used to cache the loader.
         * @para ba The byte array to load.
         * @param context A specific context to load the graphic. If no context is passed, then the default context is used.
         * @return The loader used to load the byte array. 
         */
        public function loadBytes(request:URLRequest, ba:ByteArray, context:LoaderContext = null):Loader 
        {
            var loader :Loader;
            if (request.url in caches) {
                loader = caches[request.url] as Loader;
            }
            else {
                loader = new flash.display.Loader();
                caches[request.url] = loader;
                addEventListeners(loader, request);
                loader.loadBytes(ba, context);
            }
            return loader;
        }
        
        /**
         * Creates a URL loader, and starts loading string data.
         * If the data has already been requested, then the same loader is used instead.
         * 
         * @param request The URL Request.
         * @param dataFormat The format of the loaded data.
         * @return The url loader used to load the data.
         */
        public function loadData(request:URLRequest, dataFormat:String):URLLoader
        {
            var loader:URLLoader;
            
            if (request.url in caches) {
                loader = caches[request.url] as URLLoader;
            }
            else {
                loader = new URLLoader();
                loader.dataFormat = dataFormat;
                caches[request.url] = loader;
                addEventListeners(loader, request);
                loader.load(request);
            }
            return loader;
        }
        
        /**
         * Removes all loaders in cache, and calls for the garbage collector.
         */
        public function clear():void
        {
            for (var url:String in caches) {
                delete caches[url];
            }
            
            System.gc();
        }
        
        private function onError(event:Event, request:URLRequest):void
        {
            remove(request);
        }
        
        private function addEventListeners(loader:IEventDispatcher, request:URLRequest):void
        {
            if (_subscriptions) {
                cancelSubscriptions();
            }
            _subscriptions = [
                new Subscription(loader, IOErrorEvent.IO_ERROR, FunctionUtils.attachParamsTo(onError, request)),
                new Subscription(loader, SecurityErrorEvent.SECURITY_ERROR, FunctionUtils.attachParamsTo(onError, request))
            ];
        }
        
        private function cancelSubscriptions():void
        {
            for each (var subscription:Subscription in _subscriptions) {
                subscription.cancel();
            }
            _subscriptions = null;
        }
    }
}