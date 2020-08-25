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
	import flash.system.LoaderContext;
	
	public class QueueLoaderObject extends Object 
	{
		private var _url:String;
		private var _context:LoaderContext;
		private var _loader:AbstractLoader;
		
		public function QueueLoaderObject(url_:String = null, loader_:AbstractLoader = null, context_:LoaderContext = null) 
		{
			super();
			if (url_ != null) _url = url_;
			if (context_ != null) _context = context_;
			if (loader_ != null) _loader = loader_;
		}
		
		public function get url():String { return _url; }
		
		public function set url(value:String):void 
		{
			_url = value;
		}
		
		public function get context():LoaderContext { return _context; }
		
		public function set context(value:LoaderContext):void 
		{
			_context = value;
		}
		
		public function get loader():AbstractLoader { return _loader; }
		
		public function set loader(value:AbstractLoader):void 
		{
			_loader = value;
		}
		
	}
	
}