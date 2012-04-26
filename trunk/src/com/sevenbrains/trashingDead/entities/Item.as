package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Item 
	{
		private var _props:ItemDefinition;
		
		public function Item(props:ItemDefinition) 
		{
			_props = props;
		}
		
		public function get props():ItemDefinition 
		{
			return _props;
		}
		
		/**
		 * Devuelve si el arma esta activa.
		 * Corresponde a los locks que tenga.
		 */
		public function isEnabled():Boolean {
			return true;
		}
	}

}