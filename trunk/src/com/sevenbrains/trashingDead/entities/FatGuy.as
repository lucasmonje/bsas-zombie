package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.managers.AssetLoader;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.utils.Animation;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.events.PlayerEvents;
	import com.sevenbrains.trashingDead.events.FatGuyEvents;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class FatGuy extends Sprite 
	{
		private var _content:Sprite;
		private var _mcPlayer:MovieClip;
		private var _throwingContainer:MovieClip;
		
		private var _animation:Animation;
		
		private var _threwTrash:Boolean;
		
		private var _trashDefinition:ItemDefinition;
		
		public function FatGuy() 
		{
			super();
			
		}
		
		public function init():void {
			var fatGuyClass:Class = AssetLoader.instance.getAssetDefinition(AssetsEnum.GORDO, "Asset") as Class;
			_content = new fatGuyClass();
			addChild(_content);
			
			_mcPlayer = _content.getChildByName("mcPlayer") as MovieClip;
			_throwingContainer = _mcPlayer.getChildByName("trash") as MovieClip;
			
			_animation = new Animation(_mcPlayer);
			_animation.addAnimation("throwing", 1, 60);
			_animation.setAnim("throwing");
			
			this.x = -100;
			this.y = 80;
			
			prepareTrash();
			onPlayerThrewItem(null);
			
			_mcPlayer.addEventListener(Event.ENTER_FRAME, onUpdate);
			
			UserModel.instance.player.addEventListener(PlayerEvents.TRASH_HIT, onPlayerThrewItem);
		}
		
		private function onPlayerThrewItem(e:PlayerEvents):void {
			_animation.play("throwing", 1);
			_threwTrash = true;
		}
		
		private function prepareTrash():void {
			while (_throwingContainer.numChildren > 0) {
				_throwingContainer.removeChildAt(0);
			}
			
			_trashDefinition = WorldModel.instance.currentWorld.itemManager.getTrash();
			var assetClass:Class = AssetLoader.instance.getAssetDefinition(_trashDefinition.name, 'box1');
			var assetTrash:MovieClip = new assetClass();
			_throwingContainer.addChild(assetTrash);
		}
		
		private function onUpdate(e:Event):void {
			if (_threwTrash) {
				if (!_animation.isPlaying) {
					_threwTrash = false;
					_animation.setAnim("throwing");
					prepareTrash();
					dispatchEvent(new FatGuyEvents(FatGuyEvents.THREW_TRASH, _trashDefinition));
				}
			}
		}
	}

}