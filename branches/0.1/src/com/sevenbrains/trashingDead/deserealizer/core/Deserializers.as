//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.deserealizer.core {
	
	import com.sevenbrains.trashingDead.deserealizer.*;
	
	import flash.utils.Dictionary;
	
	public class Deserializers {
		
		private static var deserializersMap:Dictionary;
		
		public static function get map():Dictionary {
			if (Boolean(deserializersMap)) {
				return deserializersMap;				
			}
			deserializersMap = new Dictionary(true);
			deserializersMap[ActionDeserializer.TYPE] = new ActionDeserializer();
			deserializersMap[ConditionDeserializer.TYPE] = new ConditionDeserializer();
			deserializersMap[ExecuteDeserializer.TYPE] = new ExecuteDeserializer();
			deserializersMap[LockDeserializer.TYPE] = new LockDeserializer();
			deserializersMap[StatsDeserializer.TYPE] = new StatsDeserializer();
			deserializersMap[TradeValueDeserializer.TYPE] = new TradeValueDeserializer();
			return deserializersMap;
		}
	}
}