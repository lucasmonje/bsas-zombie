package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.definitions.DamageAreaDefinition;
	import com.sevenbrains.trashingDead.managers.GameTimer;
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
		private var _time:int;
		private var _hits:int;
		private var _content:Sprite;
		private var _spent:Boolean;
		
		private var _props:DamageAreaDefinition;
		
		public function DamageArea(position:Point, props:DamageAreaDefinition) 
		{
			_props = props;
			
			_xA = position.x - _props.radius;
			_xB = position.x + _props.radius;
			_time = _props.time;
			_hits = _props.hit;
			
			_spent = false;
			
			_content = new Sprite();
			_content.graphics.beginFill(0xff0000);
			_content.graphics.drawRect(0, 0, (_xB - _xA) * GameProperties.WORLD_SCALE, 20);
			_content.graphics.endFill();
			_content.x = _xA * GameProperties.WORLD_SCALE;
			_content.y = 490; // (position.y * worldScale) + _content.height;
			
			GameTimer.instance.callMeIn(_time, spent);
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
		
		public function set time(value:int):void 
		{
			_time = value;
		}
		
		public function get time():int 
		{
			return _time;
		}
		
		private function spent():void {
			_spent = true;
		}
		
		public function isSpent():Boolean {
			return _spent;
		}
		
		public function isInside(position:Point):Boolean {
			return (position.x >= _xA && position.x <= _xB);
		}
		
		public function destroy():void {
			_props = null;
			_content = null;
		}
	}

}