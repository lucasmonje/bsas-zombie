package com.sevenbrains.trashingDead.exception
{
	public function ASSERT(condition:Object, ...message):void {
		if (!condition) {
			var error:String = message.length ? message.join(' ') : 'Assertion Error';
			throw new Error(error);
		}
	}
}