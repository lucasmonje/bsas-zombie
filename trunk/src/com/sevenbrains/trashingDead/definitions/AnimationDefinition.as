//------------------------------------------------------------------------------
//
//	This software is the confidential and proprietary information of   
//	7 Brains. You shall not disclose such Confidential Information and   
//	shall use it only in accordance with the terms of the license   
//	agreement you entered into with 7 Brains.  
//	Copyright 2012 - 7 Brains. 
//	All rights reserved.  
//
//------------------------------------------------------------------------------
package com.sevenbrains.trashingDead.definitions {
	
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class AnimationDefinition {
		
		private var _afterReproduce:String;
		
		private var _defaultAnim:Boolean;
		
		private var _frameTime:Number;
		
		private var _name:String;
		
		public function AnimationDefinition(name:String, frameTime:Number, afterReproduce:String, defaultAnim:Boolean) {
			_name = name;
			_frameTime = frameTime;
			_afterReproduce = afterReproduce;
			_defaultAnim = defaultAnim;
		}
		
		public function get afterReproduce():String {
			return _afterReproduce;
		}
		
		public function get defaultAnim():Boolean {
			return _defaultAnim;
		}
		
		public function get frameTime():Number {
			return _frameTime;
		}
		
		public function get name():String {
			return _name;
		}
	}
}