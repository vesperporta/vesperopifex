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
package com.vesperopifex.display.book 
{
	import com.vesperopifex.events.LoadFactoryEvent;
	import com.vesperopifex.events.LoadFactoryProgressEvent;
	import com.vesperopifex.events.XMLFactoryEvent;
	import com.vesperopifex.events.XMLFactoryProgressEvent;
	import com.vesperopifex.Root;
	import com.vesperopifex.utils.CacheLoadFactory;
	import com.vesperopifex.utils.LoadContext;
	import com.vesperopifex.xml.XMLFactory;
	import com.vesperopifex.xml.XMLStore;
	
	public class GraphicPreloadPage extends GraphicAnimatedPage 
	{
		protected static const PRELOAD_NAME:String			= "load";
		protected static const XML_DIRECTORY_NAME:String	= "directory";
		
		protected static var AssetLoader:CacheLoadFactory	= new CacheLoadFactory();
		
		protected var XMLLoader:XMLFactory					= new XMLFactory();
		protected var dataStore:XMLStore					= new XMLStore();
		protected var _language:String						= null;
		protected var _built:Boolean						= false;
		
		/**
		 * PreloadChapter :: Constructor
		 */
		public function GraphicPreloadPage(id:String, xml:XML, lang:String = null) 
		{
			if (lang != null) _language = lang;
			super(id, xml);
		}
		
		/**
		 * close :: close the current component
		 */
		public override function close():void 
		{
			AssetLoader.close();
			// need to do something about any loader visuals here, reset them as any data loaded and stopped without finishing will be removed.
			super.close();
		}
		
		/**
		 * openPage :: override to run intro animation
		 */
		protected override function openPage():void 
		{
			if (_built) super.openPage();
			else 
			{
				addLoaderVisual();
				XMLLoader.addEventListener(XMLFactoryProgressEvent.PROGRESS, xmlProgressEventHandler);
				XMLLoader.addEventListener(XMLFactoryEvent.COMPLETE, xmlCompleteEventHandler);
				XMLLoader.addEventListener(XMLFactoryEvent.COMPILE, xmlCompileEventHandler);
				XMLLoader.loadDirectory(_data[XMLFactory.XML_DIRECTORY], _language);
			}
		}
		
		/**
		 * xmlProgressEventHandler :: update the loader visual
		 * @param	event	<XMLFactoryEvent>
		 */
		protected function xmlProgressEventHandler(event:XMLFactoryProgressEvent):void 
		{
			// event.bytesLoaded / event.bytesTotal;
		}
		
		/**
		 * xmlCompleteEventHandler :: XML loading has completed
		 * @param	event	<XMLFactoryEvent>
		 */
		protected function xmlCompleteEventHandler(event:XMLFactoryEvent):void 
		{
			// the XMLLoader auto compiles the XML and sends an event once completed the compiling of the data
		}
		
		/**
		 * xmlCompileEventHandler :: XML compile has completed
		 * @param	event	<XMLFactoryEvent>
		 */
		protected function xmlCompileEventHandler(event:XMLFactoryEvent):void 
		{
			XMLLoader.removeEventListener(XMLFactoryProgressEvent.PROGRESS, xmlProgressEventHandler);
			XMLLoader.removeEventListener(XMLFactoryEvent.COMPLETE, xmlCompleteEventHandler);
			XMLLoader.removeEventListener(XMLFactoryEvent.COMPILE, xmlCompileEventHandler);
			
			dataStore.data = event.data;
			if (dataStore.preload.children().length()) 
			{
				AssetLoader.addEventListener(LoadFactoryProgressEvent.PROGRESS, dataProgressEventHandler);
				AssetLoader.addEventListener(LoadFactoryEvent.COMPLETE, dataCompleteEventHandler);
				AssetLoader.addEventListener(LoadFactoryEvent.FINISHED, dataFinishedEventHandler);
				for each (var item:XML in dataStore.preload.children()) AssetLoader.load(item, LoadContext.create(item));
			} else buildChapter();
		}
		
		private function dataFinishedEventHandler(event:LoadFactoryEvent):void 
		{
			AssetLoader.removeEventListener(LoadFactoryProgressEvent.PROGRESS, dataProgressEventHandler);
			AssetLoader.removeEventListener(LoadFactoryEvent.COMPLETE, dataCompleteEventHandler);
			AssetLoader.removeEventListener(LoadFactoryEvent.FINISHED, dataFinishedEventHandler);
			buildChapter();
		}
		
		/**
		 * dataCompleteEventHandler :: on completion of all assets downloading run this to complete any animations into the scene
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function dataCompleteEventHandler(event:LoadFactoryEvent):void 
		{
			
		}
		
		/**
		 * dataProgressEventHandler :: during the preloading of the assets for the children, use this event handler to gain access to the percentage of data downloaded.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function dataProgressEventHandler(event:LoadFactoryProgressEvent):void 
		{
			// update preloader visual here.
		}
		
		/**
		 * buildChapter :: create the layout for the chapter
		 */
		protected function buildChapter():void 
		{
			removeLoaderVisual();
			_data = dataStore.data;
			var chap:GraphicPage = null;
			if (dataStore.pages.children().length()) chap = Root.MANAGER.build(dataStore.pages, this);
			_built = true;
			super.openPage();
		}
		
	}
	
}