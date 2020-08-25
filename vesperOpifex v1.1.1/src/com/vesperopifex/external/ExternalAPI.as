/**
 * @author:		Laurence Green
 * @email:		contact@laurencegreen.com
 * @www:		http://www.laurencegreen.com/
 * @code:		http://vesper-opifex.googlecode.com/
 * @blog:		http://vesperopifex.blogspot.com/
 * 
The MIT License

Copyright (c) 2008-2009 Laurence Green

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */
package com.vesperopifex.external 
{
	import com.vesperopifex.utils.QueueFIFO;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	public class ExternalAPI extends Object 
	{
		private static const TYPE_CALLBACK:String 	= "callback";
		private static const TYPE_CALL:String 		= "call";
		private static const CALL_INTERVAL:uint		= 100;
		
		private static var _queue:QueueFIFO = new QueueFIFO();
		private static var _timer:Timer = new Timer(CALL_INTERVAL);
		
		/**
		 * Indicates whether this player is in a container that offers an external interface.
		 *  If the external interface is available, this property is true; otherwise,
		 *  it is false.
		 */
		public static function get available():Boolean { return ExternalInterface.available; }
		
		/**
		 * Indicates whether the external interface should attempt to pass ActionScript exceptions to the
		 *  current browser and JavaScript exceptions to Flash Player. You must explicitly set this property
		 *  to true to catch JavaScript exceptions in ActionScript and to catch ActionScript exceptions
		 *  in JavaScript.
		 */
		private static var _marshallExceptions:Boolean = false;
		
		static public function get marshallExceptions():Boolean { return ExternalInterface.marshallExceptions; }
		
		static public function set marshallExceptions(value:Boolean):void 
		{
			ExternalInterface.marshallExceptions = value;
		}
		
		/**
		 * Constructor
		 * 	applies the event handlers to the Timer event
		 */
		public function ExternalAPI() 
		{
			super();
			_timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
		}
		
		/**
		 * Returns the id attribute of the object tag in Internet Explorer,
		 *  or the name attribute of the embed tag in Netscape.
		 */
		public static function get objectID():String { return ExternalInterface.objectID; }
		
		/**
		 * Queue up the addCallback to wait in turn until an available time is reached.
		 * @param	functionName	<String> value of teh JavaScript function available to the flash player
		 * @param	closure			<Function> Once a reply has been recieved this function will be called with any paramaters passed back from the JavaScript.
		 */
		public static function addCallback(functionName:String, closure:Function):void 
		{
			_queue.add( { type: TYPE_CALLBACK, functionName: functionName, closure: closure } );
			if (_timer.currentCount == 0) _timer.start();
		}
		
		/**
		 * Queue up the call to wait in turn until an available time is reached.
		 * @param	functionName	<String> value of teh JavaScript function available to the flash player
		 * @param	... arguments	<Array> Any number of arguments to pass to the JavaScript function.
		 */
		public static function call(functionName:String, ... arguments):void 
		{
			_queue.add( { type: TYPE_CALL, functionName: functionName, arguments: arguments } );
			if (_timer.currentCount == 0) _timer.start();
		}
		
		/**
		 * Called every timed interval defined by CALL_INTERVAL, to take the next available call to the javascript API
		 * @param	event	<TimerEvent>
		 */
		private static function timerEventHandler(event:TimerEvent):void 
		{
			var obj:Object = _queue.next;
			
			switch (obj.type) 
			{
				case TYPE_CALLBACK:
					ExternalInterface.addCallback(obj.functionName, obj.closure);
					break;
				case TYPE_CALL:
					ExternalInterface.call(obj.functionName, obj.arguments);
					break;
			}
			
			if (_queue.length == 0) _timer.reset();
		}
		
	}
	
}