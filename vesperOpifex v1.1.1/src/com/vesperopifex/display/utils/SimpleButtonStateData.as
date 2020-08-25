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
package com.vesperopifex.display.utils 
{
	
	public class SimpleButtonStateData extends Object 
	{
		public static const UP:String			= "up";
		public static const OVER:String			= "over";
		public static const DOWN:String			= "down";
		public static const HIT_TEST:String		= "hit_test";
		public static const ALL:String			= "all";
		
		protected var _upData:Array			= new Array();
		protected var _overData:Array		= new Array();
		protected var _downData:Array		= new Array();
		protected var _hitTestData:Array	= new Array();
		
		public function get upData():Array { return _upData; }
		public function set upData(value:Array):void 
		{
			_upData = value;
		}
		
		public function get overData():Array { return _overData; }
		public function set overData(value:Array):void 
		{
			_overData = value;
		}
		
		public function get downData():Array { return _downData; }
		public function set downData(value:Array):void 
		{
			_downData = value;
		}
		
		public function get hitTestData():Array { return _hitTestData; }
		public function set hitTestData(value:Array):void 
		{
			_hitTestData = value;
		}
		
		public function SimpleButtonStateData() 
		{
			
		}
		
		public function clear():void 
		{
			_upData			= new Array();
			_overData		= new Array();
			_downData		= new Array();
			_hitTestData	= new Array();
		}
		
	}
	
}