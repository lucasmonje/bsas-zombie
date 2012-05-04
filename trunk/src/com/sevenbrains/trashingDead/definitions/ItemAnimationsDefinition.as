package com.sevenbrains.trashingDead.definitions 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemAnimationsDefinition 
	{
		private var _name:String;
		private var _from:int;
		private var _to:int;
		private var _afterReproduce:String;
		private var _defaultAnim:Boolean;
		
		public function ItemAnimationsDefinition(name:String, from:int, to:int, afterReproduce:String, defaultAnim:Boolean) 
		{
			_name = name;
			_from = from;
			_to = to;
			_afterReproduce = afterReproduce;
			_defaultAnim = defaultAnim;
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
		
		public function get afterReproduce():String 
		{
			return _afterReproduce;
		}
		
		public function get defaultAnim():Boolean 
		{
			return _defaultAnim;
		}
		
	}

}