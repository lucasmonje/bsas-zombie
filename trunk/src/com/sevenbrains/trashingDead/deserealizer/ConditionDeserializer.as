//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.condition.ItemConditionDefinition;
	import com.sevenbrains.trashingDead.condition.StatsConditionDefinition;
	import com.sevenbrains.trashingDead.condition.core.ConditionDefinition;
	import com.sevenbrains.trashingDead.interfaces.Deserializable;
	import com.sevenbrains.trashingDead.interfaces.IStats;
	import com.sevenbrains.trashingDead.models.user.Stats;
	
	import flash.utils.Dictionary;
	
	public class ConditionDeserializer implements Deserializable {

		public static const TYPE:String = "conditionDeserializer";

		private static const DATE:String = "date";
		private static const ITEM:String = "item";
		private static const STATS:String = "stats";
		
		public var statsClass:Class = Stats;
		
		private var _validStats:Dictionary;
		
		private var builderMap:Dictionary;

		private var _node:XML;
		
		public function ConditionDeserializer() {
			createBuilderMap();
		}
		
		public function deserialize(node:XML):* {
			if (!Boolean(node.length())) {
				return null;				
			}
			_node = node;
			var xml:XML = _node;
			var builder:Function = getBuilder(xml);
			
			if (builder === null) {
				return null;				
			}
			var condition:ConditionDefinition = builder(xml);
			return condition;
		}
		/*
		private function buildDateCondition(source:XML):ConditionDefinition {
			var condition:DateConditionDefinition = new DateConditionDefinition();
			var dateString:String = source.@fromDate.toString();
			
			if (dateString) {
				condition.from = DateUtils.fromString(dateString).time;
			}
			dateString = source.@toDate.toString();
			
			if (dateString) {
				condition.to = DateUtils.fromString(dateString).time;
			}
			return condition;
		}
		*/
		private function buildItemCondition(source:XML):ConditionDefinition {
			var condition:ItemConditionDefinition = new ItemConditionDefinition();
			condition.code = int(source.@item);
			condition.quantity = int(source.@quantity) || int(source.@qty);
			return condition;
		}
		
		private function buildStatsCondition(source:XML):ConditionDefinition {
			var condition:StatsConditionDefinition = new StatsConditionDefinition();
			var stats:IStats = new statsClass();
			
			var attributes:XMLList = source.attributes();
			
			for each (var attribute:XML in attributes) {
				var statName:String = attribute.localName();
				var statKey:String =  statName.split("_")[0];
				
				if (_validStats[statKey]) {
					stats.set(statName, parseInt(attribute));
				}
			}
			condition.stats = stats;
			return condition;
		}
		
		private function getBuilder(source:XML):Function {
			var type:String = getType(XML(source));
			var builder:Function = builderMap[type];
			return builder;
		}
		
		private function getType(source:XML):String {
			
			if (source.attribute("item").length()) {
				return ITEM;
			}
			/*
			if (source.attribute("fromDate").length() || source.attribute("toDate").length()) {
				return TYPE_DATE;
			}
			*/
			//TODO: LOCK MANAGER
			
			var attributes:XMLList = source.attributes();
			
			//check for stats
			for each (var attribute:XML in attributes) {
				var statName:String = attribute.localName();
				var statKey:String =  statName.split("_")[0];
				
				if (_validStats[statKey]) {
					return STATS;
				}
			}
			
			return null;
		
		}
		
		private function createBuilderMap():void {
			builderMap = new Dictionary();
			builderMap[STATS] = buildStatsCondition;
			builderMap[ITEM] = buildItemCondition;
			//builderMap[TYPE_DATE] = buildDateCondition;
			//TODO: LOCK MANAGER
		}
	}
}