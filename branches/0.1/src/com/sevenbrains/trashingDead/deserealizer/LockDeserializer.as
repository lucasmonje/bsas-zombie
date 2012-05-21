//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.condition.core.ConditionDefinition;
	import com.sevenbrains.trashingDead.definitions.LockDefinition;
	import com.sevenbrains.trashingDead.deserealizer.core.Deserializers;
	import com.sevenbrains.trashingDead.interfaces.Deserializable;
	import com.sevenbrains.trashingDead.managers.LockManager;
	
	import flash.utils.Dictionary;
	
	public class LockDeserializer implements Deserializable {
		
		public static const TYPE:String = "lockDeserializer";

		private static var deserializedLocks:Object;
		
		private static var missingIdRef:Dictionary;
		
		public var lockManager:LockManager;
		
		private var node:XML;
		
		public function LockDeserializer() {
			deserializedLocks = new Object();
			missingIdRef = new Dictionary();
		}
		
		public function deserialize(node:XML):* {
			if (!node) {
				return null;
			}
			var lockDefinition:LockDefinition;
			
			if (String(node.@["id-ref"]).length) {
				var idRef:int = int(node.@["id-ref"]);
				
				if (!deserializedLocks.hasOwnProperty(idRef)) {
					if (!Boolean(missingIdRef[idRef])) {
						lockDefinition = new LockDefinition();
						lockDefinition.id = idRef;
						missingIdRef[idRef] = lockDefinition;
						return lockDefinition;
					} else {
						return missingIdRef[idRef];
					}
				} else {
					lockDefinition = deserializedLocks[idRef];
				}
				
			} else {
				
				var id:int = int(node.@id) ? int(node.@id) : -1;
				
				if (deserializedLocks.hasOwnProperty(id)) {
					throw new Error("Duplicated Lock with id=" + id);
				}
				
				if (Boolean(missingIdRef[id])) {
					lockDefinition = missingIdRef[id] as LockDefinition;
					deserializeLock(lockDefinition, node);
					delete missingIdRef[id];
				} else {
					lockDefinition = new LockDefinition();
					lockDefinition.id = id;
					deserializeLock(lockDefinition, node);
				}
			}
			return lockDefinition;
		}

		private function deserializeCondition(definition:LockDefinition, node:XML):void {
			var conditionDeserializer:ConditionDeserializer = Deserializers.map[ConditionDeserializer.TYPE];
			var condition:ConditionDefinition = conditionDeserializer.deserialize(node);
			
			if (condition) {
				definition.addCondition(condition);
			}
		}
		
		private function deserializeLock(definition:LockDefinition, xml:XML):* {
			
			deserializeCondition(definition, xml);
			
			for each (var conditionNode:XML in xml.condition) {
				deserializeCondition(definition, conditionNode);
			}
			
			LockManager.instance.addLock(definition);
			
			if (definition.id > 0) {
				deserializedLocks[definition.id] = definition;
			}
			return definition;
		}
	}
}