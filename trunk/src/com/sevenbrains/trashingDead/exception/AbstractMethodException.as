package com.sevenbrains.trashingDead.exception
{
	public class AbstractMethodException extends Error
	{		
		/**
		 * Creates instance.
		 * 
		 * @param	message	Exception message
		 */
		public function AbstractMethodException(methodName:String)
		{
			super("Method called " + methodName + " is not overriden properly");
		}
	}
}