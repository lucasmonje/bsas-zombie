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
package com.sevenbrains.trashingDead.events {
	
	import flash.events.Event;
	
	
	public class StageTimerEvent extends Event {
		
		public static const SECOND_ROUND:String = "intermediate";

		public static const FINAL_ROUND:String = "final";

		public static const COMPLETED:String = "completed";
		
		public function StageTimerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}