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
	import flash.display.DisplayObject;
	
	public class EventContext extends Object 
	{
		private var _name:String				= null;
		private var _context:String				= null;
		private var _action:String				= null;
		private var _displayChild:DisplayObject	= null;
		private var _event:String				= null;
		
		public function get name():String { return _name; }
		
		public function get context():String { return _context; }
		
		public function get action():String { return _action; }
		
		public function get displayChild():DisplayObject { return _displayChild; }
		
		public function get event():String { return _event; }
		
		public function EventContext(name:String, context:String, action:String, object:DisplayObject, event:String) 
		{
			_name			= name;
			_context		= context;
			_action			= action;
			_displayChild	= object;
			_event			= event;
		}
		
		public function toString():String 
		{
			return "[EventContext name=" + name + " context=" + context + " action=" + action + " displayChild=" + displayChild + " event=" + event + "]"; 
		}
		
	}
	
}