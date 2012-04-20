package client.definitions 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemPhysicDefinition 
	{
		private var _density:Number;
		private var _friction:Number;
		private var _restitution:Number;
		private var _width:Number;
		private var _height:Number;
		
		public function ItemPhysicDefinition(density:Number, friction:Number, restitution:Number, width:Number, height:Number) 
		{
			_density = density;
			_friction = friction;
			_restitution = restitution;
			_width = width;
			_height = height;
		}
		
		public function get density():Number 
		{
			return _density;
		}
		
		public function get friction():Number 
		{
			return _friction;
		}
		
		public function get restitution():Number 
		{
			return _restitution;
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
	}

}