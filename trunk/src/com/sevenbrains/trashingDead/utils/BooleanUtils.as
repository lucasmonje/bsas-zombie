package com.sevenbrains.trashingDead.utils
{
	/**
	 * 
	 * @author Nicolas
	 * 
	 */	
	public class BooleanUtils
	{
		/**
		 * Transform <code>argument</code> to boolan value.
		 * 
		 * @param boolean value to <code>argument</code> or 
		 * <code>defaultValue</code> if argument is null or empty
		 */
		static public function fromString(argument:String, defaultValue:Boolean = false):Boolean {
			switch(argument) {
				case null:
				case '':
					return defaultValue;
					
				case '1':
				case 'true':
					return true;
					
				case '0':
				case 'false':
					return false;
					
				default:
					throw new ArgumentError(argument + ' is not a valid boolean value');
			}
		}
	}
}