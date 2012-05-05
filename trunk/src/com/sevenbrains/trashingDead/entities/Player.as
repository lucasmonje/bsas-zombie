package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.enum.PlayerStatesEnum;
	import com.sevenbrains.trashingDead.events.PlayerEvents;
	import com.sevenbrains.trashingDead.managers.AssetLoader;
	import com.sevenbrains.trashingDead.utils.Animation;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	import com.sevenbrains.trashingDead.utils.StageReference;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.events.AnimationsEvent;
	import com.sevenbrains.trashingDead.models.WorldModel;
	
	/**
	 * ...
	 * @author lmonje
	 */
	public class Player extends Sprite 
	{
		private var _stage:Stage;
		
		private var _actualWeapon:int;
		
		private var _state:String;
		
		private var _mcPlayer:MovieClip;
		private var _poweringArrow:MovieClip;
		private var _throwingArea:Sprite;
		
		private var _isAnimatingShooting:Boolean;
		private var _powering:Boolean;
		private var _power:Number;
		private var _angle:Number;
		private var _trashPosition:Point;
		private var _wagonPosition:Point;
		private var _content:MovieClip;
		
		private var _weapons:Vector.<Item>;
		
		private var _animation:Animation;
		
		public function Player(weapons:Vector.<Item>) {
			_stage = StageReference.stage;
			_weapons = weapons;
		}
		
		/**
		 * Inicializa el asset del player de acuerdo al mundo cargado
		 * @param	content. Recibe el content del mundo cargado para obtener al player
		 */
		public function initPlayer():void {
			var playerClass:Class = ConfigModel.assets.getAssetDefinition(AssetsEnum.BATEADOR, "Asset") as Class;
			_content = new playerClass();
			this.x += 50;
			this.y = - (WorldModel.instance.floorRect.height << 2);
			addChild(_content);
			
			_mcPlayer = _content.getChildByName("mcPlayer") as MovieClip;
			_poweringArrow = _content.getChildByName("mcPoweringContainer") as MovieClip;
			
			var mcTrashPosition:MovieClip = _content.getChildByName("mcTrashPosition") as MovieClip;
			_trashPosition = new Point(mcTrashPosition.x + 50, mcTrashPosition.y - 50);
			DisplayUtil.remove(mcTrashPosition);
			
			var mcWagonPosition:MovieClip = _content.getChildByName("mcWagonPosition") as MovieClip;
			_wagonPosition = new Point(mcWagonPosition.x, mcWagonPosition.y);
			
			_throwingArea = new Sprite();
			_throwingArea.graphics.beginFill(0xff0000, 0.3);
			_throwingArea.graphics.drawCircle(0, 0, 300);
			_throwingArea.graphics.endFill();
			_throwingArea.x = _mcPlayer.x + (_mcPlayer.width >> 1);
			_throwingArea.y = _mcPlayer.y + (_mcPlayer.height >> 1);
			_throwingArea.alpha = 0;
			
			_state = PlayerStatesEnum.WAITING;
			
			_isAnimatingShooting = false;
			_powering = false;
			_power = 0;
			
			_animation = new Animation(_mcPlayer);
			_animation.addAnimation("battable");
			_animation.addAnimation("preparing");
			_animation.addAnimation("handable");
			_animation.setAnim("battable");
			_animation.addEventListener(AnimationsEvent.ANIMATION_ENDED, animEnded);
			
			_mcPlayer.addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		public function get state():String {
			return _state;
		}
		
		public function set state(value:String):void {
			
			if (_state != value) {
				var old:String = _state;
				_state = value;	
				
				switch(_state) {
					case PlayerStatesEnum.READY:
						readyToShoot();
						break;
					case PlayerStatesEnum.SHOOTING:
						shooting();	
						break;
				}
				
				dispatchEvent(new PlayerEvents(PlayerEvents.STATE_CHANGED, old, _state));
			}
		}
		
		private function animEnded(e:AnimationsEvent):void {
			if (e.value == "battable"){
				dispatchEvent(new PlayerEvents(PlayerEvents.TRASH_HIT, _power.toString(), _angle.toString()));
				state = PlayerStatesEnum.WAITING;
				_animation.play("preparing");
			}else if (e.value == "handable"){
				dispatchEvent(new PlayerEvents(PlayerEvents.THREW_ITEM, getActualWeapon().props.name));
				_animation.play("preparing");
				state = PlayerStatesEnum.WAITING;
			}
		}
		
		/**
		 * Funcion que se ejecuta frame a frame para actualizar el estado y comportamiento del player de acuerdo a su estado
		 */
		private function onUpdate(e:Event):void {
			if (_state == PlayerStatesEnum.READY) {
				if (_powering) {
					onChargingPower();
				}
			}
		}
		
		/**
		 * El player esta listo para lanzar un item
		 */
		private function readyToShoot():void {
			_power = 0;
			_poweringArrow.gotoAndStop(0);
			
			trace("Agrego los listeners");
			_throwingArea.addEventListener(MouseEvent.MOUSE_MOVE, trashMoved);
			_throwingArea.addEventListener(MouseEvent.MOUSE_DOWN, trashMouseDown);
			_throwingArea.addEventListener(MouseEvent.MOUSE_UP, trashMouseUp);
		}
		
		/**
		 * El player comienza la animacion de lanzar el item
		 * Hasta que no termina y despacha el evento para que el item sea lanzado 
		 * no esta listo para lanzar el siguiente
		 */
		private function shooting():void {
			trace("Elimino los listeners");
			_throwingArea.removeEventListener(MouseEvent.MOUSE_MOVE, trashMoved);
			_throwingArea.removeEventListener(MouseEvent.MOUSE_DOWN, trashMouseDown);
			_throwingArea.removeEventListener(MouseEvent.MOUSE_UP, trashMouseUp);
			
			_powering = false;
			_isAnimatingShooting = true;
			_animation.play(getActualWeapon().props.type);
		}
		
		/**
		 * Setea el flag para la carga del power
		 */
		private function trashMouseDown(e:MouseEvent):void {
			_powering = true;
		}
		
		/**
		 * Carga del power
		 */
		private function onChargingPower():void {
			_power += GameProperties.POWER_INCREMENT;
			if (_power > 100) {
				_power = 100;
			}
			_poweringArrow.gotoAndStop(_power);
		}
		
		/**
		 *  Establece el angulo de tiro
		 */
		private function trashMoved(e:MouseEvent):void {
			setNewAngle();
			_poweringArrow.rotation = _angle * 75;
		}
		
		private function setNewAngle():void {
			var destPoint:Point = new Point(_stage.mouseX, _stage.mouseY);
			var distanceX:Number = destPoint.x - _poweringArrow.x;
			var distanceY:Number = destPoint.y - _poweringArrow.y;
			var newAngle:Number = Math.atan2(distanceY, distanceX);	
			if (newAngle <= GameProperties.ANGLE_TOP)  {
				_angle = GameProperties.ANGLE_TOP;
			} else if (newAngle >= GameProperties.ANGLE_BOTTOM) {
				_angle = GameProperties.ANGLE_BOTTOM;
			} else {
				_angle = newAngle;
			}
		}
		
		/**
		 * El player suelta el boton del mouse para disparar la basura
		 */
		private function trashMouseUp(e:MouseEvent):void {
			if (_powering){
				setNewAngle();
				state = PlayerStatesEnum.SHOOTING;
			}
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
				var clazz:Class = ConfigModel.assets.getAssetDefinition(AssetsEnum.COMMONS, getActualWeapon().props.icon);
				var container:MovieClip = MovieClip(_mcPlayer.item);
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
		
		public function get power():Number 
		{
			return _power;
		}
		
		public function get angle():Number 
		{
			return _angle;
		}
		
		public function get wagonPosition():Point 
		{
			return _wagonPosition;
		}
		
		public function get trashPosition():Point 
		{
			return _trashPosition;
		}
		
		public function get throwingArea():Sprite 
		{
			return _throwingArea;
		}
		
	}

}