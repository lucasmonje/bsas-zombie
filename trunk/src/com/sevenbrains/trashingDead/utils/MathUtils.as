package com.sevenbrains.trashingDead.utils 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class MathUtils 
	{
		
		public function MathUtils() 
		{
			
		}

		public static function getRandom(minValue:Number, maxValue:Number):Number {
			var low:Number = minValue;
			var high:Number = maxValue;
				
			if(isNaN(low))
			{
			throw new Error("low must be defined");
			}
			if(isNaN(high))
			{
			throw new Error("high must be defined");
			}

			return Math.round(Math.random() * (high - low)) + low;
		}
		
		public static function getRandomInt(minValue:int, maxValue:int):int {
			return getRandom(minValue, maxValue) as int;
		}
	}

}