package com.sevenbrains.trashingDead.utils
{
    import flash.net.SharedObject;
    
    public class SharedObjectUtils
    {
        
        static public function load(cookie:String, property:String):*
        {
            try {
                var so:SharedObject = SharedObject.getLocal(cookie, '/');
                return so.data[property];
            } catch(e:Error) {
                trace(e.toString());
            }
            return null;
        }
        
        static public function save(cookie:String, property:String, value:*):Boolean
        {
            try {
                var so:SharedObject = SharedObject.getLocal(cookie, '/');
                so.data[property] = value;
                so.flush();
                return true;
            } catch(e:Error) {
                trace(e.toString());
            }
            return false;
        }
        
        static public function clear(cookie:String, property:String):Boolean
        {
            try {
                var so:SharedObject = SharedObject.getLocal(cookie, '/');
                so.clear();
                return true;
            } catch(e:Error) {
                trace(e.toString());
            }
            return false;
        }
    }
}