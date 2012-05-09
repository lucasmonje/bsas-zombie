package com.sevenbrains.trashingDead.display 
{
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.events.PlayerEvents;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.models.UserModel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
			
			UserModel.instance.players.batter.addEventListener(PlayerEvents.CHANGE_WEAPON, changeWeapon);
		}
		
		private function changeWeapon(e:PlayerEvents):void {
			while (_weaponContainer.numChildren > 0) {
				_weaponContainer.removeChildAt(0);
			}
			
			var cAsset:Class = ConfigModel.assets.getDefinition(AssetsEnum.COMMONS, UserModel.instance.players.batter.getActualWeapon().props.icon);
			var mc:MovieClip = new cAsset();
			
			_weaponContainer.addChild(mc);			
		}
	}

}