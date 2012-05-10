package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.display.userInterface.ThrowingArea;
	import com.sevenbrains.trashingDead.display.userInterface.ThrowingAreaFaster;
	import com.sevenbrains.trashingDead.display.userInterface.ThrowingAreaRect;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.events.PlayerEvents;
	import com.sevenbrains.trashingDead.interfaces.ThrowableArea;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.utils.Animation;
	import com.sevenbrains.trashingDead.events.ThrowingAreaEvent;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.display.canvas.GameCanvas;
	/**
	 * ...
	 * @author lmonje
	 */
	public class Batter extends EventDispatcher 
	{
		private static const STATE_READY_TO_BAT:String = "ready";
		private static const STATE_BATTING:String = "batting";
		private static const STATE_WAITING_BATTING:String = "waiting_batting";
		private static const STATE_WAITING_TRASH:String = "waiting_trash";
		
		private static const ANIM_BATTABLE:String = "battable";
		private static const ANIM_HANDABLE:String = "handable";
		private static const ANIM_PREPARING:String = "preparing";
		
		private var _state:String;
		
		private var _content:MovieClip;
		private var _throwingArea:ThrowingArea;
		
		private var _weapons:Vector.<Item>;
		private var _actualWeapon:int;
		
		private var _animation:Animation;
		
		private var _callId:int;
		
		public function Batter(weapons:Vector.<Item>) {
			_weapons = weapons;
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
				case STATE_READY_TO_BAT:
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
			}
		}
		
		public function readyToBat():void {
			_state = STATE_READY_TO_BAT;
			//_throwingArea.activate(true);
		}
		
		private function hitSetted(e:ThrowingAreaEvent):void {
			_state = STATE_BATTING;
		}
		
		/**
		 * Cambio de arma
		 */
		public function keyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.RIGHT) {
				changeWeapon(e.keyCode == Keyboard.LEFT);
			}
		}
		
		/**
		 * Cambia el arma
		 */
		private function changeWeapon(left:Boolean):void {
			var len:int = _weapons.length;
			if (left) {
				actualWeapon = actualWeapon == 0? len - 1: actualWeapon-1;
			}else {
				actualWeapon = actualWeapon == len -1? 0: actualWeapon+1;
			}
			
			if (getActualWeapon().props.type == 'handable') {
				var clazz:Class = ConfigModel.assets.getDefinition(AssetsEnum.COMMONS, getActualWeapon().props.icon);
				var container:MovieClip = MovieClip(_content.item);
				while (container && container.numChildren > 0) {
					container.removeChildAt(0);
				}
				container.addChild(new clazz());
			}
		}
		
		/**
		 * Retorna el item de arma actual
		 */
		public function getActualWeapon():Item {
			return _weapons[_actualWeapon];
		}
		
		/**
		 * Retorna el id del arma actual
		 */
		public function get actualWeapon():int {
			return _actualWeapon;
		}
		
		/**
		 * Setea el arma actual
		 */
		public function set actualWeapon(value:int):void {
			var old:int = _actualWeapon;
			_actualWeapon = value;
			_animation.setAnim(getActualWeapon().props.type);
			dispatchEvent(new PlayerEvents(PlayerEvents.CHANGE_WEAPON, _actualWeapon.toString(), old.toString()));
		}
		
		public function destroy():void {
			_throwingArea.removeEventListener(ThrowingAreaEvent.MOUSE_UP, hitSetted);
			GameTimer.instance.cancelCall(_callId);
		}
	}

}