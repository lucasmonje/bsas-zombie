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
package com.sevenbrains.trashingDead.managers {
	
	import com.sevenbrains.trashingDead.display.tooltip.TooltipFactory;
	import com.sevenbrains.trashingDead.exception.PrivateConstructorException;
	import com.sevenbrains.trashingDead.interfaces.ITooltip;
	import com.sevenbrains.trashingDead.interfaces.ITooltipFactory;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	import com.sevenbrains.trashingDead.utils.StageReference;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	
	/**
	 * 		var tooltipsLayer:Sprite = new Sprite();
	 * 		addChiild(tooltipsLayer)
	 * 		TooltipManager.instance.setLayer(tooltipsLayer);
	 *
	 * 		var tooltip:ITooltip = TooltipManager.instance.makeTooltip(TooltipFactory.RESIZABLE_TOOLTIP, "commons.tooltipItem");
	 *		tooltip.title = "Title Tooltip";
	 * 		tooltip.message = "Message tooltip";
	 *		TooltipManager.instance.showTip(tooltip);
	 */
	public class TooltipManager {
		
		private static var GENERIC_TOOLTIP:String = "genericTooltip";
		
		private static var _instance:TooltipManager;
		
		private static var instanciationEnabled:Boolean;
		
		private var _currentTooltip:ITooltip;
		
		private var _displayed:Boolean;
		
		private var _factory:ITooltipFactory;
		
		private var _layer:DisplayObjectContainer;
		
		public function TooltipManager(layer:DisplayObjectContainer) {
			if (!instanciationEnabled) {
				throw new PrivateConstructorException("TooltipManager is a singleton class, use instance instead");
			}
		}
		
		public function get currentTooltip():ITooltip {
			return _currentTooltip;
		}
		
		public function get displayed():Boolean {
			return _displayed;
		}
		
		public function hideTip():void {
			if (_displayed) {
				_displayed = false;
				_currentTooltip.close();
				DisplayUtil.remove(_currentTooltip);
				_currentTooltip = null;
			}
		}
		
		public function makeTooltip(type:String, displayId:String = GENERIC_TOOLTIP):ITooltip {
			return _factory.getTooltip(type, displayId);
		}
		
		public function setLayer(layer:DisplayObjectContainer):void {
			_layer = layer;
			_layer.mouseChildren = false;
			_layer.mouseEnabled = false;
			_factory = new TooltipFactory(_layer);
		}
		
		public function showTip(tooltip:ITooltip, alignment:Point = null):void {
			_displayed = true;
			_layer.addChild(tooltip);
			_currentTooltip = tooltip;
			alignment = Boolean(alignment) ? alignment : new Point(0, 0);
			updatePosition(tooltip, alignment);
			tooltip.open();
		}
		
		public function updatePosition(tooltip:ITooltip, alignment:Point):void {
			var tooltipOffset:Point = getTooltipOffset(alignment);
			var p:Point = new Point(StageReference.stage.mouseX + tooltipOffset.x, StageReference.stage.mouseY + tooltipOffset.y);
			tooltip.position = p;
		}
		
		private function getTooltipOffset(tooltip:ITooltip, alignment:Point):Point {
			var offsetX:Number = tooltip.x - (alignment.x * tooltip.width);
			var offsetY:Number = tooltip.y - (alignment.y * tooltip.height);
			return new Point(offsetX, offsetY);
		}
		
		public static function get instance():TooltipManager {
			if (!_instance) {
				instanciationEnabled = true;
				_instance = new TooltipManager();
				instanciationEnabled = false;
			}
			return _instance;
		}
	}
}