package com.sevenbrains.trashingDead.display.button
{
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	import com.sevenbrains.trashingDead.utils.BooleanUtils;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * A common interface for all "button-movieclips"
	 *
	 * */
	public class GenericButton extends EventDispatcher implements Destroyable
	{

		public static const UP_STATE : String = "_up";
		public static const DOWN_STATE : String = "_down";
		public static const OVER_STATE : String = "_over";
		public static const DISABLE_STATE : String = "_disable";
		public static const SELECT_STATE : String = DOWN_STATE;

		private static const FOUNDATIONAL_STATES : Array = [DOWN_STATE, OVER_STATE, UP_STATE];

		private var _destroyed : Boolean;

		private var listeners : Dictionary;

		protected var _display : MovieClip;
		protected var _id : Number;
		protected var _data : Object;

		public function GenericButton(mc : MovieClip)
		{
			super();

			if (!mc)
				throw new Error("GenericButton must have a Movieclip");
			_display = mc;
			checkFrameLabels();
			initialize();
		}

		private function checkFrameLabels() : void
		{
			var frameLabels : Array = _display.currentLabels;
			var missingLabels : Array = FOUNDATIONAL_STATES.concat();

			var index : int;

			for each (var frameLabel : FrameLabel in frameLabels)
			{
				index = missingLabels.indexOf(frameLabel.name);
				if (index > -1)
					missingLabels.splice(index, 1);
			}
		}

		public function get display() : MovieClip
		{
			return _display;
		}

		/**
		 * The unique identifier of the object
		 */
		public function get id() : Number
		{
			return this._id;
		}

		/**
		 * The unique identifier of the object
		 */
		public function set id(value : Number) : void
		{
			this._id = value;
		}

		public function get data() : Object
		{
			return this._data;
		}

		public function set data(value : Object) : void
		{
			this._data = value;
		}

		public function get enabled() : Boolean
		{
			return _display.enabled && _display.mouseEnabled;
		}

		public function set enabled(value : Boolean) : void
		{
			_display.mouseEnabled = value;
			_display.enabled = value;
			_display.gotoAndStop(value ? UP_STATE : DISABLE_STATE);
			_display.useHandCursor = value;
		}

		public function set visible(value : Boolean) : void
		{
			if (_display)
				_display.visible = value;
		}

		public function get x() : Number
		{
			return this._display.x;
		}

		public function set x(value : Number) : void
		{
			this._display.x = value;
		}

		public function get y() : Number
		{
			return this._display.y;
		}

		public function set y(value : Number) : void
		{
			this._display.y = value;
		}

		public function get height() : Number
		{
			return this._display.height;
		}

		public function get width() : Number
		{
			return this._display.width;
		}

		public function get selected() : Boolean
		{
			return !_display.enabled && _display.currentLabel == SELECT_STATE;
		}

		public function set selected(value : Boolean) : void
		{
			_display.enabled = !value;
			_display.mouseEnabled = true;
			_display.gotoAndPlay(value ? SELECT_STATE : UP_STATE);
		}

		private function initialize() : void
		{
			listeners = new Dictionary();

			_display.gotoAndStop(UP_STATE);
			_display.mouseChildren = false;
			_display.buttonMode = true;
			_display.useHandCursor = true;

			visible = true;
		}

		public function destroy() : void
		{
			_destroyed = true;

			for (var type : String in listeners)
			{
				var typeDict : Dictionary = listeners[type];
				for (var capture : String in typeDict)
				{
					var captureBool :Boolean = BooleanUtils.fromString(capture);
					var captArr : Vector.<Function> = typeDict[capture];
					for each (var f : Function in captArr)
					{
						_display.removeEventListener(type, redispatchEvent, captureBool);
						removeEventListener(type, redispatchEvent, captureBool);
					}
					captArr.length = 0;
				}
				delete listeners[type];
			}

			_display = null;
			_data = null;
		}

		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			_display.addEventListener(type, redispatchEvent, useCapture, priority, useWeakReference);
			var listArr : Vector.<Function> = getArrayFor(type, useCapture.toString());
			if (listArr.indexOf(listener) < 0)
			{
				listArr.push(listener);
			}
		}

		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void
		{
			super.removeEventListener(type, listener, useCapture);
			if (_destroyed)
				return;
			
			_display.removeEventListener(type, redispatchEvent, useCapture);
			var listArr : Vector.<Function> = getArrayFor(type, useCapture.toString());
			var index : int = listArr.indexOf(listener);
			if (index > -1)
			{
				listArr.splice(index, 1);
			}
		}

		protected function redispatchEvent(e : MouseEvent) : void
		{
			e.stopPropagation();
			dispatchEvent(e);
		}

		protected function getArrayFor(type : String, useCapture : String) : Vector.<Function>
		{
			var typeDict : Dictionary = listeners[type] as Dictionary;
			if (!typeDict)
			{
				typeDict = listeners[type] = new Dictionary();
			}
			var captArr : Vector.<Function> = typeDict[useCapture];
			if (!captArr)
			{
				captArr = typeDict[useCapture] = new Vector.<Function>();
			}
			return captArr;
		}

		public function isDestroyed() : Boolean
		{
			return _destroyed;
		}

		public function set useHandCursor(value : Boolean) : void
		{
			if (this._display)
				_display.useHandCursor = value;
		}
	}
}