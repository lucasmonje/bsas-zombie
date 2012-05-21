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
package com.sevenbrains.trashingDead.interfaces {
	
	
	public interface ITimer {
		function get isStarted():Boolean;
		function get isStopped():Boolean
		function registerUpdateable(obj:IUpdateable):void;
		function unregisterUpdateable(obj:IUpdateable):void;
		function start():void;
		function stop():void;
	}
}