package com.sevenbrains.trashingDead.controller
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.FrontController;
	import com.sevenbrains.trashingDead.controller.command.ToggleMusicCommand;
	import com.sevenbrains.trashingDead.controller.event.ToggleMusicEvent;
	
	public class ApplicationController extends FrontController
	{
		public function ApplicationController() {
			super();
			addCommand(ToggleMusicEvent.EVENT, ToggleMusicCommand);
		}
		
		override protected function executeCommand(event:CairngormEvent):void {
			var commandToInitialise:Class = getCommand(event.type);
			var commandToExecute:ICommand = new commandToInitialise();
			commandToExecute.execute(event);
		}
	}
}