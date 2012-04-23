package client.definitions 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemPropertiesDefinition 
	{
		private var _hits:uint;
		private var _life:uint;
		private var _collisionId:String;
		private var _collisionAccepts:Array;
		private var _speedMin:Number;
		private var _speedMax:Number;
		
		public function ItemPropertiesDefinition(hits:uint, life:uint, collisionId:String, collisionAccepts:Array, speedMin:Number, speedMax:Number) 
		{
			_hits = hits;
			_life = life;
			_collisionId = collisionId;
			_collisionAccepts = collisionAccepts.concat();
			_speedMin = speedMin;
			_speedMax = speedMax;
		}
		
		public function get hits():uint 
		{
			return _hits;
		}
		
		public function get life():uint 
		{
			return _life;
		}
		
		public function get collisionId():String 
		{
			return _collisionId;
		}
		
		public function get collisionAccepts():Array 
		{
			return _collisionAccepts;
		}
		
		public function get speedMin():Number 
		{
			return _speedMin;
		}
		
		public function get speedMax():Number 
		{
			return _speedMax;
		}
		
	}

}