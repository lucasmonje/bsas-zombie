//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.interfaces.Deserializable;
	import com.sevenbrains.trashingDead.models.user.Stats;
	
	public class StatsDeserializer implements Deserializable {
		
		public static const TYPE:String = "statsDeserializer";

		public function StatsDeserializer() {
		
		}
		
		public function deserialize(node:XML):* {
			var stats:Stats = new Stats();
			var attributes:XMLList = node.attributes();
			
			for each (var attribute:XML in attributes) {
				stats.set(attribute.localName(), int(attribute));
			}
			return stats;
		}
	}
}