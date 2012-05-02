package com.sevenbrains.trashingDead.exception
{

	/**
	 * Thrown to indicate that the requested operation is not supported.
	 * 
	 * @author Nicolas
	 */
	public class UnsupportedOperationException extends Error
	{		
		
		/**
		 * Creates instance.
		 * 
		 * @param	message	Exception message
		 */
		public function UnsupportedOperationException(message:String = "")
		{
			super(message);
		}
	}
}