package com.sevenbrains.trashingDead.interfaces
{
    import com.sevenbrains.trashingDead.interfaces.Destroyable;
    import com.sevenbrains.trashingDead.interfaces.ILoader;
    
    import flash.events.IEventDispatcher;
    
    public interface IAsset extends ILoader
    {
        function get url():String;
        function clone():IAsset;
        function hasDefinition(name:String):Boolean;
        function getDefinition(name:String):Object;
    }
}