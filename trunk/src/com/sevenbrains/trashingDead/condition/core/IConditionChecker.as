//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.condition.core {
	
	public interface IConditionChecker {
		function checkCondition(condition:ConditionDefinition):Boolean;
		function getFulfilledConditions(condition:ConditionDefinition):Array;
		function getMissingConditions(condition:ConditionDefinition):Array;
	}
}