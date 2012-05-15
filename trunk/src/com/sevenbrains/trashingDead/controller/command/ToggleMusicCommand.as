package com.sevenbrains.trashingDead.controller.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.sevenbrains.trashingDead.managers.SoundManager;
	
	public class ToggleMusicCommand implements Command {
		
		public function ToggleMusicCommand() {
			
		}
		
		public function execute(event:CairngormEvent):void {
			SoundManager.instance.musicMuted = !SoundManager.instance.musicMuted;
 		}
	}
}