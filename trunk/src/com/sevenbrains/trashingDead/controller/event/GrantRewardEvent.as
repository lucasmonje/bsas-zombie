package com.sevenbrains.trashingDead.controller.event 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sevenbrains.trashingDead.definitions.rewards.RewardList;
	
	/**
	 * ...
	 * @author Fulvio
	 */
	public class GrantRewardEvent extends CairngormEvent 
	{
		public static const EVENT:String = "grantRewardEvent";
		
		private var _rewardList:RewardList;
		
		public function GrantRewardEvent(rewardList:RewardList) 
		{
			super(EVENT);
			
			_rewardList = rewardList;
		}
		
		public function get rewardList():RewardList 
		{
			return _rewardList;
		}
		
	}

}