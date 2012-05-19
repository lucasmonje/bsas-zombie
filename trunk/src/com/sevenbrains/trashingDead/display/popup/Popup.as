package com.sevenbrains.trashingDead.display.popup {
	import com.sevenbrains.trashingDead.display.loaders.DefaultAssetLoader;
	import com.sevenbrains.trashingDead.display.popup.nodes.IPopupNode;
	import com.sevenbrains.trashingDead.display.popup.nodes.PopupI18nNode;
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
	import com.sevenbrains.trashingDead.enum.AnimationType;
	import com.sevenbrains.trashingDead.tween.Tweener;
	import com.sevenbrains.trashingDead.utils.ObjectUtil;
	
	public class Popup extends AbstractPopup {
		
		protected var _i18n:String;
		protected var _initialized:Boolean;
		protected var _nodes:Array;
		protected var _content:MovieClip;
		protected var _localization:Locable;
		
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
			_i18n = _props.popupId;
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
		
		protected function applyNode(node:IPopupNode):void {
			node.applyTo(this);
		}
		
		override protected function onComplete(e:Event = null):void {
			_content = this.loader.getMCByDef("Popup");
			preCreation();
			creationComplete();
			postCreation();
		}
		
		public function refreshTexts():void {
			for each (var node:IPopupNode in _nodes) {
				if (node is PopupI18nNode) {
					node.applyTo(this);
				}
			}
		}
		
		public function reapplyNodes():void {
			removeNodes();
			applyNodes();
		}
		
		protected function preCreation():void {
			applyNodes();
		}
		
		protected function creationComplete():void {
			addChild(_content);
		}
		
		protected function postCreation():void {
			checkReady();
		}
		
		private function applyNodes():void {
			loadNodes();
			_initialized = true;
		}
		
		private function removeNodes():void {
			for each (var node:IPopupNode in _nodes) {
				node.removeFrom(this);
			}
		}
		
		private function checkReady():void {
			if (_initialized && _showing) {
				animationReady();
				dispatchEvent(new PopupEvent(PopupEvent.END_OPEN, this));
			}
		}
		
		protected function animationReady():void {
			var time:Number = 0.25;
			var animParams:Object = new Object();
			animParams.ease = Tweener.EASE_IN_EXPO;
			
			for each (var animName:String in _props.animation) {
				var animObj:Object = AnimationType[animName];
				if (animObj) {
					mergeObjs(animObj, animParams);
				} else if (!isNaN(parseFloat(animName))) {
					time = parseFloat(animName);
				}
			}
			Tweener.from(this, time, animParams);
		}
		
		private function mergeObjs(obj1:Object, obj2:Object):void {
			 for (var key:String in obj1) {
				 obj2[key] = obj1[key];
			 }
		}
		
		// Localization
		public function localizeByPath(path:String, key:String, args:Array=null):String {
			var field:TextField = getFieldByPath(path);
			field.mouseEnabled = false;
			field.mouseWheelEnabled = false;
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