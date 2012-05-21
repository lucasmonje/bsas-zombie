package com.sevenbrains.trashingDead.utils
{
    
    public class ObjectUtil
    {
        /**
         * @return Whether the object is empty
         */ 
        public static function isEmpty(object:Object):Boolean {
            for (var key:String in object) {
                return false;
            }
            return true;
        }
        
        /**
         * @return The amount of entries in the object
         */ 
        public static function length(object:Object):uint {
            var count:uint = 0;
            for (var key:String in object) {
                count++;
            }
            return count;
        }
        
        /**
         * @return The object's keys
         */
        public static function keys(object:Object):Array {
            var ret:Array = [];
            for (var key:String in object) {
                ret.push(key);
            }
            return ret;
        }
        
        /**
         * @return The object's values
         */
        public static function values(object:Object):Array {
            var ret:Array = [];
            for each(var value:Object in object) {
                ret.push(value);
            }
            return ret;
        }
        
        /**
         * Traverses the target object throught all the properties in the path.
         * 
         * @example If target is a MovieClip and path is 'transform.colorTransform.greenMultiplier'
         * then this method will return the same as:
         * <code>target.transform.colorTransform.greenMultiplier</code>
         * 
         * @param path A dot separated list of names of properties.
         * @param target The object where the search will start.
         * @return The object at the end of the path or null if no object
         * was found or the path was invalid.
         */
        public static function getIntrospectiveValue(path:String, target:Object):Object
        {
            var result:Object;
            
            if (target == null || path == null) {
                return null;
            }
            
            var properties:Array = path.split(".");
            for each(var property:String in properties)
            {
                target = target[property];
                if (target == null) {
                    return null;
                }
            }
            
            return target;
        }
        
        /**
         * @private
         * 
         * builders used to build an dynamically an object. add more as needed
         */
        static private const builders:Array = [
            build0p, build1p, build2p, build3p, build4p,
            build5p, build6p, build7p, build8p, build9p
        ];
        
        /**
         * Creates an new Object of the <code>ObjectClass</code> and pass the params
         * to the constructor of that object.
         * 
         * @param ObjectClass The Class of the object to create
         * @param params The arguments for the constructor of the object
         * @return A new object of class <code>ObjectClass</code>
         * 
         */
        static public function buildFromParams(ObjectClass:Class, ...params):* {
            return builders[params.length](ObjectClass, params);
        }
        
        /**
         * Creates an new Object of the <code>ObjectClass</code> and pass the params
         * to the constructor of that object.
         * 
         * @param ObjectClass The Class of the object to create
         * @param params The arguments for the constructor of the object
         * @return A new object of class <code>ObjectClass</code>
         * 
         */
        static public function buildFromArray(ObjectClass:Class, params:Array):* {
            return builders[params.length](ObjectClass, params);
        }
        
        /**
         * @private
         * 
         * all builders used to build dynamically an object. add more as needed.
         */
        static private function build0p(ObjectClass:Class, p:Array):* { return new ObjectClass(); }
        static private function build1p(ObjectClass:Class, p:Array):* { return new ObjectClass(p[0]); }
        static private function build2p(ObjectClass:Class, p:Array):* { return new ObjectClass(p[0], p[1]); }
        static private function build3p(ObjectClass:Class, p:Array):* { return new ObjectClass(p[0], p[1], p[2]); }
        static private function build4p(ObjectClass:Class, p:Array):* { return new ObjectClass(p[0], p[1], p[2], p[3]); }
        static private function build5p(ObjectClass:Class, p:Array):* { return new ObjectClass(p[0], p[1], p[2], p[3], p[4]); }
        static private function build6p(ObjectClass:Class, p:Array):* { return new ObjectClass(p[0], p[1], p[2], p[3], p[4], p[5]); }
        static private function build7p(ObjectClass:Class, p:Array):* { return new ObjectClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6]); }
        static private function build8p(ObjectClass:Class, p:Array):* { return new ObjectClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]); }
        static private function build9p(ObjectClass:Class, p:Array):* { return new ObjectClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]); }
    }
}
