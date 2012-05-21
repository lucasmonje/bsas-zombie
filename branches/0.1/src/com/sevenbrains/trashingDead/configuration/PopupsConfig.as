package com.sevenbrains.trashingDead.configuration {

	import com.sevenbrains.trashingDead.configuration.core.AbstractConfig;
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.display.popup.PopupProperties;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import flash.utils.Dictionary;
	/**
	* ...
	* @author Lucas Monje
	*/
	public class PopupsConfig extends AbstractConfig {
		
		public function PopupsConfig(map:Dictionary) {
			super(map);
		}
		
		override public function init():void {
			notifyEnd();
		}
		
		public function getAll():Array {
			return _configMap[ConfigNodes.POPUPS];
		}
		
		public function get(id:String):PopupProperties {
			return _configMap[ConfigNodes.IDS][id];
		}
		
	}
}