package com.sevenbrains.trashingDead.exception
{

	/**
	 * The IllegalStateException exception.
	 */
	public class IllegalStateException extends Error
	{		
		/**
		 * Creates instance.
		 * 
		 * @param	message	Exception message
		 */
		public function IllegalStateException(message:String = "")
		{
			super(message);
		}
	}
}