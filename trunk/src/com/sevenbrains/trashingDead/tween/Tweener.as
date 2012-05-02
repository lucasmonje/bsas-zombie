package com.sevenbrains.trashingDead.tween
{
    import flash.display.*;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    /**
     * Se implementa practicamente como el TweenLite, la unica diferencia es como se setea el ease.
     * Tweens.to(popup, 0.5, {scaleX:0, scaleY:0, onComplete:afterPopupIsRemoved, onCompleteParams:[popup]}); // por defecto el ease es LINEAR.
     * Tweens.from(view, 0.5, {scaleX:0, scaleY:0, ease:Tweens.EASE_OUT_EXPO, onComplete:popup.isShowing});
     * 
     * @author Lucas Monje
     */	
    public class Tweener {
        
        public static const LINEAR:String = "linear";
        
        public static const EASE_IN_QUAD:String = "easeInQuad";
        public static const EASE_OUT_QUAD:String = "easeOutQuad";
        public static const EASE_IN_OUT_QUAD:String = "easeInOutQuad";
        
        public static const EASE_IN_BACK:String = "easeInBack";
        public static const EASE_OUT_BACK:String = "easeOutBack";
        public static const EASE_IN_OUT_BACK:String = "easeInOutBack";
        
        public static const EASE_IN_EXPO:String = "easeInExpo";
        public static const EASE_OUT_EXPO:String = "easeOutExpo";
        public static const EASE_IN_OUT_EXPO:String = "easeInOutExpo";
        
        public static const EASE_IN_BOUNCE:String = "easeInBounce";
        public static const EASE_OUT_BOUNCE:String = "easeOutBounce";
        public static const EASE_IN_OUT_BOUNCE:String = "easeInOutBounce";
        
        private static const CLASS_PARAMS:Array = [
            "delay",
            "ease",
            "onComplete",
            "onCompleteParams",
            "onUpdate",
            "onUpdateParams"
        ];
        
        private static var _easingInitied:Boolean;
        private static var _inited:Boolean;
        private static var _mc:MovieClip;
        private static var _currentTime:Number;		
        private static var _tweenList:Vector.<TweenProperties>;
        private static var _easeMap:Dictionary;
        
        private static function tweensOf(target:Object):Array {
            var tweens:Array = [];
            if (!Boolean(_tweenList)) return tweens;
            for (var i:uint = 0; i < _tweenList.length; i++) {
                var tweening:TweenProperties = _tweenList[i] as TweenProperties;
                if (tweening == null || !Boolean(tweening.target)) continue;
                if (tweening.target == target) {
                    tweens.push(tweening);
                }
            }
            return tweens;
        }
        
        public static function killTweensOf(target:Object):Boolean {
            var tweens:Array = tweensOf(target);
            if (!Boolean(tweens) || tweens.length == 0) return false;
            for (var i:uint = 0; i < tweens.length; i++) {
                var tweening:TweenProperties = tweens[i] as TweenProperties;
                _tweenList.splice(_tweenList.indexOf(tweening), 1);
            }
            return true;
        }
        
        public static function pauseTweensOf(target:Object):void {
            var tweens:Array = tweensOf(target);
            for (var i:uint = 0; i < tweens.length; i++) {
                tweens[i].paused = true;
            }
        }
        public static function resumeTweensOf(target:Object):void {
            var tweens:Array = tweensOf(target);
            for (var i:uint = 0; i < tweens.length; i++) {
                tweens[i].paused = false;
            }
        }
        
        public static function to(target:Object, time:Number = 0, parameters:Object = null):Boolean {
            return addTween(target, time, parameters, "to");
        }
        
        public static function from(target:Object, time:Number = 0, parameters:Object = null):Boolean {
            return addTween(target, time, parameters, "from");
        }
        
        public static function isTweening(target:Object):Boolean {
            if (!Boolean(_tweenList))return false;
            for each (var tweening:TweenProperties in _tweenList) {
                if (tweening == null || !Boolean(tweening.target)) return false;
                if (tweening.target == target) {
                    return true;
                }
            }
            return false;
        }
        
        private static function addTween(target:Object, time:Number = 0, params:Object = null, type:String = ""): Boolean {
            if (!target || !params || type == "") return false;
            if (!_easingInitied) setTransitions();
            if (!_inited || !Boolean(_mc))init();
            
            var props:Array = []; 
            for (var prop:String in params) {
                if (CLASS_PARAMS.indexOf(prop) == -1) {
                    props[prop] = params[prop];
                } 
            }
            _currentTime = getTimer(); 
            var delay:Number = (isNaN(params.delay) ? 0 : params.delay);
            var ease:Function = (Boolean(params.ease) && params.ease is String) ? _easeMap[params.ease] : _easeMap[LINEAR];
            var newTween:TweenProperties = new TweenProperties (target, _currentTime + ((delay * 1000)),_currentTime + (((delay * 1000) + (time * 1000))), ease, type);
            newTween.onComplete = params.onComplete;
            newTween.onCompleteParams = params.onCompleteParams;
            newTween.onUpdate = params.onUpdate;
            newTween.onUpdateParams = params.onUpdateParams;
            for (prop in props) {
                if (type == "to") {
                    newTween.propsMap[prop] = new ValueProperties(target[prop], props[prop]);
                } else if (type == "from") {
                    newTween.propsMap[prop] = new ValueProperties(props[prop], target[prop]);
                    target[prop] = props[prop];
                }
            }
            _tweenList.push(newTween);
            return true;
        }
        
        private static function setTransitions():void {
            _easingInitied = true;
            _easeMap = new Dictionary();
            _easeMap[LINEAR] = easeNone;
            
            _easeMap[EASE_IN_QUAD] = easeInQuad;
            _easeMap[EASE_OUT_QUAD] = easeOutQuad;
            _easeMap[EASE_IN_OUT_QUAD] = easeInOutQuad;
            
            _easeMap[EASE_IN_EXPO] = easeInExpo;
            _easeMap[EASE_OUT_EXPO] = easeOutExpo;
            _easeMap[EASE_IN_OUT_EXPO] = easeInOutExpo;
            
            _easeMap[EASE_IN_BACK] = easeInBack;
            _easeMap[EASE_OUT_BACK] = easeOutBack;
            _easeMap[EASE_IN_OUT_BACK] = easeInOutBack;
            
            _easeMap[EASE_IN_BOUNCE] = easeInBounce;
            _easeMap[EASE_OUT_BOUNCE] = easeOutBounce;
            _easeMap[EASE_IN_OUT_BOUNCE] = easeInOutBounce;
        }
        
        private static function init():void 
        {
            _inited = true;
            _tweenList = new Vector.<TweenProperties>();
            _mc = new MovieClip();
            _mc.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private static function onEnterFrame(e:Event):void 
        {
            var lastTime:Number = _currentTime;
            _currentTime = getTimer();
            var delta:Number = _currentTime - lastTime;
            for (var i:uint = 0; i < _tweenList.length; i++) {
                if (_tweenList[i].paused) {
                    _tweenList[i].pausedTime += delta;
                } else if (!updateTween(i)) {
                    _tweenList[i] = null;
                    _tweenList.splice(i, 1);
                    i--;
                }
            }
            if (_tweenList.length == 0) destroy();
        }
        
        private static function updateTween(index:uint):Boolean {
            
            var tweening:TweenProperties = _tweenList[index] as TweenProperties;
            if (tweening == null || !Boolean(tweening.target)) return false;
            
            var isOver:Boolean = false;		
            var propName:String;
            
            if (_currentTime >= (tweening.timeStart + tweening.pausedTime)) {
                if (_currentTime >= (tweening.timeComplete + tweening.pausedTime)) isOver = true;
                
                if (!tweening.hasStarted) {
                    var pv:Number;
                    for (propName in tweening.propsMap) {
                        pv = tweening.target[propName];
                        tweening.propsMap[propName].valueStart = isNaN(pv) ? tweening.propsMap[propName].valueComplete : pv;
                    }
                    tweening.hasStarted = true;
                }
                
                for (propName in tweening.propsMap) {
                    var valueProps:ValueProperties = tweening.propsMap[propName] as ValueProperties;
                    var newValue:Number;
                    if (isOver) {
                        newValue = valueProps.valueComplete;
                    } else {
                        var currentTime:Number = _currentTime - (tweening.timeStart + tweening.pausedTime);
                        var beginningValue:Number = valueProps.valueStart;
                        var changeInValue:Number = valueProps.valueComplete - valueProps.valueStart;
                        var duration:Number = tweening.timeComplete - tweening.timeStart;
                        newValue = tweening.ease(currentTime, beginningValue, changeInValue, duration);
                    }
                    tweening.target[propName] = newValue;
                }
                
                if (isOver) {
                    tweening.onComplete && tweening.onComplete.apply(tweening.target, tweening.onCompleteParams);
                } else {
                    tweening.onUpdate && tweening.onUpdate.apply(tweening.target, tweening.onUpdateParams);
                }
                return (!isOver);
            }
            return (true);
        }
        
        public static function destroy():void {
            _tweenList = null;
            _currentTime = 0;
            _mc.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            _mc = null;
        }
        
        private static function easeNone(t:Number, b:Number, c:Number, d:Number):Number {
            return c*t/d + b;
        }
        
        private static function easeInQuad(t:Number, b:Number, c:Number, d:Number):Number {
            return c*(t/=d)*t + b;
        }
        
        private static function easeOutQuad(t:Number, b:Number, c:Number, d:Number):Number {
            return -c *(t/=d)*(t-2) + b;
        }
        
        private static function easeInOutQuad(t:Number, b:Number, c:Number, d:Number):Number {
            if ((t/=d/2) < 1) return c/2*t*t + b;
            return -c/2 * ((--t)*(t-2) - 1) + b;
        }
        
        private static function easeInExpo(t:Number, b:Number, c:Number, d:Number):Number {
            return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b - c * 0.001;
        }
        
        private static function easeOutExpo(t:Number, b:Number, c:Number, d:Number):Number {
            return (t==d) ? b+c : c * 1.001 * (-Math.pow(2, -10 * t/d) + 1) + b;
        }
        
        private static function easeInOutExpo(t:Number, b:Number, c:Number, d:Number):Number {
            if (t==0) return b;
            if (t==d) return b+c;
            if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b - c * 0.0005;
            return c/2 * 1.0005 * (-Math.pow(2, -10 * --t) + 2) + b;
        }
        
        private static function easeOutInExpo(t:Number, b:Number, c:Number, d:Number):Number {
            if (t < d/2) return easeOutExpo (t*2, b, c/2, d);
            return easeInExpo((t*2)-d, b+c/2, c/2, d);
        }
        
        public static function easeInBack (t:Number, b:Number, c:Number, d:Number):Number {
            var s:Number = 1.70158;
            return c*(t/=d)*t*((s+1)*t - s) + b;
        }
        
        public static function easeOutBack (t:Number, b:Number, c:Number, d:Number):Number {
            var s:Number = 1.70158;
            return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
        }
        
        public static function easeInOutBack (t:Number, b:Number, c:Number, d:Number):Number {
            var s:Number = 1.70158;
            if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
            return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
        }
        
        
        //BOUNCE
        public static function easeInBounce (t:Number, b:Number, c:Number, d:Number):Number {
            return c - easeOutBounce (d-t, 0, c, d) + b;
        };
        
        
        public static function easeOutBounce  (t:Number, b:Number, c:Number, d:Number):Number {
            if ((t/=d) < (1/2.75)) {
                return c*(7.5625*t*t) + b;
            } else if (t < (2/2.75)) {
                return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
            } else if (t < (2.5/2.75)) {
                return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
            } else {
                return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
            }
        };
        
        // bounce easing in/out
        public static  function easeInOutBounce(t:Number, b:Number, c:Number, d:Number):Number {
            if (t < d/2) return easeInBounce (t*2, 0, c, d) * .5 + b;
            return easeOutBounce (t*2-d, 0, c, d) * .5 + c*.5 + b;
        };
    }
}

import flash.utils.Dictionary;
internal class TweenProperties {
    
    public var target:Object;
    public var propsMap:Dictionary;
    public var timeStart:Number;
    public var timeComplete:Number;
    public var ease:Function;
    public var type:String;
    public var onComplete:Function;
    public var onCompleteParams:Array;
    public var onUpdate:Function;
    public var onUpdateParams:Array;
    public var hasStarted:Boolean;
    public var paused:Boolean;
    public var pausedTime:Number;
    
    function TweenProperties(target:Object, timeStart:Number, timeComplete:Number, ease:Function, type:String = "") {
        this.target = target;
        this.timeStart = timeStart;
        this.timeComplete =	timeComplete;
        this.ease = ease;
        this.type = type;
        this.propsMap = new Dictionary();
        this.hasStarted = false;
        this.paused = false;
        this.pausedTime = 0;
    }
}

internal class ValueProperties {
    
    public var valueStart:Number;
    public var valueComplete:Number;
    
    function ValueProperties(valueStart:Number, valueComplete:Number) {
        this.valueStart = valueStart;
        this.valueComplete = valueComplete;
    }
}