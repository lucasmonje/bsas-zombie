//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.display.iconList {
	
	import com.sevenbrains.trashingDead.definitions.SuggestionDefinition;
	import com.sevenbrains.trashingDead.exception.AbstractMethodException;
	import com.sevenbrains.trashingDead.interfaces.Locable;
	import com.sevenbrains.trashingDead.managers.ExecuteManager;
	import com.sevenbrains.trashingDead.managers.FullscreenManager;
	import com.sevenbrains.trashingDead.utils.ClassUtil;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class IconList extends Sprite {
		
		protected var _clickedIcons:Array;
		
		protected var _currentIcons:Vector.<Icon>;
		
		protected var _executeManager:ExecuteManager;
		
		protected var _fullScreenManager:FullscreenManager;
				
		protected var _iconMap:Dictionary;
		protected var _itemHeight:Number = 60;
		
		protected var _loadIcons:int;
		
		protected var _locale:Locable;
		protected var _maxVisibleItems:int = 4;
		
		protected var _onStage:Boolean;
		protected var _separation:Number = 5;
		
		//protected var _tooltipManager:TooltipManager;
		
		public function IconList() {
			_clickedIcons = new Array();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function refresh():void {
			if (canInitialize()) {
				clear();
				addIcons();
			}
		}
		
		public function relocate():void {
			_fullScreenManager.addEventListener(Event.RESIZE, locateMenu);
			locateMenu();
			refresh();
		}
		
		protected function addIcons():void {
			_iconMap = new Dictionary();
			_currentIcons = new Vector.<Icon>();
			_loadIcons = 0;
			var numVisible:int = 0;
			
			for each (var iconDef:SuggestionDefinition in iconDefinitions) {
				var icon:Icon = new Icon(iconDef.url, ClassUtil.getName(this) + "." + iconDef.name, false);
				//icon.tooltipManager = _tooltipManager;
				//icon.locale = _locale;
				_iconMap[icon] = iconDef;
				_currentIcons.push(icon);
				_loadIcons++;
				icon.addEventListener(Event.COMPLETE, onIconComplete);
				icon.init();
				
				if (++numVisible === _maxVisibleItems) {
					break;
				}
			}
		}
		
		protected function canInitialize():Boolean {
			return _onStage;
		}
		
		protected function get iconDefinitions():Vector.<SuggestionDefinition> {
			throw new AbstractMethodException('IconList::get items');
		}
		
		protected function locateMenu(e:Event = null):void {
			throw new AbstractMethodException('IconList::locateMenu');
		}
		
		protected function sortIcons():void {
			var offsetY:Number = 0;
			
			for each (var icon:Icon in _currentIcons) {
				icon.view.y = offsetY;
				offsetY += _itemHeight + _separation;
				addChild(icon.view);
			}
		}
		
		private function clear():void {
			for each (var icon:Icon in _currentIcons) {
				icon.removeEventListener(Event.SELECT, onIconSelect);
				DisplayUtil.remove(icon.view);
				icon.destroy();
			}
			_currentIcons = null;
			_iconMap = null;
		}
		
		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_onStage = true;
			relocate();
		}
		
		private function onIconComplete(e:Event):void {
			var icon:Icon = e.currentTarget as Icon;
			icon.removeEventListener(Event.COMPLETE, onIconComplete);
			icon.addEventListener(Event.SELECT, onIconSelect);
			_loadIcons--;
			
			if (_loadIcons == 0) {
				sortIcons();
			}
		}
		
		private function onIconSelect(e:Event):void {
			var icon:Icon = e.currentTarget as Icon;
			var iconDef:SuggestionDefinition = _iconMap[icon] as SuggestionDefinition;
			_clickedIcons.push(iconDef.name);
			_executeManager.execute(iconDef.execute);
			refresh();
		}
	}
}