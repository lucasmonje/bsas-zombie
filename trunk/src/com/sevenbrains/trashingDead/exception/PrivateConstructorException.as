package com.sevenbrains.trashingDead.exception
{
	/**
	 * A PrivateConstructorException exception is thrown when trying 
	 * to access private constructor of a class.
	 * 
	 * <p>Abstract class implementation rule.</p>
	 * 
	 * @author Nicolas
	 */	 
	public class PrivateConstructorException extends Error
	{
		
		/**
		 * Creates instance.
		 * 
		 * @param message Exception message
		 */
		public function PrivateConstructorException(message:String = "")
		{
			super(message);
		}
	}
}