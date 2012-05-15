package com.sevenbrains.trashingDead.deserealizer 
{
	import com.sevenbrains.trashingDead.definitions.rewards.CoinsReward;
	import com.sevenbrains.trashingDead.definitions.rewards.Reward;
	import com.sevenbrains.trashingDead.definitions.rewards.RewardList;
	import com.sevenbrains.trashingDead.definitions.rewards.XpReward;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Fulvio
	 */
	public class RewardConfigDeserializer 
	{
		private static var _instance:RewardConfigDeserializer = null;
		private static var _instanciable:Boolean = false;
		
		public static function get instance():RewardConfigDeserializer {
			if (!_instance) {
				_instanciable = true;
				_instance = new RewardConfigDeserializer();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		private static const ATTR_PREFIX:String = 'reward';
		
		private static const COINS:String = "coins";
		private static const XP:String = "xp";
		
		public function RewardConfigDeserializer() 
		{
			if (!_instanciable) {
				throw new Error("This is a singleton class!");
			}
		}
		
		public function decodeRewards(root:XML, nodeName:String = "rewards"):RewardList {
			var rewards:Array = [];
			
			var xml:XML = getNodeXml(root, nodeName);
			if (xml) {
				for each(var element:XML in xml.elements()) {
					
					var reward:Reward;
					var type:String = decodeType(element.localName());
					switch(type) {
						case COINS:
							reward = new CoinsReward(element.@value);
							break;
						case XP:
							reward = new XpReward(element.@value);
							break;
					}
					
					rewards.push(reward);
				}
			}
			
			return new RewardList(rewards);
		}
		
		private function getNodeXml(parent:XML, nodeName:String):XML {
			for each(var node:XML in parent.elements()) {
				if (node.localName() == nodeName) {
					return node;
				}
			}
			
			return null;
		}
		
		private function decodeType(key:String):String {
			key = key.toLowerCase();
			var fristIndex:int = key.indexOf(ATTR_PREFIX);
			return fristIndex > 0 ? key.slice(0, fristIndex) : key.slice(ATTR_PREFIX.length);
		}
		
	}

}