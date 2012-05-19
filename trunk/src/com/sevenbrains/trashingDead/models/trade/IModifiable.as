//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models.trade {
	
	public interface IModifiable {
		
		function canBeModified():Boolean;
		function copy():ITradeValue;
		function get possibleModifierEffects():Array;
		function get type():String;
	}
}