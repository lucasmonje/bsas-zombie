package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.deserealizer.core.BuilderDeserealizer;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.interfaces.Buildable;
	import com.sevenbrains.trashingDead.sound.SoundDefinition;
	import com.sevenbrains.trashingDead.utils.BooleanUtils;
	
	import flash.utils.Dictionary;
	
	public class SoundConfigDeserializer extends BuilderDeserealizer implements Buildable {
		
		public static const TYPE:String = "soundConfigDeserializer";

		private var _idsMap:Dictionary;
		
		public function SoundConfigDeserializer(source:String) {
			super(source);
		}
		
		override public function deserialize(source:String):* {
			_xml = new XML(source);
			_idsMap = new Dictionary();
			_map = new Dictionary();
			_map[ConfigNodes.SOUNDS] = deserializeSounds(_xml.sounds as XMLList);
			_map[ConfigNodes.IDS] = _idsMap;
			return _map;
		}
		
		private function deserializeSounds(sounds:XMLList):Array {
			var folderPath:String = sounds.@folderPath.toString();
			var sounds:XMLList = sounds.sound as XMLList;
			var sdsList:Array = [];
			for (var i:int = 0; i < sounds.length(); i++) {
				var sound:XML = sounds[i];
				var soundDefinition:SoundDefinition = new SoundDefinition();
				soundDefinition.id = sound.@assetRef.toString();
				soundDefinition.stream = BooleanUtils.fromString(sound.@stream.toString());
				soundDefinition.loops = uint(sound.@loops);
				soundDefinition.type = sound.@type.toString();
				soundDefinition.path = folderPath + sound.@path.toString();
				_idsMap[soundDefinition.id] = soundDefinition;
				sdsList.push(soundDefinition);
			}
			return sdsList;
		}
	}
}