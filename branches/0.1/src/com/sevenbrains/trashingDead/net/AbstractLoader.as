package com.sevenbrains.trashingDead.net
{
    import com.sevenbrains.trashingDead.exception.AbstractMethodException;
    import com.sevenbrains.trashingDead.interfaces.ILoader;
	import com.sevenbrains.trashingDead.managers.VersionManager;
	
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
    
    public class AbstractLoader implements ILoader
    {
        /**
         * Original (not versioned) url of the file to load.
         */
        protected var _url:String;
        
        /**
         * Number of retries to make before cancel the load and dispatch an error.
         * @default 1
         */
        protected var _retries:uint;
        
        /**
         * Request to a versioned url (using VersionManager.getUrl)
         */
        protected var _request:URLRequest;
        
        /**
         * <code>true</code> if this loader must use VersionManager to load the current
         * version or <code>false</code> when this object don't have to manage the version of
         * the file to load.
         */
        protected var _versioned:Boolean;
        
        private var _dispatcher:EventDispatcher;
        private var _performedRetries:uint;
        private var _destroyed:Boolean;
        
        public function AbstractLoader(url:String, retries:uint = 1, versioned:Boolean = true)
        {
            _url = url;
            _retries = retries;
            _versioned = versioned;
            
            _request = createRequest();
            
            _dispatcher = new EventDispatcher(this);
            _performedRetries = 0;
            _destroyed = false;
        }
        
        /**
         * @return The url of the file to load.
         */
        public function get url():String
        {
            return _url;
        }
        
        [Abstract]
        /**
         * <b>ABSTRACT METHOD!</b>
         * <p/>
         * Constructs a clone of this loader so it can be reused.
         * <p/>
         * @return a new instance of this loader.
         * 
         */
        public function clone():AbstractLoader
        {
            throw new AbstractMethodException('clone');
        }
        
        [Abstract]
        /**
         * <b>ABSTRACT METHOD!</b>
         * <p/>
         * Checks whether the loading operation is completed or not.
         * <p/>
         * @return <code>true</code> when the loading operation is completed. <code>false</code> otherwise.
         * 
         */
        public function isLoaded():Boolean
        {
            throw new AbstractMethodException('isLoaded');
        }
        
        [Abstract]
        /**
         * <b>ABSTRACT METHOD!</b>
         * <p/>
         * Override this to perform the loading operation.
         * <p/>
         * <ul>
         *   <li>When a loading error occurrs, call <code>onError(Event)</code> method.</li>
         *   <li>When the load progress, call <code>onProgress(ProgressEvent)</code> method.</li>
         *   <li>When the load is completed successfully, call <code>onComplete(Event)</code> method.</li>
         * </ul>
         * <p/>
         * @see DefaultLoader#load()
         * @see DefaultLoader#onError()
         * @see DefaultLoader#onComplete()
         * @see DefaultLoader#onProgress()
         */
        protected function doLoad():void
        {
            throw new AbstractMethodException('doLoad');
        }
        
        /**
         * Starts the load of the configured url. To perform the loading operation
         * override <code>doLoad</code> method.
         * <p/>
         * If the loading operation is already completed (if the <code>isLoaded()</code> method
         * return <code>true</code>) then this method do not call <code>doLoad()</code> method but
         * dispatches the <code>Event.COMPLETE</code> event calling <code>onComplete(Event)</code>
         * <p/>
         * @see DefaultLoader#doLoad()
         * @see DefaultLoader#onComplete(Event)
         * 
         */
        final public function load():void
        {
            if (isLoaded()) {
                onComplete(new Event(Event.COMPLETE));
                return;
            }
            
            doLoad();
        }
        
        /**
         * @inheritDoc
         */
        public function destroy():void
        {
            _url = null;
            _request = null;
            _dispatcher = null;
            _retries = 0;
            _performedRetries = 0;
            
            _destroyed = true;
        }
        
        /**
         * @inheritDoc
         */
        public function isDestroyed():Boolean
        {
            return _destroyed;
        }
        
        /**
         * Constructs an URLRequest to use by the loading operation.
         * 
         * @return a new request with a versioned url.
         * 
         */
        protected function createRequest():URLRequest
        {
            var url:String = _url;
            if (_versioned) {
                url = VersionManager.getUrl(url);
            }
            return new URLRequest(url);
        }
        
        /**
         * Called when an error occurred while loading the data.
         * 
         * @param event an event with IOErrorEvent.IO_ERROR as its type
         * 
         * @see DefaultLoader#doLoad()
         */
        protected function onError(event:Event):void
        {
            event.preventDefault();
            event.stopImmediatePropagation();
            var errorMessage:String = 'Failed to load file: ' + _url + ' [attempt ' + (_performedRetries+1) +'] (error: ' + event + ')';
            if (_performedRetries < _retries) {
                _performedRetries++;
                trace(errorMessage);
                load();
            } else {
                trace(errorMessage);
                dispatchEvent(event.clone());
            }
        }
        
        /**
         * Called when the load operation is completed successfully.
         * 
         * @param event an event with Event.COMPLETE as its type.
         * 
         * @see DefaultLoader#doLoad()
         */
        protected function onComplete(event:Event):void
        {
            _performedRetries = 0;
            dispatchEvent(event.clone());
        }
        
        /**
         * Called when the load operation update its progress.
         * 
         * @param event an event with ProgressEvent.PROGRESS as its type.
         * 
         * @see DefaultLoader#doLoad()
         */
        protected function onProgress(event:ProgressEvent):void
        {
            dispatchEvent(event.clone());
        }
        
        // --- IEventDispatcher --- //
        public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void { _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference); }
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void { _dispatcher.removeEventListener(type, listener, useCapture); }
        public function dispatchEvent(event:Event):Boolean { return _dispatcher.dispatchEvent(event); }
        public function hasEventListener(type:String):Boolean { return _dispatcher.hasEventListener(type); }
        public function willTrigger(type:String):Boolean { return _dispatcher.willTrigger(type); }
        // --- IEventDispatcher --- //
    }
}