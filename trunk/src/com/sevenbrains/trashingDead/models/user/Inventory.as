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
package com.sevenbrains.trashingDead.models.user {
	
	import com.sevenbrains.trashingDead.events.InventoryEvent;
	import com.sevenbrains.trashingDead.interfaces.IClassifiable;
	import com.sevenbrains.trashingDead.models.item.StockedItem;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	
	public class Inventory extends EventDispatcher {
		
		private var _items:Dictionary;
		
		public function Inventory() {
			super(this);
			_items = new Dictionary(true);
		}
		
		public function addItem(item:IClassifiable, quantity:int = 1):void {
			var stockedItem:StockedItem;
			
			if (_items[item.code]) {
				stockedItem = _items[item.code];
				stockedItem.quantity += quantity;
			} else {
				stockedItem = new StockedItem(item);
				stockedItem.quantity = quantity;
				_items[item.code] = stockedItem;
			}
			dispatchEvent(new InventoryEvent(InventoryEvent.ADD_ITEM, item, quantity));
		}
		
		public function getItemQuantity(item:IClassifiable):int {
			if (_items[item.code]) {
				var stockedItem:StockedItem = _items[item.code];
				return stockedItem.quantity;
			} else {
				return 0;
			}
		}
		
		public function getItems():Array {
			var arr:Array = new Array();
			
			for each (var item:StockedItem in _items) {
				arr.push(item);
			}
			return arr;
		}
		
		public function removeItem(item:IClassifiable, quantity:int = 1):Boolean {
			if (!Boolean(_items[item.code])) {
				return false;
			}
			var stockedItem:StockedItem = _items[item.code];
			stockedItem.quantity -= quantity;
			
			if (stockedItem.quantity <= 0) {
				_items[item.code] = null;
				delete _items[item.code];
			}
			dispatchEvent(new InventoryEvent(InventoryEvent.REMOVE_ITEM, item, quantity));
			return true;
		}
	}
}