//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.display.iconList.promotion {
	
	import com.sevenbrains.trashingDead.configuration.SuggestionConfig;
	import com.sevenbrains.trashingDead.definitions.SuggestionDefinition;
	import com.sevenbrains.trashingDead.display.iconList.IconList;
	import com.sevenbrains.trashingDead.display.loaders.DefaultAssetLoader;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.events.SuggestionConfigEvent;
	import com.sevenbrains.trashingDead.managers.LockManager;
	import com.sevenbrains.trashingDead.utils.ArrayUtil;
	import com.sevenbrains.trashingDead.utils.StageReference;
	
	import flash.events.Event;
	
	public class PromotionBar extends IconList {
		
		public var asset:DefaultAssetLoader;
		
		public var itemWidth:Number = 60;
		
		public var lockManager:LockManager;
		
		public var suggestionConfig:SuggestionConfig;
		
		private var _hasSuggs:Boolean;
		
		public function PromotionBar() {
			super();
		}
		
		public function init():void {
			suggestionConfig.addEventListener(SuggestionConfigEvent.SUGGESTIONS_ADDED, onSuggestionsAdded);
		}
		
		override protected function canInitialize():Boolean {
			return _onStage && _hasSuggs;
		}
		
		override protected function get iconDefinitions():Vector.<SuggestionDefinition> {
			var result:Vector.<SuggestionDefinition> = new Vector.<SuggestionDefinition>();
			var suggDefList:Vector.<SuggestionDefinition> = suggestionConfig.getGroupById(ConfigNodes.PROMOTIONS);
			
			for each (var suggDef:SuggestionDefinition in suggDefList) {
				var unlocked:Boolean = !lockManager.isLocked(suggDef.lock);
				var persist:Boolean = suggDef.persist;
				var clicked:Boolean = ArrayUtil.contains(_clickedIcons, suggDef.name);
		
				if (unlocked && (persist || !clicked)) {
					result.push(suggDef);
				}
			}
			return result;
		}
		
		override protected function locateMenu(e:Event = null):void {
			this.x = StageReference.stage.stageWidth - itemWidth - _separation;
			this.y = 120;
		}
		
		private function onSuggestionsAdded(e:SuggestionConfigEvent):void {
			_hasSuggs = true;
			refresh();
		}
	}
}