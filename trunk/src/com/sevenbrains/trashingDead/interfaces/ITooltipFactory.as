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
	
	import com.sevenbrains.trashingDead.display.tooltip.AbstractTooltip;
	
	public interface ITooltipFactory extends Destroyable {
		function getTooltip(type:String = "", displayId:String = ""):AbstractTooltip;
	}
}