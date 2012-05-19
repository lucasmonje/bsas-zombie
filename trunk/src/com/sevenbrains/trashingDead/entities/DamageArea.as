package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.definitions.DamageAreaDefinition;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.utils.Animation;
	import com.sevenbrains.trashingDead.events.AnimationsEvent;
	import flash.display.MovieClip;
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
		private var _fireMC:MovieClip;
		private var _fireAnim:Animation;
		private var _callId:int;
		
		private var _props:DamageAreaDefinition;
		
		public function DamageArea(position:Point, props:DamageAreaDefinition) 
		{
			_props = props;
			
			_xA = position.x - _props.radius;
			_xB = position.x + _props.radius;
			_time = _props.time;
			_hits = _props.hit;
			
			_spent = false;
			
			var classFire:Class = ConfigModel.assets.getDefinition(AssetsEnum.COMMONS, "fire") as Class;
			_fireMC = new classFire();
			_fireAnim = new Animation(_fireMC);
			_fireAnim.addAnimation("explosion");
			_fireAnim.addAnimation("fire");
			_fireAnim.play("explosion");
			_fireAnim.addEventListener(AnimationsEvent.ANIMATION_ENDED, changeAnim);
			_content = new Sprite();
			_content.addChild(_fireMC);
			
			/*
			_content = new Sprite();
			_content.graphics.beginFill(0x00ff00);
			_content.graphics.drawRect(0, 0, (_xB - _xA) * GameProperties.WORLD_SCALE, 20);
			_content.graphics.endFill();
			*/
			_content.x = _xA;
			_content.y = WorldModel.instance.floorRect.y;
			
			_callId = GameTimer.instance.callMeIn(_time, spent);
		}
		
		private function changeAnim(e:AnimationsEvent):void {
			if (_fireAnim.currentAnimName == "explosion"){
				_fireAnim.removeEventListener(AnimationsEvent.ANIMATION_ENDED, changeAnim);
				_fireAnim.play("fire", 0);
			}
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
			GameTimer.instance.cancelCall(_callId);
			if (_fireAnim.hasEventListener(AnimationsEvent.ANIMATION_ENDED)){
				_fireAnim.removeEventListener(AnimationsEvent.ANIMATION_ENDED, changeAnim);
			}
			_props = null;
			_content = null;
		}
	}

}