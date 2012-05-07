package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.events.PlayerEvents;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.utils.Animation;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class FatGuy extends EventDispatcher
	{
		private static const STATE_THREW:String = "threw";
		private static const STATE_WAITING_THREW:String = "waiting_threw";
		private static const STATE_PREPARE:String = "prepare";
		
		private static const ANIM_THROUGH:String = "through";
		
		private var _content:MovieClip;
		private var _throwingContainer:MovieClip;
		
		private var _animation:Animation;
		
		private var _state:String;
		
		private var _trashDefinition:ItemDefinition;
		
		public function FatGuy() 
		{
		}
		
		public function init(content:MovieClip):void {
			_content = content;
			_throwingContainer = _content.getChildByName("trash") as MovieClip;
			
			_animation = new Animation(_content);
			_animation.addAnimation(ANIM_THROUGH);
			_animation.setAnim(ANIM_THROUGH);
			
			_state = STATE_PREPARE;
			
			GameTimer.instance.callMeEvery(1, update);
		}
		
		public function prepareTrash():void {
			_state = STATE_PREPARE;
		}
		
		/**
		 * Obtiene una basura y la coloca en el lugar para arrojarsela al bateador
		 */
		private function getTrash():void {
			while (_throwingContainer.numChildren > 0) {
				_throwingContainer.removeChildAt(0);
			}
			
			_trashDefinition = WorldModel.instance.currentWorld.itemManager.getTrash();
			var assetClass:Class = ConfigModel.assets.getDefinition(_trashDefinition.name, 'box1');
			var assetTrash:MovieClip = new assetClass();
			_throwingContainer.addChild(assetTrash);
		}
		
		private function update():void {
			switch(_state) {
				case STATE_PREPARE:
					getTrash();
					_state = STATE_THREW;
				break;
				case STATE_THREW:
					_animation.play(ANIM_THROUGH);
					_state = STATE_WAITING_THREW;
				break;
				case STATE_WAITING_THREW:
					if (!_animation.isPlaying) {
						dispatchEvent(new PlayerEvents(PlayerEvents.THREW_TRASH, _trashDefinition));
					}
				break;
			}
		}
		
	}

}