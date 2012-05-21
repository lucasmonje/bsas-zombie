//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.exception {
	
	public class DuplicateIdException extends Error {
		
		public function DuplicateIdException(message:String = "") {
			super("DuplicateIdException > " + message);
		}
	}
}