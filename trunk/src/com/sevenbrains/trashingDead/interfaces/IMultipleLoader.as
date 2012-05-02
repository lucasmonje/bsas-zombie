package com.sevenbrains.trashingDead.interfaces
{
    
    public interface IMultipleLoader extends ILoader
    {
        /**
         * Adds a loader to this MultipleLoader.
         * 
         * @param loader the loader to add.
         * 
         */
        function addLoader(loader:ILoader):void;
        
        /**
         * @return a copy of the list with all the loaders in this MultipleLoader.
         */
        function get loaderList():Vector.<ILoader>;
        
        /**
         * @return the number of loaders in this MultipleLoader.
         */
        function get loadersAmount():int;
        
        /**
         * @return the number of loaders completed succefully.
         */
        function get loadedCount():int;
    }
}