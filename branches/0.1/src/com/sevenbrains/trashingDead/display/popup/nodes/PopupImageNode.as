package com.sevenbrains.trashingDead.display.popup.nodes {
	
	import com.sevenbrains.trashingDead.display.loaders.DefaultAssetLoader;
	
	public final class PopupImageNode extends PopupAsynchronicNode {
		
		public function PopupImageNode(path:String, url:String, argsName:String=null) {
			_path = path;
			_url = url;
			_argsName = argsName;
		}
		
		override protected function createLoader():DefaultAssetLoader {
			return new DefaultAssetLoader(url);
		}
	}
}