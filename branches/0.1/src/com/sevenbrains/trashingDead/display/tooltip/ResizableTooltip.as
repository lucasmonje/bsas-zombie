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
package com.sevenbrains.trashingDead.display.tooltip {
	
	import com.sevenbrains.trashingDead.utils.Resizer;
	
	import flash.display.DisplayObject;
	import flash.text.TextFieldAutoSize;
	
	
	public class ResizableTooltip extends Tooltip {
		
		protected var resizer:Resizer;
		
		public function ResizableTooltip() {
			super();
			resizer = new Resizer();
		}
		
		override public function open():void {
			super.open();
			
			if (txtTitle && !titleStr) {
				txtMessage.y = txtTitle.y;
			} else if (txtTitle && titleStr && txtMessage && messageStr) {
				txtMessage.y = txtTitle.y + txtTitle.height + 3;
			}
			resizer.resize();
		}
		
		protected function setupResize():void {
			var back:DisplayObject = _target.getChildByName("back");
			resizer.setup(back, container);
		}
		
		override protected function setupTarget():void {
			super.setupTarget();
			setupResize();
		}
		
		override protected function setupTextfileds():void {
			super.setupTextfileds();
			
			if (txtMessage && txtMessage.autoSize == TextFieldAutoSize.NONE) {
				txtMessage.autoSize = TextFieldAutoSize.LEFT;
			}
			
			if (txtTitle && txtTitle.autoSize == TextFieldAutoSize.NONE) {
				txtTitle.autoSize = TextFieldAutoSize.LEFT;
			}
		}
	}
}