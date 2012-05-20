package com.sevenbrains.trashingDead.display 
{
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.events.PropertyChangeEvent;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.models.user.Stats;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Hud extends Sprite 
	{
		private static const ITEM_ROCK_CODE:Number = 100004;
		
		private var _weaponContainer:Sprite;
		
		private var _txtCoins:TextField;
		private var _txtXp:TextField;
		private var _txtCredits:TextField;
		
		public function Hud() 
		{
			
		}
		
		public function init():void {
			var hudClass:Class = ConfigModel.assets.getDefinition(AssetsEnum.HUD, "asset") as Class;
			var _content:MovieClip = new hudClass();
			addChild(_content);
			
			_txtCoins = _content.getChildByName("txtCoins") as TextField;
			_txtCoins.text = UserModel.instance.stats.get(Stats.COINS).toString();

			_txtXp = _content.getChildByName("txtXp") as TextField;
			_txtXp.text = UserModel.instance.stats.get(Stats.XP).toString();
			
			_txtCredits = _content.getChildByName("txtCredits") as TextField;
			_txtCredits.text = UserModel.instance.stats.get(Stats.CREDITS).toString();
			
			var classBtnTrash:Class = ConfigModel.assets.getDefinition(AssetsEnum.COMMONS, "Bat") as Class;
			var mcBtnTrash:MovieClip = new classBtnTrash();
			mcBtnTrash.x = _content.btnTrash.width >> 1;
			mcBtnTrash.y = _content.btnTrash.height >> 1;
			MovieClip(_content.btnTrash).addChild(mcBtnTrash);

			var classBtnRock:Class = ConfigModel.assets.getDefinition(AssetsEnum.TRASH_ROCK, "box1") as Class;
			var mcBtnRock:MovieClip = new classBtnRock();
			mcBtnRock.x = _content.btnSpecialsTrash.width >> 1;
			mcBtnRock.y = _content.btnSpecialsTrash.height >> 1;
			_content.btnSpecialsTrash.itemCode = 100004;
			MovieClip(_content.btnSpecialsTrash).addChild(mcBtnRock);

			var classBtnMolotov:Class = ConfigModel.assets.getDefinition(AssetsEnum.ITEM_MOLOTOV, "box1") as Class;
			var mcBtnMolotov:MovieClip = new classBtnMolotov();
			mcBtnMolotov.x = _content.btnGuns.width >> 1;
			mcBtnMolotov.y = _content.btnGuns.height >> 1;
			_content.btnGuns.itemCode = 100005;
			MovieClip(_content.btnGuns).addChild(mcBtnMolotov);
			
			_content.btnTrash.addEventListener(MouseEvent.CLICK, buttonTrashClicked);
			_content.btnSpecialsTrash.addEventListener(MouseEvent.CLICK, buttonItemClicked);
			_content.btnGuns.addEventListener(MouseEvent.CLICK, buttonItemClicked);
			
			UserModel.instance.stats.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED, onStatsChange);
		}
		
		private function onStatsChange(e:PropertyChangeEvent):void {
			switch (e.property) {
				case Stats.COINS: _txtCoins.text = e.newValue.toString(); break;
				case Stats.CREDITS: _txtCredits.text = e.newValue.toString(); break;
				case Stats.XP: _txtXp.text = e.newValue.toString(); break;
			}
		}
		
		private function buttonTrashClicked(e:MouseEvent):void {
			UserModel.instance.players.batter.changeWeapon("battable");
		}
		
		private function buttonItemClicked(e:MouseEvent):void {
			UserModel.instance.players.batter.changeWeapon("handable", e.currentTarget.itemCode);
		}
	}

}