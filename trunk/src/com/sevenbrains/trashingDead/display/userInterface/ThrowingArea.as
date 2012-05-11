package com.sevenbrains.trashingDead.display.userInterface 
{
	import com.sevenbrains.trashingDead.interfaces.ThrowableArea;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Fulvio
	 */
	public class ThrowingArea extends Sprite implements ThrowableArea
	{
		protected var _power:int;
		protected var _angle:int;
		
		public function ThrowingArea() 
		{
			_power = 0;
			_angle = 0;
		}
		
		public function activate(value:Boolean):void {
			
		}
		
		public function get hitPower():Number 
		{
			return _power;
		}
		
		public function get hitAngle():Number 
		{
			return _angle;
		}
		
		public function resetValues():void {
			
		}
		
		public function destroy():void {
			
		}
	}

}