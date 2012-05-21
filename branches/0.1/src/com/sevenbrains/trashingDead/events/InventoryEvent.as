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
	
	import com.sevenbrains.trashingDead.interfaces.IClassifiable;
	import flash.events.Event;
	
	
	public class InventoryEvent extends Event {
	
		public static const ADD_ITEM:String = "addItem";
		
		public static const REMOVE_ITEM:String = "removeItem";
		
		private var _item:IClassifiable;
		
		private var _quantity:uint;
		
		public function InventoryEvent(type:String, item:IClassifiable, quantity:uint) {
			super(type);
		}
		
		public function get item():IClassifiable {
			return _item;
		}
		
		public function set item(value:IClassifiable):void {
			_item = value;
		}
		
		public function get quantity():uint {
			return _quantity;
		}
	}
}