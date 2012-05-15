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
	import com.sevenbrains.trashingDead.controller.command.ToggleMusicCommand;
	import com.sevenbrains.trashingDead.controller.event.ToggleMusicEvent;
	import com.sevenbrains.trashingDead.definitions.LockDefinition;
	import com.sevenbrains.trashingDead.deserealizer.*;
	import com.sevenbrains.trashingDead.display.iconList.promotion.PromotionBar;
	import com.sevenbrains.trashingDead.managers.LockManager;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class Manifest {
		
		public function Manifest() {
			EmbedAsset;
			
			AssetsConfig;
			EntitiesConfig;
			SoundsConfig;
			WorldsConfig;
			LocaleConfig;
			PopupsConfig
			
			AssetsConfigDeserealizer;
			EntityConfigDeserealizer;
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
			
			PromotionBar;
			
			ToggleMusicEvent;
			
			ToggleMusicCommand;
		
		}
	}
}