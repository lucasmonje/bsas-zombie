package com.sevenbrains.trashingDead.interfaces
{
    import com.sevenbrains.trashingDead.interfaces.Destroyable;
    
    import flash.events.IEventDispatcher;
    
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
    
    public interface ILoader extends IEventDispatcher, Destroyable
    {
        function load():void;
        function isLoaded():Boolean;
    }
}