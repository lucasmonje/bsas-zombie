package com.sevenbrains.trashingDead.exception
{
	/**
	 * Thrown when calling an abstract method that was't overriden properly.
	 * 
	 * @author German Allemand
	 */
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