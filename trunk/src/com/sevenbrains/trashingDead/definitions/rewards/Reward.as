package com.sevenbrains.trashingDead.definitions.rewards 
{
	/**
	 * ...
	 * @author Fulvio
	 */
	public class Reward 
	{
		protected var _name:String;
		protected var _value:Number;
		
		public function Reward(value:Number) 
		{
			_value = value;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
	}

}