package com.sevenbrains.trashingDead.utils 
{
	import flash.display.Loader;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class CustomLoader extends Loader 
	{
		private var _map:Dictionary;
		private var _assetName:String;
		public function CustomLoader(map:Dictionary, assetName:String) 
		{
			super();
			_map = map;
			_assetName = assetName;
		}
		
		public function get map():Dictionary 
		{
			return _map;
		}
		
		public function get assetName():String 
		{
			return _assetName;
		}
		
	}

}