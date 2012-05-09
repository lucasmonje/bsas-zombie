package com.sevenbrains.trashingDead.exception
{ 
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