package client.utils
{
    import com.vostu.commons.logging.ILogger;
    import com.vostu.commons.logging.LogContext;
    
    import flash.net.SharedObject;
    
    public class SharedObjectUtils
    {
        static private var log:ILogger = LogContext.getLogger(SharedObjectUtils);
        
        static public function load(cookie:String, property:String):*
        {
            try {
                var so:SharedObject = SharedObject.getLocal(cookie, '/');
                return so.data[property];
            } catch(e:Error) {
                log.error(e.toString());
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
                log.error(e.toString());
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
                log.error(e.toString());
            }
            return false;
        }
    }
}