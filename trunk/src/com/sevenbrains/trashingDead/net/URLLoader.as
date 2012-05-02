package com.sevenbrains.trashingDead.net
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;

    public class URLLoader extends AbstractLoader
    {
        private var _urlLoader:flash.net.URLLoader;
        private var _dataFormat:String;
        
        public function URLLoader(url:String, retries:uint=1, versioned:Boolean=true, dataFormat:String=URLLoaderDataFormat.TEXT)
        {
            super(url, retries, versioned);
            _dataFormat = dataFormat;
            init();
        }
        
        /**
         * @return the loaded data.
         */
        public function get data():* { return _urlLoader.data; }
        
        /**
         * @return the number of bytes loaded so far.
         */
        public function get bytesLoaded():uint { return _urlLoader.bytesLoaded; }
        
        /**
         * @return the total number of bytes to load.
         */
        public function get bytesTotal():uint { return _urlLoader.bytesTotal; }
        
        /**
         * @inheritDoc
         */
        override public function clone():AbstractLoader
        {
            return new URLLoader(_url, _retries, _versioned, _dataFormat);
        }
        
        /**
         * @inheritDoc
         */
        override public function isLoaded():Boolean
        {
            return _urlLoader
                && _urlLoader.bytesTotal > 0
                && _urlLoader.bytesLoaded >= _urlLoader.bytesTotal;
        }
        
        /**
         * @inheritDoc
         */
        override protected function doLoad():void
        {
            _urlLoader.load(_request);
        }
        
        /**
         * @inheritDoc
         */
        override public function destroy():void
        {
            removeLoaderListeners();
            _urlLoader = null;
            
            super.destroy();
        }
        
        private function init():void
        {
            _urlLoader = new flash.net.URLLoader();
            _urlLoader.dataFormat = _dataFormat;
            addLoaderListeners();
        }
        
        private function addLoaderListeners():void
        {
            _urlLoader.addEventListener(Event.COMPLETE, onComplete);
            _urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
            _urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            _urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
        }
        
        private function removeLoaderListeners():void
        {
            _urlLoader.removeEventListener(Event.COMPLETE, onComplete);
            _urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            _urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            _urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        }
    }
}