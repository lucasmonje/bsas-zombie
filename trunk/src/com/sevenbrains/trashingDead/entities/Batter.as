package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.display.canvas.GameCanvas;
	import com.sevenbrains.trashingDead.display.userInterface.ThrowingArea;
	import com.sevenbrains.trashingDead.display.userInterface.ThrowingAreaRect;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.events.PlayerEvents;
	import com.sevenbrains.trashingDead.events.ThrowingAreaEvent;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.utils.Animation;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Batter extends EventDispatcher 
	{
		private static const STATE_READY_TO_BAT:String = "ready_to_bat";
		private static const STATE_BATTING:String = "batting";
		private static const STATE_WAITING_BATTING:String = "waiting_batting";
		private static const STATE_READY_TO_HANDLE:String = "ready_to_handle";
		private static const STATE_HANDLING:String = "handling";
		private static const STATE_WAITING_HANDLING:String = "waiting_handling";
		private static const STATE_WAITING_TRASH:String = "waiting_trash";
		
		private static const ANIM_BATTABLE:String = "battable";
		private static const ANIM_HANDABLE:String = "handable";
		private static const ANIM_PREPARING:String = "preparing";
		
		private var _state:String;
		
		private var _content:MovieClip;
		private var _throwingArea:ThrowingArea;
		
		private var _itemCode:Number;
		private var _actualWeapon:String;
		
		private var _animation:Animation;
		
		private var _callId:int;
		
		public function Batter() {
		}
		
		/**
		 * Inicializa el asset del player de acuerdo al mundo cargado
		 * @param	content. Recibe el content del mundo cargado para obtener al player
		 */
		public function init(content:MovieClip, poweringArrow:MovieClip):void {
			_content = content;
			
			_animation = new Animation(_content);
			_animation.addAnimation(ANIM_BATTABLE);
			_animation.addAnimation(ANIM_PREPARING);
			_animation.addAnimation(ANIM_HANDABLE);
			_animation.setAnim(ANIM_BATTABLE);
			
			var pointerClass:Class = ConfigModel.assets.getDefinition(AssetsEnum.COMMONS, "puntero");
			
			_throwingArea = new ThrowingAreaRect(MovieClip(new pointerClass()));
			_throwingArea.addEventListener(ThrowingAreaEvent.MOUSE_UP, hitSetted);
			GameCanvas.instance.hud.addChild(_throwingArea);
			
			_state = STATE_WAITING_TRASH;
			_actualWeapon = "battable";
			
			_throwingArea.activate(true);
			
			_callId = GameTimer.instance.callMeEvery(1, update);
		}
		
		/**
		 * Funcion que se ejecuta frame a frame para actualizar el estado y comportamiento del player de acuerdo a su estado
		 */
		private function update():void {
			switch(_state) {
				case STATE_WAITING_TRASH:
					break;
				case STATE_READY_TO_HANDLE:
				case STATE_READY_TO_BAT:
					break;
				case STATE_HANDLING:
					
					_animation.play(ANIM_HANDABLE);
					_state = STATE_WAITING_HANDLING;
					break;
				case STATE_BATTING:
					//_throwingArea.activate(false);
					
					_animation.play(ANIM_BATTABLE);
					_state = STATE_WAITING_BATTING;
					break;
				case STATE_WAITING_BATTING:
					if (!_animation.isPlaying) {
						dispatchEvent(new PlayerEvents(PlayerEvents.TRASH_HIT, _throwingArea.hitPower, _throwingArea.hitAngle));
						_throwingArea.resetValues();
						_animation.play(ANIM_PREPARING);
						_state = STATE_WAITING_TRASH;
					}
					break;
				case STATE_WAITING_HANDLING:
					if (!_animation.isPlaying) {
						dispatchEvent(new PlayerEvents(PlayerEvents.THREW_ITEM, _throwingArea.hitPower, _throwingArea.hitAngle, _itemCode));
						_throwingArea.resetValues();
						_animation.setAnim(ANIM_HANDABLE);
						_state = STATE_READY_TO_HANDLE;
					}
					break;
			}
		}
		
		public function readyToHandle():void {
			_state = STATE_READY_TO_HANDLE;
		}
		
		public function readyToBat():void {
			_state = STATE_READY_TO_BAT;
			//_throwingArea.activate(true);
		}
		
		private function hitSetted(e:ThrowingAreaEvent):void {
			if (_state == STATE_READY_TO_BAT){
				_state = STATE_BATTING;
			}else if (_state == STATE_READY_TO_HANDLE) {
				_state = STATE_HANDLING;
			}
		}
		
		/**
		 * Cambia el arma
		 */
		public function changeWeapon(type:String, code:Number = 0):void {
			if (_actualWeapon == type) {
				return;
			}
			
			_actualWeapon = type;
			_itemCode = code;
			if (type == 'handable') {
				readyToHandle();
				_animation.setAnim(ANIM_HANDABLE);
				loadItem();
			}else if ('battable') {
				readyToBat();
				_animation.setAnim(ANIM_BATTABLE);
			}
			dispatchEvent(new PlayerEvents(PlayerEvents.CHANGE_WEAPON, type));
		}
		
		private function loadItem():void {
			var itemDef:ItemDefinition = ConfigModel.entities.getTrashByCode(_itemCode);
			if (itemDef) {
				var classBtnRock:Class = ConfigModel.assets.getDefinition(itemDef.name, "box1") as Class;
				var mcBtnRock:MovieClip = new classBtnRock();
				mcBtnRock.x = _content.item.width >> 1;
				mcBtnRock.y = _content.item.height >> 1;
				var itemContent:MovieClip = _content.item as MovieClip;
				emptyContent(itemContent);
				itemContent.addChild(mcBtnRock);
			}
		}
		
		private function emptyContent(mc:MovieClip):void {
			while (mc.numChildren > 0) {
				mc.removeChildAt(0);
			}
		}
		
		public function destroy():void {
			_throwingArea.removeEventListener(ThrowingAreaEvent.MOUSE_UP, hitSetted);
			GameTimer.instance.cancelCall(_callId);
		}
	}

}