package com.sevenbrains.trashingDead.utils 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.sevenbrains.trashingDead.events.AnimationsEvent;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Animation extends EventDispatcher
	{
		private var _content:MovieClip;
		
		private var _animations:Vector.<AnimationDefinition>;
		
		private var _actual:AnimationDefinition
		private var _actualFrame:int;
		private var _times:int;
		private var _actualTime:int;
		
		private var _isPlaying:Boolean;
		
		public function Animation(content:MovieClip) 
		{
			_content = content;
			_animations = new Vector.<AnimationDefinition>();
			_isPlaying = false;
			_content.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function addAnimation(name:String, from:int, to:int):void {
			_animations.push(new AnimationDefinition(name, from, to));
		}
		
		public function setAnim(name:String):void {
			_actual = getAnim(name);
			_actualFrame = _actual.from;
			_content.gotoAndStop(_actualFrame);
		}
		
		private function getAnim(name:String):AnimationDefinition {
			for each(var anim:AnimationDefinition in _animations) {
				if (anim.name == name) {
					return anim;
				}
			}
			
			return null;
		}
		
		public function play(name:String, times:int = 1):void {
			_times = times;
			_actual = getAnim(name);
			_actualFrame = _actual.from;
			_isPlaying = true;
			_actualTime = 0;
		}
		
		private function update(e:Event):void {
			if (!_isPlaying) {
				return;
			}
			
			_content.gotoAndStop(_actualFrame);
			if (++_actualFrame == _actual.to) {
				if (++_actualTime == _times){
					_isPlaying = false;
					dispatchEvent(new AnimationsEvent(AnimationsEvent.ANIMATION_ENDED, _actual.name));
				}else {
					_actualFrame == _actual.from;
				}
			}
		}
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
		public function get currentFrame():int {
			return _actualFrame - _actual.from;
		}
		
		public function get totalFrames():int {
			return _actual.to - _actual.from
		}
		
		public function get currentAnimName():String {
			return _actual.name;
		}
		
		public function destroy():void {
			_isPlaying = false;
			_content.removeEventListener(Event.ENTER_FRAME, update);
		}
		
	}

}


internal class AnimationDefinition {
	
	private var _name:String;
	private var _from:int;
	private var _to:int;
	
	public function AnimationDefinition(name:String, from:int, to:int) {
		_name = name;
		_from = from;
		_to = to;
	}
	
	public function get name():String 
	{
		return _name;
	}
	
	public function get from():int 
	{
		return _from;
	}
	
	public function get to():int 
	{
		return _to;
	}
	
}

