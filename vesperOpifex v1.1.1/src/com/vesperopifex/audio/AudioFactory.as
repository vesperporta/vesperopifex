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
	import com.vesperopifex.data.SoundCache;
	import com.vesperopifex.events.LoadFactoryEvent;
	import com.vesperopifex.events.LoadFactoryProgressEvent;
	import com.vesperopifex.utils.QueueFIFO;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	public class AudioFactory extends EventDispatcher 
	{
		public static const XML_AUDIO:String			= "audio";
		public static const XML_STREAM:String			= "stream";
		public static const XML_CONTEXT:String			= "context";
		public static const XML_ID:String				= "id";
		public static const XML_ENFORCED:String			= "enforced";
		public static const XML_TRUE:String				= "true";
		public static const MODE_SINGLE:String			= "single_mode";
		public static const MODE_MULTI:String			= "multi_mode";
		public static const MODE_MULTI_STATIC:String	= "static_multi_mode";
		public static const QUEUE_COMPLETE:Number		= 2;
		public static const QUEUE_RESET:Number			= -1;
		
		protected static var _CACHE:AudioManager 		= new AudioManager();
		protected static var _STATIC_QUEUE:QueueFIFO	= new QueueFIFO();
		
		protected var _QUEUE:QueueFIFO					= new QueueFIFO();
		protected var _autoLoad:Boolean					= true;
		protected var _mode:String						= MODE_MULTI;
		protected var _currentLoadProgress:Number		= QUEUE_RESET;
		
		public function get autoLoad():Boolean { return _autoLoad; }
		public function set autoLoad(value:Boolean):void 
		{
			_autoLoad = value;
			if (value) checkAutoLoad();
		}
		
		public function get mode():String { return _mode; }
		public function set mode(value:String):void 
		{
			if (value == MODE_SINGLE || value == MODE_MULTI || value == MODE_MULTI_STATIC) _mode = value;
		}
		
		/**
		 * AudioFactory :: Constructor.
		 * @param	mode	<String>	a value to determine what type of queue to use, the use of the following constants have the following results.
		 * 		MODE_SINGLE			["single_mode"]			load in single files when they are added to the loader.
		 * 		MODE_MULTI			["multi_mode"]			load audio files in a local queue system to this AudioFactory class.
		 * 		MODE_MULTI_STATIC	["static_multi_mode"]	load audio files on a global scope (to the AudioFactory class) loading only when all other files on the available queue have been delt with accordingly.
		 * @param	autoLoad	<Boolean>	a value to determine whether to load sounds automatically of to wait for further instructions on the initialisation of any loading.
		 */
		public function AudioFactory(mode:String = MODE_MULTI, autoLoad:Boolean = true) 
		{
			super();
			_mode		= mode;
			_autoLoad	= autoLoad;
		}
		
		/**
		 * generate :: pass XML data to find and load (if autoLoad is set to true).
		 * @param	data	<XML>	data pertaining to the available audio files to download and store.
		 */
		public function generate(data:XML):void 
		{
			var queue:QueueFIFO		= getLoadQueue();
			var audio:AudioLoader	= null;
			for each (audio in passData(data)) 
			{
				if (!_CACHE.retrieveSound(audio.storedURL)) 
				{
					_CACHE.addSound(audio.storedURL, audio);
					queue.add(audio);
				}
			}
			checkAutoLoad();
		}
		
		/**
		 * forceLoad :: stop any current loading of files and load the audio file associated with the String value passed.
		 * @param	value	<String>	the URL value of the audio file to check for and load.
		 */
		public function forceLoad(value:String):void 
		{
			var queue:QueueFIFO		= getLoadQueue();
			var audio:AudioLoader	= null;
			if (queue) 
			{
				if (queue.current is AudioLoader) 
				{
					audio	= queue.current as AudioLoader;
					if (value == audio.storedURL) return;
					else audio.close();
				}
			}
			audio	= _CACHE.retrieveSound(value);
			if (audio && audio.loadComplete) return;
			else if (!audio) 
			{
				audio	= new AudioLoader(new URLRequest(value));
				_CACHE.addSound(value, audio);
			}
			applyAudioEventHandlers(audio);
			audio.load(new URLRequest(audio.storedURL), audio.loaderContext);
		}
		
		/**
		 * startQueue :: for use when autoLoad is set to false, to start the queues loading progress.
		 */
		public function startQueue():void 
		{
			var queue:QueueFIFO	= getLoadQueue();
			var audio:AudioLoader	= null;
			if (queue.current is AudioLoader) 
			{
				audio			= queue.current as AudioLoader;
				applyAudioEventHandlers(audio);
				audio.load(new URLRequest(audio.storedURL), audio.loaderContext);
			} else 
			{
				if (queue.next is AudioLoader) 
				{
					audio		= queue.current as AudioLoader;
					applyAudioEventHandlers(audio);
					audio.load(new URLRequest(audio.storedURL), audio.loaderContext);
				}
			}
		}
		
		/**
		 * checkAutoLoad :: if autoLoad is true and a queue is selected then load the available files in that queue.
		 */
		protected function checkAutoLoad():void
		{
			if (_autoLoad && getLoadQueue()) startQueue();
		}
		
		/**
		 * getLoadQueue :: find the currently selected queue and return that queue.
		 * @return	<QueueFIFO>	a selection of one of the two available queuing systems.
		 */
		protected function getLoadQueue():QueueFIFO 
		{
			var queue:QueueFIFO		= null;
			switch (_mode) 
			{
				
				case MODE_MULTI:
					queue		= _QUEUE;
					break;
					
				case MODE_MULTI_STATIC:
					queue		= _STATIC_QUEUE;
					break;
					
			}
			return queue;
		}
		
		/**
		 * applyAudioEventHandlers :: add the event handlers to the individual AudioLoader class.
		 * @param	audio	<AudioLoader> the object to assign the event handlers to.
		 */
		protected function applyAudioEventHandlers(audio:AudioLoader):void 
		{
			audio.addEventListener(ProgressEvent.PROGRESS, audioLoadProgressHandler);
			audio.addEventListener(Event.COMPLETE, audioLoadCompleteHandler);
			audio.addEventListener(IOErrorEvent.IO_ERROR, audioLoadIOErrorHandler);
		}
		
		/**
		 * removeAudioEventHandlers :: remove the event handlers from the individual AudioLoader class.
		 * @param	audio	<AudioLoader> the object to remove the event handlers from.
		 */
		protected function removeAudioEventHandlers(audio:AudioLoader):void 
		{
			audio.removeEventListener(ProgressEvent.PROGRESS, audioLoadProgressHandler);
			audio.removeEventListener(Event.COMPLETE, audioLoadCompleteHandler);
			audio.removeEventListener(IOErrorEvent.IO_ERROR, audioLoadIOErrorHandler);
		}
		
		/**
		 * audioLoadProgressHandler :: assign the current progress of the loading asset to a variable.
		 * @param	event	<ProgressEvent>	the event dispatched from the loading asset when progress has been made in aquiring its data.
		 */
		protected function audioLoadProgressHandler(event:ProgressEvent):void 
		{
			_currentLoadProgress		= event.bytesLoaded / event.bytesTotal;
			var totalProgress:Number	= (getLoadQueue().length - 1 + _currentLoadProgress) / getLoadQueue().total;
			var audio:AudioLoader		= event.target as AudioLoader;
			dispatchEvent(new LoadFactoryProgressEvent(LoadFactoryProgressEvent.PROGRESS, true, true, null, audio.storedURL, totalProgress));
		}
		
		/**
		 * audioLoadCompleteHandler :: when an AudioLoader has completed its download this handler determines if there is another AudioLoader to download information for in the queue and start that loading process off.
		 * @param	event	<Event>	the event dispatched from the loading object detailing that the asset has downloaded completely.
		 */
		protected function audioLoadCompleteHandler(event:Event):void 
		{
			var queue:QueueFIFO				= getLoadQueue();
			var audio:AudioLoader			= event.target as AudioLoader;
			if (audio) 
			{
				removeAudioEventHandlers(audio);
				dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.COMPLETE, true, true, null, audio.storedURL));
			}
			if (queue)
			{
				audio						= queue.current;
				if (audio.loadComplete) 
					audio					= queue.next;
				if (audio) 
				{
					applyAudioEventHandlers(audio);
					audio.load(new URLRequest(audio.storedURL), audio.loaderContext);
				} else 
				{
					dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.FINISHED, true, true));
					_currentLoadProgress	= QUEUE_COMPLETE;
				}
			}
		}
		
		/**
		 * audioLoadIOErrorHandler :: a handler for when an asset is not found on a server, determining if there are any further objects to download in the queue system and to start the prcess off for that AudioLoader.
		 * @param	event	<IOErrorEvent>	event dispatched from the loading object.
		 */
		protected function audioLoadIOErrorHandler(event:IOErrorEvent):void 
		{
			var queue:QueueFIFO		= getLoadQueue();
			var audio:AudioLoader	= event.target as AudioLoader;
			if (audio) removeAudioEventHandlers(audio);
			if (queue)
			{
				audio				= queue.next;
				if (audio) 
				{
					applyAudioEventHandlers(audio);
					audio.load(new URLRequest(audio.storedURL), audio.loaderContext);
				} else dispatchEvent(new LoadFactoryEvent(LoadFactoryEvent.FINISHED));
			}
		}
		
		/**
		 * passData :: from the passed data, loop through an XMLList and find all available Audio objects to load.
		 * @param	data	<XML>	the data containing the audio information.
		 * @return	<Array>	an Array object containing all the available audio objects.
		 */
		protected function passData(data:XML):Array 
		{
			var rtn:Array					= new Array();
			var _data:XML					= null;
			var audio:AudioLoader			= null;
			var context:SoundLoaderContext	= null;
			var item:XML					= null;
			if (String(data.name()) == XML_AUDIO) _data	= data;
			else if (data[XML_AUDIO].length()) _data	= data;
			else if (data..*[XML_AUDIO].length()) _data	= data;
			else _data									= data;
			for each (item in _data) 
			{
				audio						= new AudioLoader();
				audio.storedURL				= String(item[XML_STREAM][0]);
				audio.loaderContext			= createSoundLoaderContext(item);
				rtn.push(audio);
				context						= null;
			}
			return rtn;
		}
		
		/**
		 * createSoundLoaderContext :: find informaiton pertaining to the SoundLoaderContext objects upon the available data and create a policy if required.
		 * @param	data	<XML>	data containing the policy object informaiton.
		 * @return	<SoundLoaderContext>	the object generated fromt he data passed.
		 */
		protected function createSoundLoaderContext(data:XML):SoundLoaderContext 
		{
			var rtn:SoundLoaderContext	= new SoundLoaderContext();
			var item:XML				= null;
			if (data..*.@bufferTime.length()) 
			{
				rtn.bufferTime			= Number(data.@bufferTime);
				if (data..*.@checkPolicyFile.length()) 
					rtn.checkPolicyFile	= (String(data..*.@checkPolicyFile) == XML_TRUE)? true: false;
			}
			if (data..*.bufferTime.length()) 
			{
				rtn.bufferTime			= Number(data..*.bufferTime);
				if (data..*.checkPolicyFile.length()) 
					rtn.checkPolicyFile	= (String(data..*.checkPolicyFile) == XML_TRUE)? true: false;
			}
			if (rtn.bufferTime) return rtn;
			return null;
		}
		
	}
	
}