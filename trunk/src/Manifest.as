//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package {
	
	import com.sevenbrains.trashingDead.builders.*;
	import com.sevenbrains.trashingDead.condition.ItemConditionChecker;
	import com.sevenbrains.trashingDead.condition.StatsConditionChecker;
	import com.sevenbrains.trashingDead.configuration.*;
	import com.sevenbrains.trashingDead.controller.command.GrantRewardCommand;
	import com.sevenbrains.trashingDead.controller.command.ToggleMusicCommand;
	import com.sevenbrains.trashingDead.controller.event.GrantRewardEvent;
	import com.sevenbrains.trashingDead.controller.event.ToggleMusicEvent;
	import com.sevenbrains.trashingDead.definitions.LockDefinition;
	import com.sevenbrains.trashingDead.deserealizer.*;
	import com.sevenbrains.trashingDead.display.iconList.promotion.PromotionBar;
	import com.sevenbrains.trashingDead.execute.actions.PopupAction;
	import com.sevenbrains.trashingDead.execute.actions.UIAction;
	import com.sevenbrains.trashingDead.managers.ExecuteManager;
	import com.sevenbrains.trashingDead.managers.LockManager;
	import com.sevenbrains.trashingDead.managers.TradeManager;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class Manifest {
		
		public function Manifest() {
			EmbedAsset;
			
			AssetsConfig;
			ItemsConfig;
			SoundsConfig;
			WorldsConfig;
			LocaleConfig;
			PopupsConfig
			
			AssetsConfigDeserealizer;
			ItemConfigDeserealizer;
			SoundConfigDeserealizer;
			WorldConfigDeserealizer;
			LocaleConfigDeserealizer;
			PopupsConfigDeserealizer;
			ActionDeserializer;
			ExecuteDeserializer;
			SuggestionConfigDeserializer;
			ConditionDeserializer;
			LockDeserializer;
			
			ConfigModel;
			ConfigBuilder;
			LocaleBuilder;
			
			LockManager;
			StatsConditionChecker;
			ItemConditionChecker;
			
			ExecuteManager;
			PopupAction;
			UIAction;
			
			PromotionBar;
			
			ToggleMusicEvent;
			GrantRewardEvent;
			
			ToggleMusicCommand;
			GrantRewardCommand;
			
			TradeManager;
		
		}
	}
}