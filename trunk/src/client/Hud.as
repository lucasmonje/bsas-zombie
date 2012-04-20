package client 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import client.UserModel;
	import client.events.PlayerEvents;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Hud extends Sprite 
	{
		
		private var _weaponContainer:Sprite;
		
		public function Hud() 
		{
			
		}
		
		public function init():void {
			_weaponContainer = new Sprite();
			_weaponContainer.x = 50;
			_weaponContainer.y = 50;
			addChild(_weaponContainer);
			
			changeWeapon(null);
			
			UserModel.instance.player.addEventListener(PlayerEvents.CHANGE_WEAPON, changeWeapon);
		}
		
		private function changeWeapon(e:PlayerEvents):void {
			while (_weaponContainer.numChildren > 0) {
				_weaponContainer.removeChildAt(0);
			}
			
			var cAsset:Class = AssetLoader.instance.getAssetDefinition(UserModel.instance.weapons[UserModel.instance.player.actualWeapon].props.icon);
			var mc:MovieClip = new cAsset();
			
			_weaponContainer.addChild(mc);			
		}
	}

}