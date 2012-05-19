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
	import com.sevenbrains.trashingDead.deserealizer.core.Deserializers;
	import com.sevenbrains.trashingDead.execute.IActionDefinition;
	import com.sevenbrains.trashingDead.interfaces.Deserializable;
	
	import flash.utils.Dictionary;
	
	public class ExecuteDeserializer implements Deserializable {
		
		public static const TYPE:String = "executeDeserializer";

		public function ExecuteDeserializer() {
		
		}
		
		public function deserialize(node:XML):* {
			if (!Boolean(node.length())) {
				return null;
			}
			var executeDef:ExecuteDefinition = new ExecuteDefinition();
			deserializeAction(executeDef, node);
			
			for each (var conditionNode:XML in node.action) {
				deserializeAction(executeDef, conditionNode);
			}
			return executeDef;
		}
		
		private function deserializeAction(definition:ExecuteDefinition, node:XML):void {
			var actionDeserealizer:ActionDeserializer = Deserializers.map[ActionDeserializer.TYPE];
			var actionDef:IActionDefinition = actionDeserealizer.deserialize(node);
			
			if (actionDef) {
				definition.addAction(actionDef);
			}
		}
	}
}