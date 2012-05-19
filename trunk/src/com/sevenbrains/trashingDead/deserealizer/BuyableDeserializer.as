//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.BuyableDefinition;
	import com.sevenbrains.trashingDead.interfaces.Deserializable;
	
	public class BuyableDeserializer implements Deserializable {
		
		public static const TYPE:String = "buyableDeserializer";

		public function BuyableDeserializer() {
		
		}
		
		public function deserialize(node:XML):* {
			if (!Boolean(node.length())) {
				return null;
			}
			var buyableDef:BuyableDefinition;
			return buyableDef;
		}
	}
}