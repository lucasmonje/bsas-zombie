package com.sevenbrains.trashingDead.definitions.rewards 
{
	/**
	 * ...
	 * @author Fulvio
	 */
	public class MaterialReward extends Reward 
	{
		private var _code:uint;
		
		public function MaterialReward(code:uint, value:Number) 
		{
			super(value);
			_code = code;
		}
		
		public function get code():uint 
		{
			return _code;
		}
		
		
	}

}