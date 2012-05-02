package com.sevenbrains.trashingDead.display.popup
{
	import com.sevenbrains.trashingDead.managers.FullscreenManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Helper class for popups 
	 * @author matiasm
	 * 
	 */	
	public class PopupData
	{
		
		
		public var window:IPopup;
		
		public var center:Boolean;
		
		public var modal:Boolean;
		
		public var animate:Boolean;
		
		public var channel:PopupChannel;
		
		private var _modalWindow:Sprite;
		
		public function PopupData()
		{
			//Constructor
		}

		/**
		 *  @private
		 *  Set by PopUpManager on modal windows to make sure they cover the whole screen
		 */
		public function resizeHandler(event:Event):void
		{
			if(_modalWindow )
			{
				var fsm:FullscreenManager = event.target as FullscreenManager;
				
				if(fsm.isFullScreen)
				{
					_modalWindow.width = fsm.stage.fullScreenWidth;
					_modalWindow.height = fsm.stage.fullScreenWidth;
					DisplayObject(window).x = fsm.stage.fullScreenWidth/2;
					DisplayObject(window).y = fsm.stageHeight/2;
				}
				else
				{
					_modalWindow.width = fsm.stageWidth;
					_modalWindow.height = fsm.stageHeight;
					DisplayObject(window).x = fsm.stageWidth/2;
					DisplayObject(window).y = fsm.stageHeight/2;
				}
				
				_modalWindow.x = fsm.stage.x;
				_modalWindow.y = fsm.stage.y;

			}
			
		}

		public function get modalWindow():Sprite
		{
			return _modalWindow;
		}

		public function set modalWindow(value:Sprite):void
		{
			_modalWindow = value;
		}

		
	}
	
}