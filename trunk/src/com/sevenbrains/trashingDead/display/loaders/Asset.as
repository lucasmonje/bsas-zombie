package com.sevenbrains.trashingDead.display.loaders
{
    import com.sevenbrains.trashingDead.net.*;
    import com.sevenbrains.trashingDead.interfaces.IAsset;
	
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.system.ApplicationDomain;
    import flash.utils.ByteArray;
    
    /**
     * Dispatched when data has loaded successfully.
     * @eventType flash.events.Event
     */
    [Event(name = "complete", type = "flash.events.Event")]
    
    /**
     * Dispatched when an input or output error occurs that causes a load operation to fail
     * @eventType flash.events.IOErrorEvent
     */
    [Event(name = "ioError", type = "flash.events.IOErrorEvent")]
    
    /**
     * Dispatched when the object has updated its loading progress
     * @eventType flash.events.ProgressEvent
     */
    [Event(name = "progress", type = "flash.events.ProgressEvent")]
    
    public class Asset extends Sprite implements IAsset
    {
        private var _url:String;
        private var _className:String;
        
        private var _loader:DefaultAssetLoader;
        
        private var _destroyed:Boolean;
        private var _content:DisplayObject;
        
        public function Asset(url:String, className:String=null, retries:uint=1)
        {
            super();
            
            _loader = createLoader(url, retries);
            addLoaderEventListeners();
            
            _url = url;
            _className = className;
            
            _destroyed = false;
        }
        
        protected function createLoader(url:String, retries:uint):DefaultAssetLoader
        {
            return new DefaultAssetLoader(url, retries);
        }
        
        /**
         * Creates a new instance, with the same URL and class name.
         */
        public function clone():IAsset
        {
            return new Asset(_url, _className);
        }
        
        /**
         * Removes all listeners from the loader and removes all references.
         */
        public function destroy():void
        {
            if (_loader) {
                removeLoaderEventListeners();
                _loader.destroy();
            }
            
            _loader = null;
            _destroyed = true;
        }
        
        /**
         * If the asset is destroyed.
         * Returns true only if the destroy() method has been called.
         */
        public function isDestroyed():Boolean
        {
            return _destroyed;
        }
        
        /**
         * Searchs for a definition in the asset application domain.
         * 
         * Note: This method checks if there's a definition by using the "hasDefinition()" method.
         * Avoid using that method to check before asking for a definition.
         * Instead, ask for the definition, and then check if its null.
         * 
         * @param name A string that matches the linkage name of the definition.
         * @return A definition. Returns null if theres no definition.
         */
        public function getDefinition(name:String):Object
        {
            if (!hasDefinition(name)) {
                return null;
            }
            
            return applicationDomain.getDefinition(name);
        }
        
        /**
         * Checks if there's a definition with the given name in the asset application domain.
         * 
         * @param name A string that matches the linkage name of the definition.
         * @return A flag representing the existence of the definition.
         */
        public function hasDefinition(name:String):Boolean
        {
            return applicationDomain.hasDefinition(name);
        }
        
        /**
         * Gets the definition of the asset class name.
         * 
         * @return The class of the asset class name inside the asset application domain.
         */
        public function getContentClass():Class
        {
            return getDefinition(_className) as Class;
        }
        
        /**
         * Gets the name of the asset class.
         * 
         * @return the class name. Returns null if the asset does not have a class name.
         */
        public function getClassName():String
        {
            return _className;
        }
        
        
        /**
         * Loads a ByteArray and converts it into a bitmap. This is used to load a zip png. The
         * loading flow is the same as using the load() method but you must use isContentLoaded()
         * instead of isLoaded() to know when the asset is loaded.
         * <p/>
         * @see Asset#isContentLoaded()
         * 
         * @param ba an image as a ByteArray.
         */
        public function loadBytes(ba:ByteArray):void
        {
            _loader && _loader.loadBytes(ba);
        }
        
        /**
         * Loads an asset using the url pased in the constructor. Note that the URL can't be change on the fly.
         * When the loading is completed the "Event.COMPLETE" event is dispatched.
         */
        public function load():void
        {
            _loader && _loader.load();
        }
        
        /**
         * Checks if the bytes are loaded.
         * Note that this method checks only the existance of the loader content.
         * check with this method if you are loading a byte chunk using the loadByte() method.
         * 
         * @return If the bytes has been loaded.
         */
        public function isContentLoaded():Boolean
        {
            return _loader && _loader.isContentLoaded();
        }
        
        /**
         * Checks if the bytes loaded of the content loader info are equal to the total bytes.
         * 
         * @return If the asset is loaded.
         */
        public function isLoaded():Boolean
        {
            return _loader && _loader.isLoaded();
        }
        
        public function getInstanceByName(name:String):DisplayObject 
        {
            var DisplayClass:Class = getDefinition(name) as Class;
            if (DisplayClass == null) {
                return null;
            }
            
            var dob:DisplayObject =  new DisplayClass() as DisplayObject;
            var mc:MovieClip = dob as MovieClip;
            if (mc) {
                stopMovieClip(mc);
            }
            
            return dob;
        }
        
        /**
         * The URL of the asset. Can't be null.
         */
        public function get url():String
        {
            return _url;
        }
        
        /**
         * The content of the asset as a display object.
         */
        public function get content():DisplayObject
        {
            return _content;
        }
        
        // ---------------------------------------------------------------------------
        // ----------------------------- PRIVATE METHODS -----------------------------
        // ---------------------------------------------------------------------------
        
        protected function onComplete(event:Event):void
        {
            if (!_content) {
                _content = getContent();
                if (_content) {
                    addChild(_content);
                }
            }
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        protected function onProgress(event:ProgressEvent):void
        {
            dispatchEvent(event);
        }
        
        protected function onError(event:IOErrorEvent):void
        {
            dispatchEvent(event);
        }
        
        private function stopMovieClip(mc:MovieClip):void
        {
            mc.stop();
            for(var i:int = 0; i < mc.numChildren; i++)
            {
                var child:MovieClip = mc.getChildAt(i) as MovieClip;
                if( child ) {
                    stopMovieClip(child);
                }
            }
        }
        
        private function getContent():DisplayObject
        {
            if (_className) {
                return getInstanceByName(_className);
            }
            var cont:DisplayObject = _loader.content as DisplayObject;
            if (cont is Bitmap) {
                cont = new Bitmap((cont as Bitmap).bitmapData.clone());
            }
            if (cont is MovieClip) {
                stopMovieClip(MovieClip(cont));
            }
            
            return cont;
        }
        
        override public function toString():String
        {
            return '[Asset ' + _url + ']';
        }
        
        private function get applicationDomain():ApplicationDomain
        {
            return _loader.contentLoaderInfo.applicationDomain;
        }
        
        private function addLoaderEventListeners():void
        {
            _loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
            _loader.addEventListener(Event.COMPLETE, onComplete);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
        }
        
        private function removeLoaderEventListeners():void
        {
            _loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            _loader.removeEventListener(Event.COMPLETE, onComplete);
            _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            _loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        }
    }
}