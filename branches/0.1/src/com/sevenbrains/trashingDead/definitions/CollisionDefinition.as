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
	public class CollisionDefinition {
		
		private var _collisionAccepts:Array;
		
		private var _collisionId:String;
		
		private var _hits:uint;
		
		private var _life:uint;
		
		private var _speedMax:Number;
		
		private var _speedMin:Number;
		
		public function CollisionDefinition(hits:uint, life:uint, collisionId:String, collisionAccepts:Array, speedMin:Number, speedMax:Number) {
			_hits = hits;
			_life = life;
			_collisionId = collisionId;
			_collisionAccepts = collisionAccepts.concat();
			_speedMin = speedMin;
			_speedMax = speedMax;
		}
		
		public function get collisionAccepts():Array {
			return _collisionAccepts;
		}
		
		public function get collisionId():String {
			return _collisionId;
		}
		
		public function get hits():uint {
			return _hits;
		}
		
		public function get life():uint {
			return _life;
		}
		
		public function get speedMax():Number {
			return _speedMax;
		}
		
		public function get speedMin():Number {
			return _speedMin;
		}
	}
}