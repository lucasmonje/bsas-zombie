package com.sevenbrains.trashingDead.exception
{

	/**
	 * A NoSuchElementException exception is thrown when the object supplied 
	 * in a function or process is not find in current data structure.
	 */
	public class NoSuchElementException	extends Error
	{
		/**
		 * Creates instance.
		 * 
		 * @param message Exception message
		 */
		public function NoSuchElementException(message:String = "")
		{
			super(message);
		}
	}
}