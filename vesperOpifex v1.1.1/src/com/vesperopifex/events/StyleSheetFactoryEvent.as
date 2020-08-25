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
	import flash.text.StyleSheet;
	
	public class StyleSheetFactoryEvent extends Event 
	{
		public static const COMPLETE:String = "style_sheet_factory_complete";
		
		private var _id:String			= null;
		private var _style:StyleSheet	= null;
		
		public function get style():StyleSheet { return _style; }
		
		public function get id():String { return _id; }
		
		/**
		 * StyleSheetFactoryEvent :: Constructor.
		 * @param	type	<String>
		 * @param	bubbles	<Boolean>
		 * @param	cancelable	<Boolean>
		 */
		public function StyleSheetFactoryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, style:StyleSheet = null, id:String = null) 
		{ 
			super(type, bubbles, cancelable);
			_style	= style;
			_id		= id;
		} 
		
		/**
		 * clone :: create a clone of this event.
		 * @return	<Event>
		 */
		public override function clone():Event 
		{ 
			return new StyleSheetFactoryEvent(type, bubbles, cancelable, style, id);
		} 
		
		/**
		 * toString
		 * @return	<String>
		 */
		public override function toString():String 
		{ 
			return formatToString("StyleSheetFactoryEvent", "type", "bubbles", "cancelable", "eventPhase", "style", "id"); 
		}
		
	}
	
}