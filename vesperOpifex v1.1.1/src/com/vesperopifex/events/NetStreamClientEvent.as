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
	
	public class NetStreamClientEvent extends Event 
	{
		public static const META_DATA:String		= "meta-data-retrieved";
		public static const CUE_POINT_DATA:String	= "cue-point-data-retrieved";
		
		protected var _info:Object					= null;
		
		public function get info():Object { return _info; }
		
		public function NetStreamClientEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, info:Object = null) 
		{
			super(type, bubbles, cancelable);
			_info = info;
		}
		
		public override function clone():Event 
		{ 
			return new NetStreamClientEvent(type, bubbles, cancelable, _info);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NetStreamClientEvent", "type", "bubbles", "cancelable", "eventPhase", "info"); 
		}
		
	}
	
}