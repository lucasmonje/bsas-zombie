//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.deserealizer {
	
	import com.adobe.serialization.json.JSON;
	import com.sevenbrains.trashingDead.execute.IActionDefinition;
	import com.sevenbrains.trashingDead.execute.definition.PopupActionDefinition;
	import com.sevenbrains.trashingDead.execute.definition.UIActionDefinition;
	import com.sevenbrains.trashingDead.interfaces.Deserializable;
	
	import flash.utils.Dictionary;
	
	public class ActionDeserializer implements Deserializable {
		
		public static const TYPE:String = "sctionDeserializer";

		private static const POPUP:String = "popup";
		private static const UI:String = "ui";
		
		private static var _builderMap:Dictionary;
		
		private var _idsMap:Dictionary;

		private var _xml:XML;
		
		public function ActionDeserializer() {
			createBuilderMap()
		}
		
		public function deserialize(node:XML):* {
			_xml = node;
			_idsMap = new Dictionary();
			var builder:Function = getBuilder(_xml);
			
			if (builder === null) {
				return null;
			}
			var actionDef:IActionDefinition = builder(_xml);
			return actionDef;
		}
		
		private function buildPopupAction(source:XML):IActionDefinition {
			var action:PopupActionDefinition = new PopupActionDefinition();
			action.id = source.@id.toString();
			var dataString:String = source.@data;
			
			if (dataString) {
				action.data = dataString.indexOf('"') > -1 ? JSON.decode(dataString) : dataString;
			}
			
			if (source.@client.toString()) {
				action.client = source.@client.toString();
			}
			return action;
		}
		
		private function buildUIAction(source:XML):IActionDefinition {
			var action:UIActionDefinition = new UIActionDefinition();
			action.tab = source.@tab.toString();
			return action;
		}
		
		private function createBuilderMap():void {
			if (!Boolean(_builderMap)) {
				_builderMap = new Dictionary();
				_builderMap[POPUP] = buildPopupAction;
				_builderMap[UI] = buildUIAction;
			}
		}
		
		private function getBuilder(source:XML):Function {
			var type:String = source.@type.toString();
			var builder:Function = _builderMap[type];
			return builder;
		}
	}
}