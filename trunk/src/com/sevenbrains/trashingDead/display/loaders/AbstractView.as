package com.sevenbrains.trashingDead.display.loaders
{
    import com.sevenbrains.trashingDead.exception.AbstractMethodException;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    
    
    /**
     * @abrtract class
     * 
     * Expone funcionalidad comun para vistas que reciben asset y demas.
     *  
     * @author Nicolas
     * 
     */	
    public class AbstractView extends Sprite
    {
        protected var _asset:Asset;
        
        private var _initialized:Boolean;
        
        
        public function AbstractView()
        {
        }
        
        public function init():void
        {
            _initialized = false;
            
            this.addEventListener(Event.ADDED_TO_STAGE, onAddedTostage, false, 0, true);
            
            if (_asset) {		
                _asset.addEventListener(Event.COMPLETE, onCompleteAsset);
                addChild(_asset);
                mouseEnabled = false;
            }
        }
        
        
        //-------------------------------------------------------
        // Event listener's
        //-------------------------------------------------------
        
        public function set asset(value:Asset):void
        {
            _asset = value;
        }
        
        private function onAddedTostage(e:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedTostage);
            
            creationComplete();
        }
        
        private function onCompleteAsset(e:Event):void
        {
            if(_asset) {
                _asset.removeEventListener(Event.COMPLETE, onCompleteAsset);
                _asset.mouseEnabled = false;
                Sprite(_asset.content).mouseEnabled = false;
            }
            _initialized = true;
            initializedAssets();
        }
        
        //-------------------------------------------------------
        // Abstrac Method's
        //-------------------------------------------------------
        
        protected function initializedAssets():void {
        }
        
        protected function creationComplete():void {
            throw new AbstractMethodException("creationComplete");
        }
        
        
        //-------------------------------------------------------
        // get's & set's
        //-------------------------------------------------------
        
        public function get asset():Asset {
            return _asset;
        }
        
        public function get initialized():Boolean {
            return _initialized;
        }
        
        public function show():void {
            _asset.visible = true;
        }
        
        public function hide():void {
            _asset.visible = false;
        }
        
        public function move(x:Number, y:Number, z:Number=0):void {
            if (x !== _asset.x) {
                _asset.x = x;
            }
            if (y !== _asset.y) {
                _asset.y = y;
            }
            if (z !== _asset.z) {
                _asset.z = z;
            }
        }
        
        public function getPosition():Point {
            return new Point(_asset.x, _asset.y);
        }
        
        public function setSize(width:Number, height:Number):void {
            _asset.width = width;
            _asset.height = height;
        }
        
        public function get spriteContent():Sprite {
            return _asset.content as Sprite;
        }
    }
}