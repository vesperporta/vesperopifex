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
package com.vesperopifex.display.book.utils 
{
	
	public class PageHistory extends Object 
	{
		protected static var HISTORY:Array		= new Array();
		protected static var _historyIndex:int	= 0;
		
		public function PageHistory() 
		{
			super();
		}
		
		public static function get list():Array { return HISTORY; }
		
		public static function get length():int { return HISTORY.length; }
		
		public static function get current():int { return _historyIndex; }
		
		public static function get index():Array { return HISTORY[_historyIndex]; }
		
		public static function addEntry(value:Array):int 
		{
			if (_historyIndex < HISTORY.length - 1) HISTORY	= HISTORY.splice(_historyIndex);
			HISTORY.push(value);
			_historyIndex++;
			return _historyIndex;
		}
		
		public static function clearHistory():Boolean 
		{
			HISTORY.splice(0, HISTORY.length);
			_historyIndex = HISTORY.length;
			return Boolean(HISTORY.length);
		}
		
		public static function back():Array 
		{
			if (_historyIndex - 1 > 0) _historyIndex--;
			else return null;
			return index;
		}
		
		public static function forward():Array 
		{
			if (_historyIndex + 1 < HISTORY.length) _historyIndex++;
			else return null;
			return index;
		}
		
		public static function jumpToIndex(value:int):Array 
		{
			if (value < HISTORY.length - 1) _historyIndex = value;
			else return null;
			return index;
		}
		
	}
	
}