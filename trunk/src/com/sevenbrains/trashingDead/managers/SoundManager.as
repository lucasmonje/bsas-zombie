package com.sevenbrains.trashingDead.managers {
	
	import com.sevenbrains.trashingDead.enum.SoundType;
	import com.sevenbrains.trashingDead.interfaces.ISoundPlayer;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.sound.Sound;
	import com.sevenbrains.trashingDead.sound.SoundPlayer;
	import com.sevenbrains.trashingDead.utils.SharedObjectUtils;
	
	public class SoundManager implements ISoundPlayer {
		
		private static const COOKIE:String = 'sound';
		private static const FX_MUTE:String = 'fx_mute';
		private static const MUSIC_MUTE:String = 'music_mute';

		private static var _instance:SoundManager = null;
		private static var _instanciable:Boolean = false;
		
		protected var _players:Vector.<ISoundPlayer>;
		protected var _fxPlayer:SoundPlayer;
		protected var _musicPlayer:SoundPlayer;
		
		public function SoundManager() {
			if (!_instanciable) {
				throw new Error("This is a singleton class");
			}
		}
		
		public static function get instance():SoundManager {
			if (!_instance) {
				_instanciable = true;
				_instance = new SoundManager();
				_instanciable = false;
			}
			return _instance;
		}
		
		public function setup():void {
			_players = new Vector.<ISoundPlayer>();
			_musicPlayer = new SoundPlayer(ConfigModel.sounds.getSoundDefinitionsByType(SoundType.MUSIC));
			_fxPlayer = new SoundPlayer(ConfigModel.sounds.getSoundDefinitionsByType(SoundType.FX));
			_players.push(_musicPlayer);
			_players.push(_fxPlayer);
			fxMuted = Boolean(SharedObjectUtils.load(COOKIE, FX_MUTE));
			musicMuted = Boolean(SharedObjectUtils.load(COOKIE, MUSIC_MUTE));
		}
		
		public function play(id:String):Sound {
			for each (var player:ISoundPlayer in _players) {
				if (player.has(id)) {
					return player.play(id);
				}
			}
			return null;
		}
		
		public function stop(id:String, fadeTime:Number=0):void {
			for each (var player:ISoundPlayer in _players) {
				if (player.has(id)) {
					player.stop(id, fadeTime);
					break;
				}
			}
		}
		
		public function has(id:String):Boolean {
			for each (var player:ISoundPlayer in _players) {
				if (player.has(id)) {
					return true;
				}
			}
			return false;
		}
		
		public function stopAll(fadeTime:Number=0):void {
			for each (var player:ISoundPlayer in _players) {
				player.stopAll(fadeTime);
			}
		}
		
		public function set fxMuted(value:Boolean):void {
			_fxPlayer && (_fxPlayer.muted = value);
			SharedObjectUtils.save(COOKIE, FX_MUTE, value);
		}
		
		public function get fxMuted():Boolean {
			return _fxPlayer && _fxPlayer.muted;
		}
		
		public function set musicMuted(value:Boolean):void {
			_musicPlayer && (_musicPlayer.muted = value);
			SharedObjectUtils.save(COOKIE, MUSIC_MUTE, value);
		}
		
		public function get musicMuted():Boolean {
			return _musicPlayer && _musicPlayer.muted;
		}
	}
}