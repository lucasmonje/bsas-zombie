//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.utils {
	
	import flash.utils.getTimer;
	
	public class DateUtils {
		
		public static var DAY:Number = 24 * HOUR;
		public static var HOUR:Number = 60 * MINUTE;
		public static var MINUTE:Number = 60 * SECOND;
		public static var SECOND:Number = 1000;
		
		public static const dateSeparator:String = "/";
		
		public static function formatTimeNumber(time:Number, decimals:uint = 1):String {
			return time.toFixed(decimals).replace('.0', '');
		}
		
		public static function fromMilliseconds(value:Number):Date {
			var result:Date = new Date(value);
			return result;
		}
		
		/**
		 * Receive an String dd/mm/yyyy HH:MM
		 * @param value
		 * @return Date
		 *
		 */
		public static function fromString(value:String, timeZoneOffset:int, dateSeparator:String = '/'):Date {
			var result:Date = new Date(0);
			
			if (!value)
				return result;
			
			var aux:Array = value.split(" ");
			var fisrtPart:String = aux[0];
			var secondPart:String = aux[1];
			
			if (fisrtPart.indexOf(dateSeparator) > -1) {
				stringToDMYDate(fisrtPart, result);
				stringToHMSDate(secondPart, timeZoneOffset, result);
			} else {
				stringToHMSDate(fisrtPart, timeZoneOffset, result);
			}
			
			return result;
		}
		
		public static function getFirstTimeOfDay(date:Date):Date {
			var first:Date = new Date(date.time);
			first.setHours(0, 0, 0, 0);
			return first;
		}
		
		public static function getIntervalDistance(date1:Number, date2:Number, intervalSize:Number, gmtOffset:Number = 0):int {
			gmtOffset *= HOUR;
			return Math.floor(Math.floor((date2 + gmtOffset) / intervalSize) - Math.floor((date1 + gmtOffset) / intervalSize));
		}
		
		public static function getLastTimeOfDay(date:Date):Date {
			var last:Date = new Date(date.time);
			last.setHours(23, 59, 59, 999);
			return last;
		}
		
		public static function isBetween(date:Date, from:Date, to:Date):Boolean {
			from = getFirstTimeOfDay(from);
			to = getLastTimeOfDay(to);
			return date.time >= from.time && date.time <= to.time;
		}
		
		public static function isToday(date:Date):Boolean {
			var now:Date = now();
			
			return isBetween(date, getFirstTimeOfDay(now), getLastTimeOfDay(now));
		}
		
		public static function isYesterday(date:Date):Boolean {
			var now:Date = now();
			
			var yesterday:Date = new Date(now.time);
			yesterday.setDate(now.date - 1);
			
			return isBetween(date, getFirstTimeOfDay(yesterday), getLastTimeOfDay(yesterday));
		}
		
		public static function now():Date {
			return new Date(getTimer());
		}
		
		/**
		 * Convert millis a minutes:seconds string format.
		 * @param millis to convert
		 */
		public static function parseHMS(millis:uint):Array {
			var seconds:uint = millis / 1000;
			var secs:uint = seconds % 60;
			var minutes:uint = (seconds - secs) / 60;
			var mins:uint = minutes % 60;
			var hs:uint = (minutes - mins) / 60;
			
			return [hs, mins, secs];
		}
		
		/**
		 * Convert millis a hours:minutes:seconds string format.
		 * @param millis to convert
		 */
		public static function toHMS(millis:uint):String {
			return formatArray(parseHMS(millis));
		}
		
		/**
		 * Convert millis a minutes:seconds string format.
		 * @param millis to convert
		 */
		public static function toMS(millis:uint):String {
			var parts:Array = parseHMS(millis);
			var min:int = parts.shift() * 60;
			parts[0] += min;
			
			return formatArray(parts);
		}
		
		private static function formatArray(arr:Array):String {
			for (var i:int = 0; i < arr.length; i++) {
				arr[i] = StringUtil.pad(arr[i]);
			}
			return arr.join(':')
		}
		
		private static function stringToDMYDate(value:String, out:Date):void {
			//dd/mm/yyyy
			var aux:Array = value.split(dateSeparator);
			var day:Number = parseInt(aux[0], 10);
			var month:Number = parseInt(aux[1], 10) - 1;
			var year:Number = parseInt(aux[2], 10);
			
			out.setUTCFullYear(year, month, day);
		}
		
		private static function stringToHMSDate(value:String, timeZoneOffset:int, date:Date):void {
			var aux:Array = value ? value.split(":") : ["0"];
			
			var hours:Number = parseInt(aux[0], 10) - (timeZoneOffset / HOUR);
			var minutes:Number = parseInt(aux[1], 10) || 0;
			var seconds:Number = parseInt(aux[2], 10) || 0;
			
			date.setUTCHours(hours, minutes, seconds);
		}
	}
}