package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.utils.Animation;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.models.UserModel;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Girl extends Sprite 
	{
		private static const STATE_REPARING:String = "reparing";
		private static const STATE_SHOOTING:String = "shooting";
		
		private static const TIME_UPDATE:int = 200;
		private static const TOLERANCE:Number = 300;
		private static const HITS:int = 10;
		
		private var _mcPlayer:MovieClip;
		private var _content:MovieClip;
		
		private var _animation:Animation;
		
		private var _zombiesWatcher:Vector.<Entity>;
		private var _zombieTargeted:Entity;
		
		private var _callId:int;
		
		private var _state:String;
		
		public function Girl() 
		{
			
		}
		
		public function init():void {
			var girlClass:Class = ConfigModel.assets.getAssetDefinition(AssetsEnum.CHICA, "Asset") as Class;
			_content = new girlClass();
			addChild(_content);
			
			_mcPlayer = _content.getChildByName("mcPlayer") as MovieClip;
			
			_animation = new Animation(_mcPlayer);
			_animation.addAnimation("repair");
			_animation.addAnimation("shoot");
			_animation.play("repair", 0);
			
			this.x = 240;
			this.y = UserModel.instance.player.y + 140;
			
			_state = STATE_REPARING;
			
			_zombiesWatcher = new Vector.<Entity>();
			_zombieTargeted = null;
			
			_callId = GameTimer.instance.callMeEvery(200, update);
		}
		
		public function registZombie(entity:Entity):void {
			_zombiesWatcher.push(entity);
		}
		
		public function update():void {
			if (_state == STATE_REPARING){
				var i:int = 0;
				var entity:Entity;
				while (i < _zombiesWatcher.length) {
					entity = _zombiesWatcher[i];
					var zombiePosX:Number = entity.getItemPosition().x;
					if (Math.abs(zombiePosX - this.x) <= TOLERANCE) {
						_zombieTargeted = entity;
						_zombiesWatcher.splice(i, 1);
						_animation.play("shoot");
						_state = STATE_SHOOTING;
						return;
					}
					i++;
				}
			}else if (_state == STATE_SHOOTING) {
				if (_zombieTargeted && _animation.currentFrame >= (_animation.totalFrames >> 1)) {
					_zombieTargeted.hit(HITS);
					_zombieTargeted = null;
				}
				if (!_animation.isPlaying) {
					_animation.play("repair", 0);
					_state = STATE_REPARING;
				}
			}
		}
		
		public function destroy():void {
			GameTimer.instance.cancelCall(_callId);
		}
	}

}