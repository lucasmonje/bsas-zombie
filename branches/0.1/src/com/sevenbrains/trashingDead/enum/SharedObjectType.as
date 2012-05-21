package com.sevenbrains.trashingDead.enum
{
	import com.sevenbrains.trashingDead.models.UserModel;

	public class SharedObjectType
	{
		private static const COOKIE:String = "trashing-dead-"; 
		
		public static function get settingsKey():String {
			return cookieName + "-settings";
		}
		
		private static function get cookieName():String {
			return COOKIE + UserModel.instance.user.socialId;
		} 
		
	}
}