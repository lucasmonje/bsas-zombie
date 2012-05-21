//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.events {
	
	import flash.events.Event;
	
	public class SuggestionConfigEvent extends Event {
		
		public static const SUGGESTIONS_ADDED:String = "suggestionsAdded";
		
		public function SuggestionConfigEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}