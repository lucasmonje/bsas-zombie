package com.sevenbrains.trashingDead.display 
{
	import com.sevenbrains.trashingDead.display.button.GenericButton;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.events.PropertyChangeEvent;
	import com.sevenbrains.trashingDead.interfaces.IUpdateable;
	import com.sevenbrains.trashingDead.managers.FullscreenManager;
	import com.sevenbrains.trashingDead.managers.SoundManager;
	import com.sevenbrains.trashingDead.managers.StageTimer;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.models.user.Stats;
	import com.sevenbrains.trashingDead.utils.DateUtils;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	import com.sevenbrains.trashingDead.utils.StageReference;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Hud extends Sprite implements IUpdateable
	{
		private static const ITEM_ROCK_CODE:Number = 100004;
		
		private var _weaponContainer:Sprite;

		private var _content:MovieClip;
		
		private var _txtCoins:TextField;
		private var _txtXp:TextField;
		private var _txtCredits:TextField;
		private var _txtTime:TextField;
		private var _mcTopMenu:MovieClip;
		private var _mcBottonMenu:MovieClip;
		private var _mcBarTime:MovieClip;
		
		private var _btnMusic:GenericButton;
		private var _btnPause:GenericButton;
		private var _btnExit:GenericButton;
		private var _btnGuns:GenericButton;
		private var _btnSpecialsTrash:GenericButton;
		private var _btnTrash:GenericButton;
		
		private var _destryed:Boolean;

		private var _stageTimer:StageTimer;

		private var _weaponMap:Dictionary;
		public function Hud() 
		{
			
		}
		
		public function init():void {
			_weaponMap = new Dictionary(true);
			var hudClass:Class = ConfigModel.assets.getDefinition(AssetsEnum.HUD, "asset") as Class;
			_content = new hudClass();
			_mcTopMenu = _content.getChildByName("mcTopMenu") as MovieClip;
			_mcBottonMenu = _content.getChildByName("mcBottonMenu") as MovieClip;
			buildTopMenu();
			buildBottonMenu();
			relocate();
			addListeners();
			addChild(_content);
		}
		
		private function addListeners():void {
			_btnTrash.addEventListener(MouseEvent.CLICK, buttonTrashClicked);
			_btnSpecialsTrash.addEventListener(MouseEvent.CLICK, buttonItemClicked);
			_btnGuns.addEventListener(MouseEvent.CLICK, buttonItemClicked);			
			_btnMusic.addEventListener(MouseEvent.CLICK, btnMusicClicked);
			UserModel.instance.stats.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED, onStatsChange);
			WorldModel.instance.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED, onWorldPropertyChange);
			StageReference.stage.addEventListener(Event.RESIZE, onResize);	
		}
		
		private function buildTopMenu():void {
			_txtCoins = _mcTopMenu.getChildByName("txtCoins") as TextField;
			_txtXp = _mcTopMenu.getChildByName("txtXp") as TextField;
			_txtCredits = _mcTopMenu.getChildByName("txtCredits") as TextField;
			_txtCoins.text = ConfigModel.messages.get("stats.coins", [UserModel.instance.stats.get(Stats.COINS)]);
			_txtXp.text = ConfigModel.messages.get("stats.xp", [UserModel.instance.stats.get(Stats.XP)]);
			_txtCredits.text = ConfigModel.messages.get("stats.credits", [UserModel.instance.stats.get(Stats.CREDITS)]);
		}

		private function buildBottonMenu():void {
			var classBtnTrash:Class = ConfigModel.assets.getDefinition(AssetsEnum.COMMONS, "Bat") as Class;
			var classBtnRock:Class = ConfigModel.assets.getDefinition(AssetsEnum.TRASH_ROCK, "box1") as Class;
			var classBtnMolotov:Class = ConfigModel.assets.getDefinition(AssetsEnum.ITEM_MOLOTOV, "box1") as Class;

			var mcBtnRock:MovieClip = new classBtnRock();
			var mcBtnMolotov:MovieClip = new classBtnMolotov();
			var mcBtnTrash:MovieClip = new classBtnTrash();
			
			_btnExit = new GenericButton(_mcBottonMenu.getChildByName("btnExit") as MovieClip);
			_btnMusic = new GenericButton(_mcBottonMenu.getChildByName("btnMusic") as MovieClip);
			_btnPause = new GenericButton(_mcBottonMenu.getChildByName("btnPause") as MovieClip);
			_btnGuns = new GenericButton(_mcBottonMenu.getChildByName("btnGuns") as MovieClip);
			_btnSpecialsTrash = new GenericButton(_mcBottonMenu.getChildByName("btnSpecialsTrash") as MovieClip);
			_btnTrash = new GenericButton(_mcBottonMenu.getChildByName("btnTrash") as MovieClip);
			
			_mcBarTime = _mcBottonMenu.getChildByName("barTime") as MovieClip;
			_txtTime = _mcBottonMenu.getChildByName("txtTime") as TextField
			
			
			DisplayUtil.fit(mcBtnTrash, _btnTrash.display);
			mcBtnTrash.x = int(_btnTrash.display.width >> 1);
			mcBtnTrash.y = int(_btnTrash.display.height >> 1);
			_btnTrash.display.addChild(mcBtnTrash);
			
			DisplayUtil.fit(mcBtnRock, _btnSpecialsTrash.display);
			mcBtnRock.x = int(_btnSpecialsTrash.display.width >> 1);
			mcBtnRock.y = int(_btnSpecialsTrash.display.height >> 1);
			_btnSpecialsTrash.display.addChild(mcBtnRock);
			_weaponMap[_btnSpecialsTrash] = 100004;
			
			DisplayUtil.fit(mcBtnMolotov, _btnGuns.display);
			mcBtnMolotov.x = int(_btnGuns.display.width >> 1);
			mcBtnMolotov.y = int(_btnGuns.display.height >> 1);
			_btnGuns.display.addChild(mcBtnMolotov);
			_weaponMap[_btnGuns] = 100005;
			
		}
		
		private function onWorldPropertyChange(e:PropertyChangeEvent):void {
			if (e.property == "stageTimer") {
				_stageTimer = WorldModel.instance.stageTimer;
				_stageTimer.registerUpdateable(this);
			}
		}
		
		public function update(s:uint=0):void {
			var percent:int = s * 100 / _stageTimer.totalTime;
			_mcBarTime.gotoAndStop(percent);
			_txtTime.text = DateUtils.toMS(s*1000);
		}
		
		private function onStatsChange(e:PropertyChangeEvent):void {
			switch (e.property) {
				case Stats.COINS: _txtCoins.text = ConfigModel.messages.get("stats.coins", [e.newValue]); break;
				case Stats.CREDITS: _txtCredits.text = ConfigModel.messages.get("stats.credits", [e.newValue]); break;
				case Stats.XP: _txtXp.text = ConfigModel.messages.get("stats.xp", [e.newValue]); break;
			}
		}
		
		private function btnMusicClicked(e:MouseEvent):void {
			SoundManager.instance.musicMuted = !SoundManager.instance.musicMuted;
		}
		
		private function buttonTrashClicked(e:MouseEvent):void {
			UserModel.instance.players.batter.changeWeapon("battable");
		}
		
		private function buttonItemClicked(e:MouseEvent):void {
			UserModel.instance.players.batter.changeWeapon("handable", _weaponMap[e.currentTarget]);
		}
		
		public function destroy():void {
			_destryed = true;
		}
		
		public function isDestroyed():Boolean {
			return _destryed; 
		}
		
		private function onResize(e:Event):void {
			relocate();
		}
		
		private function relocate():void {
			_mcTopMenu.x = _mcBottonMenu.x = StageReference.stage.stageWidth / 2; 
			_mcBottonMenu.y = StageReference.stage.stageHeight;
		}
	}

}