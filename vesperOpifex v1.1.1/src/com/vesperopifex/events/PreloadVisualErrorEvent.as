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
package com.vesperopifex.events 
{
	import flash.events.Event;
	
	public class PreloadVisualErrorEvent extends Event 
	{
		public static const SCOPE:String	= "preload_visual_error";
		
		private var _value:Number			= NaN;
		
		public function PreloadVisualErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, value:Number = 0) 
		{ 
			super(type, bubbles, cancelable);
			if (value) _value = value;
		} 
		
		public override function clone():Event 
		{ 
			return new PreloadVisualErrorEvent(type, bubbles, cancelable, _value);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PreloadVisualErrorEvent", "type", "bubbles", "cancelable", "eventPhase", "value"); 
		}
		
		public function get value():Number { return _value; }
		
	}
	
}