package com.sevenbrains.trashingDead.configuration {

	import com.sevenbrains.trashingDead.configuration.core.AbstractConfig;
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.interfaces.Locable;
	import flash.utils.Dictionary;
	/**
	* ...
	* @author Lucas Monje
	*/
	public class LocaleConfig extends AbstractConfig {
		
		public function LocaleConfig(map:Dictionary) {
			super(map);
		}
		
		override public function init():void {
			notifyEnd();
		}
	}
}