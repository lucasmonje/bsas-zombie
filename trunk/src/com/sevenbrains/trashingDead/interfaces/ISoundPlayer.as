package com.sevenbrains.trashingDead.interfaces
{
	import com.sevenbrains.trashingDead.sound.Sound;
	
    public interface ISoundPlayer
    {
        function play(id:String):Sound;
        
        function stop(id:String, fadeTime:Number=0):void;
        
        function stopAll(fadeTime:Number=0):void;
        
        function has(id:String):Boolean;
    }
}