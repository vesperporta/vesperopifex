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
package com.vesperopifex.utils 
{
	
	public class Queue extends Object 
	{
		protected var _queue:Array = new Array();
		protected var _current:int = 0;
		
		/**
		 * Queue :: Constructor
		 */
		public function Queue(queue:Array = null) 
		{
			if (queue) _queue = queue;
		}
		
		/**
		 * add :: add the passed object to the end of the Array
		 * @param	object	<*>	as there can be no defined states of what can be placed inside the _queue this has to be left untyped
		 */
		public function add(object:*):void { _queue.push(object); }
		
		/**
		 * next :: return the _current + 1 object in the _queue
		 * 	assigning the current position to i + 1
		 * @return	<*>
		 */
		public function get next():* { return (_current < _queue.length - 1)? _queue[++_current]: null; }
		
		/**
		 * previous :: return the _current - 1 object in the _queue
		 * 	assigning the current position to i - 1
		 * @return	<*>
		 */
		public function get previous():* { return (_current > -1)? _queue[--_current]: null; }
		
		/**
		 * current :: return the currently selected object in the _queue
		 * @return	<*>
		 */
		public function get current():* 
		{
			if (_current < 0) 
				_current	= 0;
			if (_current >= _queue.length) 
				_current	= _queue.length - 1;
			return _queue[_current];
		}
		
		
		/**
		 * last :: return the last object in the _queue
		 * @return	<*>
		 */
		public function get last():* 
		{
			if (_queue.length > 0) 
				_current	= _queue.length - 1;
			return _queue[_current];
		}
		
		/**
		 * length :: return the current length of the remaining _queue
		 * @return	<int>
		 */
		public function get length():int 
		{
			var rtn:int	= _queue.length - ((_queue.length > 0)? _current: 0);
			return rtn;
		}
		
		/**
		 * total :: return the total length of the _queue, regardless of current position
		 * @return	<int>
		 */
		public function get total():int { return _queue.length; }
		
	}
	
}