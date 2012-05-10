package com.sevenbrains.trashingDead.display.userInterface 
{
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.events.ThrowingAreaEvent;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.utils.StageReference;
	import com.sevenbrains.trashingDead.display.canvas.GameCanvas;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Fulvio
	 */
	public class ThrowingAreaRect extends ThrowingArea
	{
		private static const STATE_ON:String = "on";
		private static const STATE_OFF:String = "off";
		
		private var _content:Sprite;
		private var _arrow:MovieClip;
		
		private var _state:String;
		
		private var _isTargeting:Boolean;
		private var _isPressing:Boolean;
		
		private var _callId:int;
		
		public function ThrowingAreaRect(arrow:MovieClip) 
		{
			_arrow = arrow;
			_arrow.gotoAndStop(1);
			GameCanvas.instance.hud.addChild(_arrow);
			
			var _stage:Stage = StageReference.stage;
			var stageWidth:Number = StageReference.stage.width;
			var stageHeight:Number = StageReference.stage.height;
			
			_content = new Sprite();
			_content.graphics.beginFill(0xff0000, 0.3);
			_content.graphics.drawRect(0,0,stageWidth,stageHeight);
			_content.graphics.endFill();
			_content.alpha = GameProperties.DEBUG_MODE?0.5:0;
			
			addChild(_content);
			
			_state = STATE_OFF;
			
			_callId = GameTimer.instance.callMeEvery(1, update);
		}
		
		override public function activate(value:Boolean):void {
			if (value == true) {
				_state = STATE_ON;
				
				resetValues();
				
				this.addEventListener(MouseEvent.MOUSE_MOVE, trashMoved);
				this.addEventListener(MouseEvent.MOUSE_OUT, trashMovedOut);
				this.addEventListener(MouseEvent.MOUSE_DOWN, trashMouseDown);
				this.addEventListener(MouseEvent.MOUSE_UP, trashMouseUp);
			}else {
				_state = STATE_OFF;
				
				this.removeEventListener(MouseEvent.MOUSE_MOVE, trashMoved);
				this.removeEventListener(MouseEvent.MOUSE_OUT, trashMovedOut);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, trashMouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, trashMouseUp);
			}
		}
		
		private function trashMoved(e:MouseEvent):void {
			_isTargeting = true;
			Mouse.hide();
		}
		
		private function trashMovedOut(e:MouseEvent):void {
			_isTargeting = false;
			Mouse.show();
		}
		
		private function trashMouseDown(e:MouseEvent):void {
			_isPressing = true;
		}
		
		private function trashMouseUp(e:MouseEvent):void {
			_isPressing = false;
			
			dispatchEvent(new ThrowingAreaEvent(ThrowingAreaEvent.MOUSE_UP));
		}
		
		private function isPressing():Boolean {
			return _isPressing;
		}
		
		private function calcNewAngle():void {
			var destPoint:Point = new Point(this.mouseX, this.mouseY);
			var distanceX:Number = destPoint.x;
			var distanceY:Number = destPoint.y - (_content.height >> 1);
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
					setArrowAngle();
					positionatePointer();
				}
				
				if (_isPressing) {
					_power += GameProperties.POWER_INCREMENT;
					if (_power > GameProperties.POWER_LIMIT) {
						_power = GameProperties.POWER_LIMIT;
					}
					setArrowPower();
				}
			}
		}
		
		override public function resetValues():void {
			_power = 0;
			_angle = 0;
			
			setArrowAngle();
			setArrowPower();
		}
		
		private function positionatePointer():void {
			_arrow.x = StageReference.stage.mouseX;
			_arrow.y = StageReference.stage.mouseY;
		}
		
		private function setArrowAngle():void {
			//_arrow.rotation = _angle * 180 / Math.PI;
		}
		
		private function setArrowPower():void {
			_arrow.charge.gotoAndStop(_power);
		}
		
		override public function destroy():void {
			activate(false);
			GameCanvas.instance.hud.removeChild(_arrow);
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