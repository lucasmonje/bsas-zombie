package com.sevenbrains.trashingDead.utils {
    
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    
    /**
     * An abstract class to emulate Enum type.
     */
    public class Enum {
        
        /**
         * To protect from instantiation after static initializing.
         */
        protected static var locks:Dictionary = new Dictionary();
        
        /**
         * Enum label.
         */
        private var _label:String;
        
        /**
         * Function to call for each enum type declared and in static init.
         */
        protected static function initEnumConstant(inType:Class):void {
            
            var className:String = getQualifiedClassName(inType);
            var typeXML:XML = describeType(inType);
            for each (var constant:XML in typeXML.constant) {
                inType[constant.@name]._label = constant.@name;
            }
            locks[className] = true;
        }
        
        /**
         * Creates a new Enum member.
         */
        public function Enum() {
            
            var className:String = getQualifiedClassName(this);
            if (locks[className]) {
                throw new IllegalOperationError("Cannot instantiate anymore: " + className);
            }
        }
        
        /**
         * Retrieves the label of an enum. Mainly for debugging.
         */
        public function get label():String {
            return _label;
        }
        
        /**
         * @return The string representation of this Enum.
         */
        public function toString():String
        {
            return _label;
        }
    }
}