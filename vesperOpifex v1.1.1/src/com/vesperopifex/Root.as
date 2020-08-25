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
package com.vesperopifex 
{
	import com.vesperopifex.audio.AudioFactory;
	import com.vesperopifex.data.IUXTracking;
	import com.vesperopifex.data.UXTracking;
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.display.GraphicFactory;
	import com.vesperopifex.display.book.GraphicPage;
	import com.vesperopifex.display.book.utils.PageManager;
	import com.vesperopifex.display.utils.PreloadVisualStack;
	import com.vesperopifex.events.LoadFactoryEvent;
	import com.vesperopifex.events.LoadFactoryProgressEvent;
	import com.vesperopifex.events.XMLFactoryEvent;
	import com.vesperopifex.events.XMLFactoryProgressEvent;
	import com.vesperopifex.external.ExternalAPI;
	import com.vesperopifex.fonts.FontLoader;
	import com.vesperopifex.tweens.XMLAnimation;
	import com.vesperopifex.utils.AbstractLoader;
	import com.vesperopifex.utils.CacheLoadFactory;
	import com.vesperopifex.utils.IBrowserIntegration;
	import com.vesperopifex.utils.LoadContext;
	import com.vesperopifex.utils.LoadFactory;
	import com.vesperopifex.utils.Settings;
	import com.vesperopifex.utils.StageManager;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import com.vesperopifex.utils.controllers.RootEventControl;
	import com.vesperopifex.xml.XMLFactory;
	import com.vesperopifex.xml.XMLStore;
	import flash.display.LoaderInfo;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	// mxmlc com\vesperopifex\Root.as -output ..\bin\content\swf\vesperopifex.swf -sp . -use-network=false
	// mxmlc com/vesperopifex/Root.as -output ../bin/content/swf/vesperopifex.swf -sp . -use-network=false
	[SWF(width="900", height="550", backgroundColor="0xffffff", frameRate="30")]
	
	public class Root extends StageManager 
	{
		protected static var AssetLoader:CacheLoadFactory	= new CacheLoadFactory(LoadFactory.STATIC_MULTI_MODE);
		protected static var fontsLoader:FontLoader			= new FontLoader(LoadFactory.STATIC_MULTI_MODE);
		protected static var audioLoader:AudioFactory		= new AudioFactory(AudioFactory.MODE_MULTI_STATIC);
		protected static var XMLLoader:XMLFactory			= new XMLFactory();
		protected static var flashVarsStore:Object			= new Object();
		protected static var dataStore:XMLStore				= new XMLStore();
		protected static var _pageManager:PageManager		= new PageManager();
		
		public static const MANAGER:PageManager				= _pageManager;
		public static const LANGUAGE:String					= XMLLoader.language;
		
		protected var _eventController:RootEventControl		= null;
		protected var _assetsLoaded:Boolean					= false;
		protected var _fontsLoaded:Boolean					= false;
		protected var _audioLoaded:Boolean					= false;
		protected var _preloaderVisual:PreloadVisualStack	= null;
		
		/**
		 * Constructor.
		 */
		public function Root() 
		{
			trace(Settings.HEADER);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * entry point for class.
		 * @param	event	<Event>
		 */
		protected function init(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_eventController	= new RootEventControl(MANAGER);
			arrangeStage();
			arrangeFlashVariables();
			addTrackDispatcher();
			addLoaderVisual();
			initLoad();
		}
		
		/**
		 * set stage variables.
		 */
		protected function arrangeStage():void 
		{
			stage.scaleMode		= StageScaleMode.NO_SCALE;
			var version:String	= Capabilities.version;
			Settings.version	= version.slice(version.indexOf(" ") + 1).split(",");
			Settings.debugMode	= false;
		}
		
		/**
		 * flash variables passed.
		 */
		protected function arrangeFlashVariables():void 
		{
			Settings.flashVariables			= LoaderInfo(stage.loaderInfo).parameters;
		    for (var prop:String in Settings.flashVariables) 
		    {
				switch (prop) 
				{
					
					case Settings.FLASHVAR_DEEPLINK:
						Settings.deeplink	= String(Settings.flashVariables[prop]).split(Settings.PAGE_DELIMINATOR);
						break;
						
					case Settings.FLASHVAR_DIRECTORY:
						Settings.directory	= String(Settings.flashVariables[prop]);
						break;
						
					case Settings.FLASHVAR_CONTENT:
						Settings.content	= String(Settings.flashVariables[prop]);
						break;
						
					case Settings.FLASHVAR_LANGUAGE:
						Settings.LANGUAGE	= String(Settings.flashVariables[prop]);
						break;
						
				}
		    }
		}
		
		/**
		 * add a tracker to the framework depending if data is passed for not an object will be generated from the data or a generic tracking service calling a function in JavaScript will be created.
		 * @param	data	<XML>	data pertaining to the IUXTracking object to be generated.
		 */
		protected function addTrackDispatcher(data:XML = null):void 
		{
			if (_eventController) 
			{
				if (!data) _eventController.trackDispatcher		= new UXTracking();
				else 
				{
					var tracker:GraphicComponentObject			= null;
					for each (tracker in XMLGraphicDisplay.createGraphics(data)) 
					{
						if (tracker.graphic is AbstractLoader) return;
						if (tracker.graphic) 
							_eventController.trackDispatcher	= tracker.graphic as IUXTracking;
					}
				}
			}
		}
		
		/**
		 * add an object to integrate this application with the browser, allowing for browser history usage and bookmarking of pages.
		 * @param	data	<XML>	data pertaining to the IBrowserIntegration object to be generated.
		 */
		protected function addBrowserIntegration(data:XML = null):void 
		{
			if (!data || !_eventController) return;
			if (_eventController) 
			{
				var addressIntegration:GraphicComponentObject	= null;
				for each (addressIntegration in XMLGraphicDisplay.createGraphics(data)) 
				{
					if (addressIntegration.graphic is AbstractLoader) return;
					if (addressIntegration.graphic) 
						_eventController.addressDispatcher		= addressIntegration.graphic as IBrowserIntegration;
				}
			}
		}
		
		/**
		 * apply a loader visual to represent the amount of data loaded compared to the total, the data passed can be used to generate the visual.
		 * @param	data	<XML>	the data describing the visual generated.
		 */
		protected function addLoaderVisual(data:XML = null):void 
		{
			if (!data) return;
			else 
			{
				if (!_preloaderVisual) 
				{
					_preloaderVisual		= new PreloadVisualStack();
					addChild(_preloaderVisual);
				}
				_preloaderVisual.XMLData	= data;
			}
		}
		
		/**
		 * remove the loader visual described by the data passed.
		 * @param	data	<XML>	the data describing the visual generated previously.
		 */
		protected function removeLoaderVisual(data:XML = null):void 
		{
			if (!data) 
			{
				if (_preloaderVisual) removeChild(_preloaderVisual);
			} else _preloaderVisual.remove(data);
		}
		
		/**
		 * load the XML directory to compile the data
		 */
		protected function initLoad():void 
		{
			XMLLoader.addEventListener(XMLFactoryProgressEvent.PROGRESS, xmlProgressEventHandler);
			XMLLoader.addEventListener(XMLFactoryEvent.COMPLETE, xmlCompleteEventHandler);
			XMLLoader.addEventListener(XMLFactoryEvent.COMPILE, xmlCompileEventHandler);
			if (!Settings.content) XMLLoader.loadDirectory(Settings.directory, Settings.LANGUAGE);
			else XMLLoader.loadContent(Settings.content);
		}
		
		protected function xmlRegisterFontsEventHandler(event:XMLFactoryEvent):void 
		{
			
		}
		
		/**
		 * update the loader visual
		 * @param	event	<XMLFactoryEvent>
		 */
		protected function xmlProgressEventHandler(event:XMLFactoryProgressEvent):void 
		{
			// event.bytesLoaded / event.bytesTotal;
		}
		
		/**
		 * XML loading has completed
		 * @param	event	<XMLFactoryEvent>
		 */
		protected function xmlCompleteEventHandler(event:XMLFactoryEvent):void 
		{
			// the XMLLoader auto compiles the XML and sends an event once completed the compiling of the data
		}
		
		/**
		 * XML compile has completed
		 * @param	event	<XMLFactoryEvent>
		 */
		protected function xmlCompileEventHandler(event:XMLFactoryEvent):void 
		{
			XMLLoader.removeEventListener(XMLFactoryProgressEvent.PROGRESS, xmlProgressEventHandler);
			XMLLoader.removeEventListener(XMLFactoryEvent.COMPLETE, xmlCompleteEventHandler);
			XMLLoader.removeEventListener(XMLFactoryEvent.COMPILE, xmlCompileEventHandler);
			dataStore.data	= event.data;
			generatePreloaderVisuals();
			generateTrackDispatcher();
			generateFonts();
			generateAssets();
			generateAudio();
			if (_assetsLoaded && _fontsLoaded && _audioLoaded) buildBook();
		}
		
		/**
		 * if there is any audio to load, do it here. 
		 */		
		protected function generateAudio():void
		{
			if (dataStore.audio.children().length()) 
			{
				audioLoader.addEventListener(LoadFactoryProgressEvent.PROGRESS, audioProgressEventHandler);
				audioLoader.addEventListener(LoadFactoryEvent.COMPLETE, audioCompleteEventHandler);
				audioLoader.addEventListener(LoadFactoryEvent.FINISHED, audioFinishedEventHandler);
				for each (var item:XML in dataStore.audio.children()) audioLoader.generate(item);
			} else _audioLoaded	= true;
		}
		
		/**
		 * pass the available XML data and load in all assets described by the data.
		 */
		protected function generateAssets():void
		{
			if (dataStore.preload.children().length()) 
			{
				AssetLoader.addEventListener(LoadFactoryProgressEvent.PROGRESS, dataProgressEventHandler);
				AssetLoader.addEventListener(LoadFactoryEvent.COMPLETE, dataCompleteEventHandler);
				AssetLoader.addEventListener(LoadFactoryEvent.FINISHED, dataFinishedEventHandler);
				for each (var item:XML in dataStore.preload.children()) AssetLoader.load(String(item), LoadContext.create(item), (item.@[GraphicFactory.XML_ENFORCED].length())? String(item.@[GraphicFactory.XML_ENFORCED]): null);
			} else _assetsLoaded	= true;
		}
		
		/**
		 * pass the available XML data and load in all fonts described by the data.
		 */
		protected function generateFonts():void
		{
			if (dataStore.fonts.children().length()) 
			{
				fontsLoader.addEventListener(LoadFactoryProgressEvent.PROGRESS, fontsProgressEventHandler);
				fontsLoader.addEventListener(LoadFactoryEvent.COMPLETE, fontsCompleteEventHandler);
				fontsLoader.addEventListener(LoadFactoryEvent.FINISHED, fontsFinishedEventHandler);
				for each (var item:XML in dataStore.fonts.children()) fontsLoader.load(String(item), LoadContext.create(item), (item.@[GraphicFactory.XML_ENFORCED].length())? String(item.@[GraphicFactory.XML_ENFORCED]): null);
			} else _fontsLoaded		= true;
		}
		
		/**
		 * pass the available XML data and generate the browser integration object described by the data.
		 */
		protected function generateBrowserIntegration():void
		{
			if (dataStore.system[GraphicFactory.XML_BROWSER_INTEGRATION].length()) 
				for each (var item:XML in dataStore.system[GraphicFactory.XML_BROWSER_INTEGRATION]) 
					addBrowserIntegration(item);
		}
		
		/**
		 * pass the available XML data and generate the tracking object described by the data.
		 */
		protected function generateTrackDispatcher():void
		{
			if (dataStore.system[UXTracking.XML_TRACKING_OBJECT].length()) 
				for each (var item:XML in dataStore.system[UXTracking.XML_TRACKING_OBJECT]) 
					addTrackDispatcher(item);
		}
		
		/**
		 * pass the available XML data and generate the loading visuals described by the data.
		 */
		protected function generatePreloaderVisuals():void
		{
			if (dataStore.system[PreloadVisualStack.XML_PRELOAD_VISUAL_STACK].length()) 
				for each (var item:XML in dataStore.system[PreloadVisualStack.XML_PRELOAD_VISUAL_STACK]) 
					addLoaderVisual(item);
		}
		
		/**
		 * progress of all assets set for preloading.
		 * @param	event	<LoadFactoryEvent>	the Event dispatched from the loading factory.
		 */
		protected function dataProgressEventHandler(event:LoadFactoryProgressEvent):void 
		{
			if (!_preloaderVisual) return;
			var loader:AbstractLoader	= event.loader;
			_preloaderVisual.update(loader.bytesLoaded / loader.bytesTotal, loader.storedURL);
		}
		
		/**
		 * all assets have completed loading.
		 * @param	event	<LoadFactoryEvent>	the Event dispatched from the loading factory.
		 */
		protected function dataCompleteEventHandler(event:LoadFactoryEvent):void 
		{
			
		}
		
		/**
		 * notification that all external assets defined for preload are completed loading and ready for use.
		 * @param	event	<LoadFactoryEvent>	the Event dispatched from the loading factory.
		 */
		protected function dataFinishedEventHandler(event:LoadFactoryEvent):void 
		{
			AssetLoader.removeEventListener(LoadFactoryProgressEvent.PROGRESS, dataProgressEventHandler);
			AssetLoader.removeEventListener(LoadFactoryEvent.COMPLETE, dataCompleteEventHandler);
			AssetLoader.removeEventListener(LoadFactoryEvent.FINISHED, dataFinishedEventHandler);
			_assetsLoaded	= true;
			if (_fontsLoaded && _audioLoaded) 
			{
				buildBook();
				return;
			}
			if (fontsLoader.mode == LoadFactory.STATIC_MULTI_MODE && !_fontsLoaded) fontsFinishedEventHandler(event);
		}
		
		/**
		 * progress of all fonts set for preloading.
		 * @param	event	<LoadFactoryEvent>	the Event dispatched from the loading factory.
		 */
		protected function fontsProgressEventHandler(event:LoadFactoryProgressEvent):void 
		{
			if (!_preloaderVisual) return;
			var loader:AbstractLoader	= event.loader;
			_preloaderVisual.update(loader.bytesLoaded / loader.bytesTotal, loader.storedURL);
		}
		
		/**
		 * all fonts have completed loading.
		 * @param	event	<LoadFactoryEvent>	the Event dispatched from the loading factory.
		 */
		protected function fontsCompleteEventHandler(event:LoadFactoryEvent):void 
		{
			
		}
		
		/**
		 * notification that all fonts have completed loading and are ready for use.
		 * @param	event	<LoadFactoryEvent>	the Event dispatched from the loading factory.
		 */
		protected function fontsFinishedEventHandler(event:LoadFactoryEvent):void 
		{
			fontsLoader.removeEventListener(LoadFactoryProgressEvent.PROGRESS, fontsProgressEventHandler);
			fontsLoader.removeEventListener(LoadFactoryEvent.COMPLETE, fontsCompleteEventHandler);
			fontsLoader.removeEventListener(LoadFactoryEvent.FINISHED, fontsFinishedEventHandler);
			_fontsLoaded	= true;
			if (_assetsLoaded && _audioLoaded) 
			{
				buildBook();
				return;
			}
			if (fontsLoader.mode == LoadFactory.STATIC_MULTI_MODE && !_assetsLoaded) dataFinishedEventHandler(event);
		}
		
		/**
		 * update the loading visual to represent the loaded amount determined by the passed progress value.
		 * @param	event	<LoadFactoryProgressEvent>	the event dispatched from the LoaderFactory.
		 */
		protected function audioProgressEventHandler(event:LoadFactoryProgressEvent):void 
		{
			if (!_preloaderVisual) return;
			_preloaderVisual.update(event.progress, event.url);
		}
		
		/**
		 * once an audio file has completed loading this method will be called.
		 * @param	event	<LoadFactoryProgressEvent>	the event dispatched from the LoaderFactory.
		 */
		protected function audioCompleteEventHandler(event:LoadFactoryEvent):void 
		{
			
		}
		
		/**
		 * once all audio files have been loaded this method will be called.
		 * @param	event	<LoadFactoryProgressEvent>	the event dispatched from the LoaderFactory.
		 */
		protected function audioFinishedEventHandler(event:LoadFactoryEvent):void 
		{
			audioLoader.removeEventListener(LoadFactoryProgressEvent.PROGRESS, audioProgressEventHandler);
			audioLoader.removeEventListener(LoadFactoryEvent.COMPLETE, audioCompleteEventHandler);
			audioLoader.removeEventListener(LoadFactoryEvent.FINISHED, audioFinishedEventHandler);
			_audioLoaded	= true;
			if (_assetsLoaded && _fontsLoaded) buildBook();
		}
		
		/**
		 * make sure there is no additional animations to load and call the method to build the flash asset from the available XML data.
		 */
		protected function buildBook():void 
		{
			XMLAnimation.data	= dataStore.animation;
			if (XMLAnimation.loading) 
			{
				XMLAnimation.dispatcher.addEventListener(Event.COMPLETE, buildCompletion);
				return;
			}
			buildCompletion();
		}
		
		/**
		 * build the site with the availbale XML data.
		 * @param	event	<Event>	an event dispatched from the XMLAnimation loader [optional].
		 */
		protected function buildCompletion(event:Event = null):void 
		{
			GraphicFactory.GENERIC_UI_OBJECTS.registerClasses();
			if (!_eventController.trackDispatcher) generateTrackDispatcher();
			if (!_eventController.addressDispatcher) generateBrowserIntegration();
			MANAGER.language			= LANGUAGE;
			var root:GraphicPage		= MANAGER.build(dataStore.pages);
			_eventController.listener	= root;
			removeLoaderVisual();
			addChild(root);
			MANAGER.openPage(Settings.deeplink);
		}
		
	}
	
}