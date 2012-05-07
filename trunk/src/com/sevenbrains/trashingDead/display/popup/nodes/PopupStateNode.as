package com.sevenbrains.trashingDead.display.popup.nodes {
	
	import com.sevenbrains.trashingDead.display.popup.Popup;
	import com.sevenbrains.trashingDead.exception.ASSERT;
	import flash.display.MovieClip;
	
	public final class PopupStateNode implements IPopupNode {
		
		private var _path:String;
		private var _name:String;
		private var _play:Boolean;
		private var _callback:Function;
		
		public function PopupStateNode(path:String, name:String, play:Boolean=false) {
			_path = path;
			_name = name;
			_play = play;
		}
		
		public function get play():Boolean {
			return _play;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get path():String {
			return _path;
		}
		
		private function getMovie(popup:Popup):MovieClip {
			var movie:MovieClip = popup.getMovieByPath(path);
			ASSERT(movie, 'movie not found at ' + path);
			return movie;
		}
		
		public function applyTo(popup:Popup):void {
			var movie:MovieClip = getMovie(popup);
			if (play) {
				movie.gotoAndPlay(name);
			} else {
				movie.gotoAndStop(name);
			}
			if (_callback != null)
				_callback(true, this);
		}
		
		public function removeFrom(popup:Popup):void {
			getMovie(popup).stop();
		}
		
		public function setCallback(value:Function):void {
			_callback = value;
		}
	}
}