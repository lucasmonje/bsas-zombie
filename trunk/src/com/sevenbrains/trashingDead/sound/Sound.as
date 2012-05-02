package com.sevenbrains.trashingDead.sound
{
    import com.sevenbrains.trashingDead.tween.Tweener;
    import com.sevenbrains.trashingDead.interfaces.Destroyable;
    import com.sevenbrains.trashingDead.managers.VersionManager;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;
    
    /**
     * Dispatched when the sound has finished playing. 
     */
    [Event(name="soundComplete", type="flash.events.Event")]
    
    /**
     * Dispatched when the sound was muted or unmuted. 
     */
    [Event(name="change", type="flash.events.Event")]
    
    /**
     * Dispatched when the loading of the sound has completed. 
     */
    [Event(name="complete", type="flash.events.Event")]
    
    /**
     * Dispatched when the loading of the sound has encountered problem.
     */
    [Event(name="ioError", type="flash.events.IOErrorEvent")]
    
    public class Sound implements IEventDispatcher, Destroyable
    {
        // Time offset (in miliseconds) to fix the gap at the beginning of the MP3 track
        static internal const OFFSET_MSEC:int = 60;
        
        private var _dispatcher:EventDispatcher;
        
        private var _sound:flash.media.Sound;
        
        private var _id:String;
        private var _path:String;
        private var _loops:int;
        private var _stream:Boolean;
        
        private var _loaded:Boolean;
        private var _startedToLoad:Boolean;
        private var _channel:SoundChannel;
        private var _muted:Boolean;
        
        private var _destroyed:Boolean = false;
        
        public function Sound(id:String, path:String, loops:int = 0, stream:Boolean = false)
        {
            _dispatcher = new EventDispatcher(this);
            _sound = new flash.media.Sound();
            
            _id = id;
            _path = path;
            _loops = loops;
            _stream = stream;
            
            init();
        }
        
        public function isDestroyed():Boolean
        {
            return _destroyed;
        }
        
        public function get id():String
        {
            return _id;
        }
        
        public function get loops():int
        {
            return _loops;
        }
        
        public function get playing():Boolean
        {
            return _channel != null;
        }
        
        public function get muted():Boolean
        {
            return _muted;
        }
        
        public function set muted(value:Boolean):void
        {
            var lastMute:Boolean = _muted;
            _muted = value;
            
            if (_muted) {
                _channel && (_channel.soundTransform = new SoundTransform(0, _channel.soundTransform.pan));
            } else {
                _channel && (_channel.soundTransform = new SoundTransform(1, _channel.soundTransform.pan));
            }
            
            if (lastMute != _muted) {
                dispatchEvent(new Event(Event.CHANGE));
            }
        }
        
        public function play():void
        {
            if (!_loaded && !_startedToLoad) {
                load(_path);
            }
            
            if (_channel) {
                stopChannel();
            }
            
            _channel = _sound.play((_loops > 0 ? OFFSET_MSEC : 0), _loops);
            
            if (_channel) {
                _channel.soundTransform = new SoundTransform((_muted ? 0 : 1));
                _channel.addEventListener(Event.SOUND_COMPLETE, onSoundChannelComplete);
            }
        }
        
        public function stop(fadeTime:Number = 0):void
        {
            if (playing) {
                if (fadeTime) {
                    fade(0, fadeTime);
                } else {
                    stopChannel();
                }
            }
        }
        
        public function fade(finalVolume:Number, time:Number):void
        {
            if (_channel && _channel.soundTransform) {
                Tweener.to(
                    new ChannelTransformation(_channel),
                    time,
                    {
                        volume: finalVolume,
                        onComplete: stopIfNoVolume
                    }
                );
            }
        }
        
        public function setPan(pan:Number, fadeTime:Number = 0):void
        {
            if (playing) {
                var st:SoundTransform = (_channel ? _channel.soundTransform : null);
                if (fadeTime && st) {
                    Tweener.to(new ChannelTransformation(_channel), fadeTime, {pan: pan});
                } else {
                    _channel.soundTransform = new SoundTransform(st.volume, pan);
                }
            }
        }
        
        public function destroy():void
        {
            _sound = null;
            _dispatcher = null;
            _channel = null;
            
            _destroyed = true;
        }
        
        private function init():void
        {
            _sound.addEventListener(Event.COMPLETE, onSoundLoaded);
            _sound.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
            
            if (_stream) {
                load(_path);
            }
        }
        
        private function onSoundLoaded(event:Event):void
        {
            _loaded = true;
            dispatchEvent(event);
        }
        
        private function onIOErrorEvent(event:IOErrorEvent):void
        {
            // TODO: log error
            dispatchEvent(event);
        }
        
        private function onSoundChannelComplete(event:Event):void
        {
            stopChannel();
        }
        
        private function stopIfNoVolume():void
        {
            if (playing && !_muted && _channel.soundTransform && !_channel.soundTransform.volume) {
                stopChannel();
            }
        }
        
        private function stopChannel():void
        {
            if (_channel) {
                _channel.stop();
                _channel.removeEventListener(Event.SOUND_COMPLETE, onSoundChannelComplete);
                _channel = null;
            }
            
            dispatchEvent(new Event(Event.SOUND_COMPLETE));
        }
        
        private function load(path:String):void
        {
            path = VersionManager.getUrl(path);
            _sound.load(new URLRequest(path));
            _startedToLoad = true;
        }
        
        // -- IEventDispatcher | begin -- //
        public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void { _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference); }
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void { _dispatcher.removeEventListener(type, listener, useCapture); }
        public function dispatchEvent(event:Event):Boolean { return _dispatcher.dispatchEvent(event); }
        public function hasEventListener(type:String):Boolean { return _dispatcher.hasEventListener(type); }
        public function willTrigger(type:String):Boolean { return _dispatcher.willTrigger(type); }
        // -- IEventDispatcher | end -- //
    }
}
import flash.media.SoundChannel;
import flash.media.SoundTransform;

class ChannelTransformation
{
    private var _channel:SoundChannel;
    
    public function ChannelTransformation(channel:SoundChannel)
    {
        _channel = channel;
    }
    
    public function set volume(value:Number):void { _channel.soundTransform = new SoundTransform(value, pan); }
    public function get volume():Number { return _channel.soundTransform.volume; }
    
    public function set pan(value:Number):void { _channel.soundTransform = new SoundTransform(volume, value); }
    public function get pan():Number { return _channel.soundTransform.pan; }
}