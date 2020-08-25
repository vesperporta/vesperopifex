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
	
	public class XMLCompileEvent extends Event 
	{
		public static const COMPLETE:String			= "xml_compile_complete";
		public static const COMPILE_CONTENT:String	= "compile_content";
		
		private var _data:XML						= null;
		
		public function XMLCompileEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:XML = null) 
		{
			super(type, bubbles, cancelable);
			if (data) _data = data;
		}
		
		public override function clone():Event 
		{
			return new XMLCompileEvent(type, bubbles, cancelable, _data);
		}
		
		public override function toString():String 
		{
			return formatToString("XMLCompileEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
		
		public function get data():XML { return _data; }
		
	}
	
}