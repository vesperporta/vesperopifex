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
	import com.vesperopifex.data.Cache;
	import com.vesperopifex.data.CacheObject;
	import com.vesperopifex.display.AssetLoader;
	import com.vesperopifex.display.video.VideoLoader;
	import com.vesperopifex.events.IOErrorEventEx;
	import com.vesperopifex.events.LoadFactoryProgressEvent;
	import com.vesperopifex.events.SecurityErrorEventEx;
	import com.vesperopifex.utils.DataLoader;
	import com.vesperopifex.utils.MinimumPlayerVersion;
	import com.vesperopifex.utils.PlayerVersionObject;
	import com.vesperopifex.utils.QueueLoaderObject;
	import com.vesperopifex.utils.QueueFIFO;
	import com.vesperopifex.events.LoadFactoryEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class LoadFactory extends EventDispatcher 
	{
		// there are three way to use this class
		public static const SINGLE_MODE:String				= "single"; // 1. Load files on a singular basis
		public static const MULTI_MODE:String				= "multi"; // 2. Load files on a localised queue system
		public static const STATIC_MULTI_MODE:String		= "static_multi"; // 3. Load files on a global queue system
		public static const PROGRESS_RESET:uint				= 2; // once all the loaders have finished loading then the progress is reset to this unsigned-integer.
		public static const PROGRESS_COMPLETE:uint			= 1;
		
		protected static const FILE:String					= "file";
		protected static const DATA:String					= "data";
		protected static const STREAM:String				= "stream";
		protected static const AUDIO:String					= "audio";
		protected static const EMPTY:String					= "empty";
		
		protected static var staticMultiQueue:QueueFIFO		= new QueueFIFO();
		protected static var static_files_progress:Number	= 0;
		protected static var _static_files_loaded:uint		= 0;
		protected static var _static_close:Boolean			= false;
		
		protected var multiQueue:QueueFIFO					= new QueueFIFO();
		protected var files_progress:Number					= 0;
		protected var _files_loaded:uint					= 0;
		protected var _close:Boolean						= false;
		
		protected var queueState:String						= null;
		protected var _auto:Boolean							= true;
		
		/**
		 * return the state of how the LoadFactory loads objects
		 * @return	<String>	indicator on the queuing system for loading
		 */
		public function get mode():String { return queueState; }
		
		/**
		 * assign the state of how the LoadFactory should load objects
		 * @param value	<String> available values are "single", "multi", or "static_multi", it is best practice to use constants.
		 */
		public function set mode(value:String):void 
		{
			queueState = value;
		}
		
		/**
		 * @return	<Boolean>	indicator upon loading assets for the load method to be called or not.
		 */
		public function get auto():Boolean { return _auto; }
		
		/**
		 * @param	value	<Boolean>	determine whether on creation of Loaders to load the URI directly if true, or false if required to postpone the loading of assets.  This feature only works if the mode is MULTI_MODE or STATIC_MULTI_MODE.
		 */
		public function set auto(value:Boolean):void 
		{
			_auto = value;
		}
		
		/**
		 * LoadFactory :: Constructor.
		 * @param	mode	<String> pre-define the way in which the LoadFactory will load objects, 
		 * @param	auto	<Boolean>	determine whether on creation of Loaders to load the URI directly if true, or false if required to postpone the loading of assets.  This feature only works if the mode is MULTI_MODE or STATIC_MULTI_MODE.
		 * 	available values are "single", "multi", or "static_multi", it is best practice to use constants.
		 */
		public function LoadFactory(mode:String = MULTI_MODE, auto:Boolean = true) 
		{
			queueState = mode;
			_auto = auto;
			super();
		}
		
		/**
		 * progress :: find the progress of all files loaded through the LoadFactory.
		 * @return	<Number>	A value between 0 and 1, though if in SINGLE_MODE then null is returned.
		 */
		public function progress():Number 
		{
			var rtn:Number = -1;
			if (queueState != SINGLE_MODE) 
				rtn = (queueState == MULTI_MODE)? files_progress: static_files_progress;
			return rtn;
		}
		
		/**
		 * currentTarget :: find the currently loading item in the queue and return the AbstractLoader
		 * @return	<AbstractLoader>	base Class of all loaders returned
		 */
		public function currentTarget():AbstractLoader 
		{
			var current:QueueLoaderObject	= (queueState == MULTI_MODE)? multiQueue.current: staticMultiQueue.current;
			return (current.loader.loadCompleted)? null: current.loader;
		}
		
		/**
		 * close :: stop loading of the current asset and pause the queue.
		 * 	use 'resumeLoad' to start loading of the queue again.
		 */
		public function close():void 
		{
			if (queueState != SINGLE_MODE) 
			{
				var queue:QueueFIFO = (queueState == MULTI_MODE)? multiQueue: staticMultiQueue;
				var current:QueueLoaderObject = queue.current as QueueLoaderObject;
				if (current) current.loader.close();
				(queueState == MULTI_MODE)? _close = true: _static_close = true;
			}
		}
		
		/**
		 * resumeLoad :: after calling the 'close' method use this method to resume loading the queue of files
		 */
		public function resumeLoad():void 
		{
			if (_close || _static_close) 
			{
				var queue:QueueFIFO = (queueState == MULTI_MODE)? multiQueue: staticMultiQueue;
				var current:QueueLoaderObject = queue.current as QueueLoaderObject;
				current.loader.load(new URLRequest(current.url), current.context);
				applyEventHandlers(current.loader);
				(queueState == MULTI_MODE)? _close = false: _static_close = false;
			}
		}
		
		/**
		 * startLoad :: when auto is set to false this should be called to initiate the loading of the required queue determined by mode.
		 */
		public function startLoad():void 
		{
			if (queueState != SINGLE_MODE) 
			{
				var queue:QueueFIFO = (queueState == MULTI_MODE)? multiQueue: staticMultiQueue;
				var current:QueueLoaderObject = queue.current as QueueLoaderObject;
				current.loader.load(new URLRequest(current.url), current.context);
				applyEventHandlers(current.loader);
			}
		}
		
		/**
		 * forceLoad :: this method is to force the loading of a particular URL before any other objects, closing them if required. Once the forced download has completed the normal queue resumes.
		 * 		This could give rise to a prioritiesed list of downloads, giving each URL a group identifier.
		 * 		Each group would have to be described in a particular way through XML and then a String value can be used there after.
		 * 			<loadPriorities>
		 * 				<priority id="group-one"><![CDATA[0]]></priority>
		 * 				<priority id="bangers-and-mash"><![CDATA[1]]></priority>
		 * 			</loadPriorities>
		 * 		For larger projects this would be perfect, though as this framework [ATM] is targeted more towards small to medium sized applications, though there is no disqualification in the use of the framework in a huge project and is congradulated as preferably there should be no limitations in the abilities of deployment.
		 * @param	value	<String>	the URL string to load the object with.
		 */
		public function forceLoad(value:String):void 
		{
			trace("forceLoad is not implemented yet.");
		}
		
		/**
		 * reset :: if the LoadFactory is in MULTI_MODE, close all connections clear the queue and set the progress to 0.
		 */
		public function reset():void 
		{
			if (queueState != SINGLE_MODE) 
			{
				close();
				if (queueState == MULTI_MODE) 
				{
					multiQueue = new QueueFIFO();
					files_progress = PROGRESS_RESET;
				} else 
				{
					staticMultiQueue = new QueueFIFO();
					static_files_progress = PROGRESS_RESET;
				}
				
			}
		}
		
		/**
		 * load in a particular URL with optionally a LoaderContext when loading external swf files.
		 * @param	value		<String> URL of resource to load into the movie.
		 * @param	context		<LoaderContext> When load swf files use this option to allow access to the external swf's Classes.
		 * @return	<AbstractLoader> the base class of all loaders generated.
		 */
		public function load(value:String, context:LoaderContext = null, enforcedType:String = null):AbstractLoader 
		{
			if (StringValidation.validateURL(value)) return LoaderType(value, context, enforcedType);
			else return null;
		}
		
		/**
		 * LoaderType :: find the loader required for the loading type and return the loader related to the MIME type.
		 * @param	value	<String>	url for the loader.
		 * @param	context	<LoaderContext>	when loading SWF files this determines where the child SWF's Classes are registered.
		 * @param	enforcedType	<String>	the type of loader to force in the returning Loader type.
		 * @return	<AbstractLoader>	base loader for all loader types.
		 */
		protected function LoaderType(value:String, context:LoaderContext = null, enforcedType:String = null):AbstractLoader 
		{
			var rtn:AbstractLoader	= null;
			var rtn_d:DataLoader	= null;
			var rtn_a:AssetLoader	= null;
			var rtn_v:VideoLoader	= null;
			var queue:QueueFIFO		= null;
			var close_:Boolean = (queueState == MULTI_MODE)? _close: _static_close;
			if (queueState != SINGLE_MODE) queue = (queueState == MULTI_MODE)? multiQueue: staticMultiQueue;
			var request:URLRequest = new URLRequest(value);
			switch ((enforcedType)? MIMECheck.check(enforcedType): MIMECheck.check(value)) 
			{
				
				case MIMECheck.FILE:	//	------------------------	ASSET FILES
					rtn_a = new AssetLoader();
					rtn_a.storedURL = value;
					applyEventHandlers(rtn_a);
					if (queue) 
					{
						if (!close_ && _auto && queue.length == 0) 
							(context == null)? rtn_a.load(request): rtn_a.load(request, context);
						queue.add(new QueueLoaderObject(value, rtn_a, context));
					} else (context == null)? rtn_a.load(request): rtn_a.load(request, context);
					rtn = rtn_a;
					break;
					
				case MIMECheck.DATA:	//	------------------------	DATA FILES
					rtn_d = new DataLoader();
					rtn_d.storedURL	= value;
					applyEventHandlers(rtn_d);
					if (queue) 
					{
						if (!close_ && _auto && queue.length == 0) rtn_d.load(request);
						queue.add(new QueueLoaderObject(value, rtn_d, null));
					} else rtn_d.load(request);
					rtn = rtn_d;
					break;
					
				case MIMECheck.STREAM:	//	------------------------	STREAMING FILES
					rtn_v = new VideoLoader();
					rtn_v.storedURL = value;
					rtn_v.load(request);
					rtn = rtn_v;
					break;
					
			}
			return rtn;
		}
		
		/**
		 * singleLoad :: load a single item rather than using the queue system.
		 * @param	value		<String>	URL for the external resouce.
		 * @param	context		<LoaderContext>	used for external SWF files when loading Classes deternined by the domain space.
		 * @return	<AbstractLoader>	Generic loader Class for all loaders returned.
		 */
		protected function singleLoad(value:String, context:LoaderContext = null, enforcedType:String = null):AbstractLoader 
		{
			return LoaderType(value, context, enforcedType);
		}
		
		/**
		 * single point to dispatch a LoadFactoryEvent.FINISHED Event.
		 */
		protected function dispatchFinishedEvent():void 
		{
			if (hasEventListener(LoadFactoryEvent.FINISHED)) 
				dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.FINISHED, true, true));
		}
		
		/**
		 * single point to dispatch a LoadFactoryEvent.COMPLETE Event.
		 * @param	loader	<*>	the AbstractLoader or QueueLoaderObject object to reference to.
		 */
		protected function dispatchCompleteEvent(loader:* = null):void 
		{
			var aLoader:AbstractLoader		= loader as AbstractLoader;
			var object:QueueLoaderObject	= loader as QueueLoaderObject;
			if (hasEventListener(LoadFactoryEvent.COMPLETE)) 
			{
				if (aLoader) 
					dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.COMPLETE, true, true, aLoader));
				else if (object) 
					dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.COMPLETE, true, true, object.loader, object.url));
				else 
					dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.COMPLETE, true, true));
			}
		}
		
		/**
		 * single point to dispatch a LoadFactoryEvent.NEW_FILE Event.
		 * @param	loader	<QueueLoaderObject>	the loader object to reference to.
		 */
		protected function dispatchNewFileEvent(loader:QueueLoaderObject):void 
		{
			if (hasEventListener(LoadFactoryEvent.NEW_FILE)) 
				dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.NEW_FILE, true, true, loader.loader, loader.url, loader.loader.data));
		}
		
		/**
		 * single point to dispatch a LoadFactoryEvent.ERROR Event.
		 * @param	loader	<QueueLoaderObject>	the loader object to reference to.
		 */
		protected function dispatchErrorEvent(loader:QueueLoaderObject = null):void 
		{
			if (hasEventListener(LoadFactoryEvent.ERROR)) 
			{
				if (loader) 
					dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.ERROR, true, true, loader.loader, loader.url));
				else 
					dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.ERROR, true, true));
			}
		}
		
		/**
		 * single point to dispatch a LoadFactoryEvent.FATAL_ERROR Event.
		 * @param	loader	<QueueLoaderObject>	the loader object to reference to.
		 */
		protected function dispatchFatalErrorEvent(loader:QueueLoaderObject = null):void 
		{
			if (hasEventListener(LoadFactoryEvent.FATAL_ERROR)) 
			{
				if (loader) 
					dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.FATAL_ERROR, true, true, loader.loader, loader.url));
				else 
					dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.FATAL_ERROR, true, true));
			}
		}
		
		/**
		 * applyEventHandlers :: assign event listeners to the passed dispatcher.
		 * @param	dispatcher	<IEventDispatcher>	Any loader passed to have event handlers applied.
		 */
		protected function applyEventHandlers(dispatcher:IEventDispatcher):void 
		{
			dispatcher.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		/**
		 * removeEventHandlers :: remove event listeners from the passed dispatcher.
		 * @param	dispatcher	<IEventDispatcher>	Any loader passed to have event handlers applied.
		 */
		protected function removeEventHandlers(dispatcher:IEventDispatcher):void 
		{
			dispatcher.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener(Event.OPEN, openHandler);
			dispatcher.removeEventListener(Event.INIT, initHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		/**
		 * securityErrorHandler :: handler for the security alerts detailing the file being loaded is in oposition to the Adobe Flash security rules laid out in the Adobe Flash Security White Papper.  Generally the loading should continue to the next item though the next item may have the same issue thus continuation of loading is halted.
		 * @param	event	<SecurityErrorEvent>	event dispatched from the loader.
		 */
		protected function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			trace(Settings.FRAMEWORK + "FILE SECURITY ERROR\t>>>\t" + event);
			if (queueState != SINGLE_MODE) 
			{
				var queue:QueueFIFO				= (queueState == MULTI_MODE)? multiQueue: staticMultiQueue;;
				var current:QueueLoaderObject	= queue.current;
				dispatchFatalErrorEvent(current);
			} else dispatchFatalErrorEvent();
			close();
		}
		
		/**
		 * initHandler :: event handler for the availability of objects from the loader, though if a SWF or SWC are being loaded all Classes and methods may not be loaded, best is to wait for a COMPLETE event and deal with the object then.
		 * @param	event	<Event>	event dispatched from the loader.
		 */
		protected function initHandler(event:Event):void 
		{
			if (hasEventListener(Event.INIT)) dispatchEvent(event.clone());
		}
		
		/**
		 * openHandler :: event handler for the creation of the connection to the server and the beginning of transfer of data.
		 * @param	event	<Event>	event dispatched from the loader.
		 */
		protected function openHandler(event:Event):void 
		{
			if (hasEventListener(Event.OPEN)) dispatchEvent(event.clone());
		}
		
		/**
		 * ioErrorHandler :: event handler for when a file is not found on the server, general use would be to continue to the next item in the queue to download.
		 * @param	event	<IOErrorEvent> event dispatched from the loader.
		 */
		protected function ioErrorHandler(event:IOErrorEvent):void 
		{
			trace(Settings.FRAMEWORK + "FILE IO ERROR\t>>>\t" + event);
			var queue:QueueFIFO				= null;
			var current:QueueLoaderObject	= null;
			var next:QueueLoaderObject		= null;
			if (queueState != SINGLE_MODE) 
			{
				queue = (queueState == MULTI_MODE)? multiQueue: staticMultiQueue;
				current	= queue.current;
				current.loader.failed	= true;
				current.loader.close();
				dispatchErrorEvent(current);
				next = queue.next;
				if (current && next && current != next) 
				{
					dispatchNewFileEvent(next);
					next.loader.load(new URLRequest(next.url), next.context);
				} else dispatchFinishedEvent();
			} else dispatchErrorEvent();
		}
		
		/**
		 * httpStatusHandler :: event listener for HTTPStatus responces from the server.
		 * @param	event	<HTTPStatusEvent>	status event dispatched from the Loader.
		 */
		protected function httpStatusHandler(event:HTTPStatusEvent):void 
		{
			if (hasEventListener(HTTPStatusEvent.HTTP_STATUS)) dispatchEvent(event.clone());
		}
		
		/**
		 * loaderCompleteHandler :: complete loading event handler, will remove the listeners and then load the next object in the queue as long as the 'queueState' is not in 'SINGLE_MODE'.
		 * @param	event	<Event>
		 */
		protected function loaderCompleteHandler(event:Event):void 
		{
			var queue:QueueFIFO					= null;
			var current:QueueLoaderObject		= null;
			var next:QueueLoaderObject			= null;
			var completeLoader:AbstractLoader	= event.target as AbstractLoader;
			removeEventHandlers(completeLoader);
			// this would not be in use if in single mode
			if (queueState != SINGLE_MODE) 
			{
				switch (queueState) 
				{
					
					case MULTI_MODE:
						queue = multiQueue;
						files_progress++;
						break;
						
					case STATIC_MULTI_MODE:
						queue = staticMultiQueue;
						static_files_progress++;
						break;
						
				}
				current = queue.current as QueueLoaderObject;
				dispatchCompleteEvent(current);
				next = queue.next as QueueLoaderObject;
				if (current && next && current != next) 
				{
					// dispatch a LoadFactoryEvent.NEW_FILE Event
					next.loader.load(new URLRequest(next.url), next.context);
					dispatchNewFileEvent(next);
				} else dispatchFinishedEvent();
			} else dispatchCompleteEvent(event.target);
		}
		
		/**
		 * loaderProgressHandler :: progress handler for loaders, this is only used for queue versions of the LoadFactory.
		 * @param	event	<Event>
		 */
		protected function loaderProgressHandler(event:ProgressEvent):void 
		{
			if (queueState != SINGLE_MODE) 
			{
				// update the progress variable(s)
				var queue:QueueFIFO			= null;
				var $_files_progress:uint	= 0;
				var progress:Number			= NaN;
				var current:Number			= event.bytesLoaded / event.bytesTotal;
				switch (queueState) 
				{
					
					case MULTI_MODE:
						queue = multiQueue;
						$_files_progress = files_progress;
						break;
						
					case STATIC_MULTI_MODE:
						queue = staticMultiQueue;
						$_files_progress = static_files_progress;
						break;
						
				}
				progress = ($_files_progress + current) / ($_files_progress + 1);
				(queueState == MULTI_MODE)? files_progress = progress: static_files_progress = progress;
				// dispatch a LoadFactoryProgressEvent.PROGRESS Event
				var obj:QueueLoaderObject = queue.current as QueueLoaderObject;
				if (hasEventListener(LoadFactoryProgressEvent.PROGRESS) && obj) 
					dispatchEvent(new LoadFactoryProgressEvent(LoadFactoryProgressEvent.PROGRESS, true, true, obj.loader, obj.url, progress));
			}
		}
		
	}
	
}