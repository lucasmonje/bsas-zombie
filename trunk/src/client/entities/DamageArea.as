package client.entities 
{
	import client.definitions.ItemDamageAreaDefinition;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class DamageArea 
	{
		private var _xA:Number;
		private var _xB:Number;
		private var _times:int;
		private var _currentTimes:int;
		private var _hits:int;
		private var _content:Sprite;
		
		private var _props:ItemDamageAreaDefinition;
		
		public function DamageArea(position:Point, props:ItemDamageAreaDefinition, worldScale:int) 
		{
			_props = props;
			
			_xA = position.x - _props.radius;
			_xB = position.x + _props.radius;
			_times = _props.times;
			_hits = _props.hits;
			_currentTimes = 0;
			
			_content = new Sprite();
			_content.graphics.beginFill(0xff0000);
			_content.graphics.drawRect(0, 0, (_xB - _xA) * worldScale, 20);
			_content.graphics.endFill();
			_content.x = _xA * worldScale;
			_content.y = 500;
		}
		
		public function isEnded():Boolean {
			return _currentTimes == _times;
		}
		
		public function get hits():int 
		{
			return _hits;
		}
		
		public function get xA():Number 
		{
			return _xA;
		}
		
		public function get xB():Number 
		{
			return _xB;
		}
		
		public function get content():Sprite 
		{
			return _content;
		}
		
		public function isInside(position:Point):Boolean {
			return (position.x >= _xA && position.x <= _xB);
		}
	}

}