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
package com.vesperopifex.audio 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	public class AudioLoader extends Sound 
	{
		protected var _loaderContext:SoundLoaderContext	= null;
		protected var _storedURL:String					= null;
		protected var _loadComplete:Boolean				= false;
		
		public function get storedURL():String { return _storedURL; }
		public function set storedURL(value:String):void 
		{
			_storedURL = value;
		}
		
		public function get loaderContext():SoundLoaderContext { return _loaderContext; }
		public function set loaderContext(value:SoundLoaderContext):void 
		{
			_loaderContext = value;
		}
		
		public function get loadComplete():Boolean { return _loadComplete; }
		
		public function AudioLoader(stream:URLRequest = null, context:SoundLoaderContext = null) 
		{
			if (stream) 
				_storedURL	= stream.url;
			_loaderContext	= context;
			super(stream, context);
			addEventListener(Event.COMPLETE, completeEventHandler);
		}
		
		protected function completeEventHandler(event:Event):void 
		{
			_loadComplete	= true;
		}
		
	}
	
}