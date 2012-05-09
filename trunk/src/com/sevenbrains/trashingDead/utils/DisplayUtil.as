package com.sevenbrains.trashingDead.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public final class DisplayUtil
	{
		/**
		 * Similar to getChildByName() but works with a dot-separated path
		 */
		public static function getChildByPath(context:DisplayObjectContainer, path:String):DisplayObject {
			
			if (!Boolean(path)) {
				return context;
			}
			var obj:DisplayObject = context;
			for each (var name:String in path.split('.')) {
				if (obj is DisplayObjectContainer === false) return null;
				
				obj = DisplayObjectContainer(obj).getChildByName(name);
				if (!obj) break;
			}
			return obj;
		}
		
		public static function setMouseEnabled(object:DisplayObject, enabled:Boolean=true):void {
			if (object is InteractiveObject) {
				InteractiveObject(object).mouseEnabled = enabled;
				
				if (object is DisplayObjectContainer) {
					DisplayObjectContainer(object).mouseChildren = enabled;
				}
			}
		}
		
		/** Disable mouse interaction with a display object */
		public static function disableMouse(object:DisplayObject):void {
			setMouseEnabled(object, false);
		}
		
		/** Removes all children of an object */
		public static function empty(object:DisplayObjectContainer):void {
			while (object.numChildren) {
				object.removeChildAt(0);
			}
		}
		
		/** Removes a child from its parent, doesn't fail on null parent or child */
		public static function remove(object:DisplayObject):void {
			if (object && object.parent) {
				object.parent.removeChild(object);
			}
		}
		
		/** Sets a display object as button */
		public static function button(object:DisplayObject):void {
			if (object is DisplayObjectContainer) {
				DisplayObjectContainer(object).mouseChildren = false;
				if (object is Sprite) {
					Sprite(object).buttonMode = true;
				}
			}
		}
		
		/** Brings a child to the front of its parent */
		public static function bringToFront(object:DisplayObject):void {
			var parent:DisplayObjectContainer = object.parent;
			if (parent) {
				parent.setChildIndex(object, parent.numChildren-1);
			}
		}
		
		/** Changes the parent of an object but remains on the same global location  */
		public static function reparentTo(object:DisplayObject, target:DisplayObjectContainer, index:int = -1):void {
			var pos:Point = new Point(object.x, object.y);
			pos = object.parent.localToGlobal(pos);
			
			if (index == -1) {
				index = target.numChildren;
			}
			target.addChildAt(object, index);
			pos = target.globalToLocal(pos);
			
			object.x = pos.x;
			object.y = pos.y;
		}
		
		/**
		 * Returns an array with the element's children or descendants (if recursive)
		 * This function catches SecurityErrors thrown when accessing objects on different sandboxes.
		 * 
		 * @param elem The element.
		 * @param recursive If true, the function continues recursively (first children then parents).
		 * @return A regular array with the children.
		 */
		public static function children(elem:DisplayObjectContainer, recursive:Boolean=false):Array {
			var list:Array = [];
			for (var i:int = 0, l:int = elem.numChildren; i < l; i++) {
				try {
					var child:DisplayObject = elem.getChildAt(i);
				} catch (err:SecurityError){
					// Ignore this item, belongs to another sandbox (like a loaded image or SWF)
				}
				
				// This is one is odd but happens every now and then, when Flash didn't initialize the item yet
				// Also counts if the catch was met
				if (!child)	continue;
				
				if (recursive && child is DisplayObjectContainer) {
					for each (var descendant:DisplayObject in children(child as DisplayObjectContainer, true)) {
						list.push(descendant);
					}
				}
				
				list.push(child);
			}
			
			return list;
		}
		
		/**
		 * Fits and aligns a DisplayObject within a certain size (could be its container)
		 * 
		 * @param elem The object
		 * @param container An optional object with width & height, if null then it's elem's parent
		 * @param move Whether to move elem according to it's scaling
		 */
		
		public static function fit(elem:DisplayObject, container:Object=null, center:Boolean=true):void {
			container = container || elem.parent;
			
			var ew:Number = elem.width;
			var eh:Number = elem.height;
			var cw:Number = container.width;
			var ch:Number = container.height;
			
			var scale:Number = Math.min(cw / ew, ch / eh);
			elem.scaleX = elem.scaleY = scale;
			
			if (center) {
				elem.x += (cw - ew * scale) / 2;
				elem.y += (ch - eh * scale) / 2;
			}
		}
		
		public static function center(target:DisplayObject, container:Object = null, relocate:Boolean = true, propToFit:String = null):void {
			container = container || target.parent;
			
			var difW:int = Math.abs(container.width - target.width); 
			var difH:int = Math.abs(container.height - target.height);
			
			if (!propToFit) {
				if (container.width > target.width || container.height > target.height) {
					propToFit = difW > difH ? "width" : "height";
				} else {
					propToFit = difW < difH ? "width" : "height";
				}
			}
			
			var scale:Number = (Math.round((container[propToFit] / target[propToFit])*100))/100;
			target.scaleX = target.scaleY = scale;
			if (relocate) {
				var recTarget:Rectangle = target.getBounds(null);
				target.x = (container.width/2) - (target.width/2) - (recTarget.left*scale);
				target.y = (container.height/2) - (target.height/2) - (recTarget.top*scale);
			}
		}
		
	}
}