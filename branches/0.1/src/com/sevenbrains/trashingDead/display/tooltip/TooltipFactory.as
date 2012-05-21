//------------------------------------------------------------------------------
//
//	This software is the confidential and proprietary information of   
//	7 Brains. You shall not disclose such Confidential Information and   
//	shall use it only in accordance with the terms of the license   
//	agreement you entered into with 7 Brains.  
//	Copyright 2012 - 7 Brains. 
//	All rights reserved.  
//
//------------------------------------------------------------------------------
package com.sevenbrains.trashingDead.display.tooltip {
	
	import com.sevenbrains.trashingDead.interfaces.ITooltip;
	import com.sevenbrains.trashingDead.interfaces.ITooltipFactory;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	
	public class TooltipFactory implements ITooltipFactory {
		
		public static const DEFAULT_DISPLAY:String = "DefaultDisplay";
		
		public static const RESIZABLE_TOOLTIP:String = "ResizableTooltip";
		
		public static const TOOLTIP:String = "Tooltip";
		
		private var _destroyed:Boolean = false;
		
		private var _isCachingDisplay:Boolean = true;
		
		private var _isCachingTooltip:Boolean = true;
		
		private var displayCache:Dictionary;
		
		private var tooltipCache:Dictionary;
		
		private var tooltipClassList:Dictionary;
		
		public function TooltipFactory(tooltipLayer:DisplayObject = null) {
			setupDisplayCache();
			setupClassList();
			setupTooltipCache();
		}
		
		public function addTooltipClass(tooltipClass:Class, id:String):Boolean {
			if (tooltipClassList[id]) {
				return false;
			}
			tooltipClassList[id] = tooltipClass;
			return true;
		}
		
		public function destroy():void {
			displayCache = null;
			tooltipCache = null;
			tooltipClassList = null;
			_destroyed = true;
		}
		
		public function isDestroyed():Boolean {
			return _destroyed
		}
		
		public function getTooltip(type:String = "", displayId:String = ""):ITooltip {
			type = (type) ? type : TOOLTIP;
			displayId = (displayId) ? displayId : DEFAULT_DISPLAY;
			var display:DisplayObjectContainer = getDisplayInstance(displayId) as DisplayObjectContainer;
			var tootlip:ITooltip = getTooltipInstance(type);
			tootlip.target = display;
			return tootlip;
		}
		
		public function set isCachingDisplay(value:Boolean):void {
			_isCachingDisplay = value;
		}
		
		public function set isCachingTooltip(value:Boolean):void {
			_isCachingTooltip = value;
		}
		
		protected function buildTootltip(id:String):ITooltip {
			var tooltipClass:Class = tooltipClassList[id];
			var tooltip:ITooltip = (tooltipClass) ? new tooltipClass() : tooltipCache[TOOLTIP];
			return tooltip;
		}
		
		protected function getDefaultDisplay():DisplayObject {
			var display:Sprite = new Sprite();
			var back:Sprite = new Sprite();
			back.name = "back";
			display.addChild(back);
			var container:Sprite = new Sprite();
			container.name = "container";
			container.x = 10;
			container.y = 5;
			display.addChild(container);
			var titleTxt:TextField = new TextField();
			titleTxt.width = 60;
			titleTxt.height = 30;
			titleTxt.multiline = false;
			titleTxt.name = "txtTitle";
			titleTxt.defaultTextFormat = new TextFormat("Arial", 13, 0x000000);
			var msgTxt:TextField = new TextField();
			msgTxt.y = msgTxt.y + titleTxt.height + 5;
			msgTxt.width = 60;
			msgTxt.height = 30;
			msgTxt.name = "txtMessage";
			msgTxt.multiline = true;
			msgTxt.defaultTextFormat = new TextFormat("Arial", 10, 0x000000);
			container.addChild(msgTxt);
			container.addChild(titleTxt);
			back.graphics.beginFill(0XFFFFFF);
			back.graphics.lineStyle(1, 0x000000);
			back.graphics.drawRoundRect(0, 0, container.x + container.width + 10, container.y + container.height + 5, 6, 6);
			back.graphics.endFill();
			return display;
		}
		
		protected function getDisplayInstance(linkage:String):DisplayObject {
			var display:DisplayObject;
			
			if (displayCache[linkage] && _isCachingDisplay) {
				display = displayCache[linkage];
			} else {
				display = buildDisplay(linkage);
				displayCache[linkage] = display;
			}
			return display;
		}
		
		protected function getTooltipInstance(id:String):ITooltip {
			var tooltip:ITooltip;
			
			if (tooltipCache[id] && _isCachingTooltip) {
				tooltip = tooltipCache[id];
			} else {
				tooltip = buildTootltip(id);
				tooltipCache[id] = tooltip;
			}
			return tooltip;
		}
		
		private function buildDisplay(linkage:String):DisplayObject {
			var instanceClass:Class = getDefinitionByName(linkage) as Class;
			var display:DisplayObject;
			
			if (instanceClass) {
				display = new instanceClass() as DisplayObject;
			}
			return display || displayCache[DEFAULT_DISPLAY];
		}
		
		private function setupClassList():void {
			this.tooltipClassList = new Dictionary();
			tooltipClassList[TOOLTIP] = Tooltip;
			tooltipClassList[RESIZABLE_TOOLTIP] = ResizableTooltip;
		}
		
		private function setupDisplayCache():void {
			displayCache = new Dictionary();
			displayCache[DEFAULT_DISPLAY] = getDefaultDisplay();
		}
		
		private function setupTooltipCache():void {
			tooltipCache = new Dictionary();
			tooltipCache[TOOLTIP] = getTooltipInstance(TOOLTIP);
		}
	}
}