package client.utils
{
    import flash.utils.Dictionary;

    /**
     * Utility functions for arrays
     * @author Ariel
     */
    
    public class ArrayUtil
    {
        /**
         * Removes an element from an array.
         * @return The removed object if found
         */ 
        public static function remove(array:Array, elem:Object):Object {
            var i:int = array.indexOf(elem);
            if (i != -1)
                return array.splice(i, 1)[0];
            return null;
        }
        
        /**
         * Returns whether an array contains an element.
         */
        public static function contains(arr:Array, obj:Object):Boolean {
            return arr.indexOf(obj) !== -1;
        }
        
        private static function randomIndex(values:Array):int {
            return Math.random() * values.length;
        }
        
        /**
         * Return a random element from the array.
         */
        public static function randomValue(values:Array):Object	{
            return values[randomIndex(values)];
        }
        
        /** Converts an object to array by wrapping it */
        public static function makeArray(data:Object):Array {
            
            if (data is Array) {
                return data as Array;
            }
            
            if (data !== null) {
                return [data];
            }
            
            return [];
        }
        
        /** Given an iterable object it returns an array of all values in that object */
        public static function toArray(iterable:*):Array {
            var array:Array = [];
            for each (var o:* in iterable) {
                array.push(o);
            }
            return array;
        }
        
        /**
         * Remove a random element from the array and return it.
         */
        public static function removeRandom(values:Array):Object {
            return values.splice(randomIndex(values),1)[0];
        }
        
        /**
         * Shuffles an array (without cloning!)
         * 
         * @return The same array (shuffled) because that's often useful
         */
        public static function shuffle(arr:Array):Array {
            var length:uint = arr.length;
            
            for (var i:uint = 0; i < length; i++) {
                var elem:Object = arr[i];
                var j:uint = length * Math.random();
                arr[i] = arr[j];
                arr[j] = elem;
            }
            
            return arr;
        }
        
        /**
         * Returns an array with a range of numbers.
         * 
         * Note: The list doesn't include the max
         * Note: If max isn't specified, then it goes from 0 to min
         */
        public static function range(min:Number, max:Number=NaN, step:Number=1):Array {
            if (isNaN(max)) {
                max = min;
                min = 0;
            }
            
            var arr:Array = [];
            while (min < max) {
                arr.push(min);
                min += step;
            }
            return arr;
        }
        
        /**
         * Performs the intersection between to arrays and returns the result as a new Array.
         * 
         * @see http://en.wikipedia.org/wiki/Intersection_(set_theory)
         * 
         * @param a An Array to intersect with b
         * @param b An Array to intersect with a
         * @return The intersection of a and b
         * 
         */
        public static function intersection(a:Array, b:Array):Array
        {
            var value:*;
            var map:Dictionary = new Dictionary();
            var intersection:Array = [];
            for each (value in a) {
                map[value] = value;
            }
            for each (value in b) {
                if (map[value] !== undefined) {
                    intersection.push(value);
                }
            }
            return intersection;
        }
    }
}
