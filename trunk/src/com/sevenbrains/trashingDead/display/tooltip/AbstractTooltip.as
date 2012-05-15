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
	
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	public class AbstractTooltip extends Sprite implements Destroyable {
		
		protected var _destroyed:Boolean = false;
		
		protected var _target:DisplayObjectContainer;
		
		private var _position:Point;
		
		public function AbstractTooltip() {
		}
		
		public function close():void {
			if (_target) {
				_target.visible = false;
			}
		}
		
		public function destroy():void {
			_target = null;
			_destroyed = true;
		}
		
		public function isDestroyed():Boolean {
			return _destroyed;
		}
		
		public function open():void {
			if (_target) {
				_target.visible = true;
			}
		}
		
		public function set position(value:Point):void {
			this.x = value.x;
			this.y = value.y;
		}
		
		public function set target(value:DisplayObjectContainer):void {
			_target = value;
		}
	}
}