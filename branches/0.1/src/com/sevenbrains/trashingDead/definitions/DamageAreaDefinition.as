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
	public class DamageAreaDefinition {
		
		private var _hit:uint;
		
		private var _radius:Number;
		
		private var _time:uint;
		
		public function DamageAreaDefinition(radius:Number, time:uint, hit:uint) {
			_radius = radius;
			_time = time;
			_hit = hit;
		}
		
		public function get hit():uint {
			return _hit;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function get time():uint {
			return _time;
		}
	}
}