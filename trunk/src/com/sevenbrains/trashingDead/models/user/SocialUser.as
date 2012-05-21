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
	
	import com.sevenbrains.trashingDead.interfaces.ILoadable;
	
	import flash.events.EventDispatcher;
	
	
	public class SocialUser extends EventDispatcher implements ILoadable {
		
		private var _imagePath:String;
		
		private var _name:String;
		
		private var _socialId:String;
		
		public function SocialUser() {
			_imagePath = "";
			_name = "";
		}
		
		public function equals(obj:SocialUser):Boolean {
			return (socialId == obj.socialId);
		}
		
		public function get firstName():String {
			return _name.split(" ")[0];
		}
		
		public function get imagePath():String {
			return _imagePath;
		}
		
		public function set imagePath(value:String):void {
			_imagePath = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get socialId():String {
			return _socialId;
		}
		
		public function set socialId(value:String):void {
			_socialId = value;
		}
		
		override public function toString():String {
			return "socialId: " + _socialId + " - name: " + _name;
		}
		
		public function get url():String {
			return imagePath;
		}
	}
}