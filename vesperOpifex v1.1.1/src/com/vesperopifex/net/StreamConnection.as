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
package com.vesperopifex.net 
{
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.SharedObject;
	
	public class StreamConnection extends Object 
	{
		public static const PORT_DELIMINATOR:String	= ":";
		public static const PROTOCOL_END:String		= "://";
		public static const PROTOCOL_RMTP:String	= "rmtp://";
		public static const PROTOCOL_RMTPE:String	= "rmtpe://";
		public static const PROTOCOL_RMTPS:String	= "rmtps://";
		public static const PROTOCOL_RMTPT:String	= "rmtpt://";
		public static const PROTOCOL_RMTPTE:String	= "rmtpte://";
		
		protected var _sharedObject:SharedObject	= null;
		protected var _connection:NetConnection		= null;
		protected var _serverProtocol:String		= "";
		protected var _serverURI:String				= null;
		protected var _serverPort:String			= "";
		
		public function get client():Object { return _connection.client; }
		
		public function set client(value:Object):void 
		{
			_connection.client = value;
		}
		
		public function get connected():Boolean { return _connection.connected; }
		
		public function get connectedProxyType():String { return _connection.connectedProxyType; }
		
		public static function get defaultObjectEncoding():uint { return _connection.defaultObjectEncoding; }
		
		public function set defaultObjectEncoding(value:uint):void 
		{
			_connection.defaultObjectEncoding = value;
		}
		
		public function get objectEncoding():uint { return _connection.objectEncoding; }
		
		public function set objectEncoding(value:uint):void 
		{
			_connection.objectEncoding = value;
		}
		
		public function get proxyType():String { return _connection.proxyType; }
		
		public function set proxyType(value:String):void 
		{
			_connection.proxyType = value;
		}
		
		public function get uri():String { return _connection.uri; }
		
		public function get usingTLS():Boolean { return _connection.usingTLS; }
		
		public function get serverURI():String { return _serverURI; }
		
		public function set serverURI(value:String):void 
		{
			_serverURI = value;
		}
		
		public function get serverPort():String { return _serverPort; }
		
		public function set serverPort(value:String):void 
		{
			_serverPort = PORT_DELIMINATOR + value;
		}
		
		public function get protocol():String { return _serverProtocol; }
		
		public function set protocol(value:String):void 
		{
			_serverProtocol = value;
		}
		
		/**
		 * StreamConnection :: Constructor
		 * @param	server	<String>
		 */
		public function StreamConnection(server:String = null) 
		{
			_connection = new NetConnection();
			connect(server);
		}
		
		public function connect(command:String = null, ... arguments):void 
		{
			_connection.connect(command, arguments);
		}
		
		public function addHeader(operation:String, mustUnderstand:Boolean = false, param:Object = null):void 
		{
			_connection.addHeader(operation, mustUnderstand, param);
		}
		
		public function call(command:String, responder:Responder, ... arguments):void 
		{
			_connection.call(command, responder, arguments);
		}
		
		public override function close():void 
		{
			_connection.close();
		}
		
		public function reconnect():void 
		{
			
		}
		
		protected function netStatusHandler(event:NetStatusEvent):void 
		{
			switch (event.info.code) 
			{
				case "NetStream.Play.StreamNotFound":
					trace("Stream not found: " + videoURL);
					break;
			}
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			trace("securityErrorHandler: " + event);
		}
		
	}
	
}