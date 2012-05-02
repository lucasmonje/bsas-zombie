package com.sevenbrains.trashingDead.display.popup.nodes
{
	import com.sevenbrains.trashingDead.display.loaders.Asset;
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import com.sevenbrains.trashingDead.net.ILoader;
	
	/**
	 * @author Ariel
	 * <br> modified by matias.munoz
	 */
	public final class PopupImageNode extends PopupAsynchronicNode
	{
		
		public function PopupImageNode(path:String, url:String, argsName:String=null)
		{
			_path = path;
			_url = url;
			_argsName = argsName;
		}
		
		override protected function createLoader():ILoader{
			return new Asset(url);
		}
	}
}