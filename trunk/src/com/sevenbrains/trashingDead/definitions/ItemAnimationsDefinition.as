package com.sevenbrains.trashingDead.definitions 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemAnimationsDefinition 
	{
		private var _name:String;
		private var _frameTime: Number;
		private var _afterReproduce:String;
		private var _defaultAnim:Boolean;
		
		public function ItemAnimationsDefinition(name:String, frameTime:Number, afterReproduce:String, defaultAnim:Boolean) 
		{
			_name = name;
			_frameTime = frameTime;
			_afterReproduce = afterReproduce;
			_defaultAnim = defaultAnim;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get afterReproduce():String 
		{
			return _afterReproduce;
		}
		
		public function get defaultAnim():Boolean 
		{
			return _defaultAnim;
		}
		
		public function get frameTime():Number 
		{
			return _frameTime;
		}
		
	}

}