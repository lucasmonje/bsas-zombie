 package com.sevenbrains.trashingDead.exception
{
	/**
	 * A IndexOutOfBoundsException exception is thrown when the index supplied 
	 * is not valid for data structure which try to access data using this 
	 * index.
	 */
	public class IndexOutOfBoundsException  extends Error
	{
		/**
		 * Creates instance.
		 * 
		 * @param message Exception message
		 */
		public function IndexOutOfBoundsException(message:String = "")
		{
			super(message);
		}
	}
}