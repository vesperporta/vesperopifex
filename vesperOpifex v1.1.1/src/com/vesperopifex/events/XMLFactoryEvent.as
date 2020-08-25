﻿/**
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
	
	public class XMLFactoryEvent extends Event 
	{
		public static const DIRECTORY:String		= "xml_factory_directory";
		public static const COMPLETE:String			= "xml_factory_complete";
		public static const COMPILE:String			= "xml_factory_compile";
		
		protected var _data:XML						= null;
		protected var _url:String					= "";
		
		public function get data():XML { return _data; }
		
		public function get url():String { return _url; }
		
		public function XMLFactoryEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:XML = null, url:String = "") 
		{
			super(type, bubbles, cancelable);
			_data = data;
			_url = url;
		}
		
		public override function clone():Event 
		{
			return new XMLFactoryEvent(type, bubbles, cancelable, _data, _url);
		}
		
		public override function toString():String 
		{
			return formatToString("XMLFactoryEvent", "type", "bubbles", "cancelable", "eventPhase", "data", "url"); 
		}
		
	}
	
}