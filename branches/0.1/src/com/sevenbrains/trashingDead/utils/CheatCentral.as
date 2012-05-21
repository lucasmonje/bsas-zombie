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
package com.sevenbrains.trashingDead.utils {
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import com.sevenbrains.trashingDead.enum.PopupType;
	import com.sevenbrains.trashingDead.managers.PopupManager;
	
	
	public class CheatCentral {
		public function CheatCentral() {
		}
		
		public function cheat(cheatCode:String, ctrl:Boolean, alt:Boolean, shift:Boolean):void {
			cheatCode = cheatCode.toLowerCase();
			
			if (ctrl && !alt && !shift) {
				ctrlHandler(cheatCode);
				return;
			}
			
			if (ctrl && alt && !shift) {
				ctrlAltHandler(cheatCode);
				return;
			}
			
			if (ctrl && shift && !alt) {
				builtInHandler(cheatCode);
			}
		}
		
		private function ctrlAltHandler(cheatCode:String):void {
			switch (cheatCode) {
				case "a":
					break;
			}
		}
		
		private function ctrlHandler(cheatCode:String):void {
			switch (cheatCode) {
				case "a":
					PopupManager.instance.addPopup(new Popup(PopupType.MATERIALS));
					break;
			}
		}
		
		// Don't remove after each deploy
		private function builtInHandler(cheatCode:String):void {
			switch (cheatCode) {
				case "a":
					break;
			}
		}
		
	}
}