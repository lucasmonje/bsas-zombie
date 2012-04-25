package client.definitions 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemDamageAreaDefinition 
	{
		private var _radius:Number;
		private var _times:uint;
		private var _hit:uint;
		
		public function ItemDamageAreaDefinition(radius:Number, times:uint, hit:uint) 
		{
			_radius = radius;
			_times = times;
			_hit = hit;
		}
		
		public function get radius():Number 
		{
			return _radius;
		}
		
		public function get times():uint 
		{
			return _times;
		}
		
		public function get hit():uint 
		{
			return _hit;
		}
		
	}

}