//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.configuration {
	
	import com.sevenbrains.trashingDead.configuration.core.AbstractConfig;
	import com.sevenbrains.trashingDead.definitions.SuggestionDefinition;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	
	import flash.utils.Dictionary;
	
	public class SuggestionConfig extends AbstractConfig {
		
		public function SuggestionConfig(map:Dictionary) {
			super(map);
		}
		
		public function getGroupById(groupId:String):Vector.<SuggestionDefinition> {
			return _configMap[ConfigNodes.GROUP_IDS][groupId];
		}

		public function getById(id:String):Vector.<SuggestionDefinition> {
			return _configMap[ConfigNodes.IDS][id];
		}
		
		override public function init():void {
		
		}
	}
}