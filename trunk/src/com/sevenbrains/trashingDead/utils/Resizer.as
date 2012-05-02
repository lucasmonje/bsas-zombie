package commons.utils
{
	import flash.display.DisplayObject;

	/**
	 *	The function of this class is brinadar resize utility. 
	 * 	This works by passing 2 instances of DisplayObject, one that works as a size reference and the second as target of change. 
	 * @author acan
	 * @code
	 * 		var back:DisplayObject; //target of the resize
	 * 		var content:DsiplayObject; // reference of the resize
	 * 		var resizer : Resizer = new Resizer();
	 * 		resizer.setup (back, content); 
	 * 		resizer.resize();
	 * 
	 */	
	public class Resizer
	{
		private var leftMargin:int;
		private var rightMargin:int;
		private var bottomMargin:int;
		private var topMargin:int;
		
		private var target:DisplayObject;
		private var reference:DisplayObject;
		
		
		
		public function Resizer()
		{
		}
		
		/**
		 * Sets the DisplayObject that will participate resize mechanism.
		 * Keep in mind that the configuration will consider the position of the two DisplayObject and margins on all four sides.
		 * 
		 * @param target DisplayObject instance to be the target of the resize.
		 * @param reference DisplayObject instance to be the refernece of the resize.
		 * 
		 */		
		public function setup(target:DisplayObject, reference:DisplayObject):void
		{
			this.target = target;
			this.reference = reference;
			setupMargin();
		}
		
		/**
		 *Ejecuta la acción de resize 
		 */		
		public function resize():void
		{			
			if(target && reference){
				target.width =  Math.ceil(reference.width) + rightMargin + leftMargin;  
				target.height = Math.ceil(reference.height) + bottomMargin + topMargin;
			}
		}
		
		/**
		 *Set the margins of having as protagonists the DisplayObject reference and target. 
		 */		
		private function setupMargin():void
		{
			if(target && reference){
				leftMargin =  reference.x - target.x ;
				leftMargin = (leftMargin < 0) ? -leftMargin : leftMargin;
				
				rightMargin = Math.ceil(reference.x + reference.width) - Math.ceil(target.x + target.width);
				rightMargin = (rightMargin < 0) ? -rightMargin : rightMargin;
			
				bottomMargin = Math.ceil(target.y + target.height) - Math.ceil(reference.y + reference.height);
				bottomMargin = (bottomMargin < 0) ? -bottomMargin : bottomMargin;
				
				topMargin =  reference.y - target.y ;
				bottomMargin = (topMargin < 0) ? -topMargin : topMargin;
			}
		}
		
	}
}