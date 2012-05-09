package com.sevenbrains.trashingDead.exception
{
	
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