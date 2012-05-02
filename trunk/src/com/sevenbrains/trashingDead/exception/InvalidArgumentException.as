package com.sevenbrains.trashingDead.exception
{
	/**
	 * A InvalidArgumentException exception is thrown when
	 * the argument passed by reference to a function is invalid.
	 * 
	 * <p>Abstract class implementation rule.</p>
	 * 
	 * @author Nicolas
	 */	 
	public class InvalidArgumentException extends Error
	{
		/**
		 * Creates instance.
		 * 
		 * @param message Exception message
		 */
		public function InvalidArgumentException(message:String = "")
		{
			super(message);
		}
	}
}