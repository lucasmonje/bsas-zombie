package com.sevenbrains.trashingDead.display 
{
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Hud extends Sprite 
	{
		private static const ITEM_ROCK_CODE:Number = 100004;
		
		private var _weaponContainer:Sprite;
		
		public function Hud() 
		{
			
		}
		
		public function init():void {
			var hudClass:Class = ConfigModel.assets.getDefinition(AssetsEnum.HUD, "asset") as Class;
			var _content:MovieClip = new hudClass();
			addChild(_content);
			
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
		}
		
		private function buttonTrashClicked(e:MouseEvent):void {
			UserModel.instance.players.batter.changeWeapon("battable");
		}
		
		private function buttonItemClicked(e:MouseEvent):void {
			UserModel.instance.players.batter.changeWeapon("handable", e.currentTarget.itemCode);
		}
	}

}