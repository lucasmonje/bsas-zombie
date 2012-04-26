package com.sevenbrains.trashingDead.utils 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
		}
		
		public function addAnimation(name:String, from:int, to:int):void {
			_animations.push(new AnimationDefinition(name, from, to));
		}
		
		public function setAnim(name:String):void {
			if (_isPlaying) {
				return;
			}
			
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
			if (_isPlaying) {
				return;
			}
			
			_times = times;
			_actual = getAnim(name);
			_actualFrame = _actual.from;
			_isPlaying = true;
			_actualTime = 0;
			_content.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void {
			_content.gotoAndStop(_actualFrame);
			if (++_actualFrame == _actual.to) {
				if (++_actualTime == _times){
					_isPlaying = false;
					_content.removeEventListener(Event.ENTER_FRAME, update);
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

