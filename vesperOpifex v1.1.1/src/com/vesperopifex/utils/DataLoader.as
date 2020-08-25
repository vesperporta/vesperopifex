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
	import com.vesperopifex.events.IOErrorEventEx;
	import com.vesperopifex.events.SecurityErrorEventEx;
	import com.vesperopifex.utils.MinimumPlayerVersion;
	import com.vesperopifex.utils.PlayerVersionObject;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class DataLoader extends AbstractLoader 
	{
		public static const FILE_TYPE:Object = 
		{
			xml: new PlayerVersionObject("xml"),
			rss: new PlayerVersionObject("rss"),
			css: new PlayerVersionObject("css"),
			txt: new PlayerVersionObject("txt"), 
			html: new PlayerVersionObject("html")
		};
		
		public override function get bytesLoaded():uint { return _URLLoader.bytesLoaded; }
		
		public override function get bytesTotal():uint { return _URLLoader.bytesTotal; }
		
		public override function get data():* { return _URLLoader.data; }
		
		public override function get dataFormat():String { return _URLLoader.dataFormat; }
		
		public override function set dataFormat(value:String):void 
		{
			_URLLoader.dataFormat = value;
		}
		
		/**
		 * DataLoader :: Constructor.
		 * @param	request	<URLRequest>	the URL to load the data from.
		 */
		public function DataLoader(request:URLRequest = null) 
		{
			super(request);
			if (request) _URLLoader.load(request);
			_URLLoader.addEventListener(Event.COMPLETE, loaderCompleteInternalHandler);
		}
		
		/**
		 * load :: download the URLRequest passed in with the optional LoaderContext which is not required for pure data retrieval.
		 * @param	request	<URLRequest>	the URL to load the data from.
		 * @param	context	<LoaderContext>	pass this only for SWF files, it is unrequired for data files.
		 */
		public override function load(request:URLRequest, context:LoaderContext = null):void 
		{
			_URLLoader.load(request);
			super.load(request);
		}
		
		/**
		 * close :: close the connection downloading the data and remove any data already loaded.
		 */
		public override function close():void 
		{
			_URLLoader.close();
		}
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			switch (type) 
			{
				
				case Event.COMPLETE:
					_URLLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
					break;
					
				case ProgressEvent.PROGRESS:
					_URLLoader.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
					break;
					
				case HTTPStatusEvent.HTTP_STATUS:
					_URLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
					break;
					
				case IOErrorEvent.IO_ERROR:
					_URLLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					break;
					
				case Event.OPEN:
					_URLLoader.addEventListener(Event.OPEN, openHandler);
					break;
					
				case SecurityErrorEvent.SECURITY_ERROR:
					_URLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					break;
					
				default:
					return;
					
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR, false, false, event.text));
		}
		
		private function openHandler(event:Event):void 
		{
			dispatchEvent(new Event(Event.OPEN));
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void 
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, event.text));
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void 
		{
			dispatchEvent(new HTTPStatusEvent(HTTPStatusEvent.HTTP_STATUS, false, false, event.status));
		}
		
		private function loaderProgressHandler(event:ProgressEvent):void 
		{
			_bytesLoaded	= event.bytesLoaded;
			_bytesTotal		= event.bytesTotal;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _bytesLoaded, _bytesTotal));
		}
		
		private function loaderCompleteInternalHandler(event:Event):void 
		{
			_loadCompleted = true;
		}
		
		private function loaderCompleteHandler(event:Event):void 
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * removeEventListener :: remove the event listener assigned to the URLLoader.
		 * @param	type	<String>	the evnet type listened to.
		 * @param	listener	<Function>	the listener to the event dispatch.
		 * @param	useCapture	<Boolean>
		 */
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			switch (type) 
			{
				
				case Event.COMPLETE:
					_URLLoader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
					break;
					
				case ProgressEvent.PROGRESS:
					_URLLoader.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
					break;
					
				case HTTPStatusEvent.HTTP_STATUS:
					_URLLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
					break;
					
				case IOErrorEvent.IO_ERROR:
					_URLLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					break;
					
				case Event.OPEN:
					_URLLoader.removeEventListener(Event.OPEN, openHandler);
					break;
					
				case SecurityErrorEvent.SECURITY_ERROR:
					_URLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					break;
					
				default:
					return;
					
			}
			super.removeEventListener(type, listener, useCapture);
		}
		
	}
	
}