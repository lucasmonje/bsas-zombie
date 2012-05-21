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
package com.sevenbrains.trashingDead.models.item {
	
	import com.sevenbrains.trashingDead.exception.InvalidArgumentException;
	import com.sevenbrains.trashingDead.interfaces.IClassifiable;
	
	
	public class StockedItem {
		
		private var _item:IClassifiable;
		
		private var _quantity:int;
		
		public function StockedItem(item:IClassifiable) {
			_item = item;
			_quantity = 0;
		}
		
		/**
		 * @return the code of the item
		 */
		public function get code():int {
			return _item.code;
		}
		
		public function get item():IClassifiable {
			return _item;
		}
		
		/**
		 * @return the amount of items contained
		 */
		public function get quantity():int {
			return _quantity;
		}
		
		/**
		 * sets the amout of items contained
		 * @param value int
		 */
		public function set quantity(value:int):void {
			_quantity = value;
		}
	}
}