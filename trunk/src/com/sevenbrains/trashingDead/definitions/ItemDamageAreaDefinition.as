package com.sevenbrains.trashingDead.definitions 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemDamageAreaDefinition 
	{
		private var _radius:Number;
		private var _time:uint;
		private var _hit:uint;
		
		public function ItemDamageAreaDefinition(radius:Number, time:uint, hit:uint) 
		{
			_radius = radius;
			_time = time;
			_hit = hit;
		}
		
		public function get radius():Number 
		{
			return _radius;
		}
		
		public function get time():uint 
		{
			return _time;
		}
		
		public function get hit():uint 
		{
			return _hit;
		}
		
	}

}