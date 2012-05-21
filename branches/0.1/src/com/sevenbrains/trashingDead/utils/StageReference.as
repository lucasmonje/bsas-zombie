package com.sevenbrains.trashingDead.utils 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * Manages global references to the stage.
	 */
	public class StageReference {
		
		protected static var _stage:Stage;
		
		/**
		 * The stage reference constructor. Private. Don't call this!!
		 * @param lock The lock to prevent invalid instantiation of the stage reference.
		 */
		public function StageReference(lock:StageReferenceLock) {
			if(!(lock is StageReferenceLock)) {
				throw new Error("Invalid instantiation of the stage reference.");
			}
		}
		
		/**
		 * Sets the reference to ths stage. Can only be called once.
		 * @param stage The stage object.
		 */		
		public static function initReference(stage:Stage):void {
			if (_stage == null) {
				_stage = stage;
			}
		}
		
		/**
		 * Retrieves the one and only reference to the stage.
		 * @return The reference to the stage.
		 */
		public static function get stage():Stage {
			return _stage;
		}
		
		/**
		 * Retrieves the root element which is the stage's one and only child.
		 * @return The reference to the root.
		 */
		public static function get root():DisplayObjectContainer {
			return _stage.getChildAt(0) as DisplayObjectContainer;
		}
		
		/**
		 * DEMO
		 * reemplazar por root.loaderInfo.parameters
		 * cuando el locale venga por UI
		 */
		public static function get flashVars():Object {
			var params:Object = new Object();
			params.locale = "es";
			return params;
		}
		
		/** Returns the folder holding the SWF */
		public static function get baseURL():String
		{
			var url:String = root.loaderInfo.loaderURL;
			return url.split('.swf')[0].split('/').slice(0, -1).join('/');
		}
	}
}

/**
 * Internal class to prevent invalid instantiation of the class.
 */
internal class StageReferenceLock {}