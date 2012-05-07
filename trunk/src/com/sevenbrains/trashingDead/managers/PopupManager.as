package com.sevenbrains.trashingDead.managers {
	
	import com.sevenbrains.trashingDead.display.popup.IPopup;
	import com.sevenbrains.trashingDead.display.popup.PopupChannel;
	import com.sevenbrains.trashingDead.display.popup.PopupData;
	import com.sevenbrains.trashingDead.events.PopupEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;
	import com.sevenbrains.trashingDead.managers.FullscreenManager;
	
	/**
	*
	* @author matiasm
	*
	*/
	public class PopupManager extends EventDispatcher {
		
		protected var container:DisplayObjectContainer;
		protected var channels:Dictionary;
		protected var currentPopups:Dictionary;
		protected var _fullscreenManager:FullscreenManager;
		private var pendingChannel:PopupChannel;
		protected var popupInfo:Array = [];
		protected var currentPopup:PopupData;
		public var modalAlpha:Number = 0.4;
		public var modalColor:uint = 0x000000;
		protected var _blockRender:Boolean;
		
		private static var _instance:PopupManager;
		
		public function set blockRender(value:Boolean):void {
			_blockRender = value;
		}
		
		public static function get instance():PopupManager	{
			return _instance || (_instance = new PopupManager());
		}
		
		public function PopupManager() {
			init();
		}
		
		private function init():void {
			currentPopups = new Dictionary();
			_fullscreenManager = FullscreenManager.instance;
			setupChannels();			
		}
		
		public function setLayer(container:DisplayObjectContainer):void {
			this.container = container;			
		}
		
		public function getPopup(channel:PopupChannel):PopupData {
			if (!channel) {
				channel = PopupChannel.DEFAULT;
			}
			return getCurrentPopup(channel);
		}
		
		public function closeCurrentPopup(channel:PopupChannel):void {
			if (!channel) {
				channel = PopupChannel.DEFAULT;
			}
			var popup:PopupData = getCurrentPopup(channel);
			if (popup) {
				removePopup(popup.window);
			}
		}
		
		/**
		* Pops up a top-level window and open the popup
		* <br>Set popup properties: <br>center: centers the popup <br>modal window<br>animate
		* @param popup
		*
		*/
		public function addPopup(window:IPopup, channel:PopupChannel=null, center:Boolean=true, modal:Boolean=true, animate:Boolean=true):void {
			var popupData:PopupData = addPopupData(window, channel, center, modal, animate);
			addListenersToPopupData(popupData);
			if (getQueue(popupData.channel).length == 1) {
				evalOpenNextPopup(channel);
			}
		}
		
		public function getQueue(channel:PopupChannel):Vector.<PopupData> {
			if (!channel)
				channel = PopupChannel.DEFAULT;
			return this.channels[channel];
		}
		
		public function removeFromQueueAt(position:int, channel:PopupChannel=null):void {
			if (!channel)
				channel = PopupChannel.DEFAULT;
			var vector:Vector.<PopupData> = channels[channel];
			vector.splice(position, 1);
		}
		
		/**
		* Free resources used by the poup and destroy its internal components
		* Once it's done open next popup queued
		*
		* @param popup
		*
		*/
		public function removePopup(popup:IPopup):void {
			var data:PopupData;
			var n:int = popupInfo.length;
			var currentWindow:IPopup = popup;
			var found:Boolean;
			for (var i:int = 0; i < n; i++) {
				data = popupInfo[i];
				if (currentWindow == data.window) {
					if (data.modal)
						removeModal(data.modalWindow);
					data.window.removeEventListener(PopupEvent.END_CLOSE, onClosePopup);
					removeListenersToPopupData(data);
					setCurrentPopup(data.channel, null);
					if (this.container.contains(data.window as DisplayObject)) {
						this.container.removeChild(data.window as DisplayObject);
					}
					data.window.destroy();
					popupInfo.splice(i, 1);
					if (_blockRender && data.modal) {
						//_blittingStage.unblock();
					}
					openNextPopup(data.channel);
					break;
				}
			}
		}
		
		/**
		*  removes the modal window from the popup
		*/
		private function removeModal(popupModalWindow:Sprite):void {
			popupModalWindow.graphics.clear();
			container.removeChild(popupModalWindow);
		}
		
		/**
		* Opens the next popup in queue.
		*/
		protected function evalOpenNextPopup(channel:PopupChannel):void {
			if (this.getCurrentPopup(channel)) {
				return;
			}
			if (this.getQueue(channel).length == 0) {
				this.setCurrentPopup(channel, null);
				return;
			}
			openNextPopup(channel);
		}
		
		/**
		* Opens the next popup in channel's queue.
		* @param channel
		* @see PopupChannel
		*
		*/
		protected function openNextPopup(channel:PopupChannel):void {
			var queue:Vector.<PopupData> = getQueue(channel);
			if (queue.length == 0) {
				setCurrentPopup(channel, null);
				return;
			}
			if (currentPopup) {
				currentPopup.window.showing = false;
			}
			currentPopup = queue.shift();
			var window:IPopup = currentPopup.window;
			window.showing = true;
			window.addEventListener(PopupEvent.END_CLOSE, onClosePopup);
			window.addEventListener(PopupEvent.INIT_OPEN, onInitOpen);
			window.addEventListener(IOErrorEvent.IO_ERROR, onAssetError);
			setCurrentPopup(channel, currentPopup);
			container.addChild(currentPopup.window as DisplayObject);
			if (currentPopup.center) {
				centerPopup(window);
			}
			window.open();
		}
		
		private function onAssetError(e:IOErrorEvent):void {
			var n:int = popupInfo.length;
			var currentWindow:IPopup = currentPopup.window;
			var data:PopupData;
			for (var i:int = 0; i < n; i++) {
				data = popupInfo[i];
				if (currentWindow == data.window) {
					if (currentPopup.modal) {
						removeModal(data.modalWindow);
						break;
					}
				}
			}
		}
		
		protected function onInitOpen(e:PopupEvent):void {
			var n:int = popupInfo.length;
			var currentWindow:IPopup = e.currentTarget as IPopup;
			var data:PopupData;
			for (var i:int = 0; i < n; i++) {
				data = popupInfo[i];
				if (currentWindow == data.window) {
					if (_blockRender && data.modal) {
						//_blittingStage.block();
					}
					if (currentPopup.modal) {
						displayModal(data);
						break;
					}
				}
			}
			
			if (currentPopup.center) {
				centerPopup(currentWindow);
			}
		}
		
		/**
		* Build and display the modal window
		*
		*/
		protected function displayModal(popupData:PopupData):void {
			var mWin:Sprite = new Sprite();
			mWin.graphics.beginFill(modalColor, modalAlpha);
			mWin.graphics.drawRect(_fullscreenManager.left, 0, _fullscreenManager.stage.fullScreenWidth, _fullscreenManager.stage.fullScreenHeight);
			popupData.modalWindow = mWin;
			var index:int = container.getChildIndex(popupData.window as DisplayObject);
			container.addChildAt(mWin, index);
		}
		
		protected function onClosePopup(e:Event):void {
			removePopup(e.currentTarget as IPopup);
		}
		
		protected function setupChannels():void {
			this.channels = new Dictionary();
			var enums:Vector.<PopupChannel> = PopupChannel.getAll();
			var len:int = enums.length;
			for (var i:int = 0; i < len; i++) {
				channels[enums[i]] = new Vector.<PopupData>();
			}
		}
		
		protected function setCurrentPopup(channel:PopupChannel, popup:PopupData):void {
			if (!channel)
				channel = PopupChannel.DEFAULT;
			this.currentPopups[channel] = popup;
		}
		
		protected function getCurrentPopup(channel:PopupChannel):PopupData {
			if (!channel)
				channel = PopupChannel.DEFAULT;
			return this.currentPopups[channel];
		}
		
		/**
		* Centers the popup in the screen through the FullScreenManager
		* @param popup
		*
		*/
		protected function centerPopup(window:IPopup):void {
			if (_fullscreenManager.isFullScreen) {
				DisplayObject(window).x = _fullscreenManager.stage.fullScreenWidth / 2 + _fullscreenManager.left;
				DisplayObject(window).y = _fullscreenManager.stage.fullScreenHeight / 2;
			} else {
				DisplayObject(window).x = _fullscreenManager.stageWidth / 2;
				DisplayObject(window).y = _fullscreenManager.stageHeight / 2;
			}
		}
		
		/**
		* On resize should center the window if needed
		* @param e
		*
		*/ /*		protected function onResize(e:Event):void
		   {
		   //TODO: Check what happend with fullscreen changes
		   this.container.x = _fullscreenmManager.left;
		   trace("resizing "+this);
		}*/
		protected function addPopupData(window:IPopup, channel:PopupChannel=null, center:Boolean=true, modal:Boolean=true, animate:Boolean=true):PopupData {
			var popupData:PopupData = new PopupData();
			popupData.window = window;
			popupData.center = center;
			popupData.modal = modal;
			popupData.animate = animate;
			popupData.channel = channel ? channel : PopupChannel.DEFAULT;
			var vector:Vector.<PopupData> = getQueue(popupData.channel);
			vector.push(popupData);
			popupInfo.push(popupData);
			return popupData;
		}
		
		protected function addListenersToPopupData(popupData:PopupData):void {
			_fullscreenManager.addEventListener(Event.RESIZE, popupData.resizeHandler);
		}
		
		protected function removeListenersToPopupData(popupData:PopupData):void {
			_fullscreenManager.removeEventListener(Event.RESIZE, popupData.resizeHandler);
		}
	}
}