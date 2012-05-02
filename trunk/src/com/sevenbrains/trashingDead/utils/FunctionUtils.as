package com.sevenbrains.trashingDead.utils
{
    public class FunctionUtils
    {
        /**
         * A function that recieves any number of parameters and does nothing (like an NOP)
         * 
         * @param params Any parameter
         * @return Nothing.
         * 
         */
        public static function doNothing(...params):* {}
        
        /**
         * Returns a new function that when called invokes the function passed
         * as first parameter to the function parameters over the first
         * aggregates above.
         * 
         * <p>
         * Example:
         * <br>
         * <pre>
         * function one(p1:*):void {
         *     trace('one:', p1);
         * }
         * 
         * function two(p1:*, p2:*):void {
         *     trace('two:', p1, p2);
         * }
         * 
         * var f1:Function = FunctionUtils.attachParamsToFunction(one, "ONE");
         * var f2:Function = FunctionUtils.attachParamsToFunction(two, "TWO");
         * 
         * f1(); // one("ONE") is invoked
         * f2("SECOND_PARAMETER"); // two("TWO", "SECOND_PARAMETER") in invoked
         * f2(); // Error: two expect 2 parameters, and only 1 ("TWO") was given
         * 
         * // output
         * one: ONE  
         * two: TWO SECOND_PARAMETER  
         * 
         * </pre>
         * </p> 
         * 
         * @param f The function to which parameters are added
         * @param attachedParams The parameters to add
         * @return A new function that calls <code>f</code> when it's called, with the added parameters
         * 
         */
        public static function attachParamsTo(f:Function, ...attachedParams):Function {
            return function(...params):void { f.apply(null, params.concat(attachedParams)); }
        }
        
        /**
         * Returns a function that when is invoked, calls <code>f</code> with no arguments. The new function
         * recieves any number of arguments.
         * 
         * @param f The function that gets called with no arguments when the returned funcion in invoked.
         * @return A new function that calls <code>f</code> with no arguments.
         * 
         */
        public static function removeParamsFrom(f:Function):Function {
            return function(...params):void { f(); }
        }
    }
}