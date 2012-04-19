package client.definitions 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemPropertiesDefinition 
	{
		private var _hits:uint;
		
		public function ItemPropertiesDefinition(hits:uint) 
		{
			_hits = hits;
		}
		
		public function get hits():uint 
		{
			return _hits;
		}
		
	}

}