package com.sevenbrains.trashingDead.display.userInterface 
{
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.events.ThrowingAreaEvent;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio
	 */
	public class ThrowingAreaFaster extends ThrowingArea
	{
		private static const STATE_ON:String = "on";
		private static const STATE_OFF:String = "off";
		
		private var _content:Sprite;
		private var _arrow:MovieClip;
		
		private var _state:String;
		
		private var _isTargeting:Boolean;
		
		private var _callId:int;
		
		public function ThrowingAreaFaster(arrow:MovieClip) 
		{
			_arrow = arrow;
			
			_content = new Sprite();
			_content.graphics.beginFill(0xff0000, 0.3);
			_content.graphics.drawCircle(50, 50, 300);
			_content.graphics.endFill();
			_content.alpha = GameProperties.DEBUG_MODE?0.5:0;
			
			addChild(_content);
			
			_state = STATE_OFF;
			
			_callId = GameTimer.instance.callMeEvery(1, update);
		}
		
		public function activate(value:Boolean):void {
			if (value == true) {
				_state = STATE_ON;
				
				_power = 100;
				_angle = 0;
				
				_arrow.gotoAndStop(_power);
				rotateArrow();
				
				this.addEventListener(MouseEvent.MOUSE_MOVE, trashMoved);
				this.addEventListener(MouseEvent.MOUSE_OUT, trashMovedOut);
				this.addEventListener(MouseEvent.CLICK, trashMouseClic);
			}else {
				_state = STATE_OFF;
				
				this.removeEventListener(MouseEvent.MOUSE_MOVE, trashMoved);
				this.removeEventListener(MouseEvent.MOUSE_OUT, trashMovedOut);
				this.removeEventListener(MouseEvent.CLICK, trashMouseClic);
			}
		}
		
		private function trashMoved(e:MouseEvent):void {
			_isTargeting = true;
		}
		
		private function trashMovedOut(e:MouseEvent):void {
			_isTargeting = false;
		}
		
		private function trashMouseClic(e:MouseEvent):void {
			dispatchEvent(new ThrowingAreaEvent(ThrowingAreaEvent.MOUSE_UP));
		}
		
		private function calcNewAngle():void {
			var destPoint:Point = new Point(this.mouseX, this.mouseY);
			var distanceX:Number = destPoint.x;
			var distanceY:Number = destPoint.y;
			var newAngle:Number = Math.atan2(distanceY, distanceX);	
			if (newAngle <= GameProperties.ANGLE_TOP)  {
				_angle = GameProperties.ANGLE_TOP;
			} else if (newAngle >= GameProperties.ANGLE_BOTTOM) {
				_angle = GameProperties.ANGLE_BOTTOM;
			} else {
				_angle = newAngle;
			}
		}
		
		private function update():void {
			if (_state == STATE_ON) {
				
				if (_isTargeting) {
					calcNewAngle();
					rotateArrow();
				}
			}
		}
		
		private function rotateArrow():void {
			_arrow.rotation = _angle * 180 / Math.PI;
		}
		
		public function destroy():void {
			activate(false);
			GameTimer.instance.cancelCall(_callId);
		}
		
		override public function get hitPower():Number 
		{
			return _power;
		}
		
		override public function get hitAngle():Number 
		{
			return _angle;
		}
	}

}