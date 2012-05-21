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
	
	import com.sevenbrains.trashingDead.interfaces.ITooltip;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	
	public class Tooltip extends AbstractTooltip implements ITooltip {
		
		protected var container:DisplayObjectContainer;
		
		protected var messageStr:String;
		
		protected var titleStr:String;
		
		protected var txtMessage:TextField;
		
		protected var txtTitle:TextField;
		
		private var _htmlMode:Boolean = false;
		
		public function Tooltip() {
			super();
		}
		
		override public function close():void {
			if (contains(_target)) {
				removeChild(_target);
			}
			super.close();
		}
		
		override public function destroy():void {
			container = null;
			super.destroy();
		}
		
		public function getMessageTextField():TextField {
			return this.txtMessage;
		}
		
		public function getTitleTextField():TextField {
			return this.txtTitle;
		}
		
		public function set htmlMode(value:Boolean):void {
			_htmlMode = value;
		}
		
		public function set message(value:String):void {
			this.messageStr = value;
			
			if (txtMessage && messageStr) {
				if (_htmlMode) {
					txtMessage.htmlText = messageStr;
				} else {
					txtMessage.text = this.messageStr;
				}
			} else if (messageStr) {
				trace("WARN: The tooltip skin hasn't txtMessage instance");
			} else {
				txtMessage.text = "";
				txtMessage.width = 0;
				txtMessage.height = 0;
			}
		}
		
		override public function open():void {
			if (_target) {
				this.mouseEnabled = false;
				this.mouseChildren = false;
				setupContent();
				super.open();
			} else {
				throw new Error("This tooltip hasn't display")
			}
		}
		
		public function setContent(message:String, title:String = ''):void {
			messageStr = message;
			titleStr = title;
		}
		
		override public function set target(value:DisplayObjectContainer):void {
			if (_target && _target.parent) {
				_target.parent.removeChild(_target);
			}
			super.target = value;
			setup()
		}
		
		public function set title(value:String):void {
			this.titleStr = value;
			
			if (txtTitle && titleStr) {
				if (_htmlMode) {
					txtTitle.htmlText = titleStr;
				} else {
					txtTitle.text = titleStr;
				}
			} else if (titleStr) {
				trace("WARN: The tooltip skin hasn't txtTitle instance");
			} else if (txtTitle) {
				txtTitle.text = "";
				txtTitle.width = 0;
				txtTitle.height = 0;
			}
		}
		
		protected function setup():void {
			setupTarget();
			setupTextfileds();
		}
		
		protected function setupContent():void {
			setupTitleContent();
			setupMessageContent();
		}
		
		protected function setupMessageContent():void {
			if (!txtMessage && messageStr) {
				throw new Error("ERROR: The tooltip skin hasn't txtMessage instance");
				return;
			}
			message = messageStr;
		}
		
		protected function setupTarget():void {
			this.addChild(_target);
			container = _target.getChildByName("container") as DisplayObjectContainer;
			
			if (!container) {
				container = _target;
			}
		}
		
		protected function setupTextfileds():void {
			txtTitle = container.getChildByName("txtTitle") as TextField;
			txtMessage = container.getChildByName("txtMessage") as TextField;
		}
		
		protected function setupTitleContent():void {
			if (!txtTitle && titleStr) {
				throw new Error("ERROR: The tooltip skin hasn't txtTitle instance");
				return;
			}
			title = titleStr;
		}
	}
}