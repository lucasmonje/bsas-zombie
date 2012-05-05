package com.sevenbrains.trashingDead.utils 
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.sevenbrains.trashingDead.events.AnimationsEvent;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.events.GameTimerEvent;
	import com.sevenbrains.trashingDead.exception.ASSERT;
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
		private var _loops:int;
		private var _actualLoop:int;
		
		private var _isPlaying:Boolean;
		
		private var _idCallTimer:int;
		
		public function Animation(content:MovieClip) 
		{
			_content = content;
			_animations = new Vector.<AnimationDefinition>();
			_isPlaying = false;
		}
		
		public function addAnimation(name:String, frameTime:Number = 1):void {
			var label:FrameLabel;
			for (var i:int = 0; i < _content.currentLabels.length; i++ ) {
				label = _content.currentLabels[i];
				if (label.name == name) {
					var tF:int = 0;
					if (i + 1 < _content.currentLabels.length){
						var nextLabel:FrameLabel = _content.currentLabels[i + 1];
						tF = nextLabel.frame-1;
					}else {
						tF = _content.totalFrames;
					}
					
					_animations.push(new AnimationDefinition(name, label.frame, tF, frameTime));
					return;
				}
			}
			
			throw new Error("No se encuentra label " + name + " en la animacion");
		}
		
		public function setAnim(name:String):void {
			_actual = getAnim(name);
			_actualFrame = _actual.from;
			_content.gotoAndStop(_actualFrame);
			GameTimer.instance.cancelCall(_idCallTimer);
		}
		
		private function getAnim(name:String):AnimationDefinition {
			for each(var anim:AnimationDefinition in _animations) {
				if (anim.name == name) {
					return anim;
				}
			}
			
			return null;
		}
		
		public function play(name:String, loops:int = 1):void {
			_loops = loops;
			_actual = getAnim(name);
			_actualFrame = _actual.from;
			_isPlaying = true;
			_actualLoop = 0;
			GameTimer.instance.cancelCall(_idCallTimer);
			_idCallTimer = GameTimer.instance.callMeEvery(_actual.timeFrame, update);
		}
		
		private function update():void {
			if (!_isPlaying) {
				return;
			}
			
			if (++_actualFrame == _actual.to) {
				if (_loops > 0 && ++_actualLoop == _loops){
					_isPlaying = false;
					GameTimer.instance.cancelCall(_idCallTimer);
					dispatchEvent(new AnimationsEvent(AnimationsEvent.ANIMATION_ENDED, _actual.name));
				}else {
					_actualFrame = _actual.from;
				}
			}
			_content.gotoAndStop(_actualFrame);
			
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
	private var _timeFrame:Number;

	public function AnimationDefinition(name:String, from:int, to:int, timeFrame:Number) {
		_name = name;
		_from = from;
		_to = to;
		_timeFrame = timeFrame;
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
	
	public function get timeFrame():Number 
	{
		return _timeFrame;
	}
	
}

