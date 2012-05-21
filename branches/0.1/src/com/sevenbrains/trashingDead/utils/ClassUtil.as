package com.sevenbrains.trashingDead.utils
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public final class ClassUtil 
	{
		/** returns the class name of an object with namespace */
		public static function getFullName(obj:Object):String
		{
			return getQualifiedClassName(obj);
		}

		/** returns the class name of an object */
		public static function getName(obj:Object):String
		{
			return getFullName(obj).split('::')[1];
		}
		
		/** returns the class of an object */
		public static function getClass(obj:Object):Class
		{
			return getDefinitionByName(getFullName(obj)) as Class;
		}
	}
}