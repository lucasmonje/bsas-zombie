package com.sevenbrains.trashingDead.net
{
    import com.vostu.commons.net.ILoader;
    
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.system.SecurityDomain;
    
    /**
     * The RslLoader class loads a runtime shared library into a context with a specified
     * application domain and/or security domain.
     *
     * @see flash.system.ApplicationDomain
     * @see flash.system.SecurityDomain
     *
     * @author German Allemand 
     */
    public class RslLoader extends AbstractLoader
    {
        protected var _context:LoaderContext;
        protected var _loader:Loader;
        protected var _loaded:Boolean;
        
        public function RslLoader(url:String, applicationDomain:ApplicationDomain=null, securityDomain:SecurityDomain=null, retries:uint=1)
        {
            super(url, retries);
            init(applicationDomain, securityDomain);
        }
        
        protected function init(applicationDomain:ApplicationDomain, securityDomain:SecurityDomain):void
        {
            if (!applicationDomain) {
                applicationDomain = ApplicationDomain.currentDomain;
            }
            
            _context = new LoaderContext();
            _context.applicationDomain = applicationDomain;
            _context.checkPolicyFile = true;
            _context.securityDomain = securityDomain;
            
            _loader = new Loader();
            addLoaderEventListeners();
            
            _loaded = false;
        }
        
        /**
         * @inheritDoc
         */
        override public function clone():AbstractLoader
        {
            return new RslLoader(_url, _context.applicationDomain, _context.securityDomain, _retries);
        }
        
        /**
         * @inheritDoc
         */
        override public function isLoaded():Boolean
        {
            return _loaded;
        }
        
        /**
         * @inheritDoc
         */
        override protected function doLoad():void
        {
            _loader.load(_request, _context);
        }
        
        /**
         * @inheritDoc
         */
        override public function destroy():void
        {
            removeLoaderEventListeners();
            _loader = null;
            _context = null;
            
            super.destroy();
        }
        
        /**
         * @return the number of bytes already loaded.
         */
        public function get bytesLoaded():uint
        {
            if (!_loader) {
                return 0;
            }
            
            return _loader.contentLoaderInfo.bytesLoaded;
        }
        
        /**
         * @return the total number of bytes to be loaded.
         */
        public function get bytesTotal():uint
        {
            if (!_loader) {
                return 0;
            }
            
            return _loader.contentLoaderInfo.bytesTotal;
        }
        
        /**
         * @return the application domain to load this rsl into.
         */
        public function get applicationDomain():ApplicationDomain
        {
            return _context.applicationDomain;
        }
        
        /**
         * @param domain the application domain to load this rsl into.
         */
        public function set applicationDomain(domain:ApplicationDomain):void
        {
            _context.applicationDomain = domain;
        }
        
        /**
         * @return the security domain to load this rsl into.
         */
        public function get securityDomain():SecurityDomain
        {
            return _context.securityDomain;
        }
        
        /**
         * @param domain the security domain to load this rsl into.
         */
        public function set securityDomain(domain:SecurityDomain):void
        {
            _context.securityDomain = domain;
        }
        
        /**
         * @inheritDoc
         */
        override protected function onComplete(event:Event):void
        {
            _loaded = true;
            super.onComplete(event);
        }
        
        public function toString():String
        {
            return "[RslLoader url: " + _url + " ]";
        }
        
        private function addLoaderEventListeners():void
        {
            var info:LoaderInfo = _loader.contentLoaderInfo;
            
            info.addEventListener(ProgressEvent.PROGRESS, onProgress);
            info.addEventListener(Event.COMPLETE, onComplete);
            info.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            info.addEventListener(IOErrorEvent.IO_ERROR, onError);
        }
        
        private function removeLoaderEventListeners():void
        {
            if (!_loader) {
                return;
            }
            
            var info:LoaderInfo = _loader.contentLoaderInfo;
            
            if (!info) {
                return;
            }
            
            info.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            info.removeEventListener(Event.COMPLETE, onComplete);
            info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            info.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        }
    }
    
}