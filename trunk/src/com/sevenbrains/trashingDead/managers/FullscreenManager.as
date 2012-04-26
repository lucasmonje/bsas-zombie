package com.sevenbrains.trashingDead.managers
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.geom.Point;
	
	public class FullscreenManager extends EventDispatcher
	{
		private var _root:DisplayObjectContainer;
		private var _originalHeight:int;
		private var _originalWidth:int;
		
		private static var _instance:FullscreenManager;
		private static var instanciationEnabled:Boolean;
		
		public static function get instance():FullscreenManager
		{
			if (!_instance) {
				instanciationEnabled = true;
				_instance = new FullscreenManager();
				instanciationEnabled = false;
			}
			return _instance;
		}
		
		public function FullscreenManager()
		{
			if (!instanciationEnabled) throw new Error("FullscreenManager is a singleton class, use instance property instead");
		}
		
		public function toggle():void
		{
			isFullScreen = !isFullScreen;
		}
		
		public function get stage():Stage 
		{
			return _root.stage; 
		}
		
		public function get isFullScreen():Boolean
		{
			return stage.displayState == StageDisplayState.FULL_SCREEN;
		}
		
		public function set isFullScreen(v:Boolean):void
		{
			if (v !== isFullScreen) {
				stage.displayState = v ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
			}
		}
		
		public function set root(value:DisplayObjectContainer):void
		{
			_root = value;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, stageOnFullscreen);
			_originalHeight = stage.stageHeight;
			_originalWidth = stage.stageWidth;
		}
		
		public function get stageWidth():int 
		{ 
			return _originalWidth;	
		}
		
		public function get stageHeight():int 
		{ 
			return _originalHeight;
		}
		
		
		public function get stageWidthFS():int 
		{ 
			return stage.stageWidth;	
		}
		
		public function get stageHeightFS():int 
		{ 
			return stage.stageHeight;
		}
		
		
		public function get right():Number 
		{
			return Math.floor((stage.stageWidth - _root.x)/_root.scaleX);
		}
		
		public function get left():Number 
		{
			return 0 - (_root.x/_root.scaleX);
		}
		
		private function stageOnFullscreen(e:FullScreenEvent):void
		{
			if(e.fullScreen)
			{
				_root.scaleY = stage.stageHeight / _originalHeight;
				_root.scaleX = _root.scaleY;
				_root.x = Math.floor((stage.stageWidth - (_originalWidth * _root.scaleX))/2);
			}
			else
			{
				_root.scaleX = _root.scaleY = 1;
				_root.x = 0
			}
			
			dispatchEvent(e); 
			dispatchEvent(new Event(Event.RESIZE)); 
		}

		public function get inverseScale() : Point
		{
			var p : Point = new Point();
			p.x = 1 / _root.scaleY;
			p.y = 1 / _root.scaleX;
			
			return p;
		}
	}
}