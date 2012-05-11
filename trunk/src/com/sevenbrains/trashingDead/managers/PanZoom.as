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
	
	import com.sevenbrains.trashingDead.events.StageTimerEvent;
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.utils.StageReference;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	
	public class PanZoom implements Destroyable {
		
		private var _zoomIndex:int;
		
		private var _zoomLevels:Array;
		
		private var _screenWidth:Number;
		
		private var _targetInitialWidth:Number;

		private var _targetHeight:Number;
		
		private var _destroyed:Boolean;

		private var _target:DisplayObject;

		private var _cameraBounds:Rectangle;
				
		public function PanZoom(target:DisplayObject) {
			_targetInitialWidth = target.width;
			_destroyed = false;
			_zoomIndex = 0;
			_target = target;
			setZoomLevels();
			updateZoom();
			StageReference.stage.addEventListener(Event.RESIZE, onResize);
			WorldModel.instance.stageTimer.addEventListener(StageTimerEvent.SECOND_ROUND, onSecondRound);
			WorldModel.instance.stageTimer.addEventListener(StageTimerEvent.FINAL_ROUND, onFinalRound);
		}
		
		public function get cameraBounds():Rectangle {
			return _cameraBounds;
		}

		private function onSecondRound(e:StageTimerEvent):void {
			_zoomIndex = 1;
			updateZoom();
		}
		
		private function onFinalRound(e:StageTimerEvent):void {
			_zoomIndex = 2;
			updateZoom();
		}
		
		private function setZoomLevels():void {
			_screenWidth = StageReference.stage.stageWidth;
			var fitScreen:Number = _screenWidth / _targetInitialWidth;
			_zoomLevels = new Array();
			_zoomLevels[0] = fitScreen;
			_zoomLevels[1] = fitScreen * 1.35;
			_zoomLevels[2] = fitScreen * 1.75;
		}
		
		private function updateZoom():void {
			_target.scaleX = _target.scaleY = currentZoom;
			_target.y = (StageReference.stage.stageHeight - _target.height)/2;
			_target.x = 0;
			/*
			var tweenProps:Object = new Object();
			tweenProps.scaleX = currentZoom;
			tweenProps.scaleY = currentZoom;
			tweenProps.y = (StageReference.stage.stageHeight - (_target.height * currentZoom))/2;;
			tweenProps.x = 0; 
			tweenProps.ease = Tweener.EASE_IN_BACK; 
			Tweener.to(_target, 0.25, tweenProps);
			*/
			_cameraBounds = new Rectangle(Math.abs(_target.x), Math.abs(_target.y), StageReference.stage.stageWidth * currentZoom, StageReference.stage.stageHeight * currentZoom);
		}
		
		public function get currentZoom():Number {
			return _zoomLevels[_zoomIndex];
		}
		
		public function destroy():void {
			_destroyed = true;
		}
		
		public function isDestroyed():Boolean {
			return _destroyed;
		}
		
		private function onResize(e:Event):void {
			setZoomLevels();
			updateZoom();
		}
	}
}