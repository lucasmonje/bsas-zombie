package com.sevenbrains.trashingDead.utils
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;

    
    public class Subscription
    {
        private var _dispatcher:IEventDispatcher;
        private var _type:String;
        private var _listener:Function;
        private var _cancelOnDispatch:Boolean;
        
        /**
         * Creates a new subscription
         * 
         * @param dispatcher The event dispatcher who dispatch the event that we want to listen to.
         * @param type The type of the event we want to listen to.
         * @param listener The listener (callback function) that is called when the event is dispatched.
         * @param cancelOnDispatch <code>true</code> if you want the subscription to be canceled
         * after the first event dispatched. <code>false</code> if you want to cancel it manually. 
         *  
         */
        public function Subscription(dispatcher:IEventDispatcher, type:String, listener:Function, cancelOnDispatch:Boolean=true, useCapture:Boolean=false, priority:uint=0, useWeakReference:Boolean=false)
        {
            _dispatcher = dispatcher;
            _type = type;
            _listener = listener;
            _cancelOnDispatch = cancelOnDispatch;
            
            _dispatcher.addEventListener(_type, onEvent, useCapture, priority, useWeakReference);
        }
        
        
        /**
         * Cancel the subscription and "destroys" this object. Called automatically if <code>cancelOnDispatch</code>
         * is set to <code>true</code>
         */
        public function cancel():void
        {
            _dispatcher.removeEventListener(_type, onEvent);
            
            _dispatcher = null;
            _type = null;
            _listener = null;
        }
        
        private function onEvent(event:Event):void
        {
            var listener:Function = _listener;
            if (_cancelOnDispatch) {
                cancel();
            }
            listener(event);
        }
    }
}