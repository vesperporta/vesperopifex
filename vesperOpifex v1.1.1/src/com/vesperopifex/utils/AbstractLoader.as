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
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class AbstractLoader extends Sprite 
	{
		protected var _Loader:Loader				= new Loader();
		protected var _URLLoader:URLLoader			= new URLLoader();
		protected var _loadCompleted:Boolean		= false;
		protected var _storedURL:String				= null;
		protected var _bytesTotal:uint				= 0;
		protected var _bytesLoaded:uint				= 0;
		protected var _failed:Boolean				= false;
		
		private var _data:*							= null;
		private var _bytes:ByteArray				= null;
		private var _dataFormat:String				= URLLoaderDataFormat.TEXT;
		private var _request:URLRequest				= null;
		private var _context:LoaderContext			= null;
		private var _displayObject:DisplayObject	= null;
		private var _contentLoaderInfo:LoaderInfo	= null;
		private var _name:Object					= null;
		private var _start:Number					= -2;
		private var _len:Number						= -1;
		private var _reset:Object					= null;
		
		public function get failed():Boolean { return _failed; }
		
		public function set failed(value:Boolean):void 
		{
			_failed = value;
		}
		
		/**
		 * AbstractLoader :: Constructor.
		 * @param	request	<URLRequest (default = null>
		 */
		public function AbstractLoader(request:URLRequest = null) 
		{
			if (request) _request = request;
		}
		
		/**
		 * load :: transfer data from the specified location in the URLRequest.
		 * @param	request	<URLRequest>
		 * @param	context	<LoaderContext>
		 */
		public function load(request:URLRequest, context:LoaderContext = null):void 
		{
			_request = request;
			if (context) _context = context;
		}
		
		/**
		 * close :: close the current connection of the transfer object and delete any transfered information.
		 */
		public function close():void 
		{
			throw new Error("method to be overriden through extending class");
		}
		
		/* --- Loader --- */
		/**
		 * loadBytes :: load bytes from a ByteArray and instance the object.
		 * @param	bytes	<ByteArray>
		 * @param	context	<LoaderContext>
		 */
		public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void 
		{
			_bytes = bytes;
			if (context) _context = context;
		}
		
		/**
		 * unload :: unload the loader object.
		 */
		public function unload():void 
		{
			throw new Error("method to be overriden through extender class");
		}
		
		public function get contentLoaderInfo():LoaderInfo { return _contentLoaderInfo; }
		
		public function get content():DisplayObject { return _displayObject; }
		
		/* --- URLLoader --- */
		public function get bytesTotal():uint { return _bytesTotal; }
		
		public function get bytesLoaded():uint { return _bytesLoaded; }
		
		public function get data():* { return _data; }
		
		public function get dataFormat():String { return _dataFormat; }
		
		public function set dataFormat(value:String):void 
		{
			_dataFormat = value;
		}
		
		public function get loadCompleted():Boolean { return _loadCompleted; }
		
		public function get storedURL():String { return _storedURL; }
		
		public function set storedURL(value:String):void 
		{
			_storedURL = value;
		}
		
		/* --- NetStream --- */
		public function play(name:Object, start:Number = -2, len:Number = -1, reset:Object = true):void 
		{
			_name = name;
			if (start) _start = start;
			if (len) _len = len;
			if (reset) _reset = reset;
		}
		
	}
	
}