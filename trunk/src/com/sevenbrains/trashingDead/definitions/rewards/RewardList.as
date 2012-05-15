package com.sevenbrains.trashingDead.definitions.rewards 
{
	/**
	 * ...
	 * @author Fulvio
	 */
	public class RewardList 
	{
		private var _rewards:Array;
		
		public function RewardList(rewards:Array) 
		{
			_rewards = rewards;
		}
		
		public function get rewards():Array 
		{
			return _rewards;
		}
		
	}

}