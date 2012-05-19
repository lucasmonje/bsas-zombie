package com.sevenbrains.trashingDead.deserealizer
{
	import com.sevenbrains.trashingDead.models.user.Stats;

	public class StatsDeserializer
	{
		public function StatsDeserializer(){
		
		}
		
		public function deserialize(node:XML):Stats {
			var stats:Stats = new Stats();
			var attributes:XMLList = node.attributes();
			for each (var attribute:XML in attributes) {
				stats.set(attribute.localName(), int(attribute));
			}
			return stats;
		}
	}
}