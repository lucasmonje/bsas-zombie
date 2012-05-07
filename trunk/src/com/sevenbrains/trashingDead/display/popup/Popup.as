package com.sevenbrains.trashingDead.display.popup {
	import com.sevenbrains.trashingDead.display.loaders.DefaultAssetLoader;
	import com.sevenbrains.trashingDead.display.popup.nodes.IPopupNode;
	import com.sevenbrains.trashingDead.events.PopupEvent;
	import com.sevenbrains.trashingDead.exception.ASSERT;
	import com.sevenbrains.trashingDead.interfaces.ILoader;
	import com.sevenbrains.trashingDead.interfaces.Locable;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class Popup extends AbstractPopup {
		
		private var _nodes:Array;
		private var _content:MovieClip;
		protected var _i18n:String;
		private var _localization:Locable;
		protected var _waitForAllAssets:Boolean = false;
		private var _waitingNodesList:Array = [];
		
		public function Popup(popupId:String = null):void {
			super();
			_localization = ConfigModel.messages;
			if (popupId) {
				loadProperties(popupId);
			}
		}
		
		public function loadProperties(id:String):void {
			_props = ConfigModel.popups.get(id);
			ASSERT(_props, 'No popup properties found by '+id);
			_i18n = _props.i18n;
			if (_props.assetId) {
				loader = ConfigModel.assets.get(_props.assetId) as DefaultAssetLoader;
			}
			_nodes = _props.nodes;
		}
		
		public function get content():MovieClip {
			return _content;
		}
		
		/**
		* Nodes settings
		* @param value
		*
		*/
		public function set nodes(value:Array):void {
			_nodes = value.concat();
		}
		
		override public function destroy():void {
			for each (var node:IPopupNode in _nodes) {
				node.removeFrom(this);
			}
			_nodes = null;
			_client = null;
			var content:Sprite = this.content;
			if (content && this.contains(content)) {
				removeChild(content);
			}
			super.destroy();
		}
		
		public function loadNodes():void {
			for each (var node:IPopupNode in _nodes) {
				applyNode(node);
			}
		}
		
		protected function setWaitingNodes():void {
			for each (var node:IPopupNode in _nodes) {
				waitNode(node);
			}
		}
		
		public function waitNode(node:IPopupNode):void {
			if (_waitForAllAssets) {
				node.setCallback(onCompleteNode);
				_waitingNodesList.push(node);
			}
		}
		
		protected function applyNode(node:IPopupNode):void {
			node.applyTo(this);
		}
		
		private function onCompleteNode(success:Boolean, node:IPopupNode, url:String=""):void {
			if (success) {
				removeFromWaiting(node);
				if (_waitingNodesList.length == 0) {
					dispatchEvent(new PopupEvent(PopupEvent.END_OPEN, this));
				}
			} else {
				if (_waitForAllAssets) {
					throw new Error("asset: " + url + " could not be loaded");
				}
			}
		}
		
		private function removeFromWaiting(node:IPopupNode):Boolean {
			var index:int = _waitingNodesList.indexOf(node);
			if (index >= 0) {
				_waitingNodesList.splice(index, 1);
				return true;
			} else {
				throw new Error("Popup::removeFromWaiting node is not in _waitingNodeList");
			}
			return false;
		}
		
		override protected function onComplete(e:Event = null):void {
		
			_content = this.loader.getMCByDef("Popup");
			this.addChild(_content);
			_content.scaleX = 1;
			_content.scaleY = 1;
			setWaitingNodes();
			loadNodes();
			//IM-1814 avoids putting the modal if the asset is not ready
			if (!_waitForAllAssets) {
				dispatchEvent(new PopupEvent(PopupEvent.END_OPEN, this));
			}
		}
		
		// Localization
		public function localizeByPath(path:String, key:String, args:Array=null):String {
			var field:TextField = getFieldByPath(path);
			ASSERT(field, 'Popup::path "' + path + '" not found to localize');
			return localize(field, key, args);
		}
		
		protected function localize(field:TextField, key:String, args:Array=null):String {
			ASSERT(field, 'Popup::cannot localize a null TextField');
			return field.htmlText = getText(key, args);
		}
		
		protected function getText(key:String, args:Array=null):String {
			if (!_localization) {
				trace('Warning: Popup > localization is null');
				return key;
			}
			return _localization.get(key, args);
		}
		
		// Object fetching utils
		public function getByPath(path:String):DisplayObject {
			ASSERT(content);
			return DisplayUtil.getChildByPath(content, path);
		}
		
		public function getMovieByPath(path:String):MovieClip {
			return getByPath(path) as MovieClip;
		}
		
		public function getFieldByPath(path:String):TextField {
			return getByPath(path) as TextField;
		}
		
		public function get i18n():String {
			return _i18n;
		}
	}
}