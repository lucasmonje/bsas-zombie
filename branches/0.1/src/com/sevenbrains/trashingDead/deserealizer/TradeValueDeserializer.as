//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.exception.InvalidArgumentException;
	import com.sevenbrains.trashingDead.interfaces.Deserializable;
	import com.sevenbrains.trashingDead.models.trade.ITradeValue;
	import com.sevenbrains.trashingDead.models.trade.MultipleTradeValue;
	import com.sevenbrains.trashingDead.models.trade.ProbabilityData;
	import com.sevenbrains.trashingDead.models.trade.ProbabilityTradeValue;
	import com.sevenbrains.trashingDead.models.trade.StatsTradeValue;
	import com.sevenbrains.trashingDead.models.trade.StockTradeValue;
	import com.sevenbrains.trashingDead.models.user.Stats;
	
	import flash.utils.Dictionary;
	
	public class TradeValueDeserializer implements Deserializable {
		
		public static const TYPE:String = "tradeValueDeserializer";
		
		private static const MULTIPLE:String = "multiple";
		private static const PROBABILITY:String = "probability";
		private static const STATS:String = "stats";
		private static const STOCK:String = "stock";
		
		private var builderMap:Dictionary;
		
		public function TradeValueDeserializer() {
			createBuilderMap();
		}
		
		public function deserialize(node:XML):* {
			if (!Boolean(node.length())) {
				return null;
			}
			var builder:Function = getBuilder(node);
			
			if (!Boolean(builder)) {
				return null;
			}
			
			var tradeValue:ITradeValue = builder(node);
			return tradeValue;
		}
		
		private function buildMultipleTradeValue(source:XML):ITradeValue {
			var values:Vector.<ITradeValue> = new Vector.<ITradeValue>();
			
			for each (var node:XML in source.children()) {
				var value:ITradeValue = deserialize(node);
				
				if (value) {
					values.push(value);
				}
			}
			values.fixed = true;
			var tradeValue:MultipleTradeValue = new MultipleTradeValue(values);
			return tradeValue;
		}
		
		private function buildProbabilityTradeValue(source:XML):ITradeValue {
			var values:Vector.<ProbabilityData> = new Vector.<ProbabilityData>();
			
			for each (var node:XML in source.children()) {
				var value:ITradeValue = deserialize(node);
				var probability:Number = parseFloat(node.@probability);
				
				if (!probability) {
					throw new InvalidArgumentException('each value inside a selectBy="probability" must define its own probability. ' + source);
				}
				values.push(new ProbabilityData(probability, value));
			}
			values.fixed = true;
			var tradeValue:ProbabilityTradeValue = new ProbabilityTradeValue(values);
			return tradeValue;
		}
		
		private function buildStatsTradeValue(source:XML):ITradeValue {
			var stats:Stats = new Stats();
			var attributes:XMLList = source.attributes();
			
			for each (var attribute:XML in attributes) {
				var key:String = attribute.localName();
				
				if (Stats.VALID_STATS[key.split("_")[0]]) {
					stats.set(key, int(attribute));
				}
			}
			return new StatsTradeValue(stats);
		}
		
		private function buildStockTradeValue(source:XML):ITradeValue {
			var code:int = int(source.@item);
			var quantity:int = int(source.@quantity) || int(source.@qty) || 1;
			return new StockTradeValue(code, quantity);
		}
		
		private function createBuilderMap():void {
			builderMap = new Dictionary();
			builderMap[STATS] = buildStatsTradeValue;
			builderMap[STOCK] = buildStockTradeValue;
			builderMap[MULTIPLE] = buildMultipleTradeValue;
			builderMap[PROBABILITY] = buildProbabilityTradeValue;
		}
		
		private function getBuilder(source:XML):Function {
			var builder:Function = builderMap[getType(XML(source))];
			return builder;
		}
		
		private function getType(source:XML):String {
			if (source.@selectBy == "probability") {
				return PROBABILITY;
			} else if (source.attribute("item").length()) {
				return STOCK;
			}
			if (source.attributes().length()) {
				var id:String = source.attributes()[0].localName().split("_")[0];
				if (Stats.VALID_STATS[id]) {
					return STATS;
				}
			} else {
				return MULTIPLE;				
			}
			return null;
		}
	}
}