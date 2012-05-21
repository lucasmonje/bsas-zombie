//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.display.iconList.promotion {
	
	public class PromotionIcon implements IIconListItem {
		
		protected var _asset:Asset;
		
		protected var _url:String;
		
		public function PromotionIcon(url:String) {
			_asset = new Asset(_url, 'icon');
		}
		
		public function click():void {
		
		}
	}
}