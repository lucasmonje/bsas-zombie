package com.sevenbrains.trashingDead.controller.command 
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sevenbrains.trashingDead.controller.event.GrantRewardEvent;
	import com.sevenbrains.trashingDead.definitions.rewards.Reward;
	import com.sevenbrains.trashingDead.definitions.rewards.RewardList;
	import com.sevenbrains.trashingDead.utils.ClassUtil;
	import com.sevenbrains.trashingDead.definitions.rewards.*
	
	/**
	 * ...
	 * @author Fulvio
	 */
	public class GrantRewardCommand implements ICommand 
	{
		
		public function GrantRewardCommand() 
		{
			
		}
		
		/* INTERFACE com.adobe.cairngorm.commands.ICommand */
		
		public function execute(event:CairngormEvent):void 
		{
			var e:GrantRewardEvent = event as GrantRewardEvent;
			var rewardList:RewardList = e.rewardList;
			
			for each(var reward:Reward in rewardList){
				var clazz:Class = ClassUtil.getClass(reward);
				switch(clazz) {
					case CoinsReward:
						break;
					case XpReward:
						break;
				}
			}
		}
		
	}

}