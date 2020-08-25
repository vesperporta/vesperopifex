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
package com.vesperopifex.display.video 
{
	import com.vesperopifex.display.GraphicFactory;
	import com.vesperopifex.events.NetStreamClientEvent;
	import com.vesperopifex.utils.AbstractLoader;
	import com.vesperopifex.utils.MinimumPlayerVersion;
	import com.vesperopifex.utils.PlayerVersionObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class VideoPlayback extends AbstractLoader implements IVideoPlayer 
	{
		protected var _connection:NetConnection	= null;
		protected var _stream:NetStream			= null;
		protected var _video:Video				= null;
		protected var _client:Object			= null;
		protected var _serverURL:String			= null;
		protected var _streamURL:String			= null;
		protected var _connected:Boolean		= false;
		
		public function get bufferLength():Number 
		{
			if (!_stream) return NaN;
			return _stream.bufferLength;
		}
		
		public function get bufferTime():Number 
		{
			if (!_stream) return NaN;
			return _stream.bufferTime;
		}
		public function set bufferTime(value:Number):void 
		{
			if (!_stream) return;
			_stream.bufferTime = value;
		}
		
		public override function get bytesLoaded():uint 
		{
			if (!_stream) return NaN;
			return _stream.bytesLoaded;
		}
		
		public override function get bytesTotal():uint 
		{
			if (!_stream) return NaN;
			return _stream.bytesTotal;
		}
		
		public function get checkPolicyFile():Boolean 
		{
			if (!_stream) return false;
			return _stream.checkPolicyFile;
		}
		public function set checkPolicyFile(value:Boolean):void 
		{
			if (!_stream) return;
			_stream.checkPolicyFile = value;
		}
		
		public function get client():Object 
		{
			if (!_stream) return null;
			return _stream.client;
		}
		public function set client(value:Object):void 
		{
			if (!_stream) return;
			if (_client is IEventDispatcher) removeClientListeners(_client as IEventDispatcher);
			_stream.client	= value;
			_client			= value;
			if (value is IEventDispatcher) assignClientListeners(value as IEventDispatcher);
		}
		
		public function get currentFPS():Number { return _stream.currentFPS; }
		
		public function get liveDelay():Number { return _stream.liveDelay; }
		
		public function get objectEncoding():uint { return _stream.objectEncoding; }
		
		public override function get soundTransform():SoundTransform 
		{
			if (!_stream) return null;
			return _stream.soundTransform;
		}
		public override function set soundTransform(value:SoundTransform):void 
		{
			if (!_stream) return;
			_stream.soundTransform = value;
		}
		
		public function get time():Number 
		{
			if (!_stream) return NaN;
			return _stream.time;
		}
		
		public override function set storedURL(value:String):void 
		{
			_storedURL = value;
			checkPlayURI();
		}
		
		public function set server(value:String):void 
		{
			_serverURL	= value;
			connectServer(value);
		}
		
		public function set stream(value:String):void 
		{
			_streamURL	= value;
		}
		
		/**
		 * VideoLoader :: Constructor.
		 * All event handling is delt with the parent Class as there are no intrinsic needs to capture video meta data.
		 */
		public function VideoPlayback(serverURL:String = null, streamURL:String = null) 
		{
			super();
			_serverURL	= serverURL;
			_streamURL	= streamURL;
			_client	= new NetStreamClient();
			assignClientListeners(_client as IEventDispatcher);
			_video	= new Video();
			addChild(_video);
			if (!serverURL || serverURL == GraphicFactory.VOID) return;
			connectServer(_serverURL);
		}
		
		/**
		 * create a NetStream and hook it up to the rest of the Class, if there is a URL avaialble use it.
		 * @param connection	<NetConnection>	the connection to stream the content over.
		 */		
		protected function connectStream(connection:NetConnection):void 
		{
			_stream	= new NetStream(connection);
			addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			if (_client) _stream.client	= _client;
			if (_video) _video.attachNetStream(_stream);
			play((_streamURL)? _streamURL: VideoURIValidation.checkForFile(_storedURL));
		}
		
		/**
		 * connect to a flash media server or to a null object for no server connection.
		 * @param server	<String>	the server to connect to.
		 */		
		protected function connectServer(server:String = null):void 
		{
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			if (server) connect(server);
			else _connection.connect(server);
		}
		
		/**
		 * load :: load a video from a server with a url String.
		 * @param	value	<String>	URL of the current video stream
		 * @param	context	<LoaderContext>	unrequired and not used, inheritance from AbstractLoader
		 */
		public override function load(request:URLRequest, context:LoaderContext = null):void 
		{
			if (_storedURL || !request.url) play(_storedURL);
			else play(request.url);
		}
		
		/**
		 * connect :: Creates a bidirectional connection between a Flash Player or AIR application and a Flash Media Server application.
		 * @param	command
		 * @param	... arguments
		 */
		public function connect(command:String = null, ... arguments):void 
		{
			if (command) 
			{
				NetConnection.defaultObjectEncoding = ObjectEncoding.DEFAULT;
				_connection.connect(command, arguments);
			} else _connection.connect(_connection.uri);
		}
		
		/**
		 * addHeader :: Adds a context header to the Action Message Format (AMF) packet structure.
		 * @param	operation
		 * @param	mustUnderstand
		 * @param	param
		 */
		public function addHeader(operation:String, mustUnderstand:Boolean = false, param:Object = null):void 
		{
			if (!_connection) return;
			_connection.addHeader(operation, mustUnderstand, param);
		}
		
		/**
		 * close :: close the current NetStream if there is any information already downloaded otherwise close the NetConnection.
		 */
		public override function close():void 
		{
			if (!_stream) return;
			if (_stream.bytesLoaded) _stream.close();
			else _connection.close();
		}
		
		/**
		 * pause :: pause the current Net_stream
		 */
		public function pause():void 
		{
			if (!_stream) return;
			_stream.pause();
		}
		
		/**
		 * play :: play a video from a server.
		 * @param	name	<Object>
		 * @param	start	<Number>
		 * @param	len		<Number>
		 * @param	reset	<Object>
		 */
		public override function play(name:Object, start:Number = -2, len:Number = -1, reset:Object = true):void 
		{
			if (!_stream) return;
			_stream.play(name, start, len, reset);
			super.play(name, start, len, reset);
		}
		
		/**
		 * receiveAudio :: used when connected to a flash media server to subscribe to an audio stream.
		 * @param	value	<Boolean>
		 */
		public function receiveAudio(value:Boolean):void 
		{
			if (!_stream) return;
			_stream.receiveAudio(value);
		}
		
		/**
		 * receiveVideo :: used when connected to a flash media server to subscribe to a video stream.
		 * @param	value	<Boolean>
		 */
		public function receiveVideo(value:Boolean):void 
		{
			if (!_stream) return;
			_stream.receiveVideo(value);
		}
		
		/**
		 * 
		 * @param	value	<Number>
		 */
		public function receiveVideoFPS(value:Number):void 
		{
			if (!_stream) return;
			_stream.receiveVideoFPS(value);
		}
		
		/**
		 * resume :: used after the pause method has been called to resume play of the stream.
		 */
		public function resume():void 
		{
			if (!_stream) return;
			_stream.resume();
		}
		
		/**
		 * seek :: seek to a position of the streaming video if it is not live content.
		 * @param	value	<Number>
		 */
		public function seek(value:Number):void 
		{
			if (!_stream) return;
			_stream.seek(value);
		}
		
		/**
		 * togglePause :: toggle between the paused states of the connected stream.
		 */
		public function togglePause():void 
		{
			if (!_stream) return;
			_stream.togglePause();
		}
		
		/**
		 * addEventListener :: apply event listeners to the encapsulated NetStream, use is identical to NetStream.addEventListener.
		 * @param	type	<String>
		 * @param	listener	<Function>
		 * @param	useCapture	<Boolean>
		 * @param	priority	<int>
		 * @param	useWeakReference	<Boolean>
		 */
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			if (!_stream) return;
			_stream.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * checkPlayURI :: find if there is a host server URI plased in the String object passed and connect to this URI, otherwise use the String object to load a file.
		 */
		protected function checkPlayURI():void
		{
			if (_storedURL) 
			{
				var hostnameURI:String	= VideoURIValidation.checkForServer(_storedURL);
				var filenameURI:String	= VideoURIValidation.checkForFile(_storedURL);
				if (hostnameURI) connect(hostnameURI);
				else connectServer();
			}
		}
		
		/**
		 * netStatusHandler :: handle connection and streaming events.
		 * @param	event	<NetStatusEvent>
		 */
		protected function netStatusHandler(event:NetStatusEvent):void 
		{
			switch (event.info.code) 
			{
				
				case "NetStream.Buffer.Empty":
					// Data is not being received quickly enough to fill the buffer. Data flow will be interrupted until the buffer refills, at which time a NetStream.Buffer.Full message will be sent and the stream will begin playing again.
					break;
					
				case "NetStream.Buffer.Full":
					// The buffer is full and the stream will begin playing.
					break;
					
				case "NetStream.Buffer.Flush":
					// Data has finished streaming, and the remaining buffer will be emptied.
					break;
					
				case "NetStream.Failed":
					// Flash Media Server only. An error has occurred for a reason other than those listed in other event codes.
					break;
					
				case "NetStream.Publish.Start":
					// Publish was successful.
					break;
					
				case "NetStream.Publish.BadName":
					// Attempt to publish a stream which is already being published by someone else.
					break;
					
				case "NetStream.Publish.Idle":
					// The publisher of the stream is idle and not transmitting data.
					break;
					
				case "NetStream.Unpublish.Success":
					// The unpublish operation was successfuul.
					break;
					
				case "NetStream.Play.Start":
					// Playback has started.
					break;
					
				case "NetStream.Play.Stop":
					// Playback has stopped.
					break;
					
				case "NetStream.Play.Failed":
					// An error has occurred in playback for a reason other than those listed elsewhere in this table, such as the subscriber not having read access.
					break;
					
				case "NetStream.Play.StreamNotFound":
					// The FLV passed to the play() method can't be found.
					trace("Stream not found: " + event);
					break;
					
				case "NetStream.Play.Reset":
					// Caused by a play list reset.
					break;
					
				case "NetStream.Play.PublishNotify":
					// The initial publish to a stream is sent to all subscribers.
					break;
					
				case "NetStream.Play.UnpublishNotify":
					// An unpublish from a stream is sent to all subscribers.
					break;
					
				case "NetStream.Play.InsufficientBW":
					// Flash Media Server only. The client does not have sufficient bandwidth to play the data at normal speed.
					break;
					
				case "NetStream.Play.FileStructureInvalid":
					// The application detects an invalid file structure and will not try to play this type of file. For AIR and for Flash Player 9.0.115.0 and later.
					break;
					
				case "NetStream.Play.NoSupportedTrackFound":
					// The application does not detect any supported tracks (video, audio or data) and will not try to play the file. For AIR and for Flash Player 9.0.115.0 and later.
					break;
					
				case "NetStream.Pause.Notify":
					// The stream is paused.
					break;
					
				case "NetStream.Unpause.Notify":
					// The stream is resumed.
					break;
					
				case "NetStream.Record.Start":
					// Recording has started.
					break;
					
				case "NetStream.Record.NoAccess":
					// Attempt to record a stream that is still playing or the client has no access right.
					break;
					
				case "NetStream.Record.Stop":
					// Recording stopped.
					break;
					
				case "NetStream.Record.Failed":
					// An attempt to record a stream failed.
					break;
					
				case "NetStream.Seek.Failed":
					// The seek fails, which happens if the stream is not seekable.
					break;
					
				case "NetStream.Seek.InvalidTime":
					// For video downloaded with progressive download, the user has tried to seek or play past the end of the video data that has downloaded thus far, or past the end of the video once the entire file has downloaded. The message.details property contains a time code that indicates the last valid position to which the user can seek.
					seek(event.info.details);
					break;
					
				case "NetStream.Seek.Notify":
					// The seek operation is complete.
					break;
					
				case "NetConnection.Call.BadVersion":
					// Packet encoded in an unidentified format.
					break;
					
				case "NetConnection.Call.Failed":
					// The NetConnection.call method was not able to invoke the server-side method or command.
					break;
					
				case "NetConnection.Call.Prohibited":
					// An Action Message Format (AMF) operation is prevented for security reasons. Either the AMF URL is not in the same domain as the file containing the code calling the NetConnection.call() method, or the AMF server does not have a policy file that trusts the domain of the the file containing the code calling the NetConnection.call() method.
					break;
					
				case "NetConnection.Connect.Closed":
					// The connection was closed successfully.
					break;
					
				case "NetConnection.Connect.Failed":
					// The connection attempt failed.
					// trying to connect to Flash Media Server 2 using Actionscript 3 has a few issues, try setting it to AS2 mode and reconnect.
					//NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
					NetConnection.defaultObjectEncoding	= ObjectEncoding.AMF0;
					connectServer(_connection.uri);
					break;
					
				case "NetConnection.Connect.Success":
					// The connection attempt succeeded.
					connectStream(_connection);
					break;
					
				case "NetConnection.Connect.Rejected":
					// The connection attempt did not have permission to access the application.
					break;
					
				case "NetConnection.Connect.AppShutdown":
					// The specified application is shutting down.
					break;
					
				case "NetConnection.Connect.InvalidApp":
					// The application name specified during connect is invalid.
					break;
					
				case "SharedObject.Flush.Success":
					// The "pending" status is resolved and the SharedObject.flush() call succeeded.
					break;
					
				case "SharedObject.Flush.Failed":
					// The "pending" status is resolved, but the SharedObject.flush() failed.
					break;
					
				case "SharedObject.BadPersistence":
					// A request was made for a shared object with persistence flags, but the request cannot be granted because the object has already been created with different flags.
					break;
					
				case "SharedObject.UriMismatch":
					// An attempt was made to connect to a NetConnection object that has a different URI (URL) than the shared object.
					break;
					
			}
		}
		
		/**
		 * securityErrorHandler :: handle errors when connections fail.
		 * @param	event	<SecurityErrorEvent>
		 */
		protected function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			trace("securityErrorHandler: " + event);
		}
		
		/**
		 * metaDataHandler :: handle the event captured from the NetStream client.
		 * @param	event	<NetStreamClientEvent>	the event dispatched from the client.
		 */
		protected function metaDataHandler(event:NetStreamClientEvent):void 
		{
			event.stopImmediatePropagation();
		}
		
		/**
		 * cuePointDataHandler :: handle the event captured from the NetStream client.
		 * @param	event	<NetStreamClientEvent>	the event dispatched from the client.
		 */
		protected function cuePointDataHandler(event:NetStreamClientEvent):void 
		{
			event.stopImmediatePropagation();
		}
		
		/**
		 * assignClientListeners :: assign the required event listeners to the IEventDispatcher to capture the meta and cue point data.
		 * @param	client	<IEventDispatcher>	
		 */
		protected function assignClientListeners(client:IEventDispatcher):void 
		{
			client.addEventListener(NetStreamClientEvent.META_DATA, metaDataHandler);
			client.addEventListener(NetStreamClientEvent.CUE_POINT_DATA, cuePointDataHandler);
		}
		
		/**
		 * removeClientListeners :: remove any listeners from the passed client.
		 * @param	client	<IEventDispatcher>	
		 */
		protected function removeClientListeners(client:IEventDispatcher):void
		{
			if (client.hasEventListener(NetStreamClientEvent.META_DATA)) client.removeEventListener(NetStreamClientEvent.META_DATA, metaDataHandler);
			if (client.hasEventListener(NetStreamClientEvent.CUE_POINT_DATA)) client.removeEventListener(NetStreamClientEvent.CUE_POINT_DATA, cuePointDataHandler);
		}
		
	}
}