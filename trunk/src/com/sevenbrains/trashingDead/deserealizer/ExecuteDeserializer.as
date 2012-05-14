//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.ExecuteDefinition;
	import com.sevenbrains.trashingDead.deserealizer.ActionDeserializer;
	import com.sevenbrains.trashingDead.execute.interfaces.IActionDefinition;
	import flash.utils.Dictionary;
	
	public class ExecuteDeserializer {
		
		private var _xml:XML;
		
		public function ExecuteDeserializer(source:XML) {
			_xml = new XML(source);
		}
		
		public function deserialize():ExecuteDefinition {
			var executeDef:ExecuteDefinition = new ExecuteDefinition();
			deserializeAction(executeDef, _xml);
			
			for each (var conditionNode:XML in _xml.action) {
				deserializeAction(executeDef, conditionNode);
			}
			return executeDef;
		}
		
		private function deserializeAction(definition:ExecuteDefinition, node:XML):void {
			var actionDeserealizer:ActionDeserializer = new ActionDeserializer(node);
			var actionDef:IActionDefinition = actionDeserealizer.deserialize();
			
			if (actionDef) {
				definition.addAction(actionDef);
			}
		}
	}
}