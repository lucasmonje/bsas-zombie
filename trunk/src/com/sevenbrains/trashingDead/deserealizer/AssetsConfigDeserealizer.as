package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.AssetDefinition;
	import com.sevenbrains.trashingDead.deserealizer.core.AbstractDeserealizer;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.utils.BooleanUtils;
	import flash.utils.Dictionary;
	
	public class AssetsConfigDeserealizer extends AbstractDeserealizer {
		
		private var _autoLoadList:Array;
		private var _idMap:Array;
		
		public function AssetsConfigDeserealizer(source:String) {
			super(source);
		}
		
		override public function deserialize():void {
			_xml = new XML(_source);
			_autoLoadList = new Array();
			_idMap = new Array();
			_map = new Dictionary();
			_map[ConfigNodes.SWFS] = decodeAssets(_xml.swfs, ConfigNodes.SWFS);
			_map[ConfigNodes.AUTO_LOAD] = _autoLoadList;
			_map[ConfigNodes.IDS] = _idMap;
		}
		
		private function decodeAssets(xml:XMLList, type:String):Array {
			var assetDefList:Array = new Array();
			var folderPath:String = XML(xml[0]).@folderPath.toString();
			for each (var element:XML in xml.elements()) {
				var preloaderId:String = element.@preloaderId.toString() != "" ? element.@preloaderId.toString() : null;
				var assetDef:AssetDefinition = new AssetDefinition(element.@id.toString(), type, folderPath + element.@path, preloaderId);
				if (preloaderId) {
					_autoLoadList.push(assetDef);
				}
				_idMap[assetDef.id] = assetDef;
				assetDefList.push(assetDef);
			}
			return assetDefList;
		}
	}
}