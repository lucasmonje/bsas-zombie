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
	public class PhysicDefinition {
		
		private var _density:Number;
		
		private var _friction:Number;
		
		private var _restitution:Number;
		
		public function PhysicDefinition(density:Number, friction:Number, restitution:Number) {
			_density = density;
			_friction = friction;
			_restitution = restitution;
		}
		
		public function get density():Number {
			return _density;
		}
		
		public function get friction():Number {
			return _friction;
		}
		
		public function get restitution():Number {
			return _restitution;
		}
	}
}