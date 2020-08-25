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
	import com.vesperopifex.events.LoadFactoryEvent;
	import com.vesperopifex.utils.AbstractLoader;
	import flash.events.Event;
	
	public class GraphicFactoryEvent extends LoadFactoryEvent 
	{
		public static const NEW_FILE:String		= "graphic_factory_new_file";
		public static const COMPLETE:String		= "graphic_factory_complete";
		public static const FINISHED:String		= "graphic_factory_finished";
		public static const ERROR:String		= "graphic_factory_error";
		public static const FATAL_ERROR:String	= "graphic_factory_fatal_error";
		
		private var _dataURL:String	= null;
		
		public function GraphicFactoryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, loader:AbstractLoader = null, url:String = "", dataURL:String = null) 
		{
			super(type, bubbles, cancelable, loader, url);
			if (dataURL) _dataURL = dataURL;
		} 
		
		public override function clone():Event 
		{ 
			return new GraphicFactoryEvent(type, bubbles, cancelable, _loader, _url, _data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GraphicFactoryEvent", "type", "bubbles", "cancelable", "eventPhase", "loader", "url", "data");
		}
		
		public function get dataURL():String { return _dataURL; }
		
	}
	
}