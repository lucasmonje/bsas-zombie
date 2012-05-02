package com.sevenbrains.trashingDead.utils
{
    /**
     * Utility functions for strings
     * 
     * @author Ariel
     */
    public final class StringUtil
    {
        /**
         * Applies values to a string template
         * @param pattern The string template
         * @param args The data to apply (multi-arguments or one object)
         */
        public static function format(pattern:String, ...args):String {
            formatData = args.length == 1 && typeof args[0] == 'object' ? args[0] : args;
            return pattern.replace(/\{(\S+?)\}/g, replace);
        }
        
        // Used internally by format()
        private static var formatData:Object;
        
        // Used internally by format()
        private static function replace(original:String, name:String, index:uint, pattern:String):String {
            var data:Object = formatData;
            for each(var part:String in name.split('.')) {
                if (!data) break;
                data = data[part];
            }
            return data === null ? original : data.toString();
        }
        
        
        /**
         * Removes trailing and leading spaces
         * @param text The string to trim
         */
        public static function trim(text:String):String {
            return text.replace(/^\s+|\s+$/g, '');
        }
        
        /**
         * Truncates a string to a certain length with a certain suffix
         * @param text The string to trim
         * @param chars The amount of characters to keep
         * @param fill The suffix to add when needed
         */
        public static function truncate(text:String, chars:uint, fill:String='...'):String {
            if (text.length > chars) {
                text = text.slice(0, Math.max(chars - fill.length, 0)) + fill;
            }
            return text;
        }		
        
        /**
         * Capitalizes a string
         * @param str The string to capitalize
         */
        public static function capitalize(str:String):String {
            return str.charAt(0).toUpperCase() + str.slice(1);
        }
        
        /**
         * Makes a case insensitive string comparison
         * @param str One string
         * @param str2 The other string
         */
        public static function icompare(str:String, str2:String):Boolean
        {
            if (str === str2)
                return true;
            
            if (str === null || str2 === null)
                return false; 
            
            return str.toUpperCase() === str2.toUpperCase();
        }
        
        /**
         * Ensures a string with a certain length filling from the left
         * @param data The number or string to pad
         * @param len The amount of characters desired
         * @param fill The string used to fill
         */
        public static function pad(data:Object, len:uint=2, fill:String='0'):String
        {
            var str:String = data.toString();
            
            while (str.length < len) {
                str = fill + str;
            }
            
            return str;
        }
        
        /**
         * Returns a string repeated a certain amount of times
         * @param str The string
         * @param times how many times to repeat it
         */
        public static function repeat(str:String, times:uint):String
        {
            var ret:String = '';
            while (times--) {
                ret += str;
            }
            return ret;
        }
        
        /**
         * Given a String and a separator, split the string in parts and  
         * @param s
         * @param separator
         * @return 
         * 
         */
        public static function camelCase(s:String, separator:String=' '):String {
            var parts:Array = s.split(separator);
            var result:String = '';
            for each (var part:String in parts) {
                if (result.length == 0) {
                    result += part.toLowerCase();
                } else {
                    result += part.charAt(0).toUpperCase() + part.substr(1).toLowerCase();
                }
            }
            return result;
        }
    }
}