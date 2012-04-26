package com.sevenbrains.trashingDead.definitions 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class WorldEntitiesDefinition 
	{
		private var _code:uint;
		private var _weight:uint;
		
		public function WorldEntitiesDefinition(code:uint, weight:uint) 
		{
			_code = code;
			_weight = weight;
		}
		
		public function get code():uint 
		{
			return _code;
		}
		
		public function get weight():uint 
		{
			return _weight;
		}
		
	}

}