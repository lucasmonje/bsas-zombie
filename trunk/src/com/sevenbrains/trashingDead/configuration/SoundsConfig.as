package com.sevenbrains.trashingDead.configuration {
	
	import com.sevenbrains.trashingDead.configuration.core.AbstractConfig;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.sound.SoundDefinition;
	import flash.utils.Dictionary;
	import com.sevenbrains.trashingDead.enum.SoundType;
	
	public class SoundsConfig extends AbstractConfig {
		
		private var _soundDefinitions:Vector.<SoundDefinition>;
		
		private var _soundByType:Dictionary;
		
		public function SoundsConfig(map:Dictionary) {
			super(map);
			_soundByType = new Dictionary();
		}
		
		override public function init():void {
			for each (var soundDef:SoundDefinition in _configMap[ConfigNodes.SOUNDS]) {
				addSoundDefinition(soundDef);
				if (!Boolean(_soundByType[soundDef.type])) {
					_soundByType[soundDef.type] = new Vector.<SoundDefinition>();
				}
				_soundByType[soundDef.type].push(soundDef);
			}
			notifyEnd();			
		}
		
		private function addSoundDefinition(def:SoundDefinition):void {
			if (!_soundDefinitions) {
				_soundDefinitions = new Vector.<SoundDefinition>();				
			}
			_soundDefinitions.push(def);
		}
		
		public function get soundDefinitions():Vector.<SoundDefinition> {
			return _soundDefinitions;
		}
		
		public function hasDefinition(id:String):Boolean {
			return Boolean(_configMap[ConfigNodes.IDS][id]);
		}
		
		public function getSoundDefById(id:String):SoundDefinition {
			return _configMap[ConfigNodes.IDS][id];
		}
		
		public function getSoundDefinitionsByType(type:String):Vector.<SoundDefinition> {
			return _soundByType[type];
		}
		
		public function getSoundDefinitionsByStream(stream:Boolean):Vector.<SoundDefinition> {
			var definitions:Vector.<SoundDefinition> = new Vector.<SoundDefinition>;
			for each (var def:SoundDefinition in _soundDefinitions) {
				if (def.stream == stream)
					definitions.push(def);
			}
			return definitions;
		}
	}
}