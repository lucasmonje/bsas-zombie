package com.sevenbrains.trashingDead.sound {
	
	import com.sevenbrains.trashingDead.definitions.AssetDefinition;
	import com.sevenbrains.trashingDead.interfaces.ISoundPlayer;
	import com.sevenbrains.trashingDead.sound.SoundDefinition;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class SoundPlayer implements ISoundPlayer {
		
		static private const MAX_CONCURRENT_SOUNDS:int = 5;
		private var _definitions:Vector.<SoundDefinition>;
		private var _definitionById:Dictionary;
		private var _soundsPool:Dictionary;
		private var _playingSoundsById:Dictionary;
		private var _muted:Boolean;
		
		public function SoundPlayer(definitions:Vector.<SoundDefinition>) {
			_definitions = definitions;
			init();
		}
		
		public function play(id:String):Sound {
			var sound:Sound = getSound(id);
			if (sound == null) {
				return null;
			}
			if (sound.playing) {
				sound.stop(0);
			}
			sound.muted = _muted;
			sound.play();
			addPlayingSound(sound);
			return sound;
		}
		
		public function stop(id:String, fadeTime:Number=0):void {
			for each (var sound:Sound in _playingSoundsById[id]) {
				if (sound && sound.playing) {
					sound.stop(fadeTime);
				}
			}
		}
		
		public function stopAll(fadeTime:Number=0):void {
			for (var id:String in _playingSoundsById) {
				stop(id, fadeTime);
			}
		}
		
		public function has(id:String):Boolean {
			return (id in _definitionById) && (_definitionById[id] != null);
		}
		
		public function get muted():Boolean {
			return _muted;
		}
		
		public function set muted(value:Boolean):void {
			_muted = value;
			for each (var sounds:Vector.<Sound>in _playingSoundsById) {
				for each (var sound:Sound in sounds) {
					sound.muted = value;
				}
			}
		}
		
		private function init():void {
			_soundsPool = new Dictionary();
			_playingSoundsById = new Dictionary();
			_muted = false;
			_definitionById = new Dictionary();
			for each (var definition:SoundDefinition in _definitions) {
				_definitionById[definition.id] = definition;
			}
		}
		
		private function getSound(id:String):Sound {
			var sounds:Vector.<Sound> = _soundsPool[id];
			if (sounds == null) {
				sounds = _soundsPool[id] = new Vector.<Sound>();
			}
			var sound:Sound;
			if (sounds.length < MAX_CONCURRENT_SOUNDS) {
				sound = createSound(id);
				sounds.push(sound);
			} else {
				for each (var snd:Sound in sounds) {
					if (!snd.playing) {
						sound = snd;
						break;
					}
				}
			}
			return sound;
		}
		
		private function createSound(id:String):Sound {
			var definition:SoundDefinition = _definitionById[id] as SoundDefinition;
			if (definition == null) {
				return null;
			}
			return new Sound(id, definition.path, definition.loops, definition.stream);
		}
		
		private function addPlayingSound(sound:Sound):void {
			var id:String = sound.id;
			if (_playingSoundsById[id] == null) {
				_playingSoundsById[id] = new Vector.<Sound>();
			}
			_playingSoundsById[id].push(sound);
			sound.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}
		
		private function onSoundComplete(event:Event):void {
			var sound:Sound = Sound(event.target);
			sound.removeEventListener(Event.COMPLETE, onSoundComplete);
			var sounds:Vector.<Sound> = _playingSoundsById[sound.id];
			sounds.splice(sounds.indexOf(sound), 1);
		}
	}
}