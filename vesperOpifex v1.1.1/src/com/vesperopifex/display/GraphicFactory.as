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
package com.vesperopifex.display 
{
	import com.vesperopifex.data.AssetCache;
	import com.vesperopifex.data.BitmapCache;
	import com.vesperopifex.display.ui.GenericUiObjects;
	import com.vesperopifex.events.ClassLoaderEvent;
	import com.vesperopifex.events.GraphicFactoryEvent;
	import com.vesperopifex.events.GraphicFactoryProgressEvent;
	import com.vesperopifex.events.LoadFactoryEvent;
	import com.vesperopifex.events.LoadFactoryProgressEvent;
	import com.vesperopifex.events.StyleSheetFactoryEvent;
	import com.vesperopifex.text.TextFactory;
	import com.vesperopifex.utils.AbstractLoader;
	import com.vesperopifex.utils.CacheLoadFactory;
	import com.vesperopifex.utils.ClassFactory;
	import com.vesperopifex.utils.ClassLoader;
	import com.vesperopifex.utils.ImageFactory;
	import com.vesperopifex.utils.LoadFactory;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	public class GraphicFactory extends EventDispatcher 
	{
		public static const IMAGE_CACHE:BitmapCache					= new BitmapCache();
		public static const ASSET_CACHE:AssetCache					= new AssetCache();
		public static const GENERIC_UI_OBJECTS:GenericUiObjects		= new GenericUiObjects();
		public static const XML_GRAPHIC:String						= "graphic";
		public static const XML_CONTENT:String						= "content";
		public static const XML_ID:String							= "id";
		public static const XML_ENFORCED:String						= "enforced";
		public static const XML_BROWSER_INTEGRATION:String			= "browserIntegration";
		public static const XML_URL_CLASS:String					= "urlClass";
		public static const XML_URL:String							= "url";
		public static const XML_CLASS:String						= "class";
		public static const XML_LIBRARY_CLASS:String				= "libraryClass";
		public static const XML_DEFINITION:String					= "definition";
		public static const XML_TYPE:String							= "type";
		public static const VOID:String								= "void";
		
		private static var REGISTERED_GENERATORS:Array				= new Array();
		
		protected var TEXT_FACTORY:TextFactory						= new TextFactory();
		protected var LOAD_FACTORY:CacheLoadFactory					= new CacheLoadFactory();
		protected var CLASS_LOADER:ClassLoader						= new ClassLoader();
		protected var CLASS_FACTORY:ClassFactory					= new ClassFactory();
		protected var IMAGE_FACTORY:ImageFactory					= new ImageFactory();
		protected var GRAPHIC_FACTORY:GraphicSpriteFactory			= new GraphicSpriteFactory();
		protected var FILTER_FACTORY:FilterFactory					= new FilterFactory();
		protected var _fileProgess:Number							= -1;
		protected var _dispatchIDs:Array							= new Array();
		protected var _stylesLoaded:Array							= new Array();
		
		/**
		 * fileProgess :: getter for the file(s) progress of loading if loading is required
		 */
		public function get fileProgess():Number { return _fileProgess; }
		
		/**
		 * register a graphical generator here, passing in the ID to look for and the Function to generate the DisplayObject.
		 * @param	type	<String>	the identifier to look for in the XML data.
		 * @param	method	<Function>	the funciton to generate the resulting DisplayObject.
		 * @return	<Boolean>	a value to determin if the generator has been registered already, false, or not, true.
		 */
		public static function registerGenerator(type:String, method:Function):Boolean 
		{
			for each (var object:GeneratorObject in REGISTERED_GENERATORS) if (object.type == type) return false;
			REGISTERED_GENERATORS.push(new GeneratorObject(type, method));
			return true;
		}
		
		/**
		 * find if the registered object is actually registered.
		 * @param	type	<String>	the identifier of the registrated object.
		 * @return	<Boolean>	true is returned if the type is found, false is returned if not.
		 */
		public static function findRegisteredGenerator(type:String):Boolean 
		{
			for each (var object:GeneratorObject in REGISTERED_GENERATORS) if (object.type == type) return true;
			return false;
		}
		
		/**
		 * GraphicFactory :: Constructor.
		 */
		public function GraphicFactory() 
		{
			super();
			
			LOAD_FACTORY.addEventListener(LoadFactoryEvent.COMPLETE, LoadFactoryCompleteEventHandler);
			LOAD_FACTORY.addEventListener(LoadFactoryEvent.NEW_FILE, LoadFactoryNewFileEventHandler);
			LOAD_FACTORY.addEventListener(LoadFactoryEvent.FINISHED, LoadFactoryFinishedEventHandler);
			LOAD_FACTORY.addEventListener(LoadFactoryEvent.ERROR, ImageFactoryErrorEventHandler);
			LOAD_FACTORY.addEventListener(LoadFactoryEvent.FATAL_ERROR, ImageFactoryFatalErrorEventHandler);
			LOAD_FACTORY.addEventListener(LoadFactoryProgressEvent.PROGRESS, LoadFactoryProgressEventHandler);
			
			CLASS_LOADER.addEventListener(LoadFactoryEvent.COMPLETE, ClassFactoryCompleteEventHandler);
			CLASS_LOADER.addEventListener(LoadFactoryEvent.NEW_FILE, ClassFactoryNewFileEventHandler);
			CLASS_LOADER.addEventListener(LoadFactoryEvent.FINISHED, ClassFactoryFinishedEventHandler);
			CLASS_LOADER.addEventListener(LoadFactoryEvent.ERROR, ImageFactoryErrorEventHandler);
			CLASS_LOADER.addEventListener(LoadFactoryEvent.FATAL_ERROR, ImageFactoryFatalErrorEventHandler);
			CLASS_LOADER.addEventListener(LoadFactoryProgressEvent.PROGRESS, ClassFactoryProgressEventHandler);
			CLASS_LOADER.addEventListener(ClassLoaderEvent.CLASS, ClassLoaderClassEventHandler);
			
			IMAGE_FACTORY.addEventListener(LoadFactoryEvent.COMPLETE, ImageFactoryCompleteEventHandler);
			IMAGE_FACTORY.addEventListener(LoadFactoryEvent.NEW_FILE, ImageFactoryNewFileEventHandler);
			IMAGE_FACTORY.addEventListener(LoadFactoryEvent.FINISHED, ImageFactoryFinishedEventHandler);
			IMAGE_FACTORY.addEventListener(LoadFactoryEvent.ERROR, ImageFactoryErrorEventHandler);
			IMAGE_FACTORY.addEventListener(LoadFactoryEvent.FATAL_ERROR, ImageFactoryFatalErrorEventHandler);
			IMAGE_FACTORY.addEventListener(LoadFactoryProgressEvent.PROGRESS, ImageFactoryProgressEventHandler);
			
			TEXT_FACTORY.addEventListener(StyleSheetFactoryEvent.COMPLETE, styleSheetCompleteHandler);
		}
		
		/**
		 * generate :: create any graphical object from the data supplied from the XML data. 
		 * @param	data	<XML>	data outlined in either the format of attributes or child nodes.
		 * @return	<*>	the resulting display object.
		 */
		public function generate(data:XML):DisplayObject 
		{
			var rtn:DisplayObject	= null;
			var ldr:AbstractLoader	= null;
			var type:String			= null;
			var URL:String			= null;
			var libraryClass:String	= null;
			var content:String		= null;
			var shape:XMLList		= null;
			var enforce:String		= null;
			if (data.@type.length()) type					= String(data.@type);
			else if (data.type.length()) type				= String(data.type);
			if (data[XML_ENFORCED].length()) enforce		= String(data[XML_ENFORCED]);
			else if (data.@[XML_ENFORCED].length()) enforce	= String(data.@[XML_ENFORCED]);
			if (data.@[XML_DEFINITION].length()) URL		= String(data.@[XML_DEFINITION]);
			else if (data[XML_DEFINITION].length()) URL		= String(data[XML_DEFINITION]);
			// check the type of graphic to create, manufacture according to data, return result.
			switch (GraphicCheck.check(type)) 
			{
				case GraphicCheck.VECTOR_GRAPHIC:
					rtn = GRAPHIC_FACTORY.generate(data);
					break;
					
				case GraphicCheck.TEXT_GRAPHIC:
					rtn = TEXT_FACTORY.generate(data);
					break;
					
				case GraphicCheck.IMAGE_GRAPHIC:
					if (!URL) 
					{
						if (data.@[XML_URL].length()) URL		= String(data.@[XML_URL]);
						else if (data[XML_URL].length()) URL	= String(data[XML_URL]);
						else URL								= VOID;
					}
					if (URL != VOID) 
					{
						ldr = IMAGE_FACTORY.load(URL, null, enforce);
						if (ldr.loadCompleted) rtn = IMAGE_FACTORY.retrieveImage(URL);
						else rtn = ldr;
					}
					break;
					
				case GraphicCheck.LIBRARY_GRAPHIC:
					if (!URL) 
					{
						if (data.@[XML_LIBRARY_CLASS].length()) URL		= String(data.@[XML_LIBRARY_CLASS]);
						else if (data[XML_LIBRARY_CLASS].length()) URL	= String(data[XML_LIBRARY_CLASS]);
					}
					rtn = CLASS_FACTORY.retrieveAsDisplayObject(URL);
					if (!rtn && URL.indexOf(ClassFactory.CLASS_DELIMINATOR) != -1) 
					{
						var lib:String	= URL.slice(0, URL.indexOf(ClassFactory.CLASS_DELIMINATOR));
						var obj:String	= URL.slice(URL.indexOf(ClassFactory.CLASS_DELIMINATOR) + ClassFactory.CLASS_DELIMINATOR.length);
						rtn				= CLASS_FACTORY.retrieveAsDisplayObject(obj, null, lib);
					}
					break;
					
				case GraphicCheck.CLASS_GRAPHIC:
					if (!URL) 
					{
						if (data.@[XML_URL_CLASS].length()) URL		= String(data.@[XML_URL_CLASS]);
						else if (data[XML_URL_CLASS].length()) URL	= String(data[XML_URL_CLASS]);
						else URL									= VOID;
					}
					if (URL != VOID) 
					{
						ldr = LOAD_FACTORY.load(ClassLoader.getURL(URL), null, enforce);
						if (ldr.loadCompleted) rtn = CLASS_LOADER.retrieveDisplayObject(URL);
						else 
						{
							ldr.storedURL = URL;
							rtn = ldr;
							_dispatchIDs.push(new ClassDispatchCache(ldr.contentLoaderInfo.url, URL, ldr));
						}
					}
					break;
					
				case GraphicCheck.VIDEO_GRAPHIC:
					if (!URL) 
					{
						if (data.@[XML_URL].length()) URL		= String(data.@[XML_URL]);
						else if (data[XML_URL].length()) URL	= String(data[XML_URL]);
						else URL								= VOID;
					}
					rtn = LOAD_FACTORY.load(URL, null, enforce);
					break;
					
				case GraphicCheck.MASK_GRAPHIC:
					rtn = generateMask(data);
					break;
			}
			if (!rtn) rtn	= generateFromRegistered(data);
			if (rtn is IGraphicRegister && !findRegisteredGenerator((rtn as IGraphicRegister).XML_IDENTIFIER)) registerGenerator((rtn as IGraphicRegister).XML_IDENTIFIER, (rtn as IGraphicRegister).generateGraphicObject);
			if (!(rtn is AbstractLoader) && FilterFactory.checkFilters(data)) rtn.filters = FILTER_FACTORY.generate(data);
			return rtn;
		}
		
		/**
		 * find if the data block is a form of registered object pertaining to a Class specific generator.
		 * @param	data	<XML>	the data requesting to find if there is a generator for this data block.
		 * @return	<Boolean>	a true value is returned if the value is found to be registered and false if not.
		 */
		public function registeredXMLIdentifier(data:XML):Boolean 
		{
			var object:GeneratorObject	= null;
			for each (object in REGISTERED_GENERATORS) if (object.type	== String(data.name())) return true;
			return false;
		}
		
		/**
		 * run through all the registered objercts and return the resulting DisplayObject from the Class specific generator.
		 * @param	data	<XML>	the data requested to be generated from one of the registered Class's.
		 * @return	<DisplayObject>	the resulting object to be added to the display stack.
		 */
		protected function generateFromRegistered(data:XML):DisplayObject
		{
			var object:GeneratorObject	= null;
			var type:String				= null;
			var rtn:DisplayObject		= null;
			if (data.@type.length()) 
				type					= String(data.@type);
			else if (data.type.length()) 
				type					= String(data.type);
			for each (object in REGISTERED_GENERATORS) 
				if (object.type	== type || object.type == String(data.name())) 
					rtn	= object.method(data);
			return rtn;
		}
		
		/**
		 * generateMask :: in the case of generating a mask it is simpler to have the function externally to the main generator.
		 * @param	data	<XML>	data corresponding to the visual elements within the mask.
		 * @return	<DisplayObject>
		 */
		protected function generateMask(data:XML):DisplayObject 
		{
			// todo: this needs to be extended to the new set of graphics being allowed for genration.
			var rtn:MaskSprite	= new MaskSprite();
			for each (var item:XML in data[XML_GRAPHIC]) rtn.addChild(generate(item));
			return rtn as DisplayObject;
		}
		
		/**
		 * dispatchProgress :: dispatch the current loading progress of any files being loaded.
		 */
		protected function dispatchProgress():void 
		{
			dispatchEvent(new GraphicFactoryProgressEvent(GraphicFactoryProgressEvent.PROGRESS, true, true, getCompleteProgress()));
		}
		
		/**
		 * getCompleteProgress :: Collate from all sources the absolute total amount of progress made loading all available assets.
		 * @return	<Number>	a percentage representation on a scale from 0 to 1.
		 */
		protected function getCompleteProgress():Number 
		{
			var classP:Number	= CLASS_LOADER.progress();
			var loaderP:Number	= LOAD_FACTORY.progress();
			var imageP:Number	= IMAGE_FACTORY.progress();
			var total:uint		= 0;
			var progress:Number	= 0;
			
			if (Boolean(CLASS_LOADER.currentTarget)) 
			{
				progress += classP;
				total += Math.ceil(classP);
			}
			if (Boolean(LOAD_FACTORY.currentTarget)) 
			{
				progress += loaderP;
				total += Math.ceil(loaderP);
			}
			if (Boolean(IMAGE_FACTORY.currentTarget)) 
			{
				progress += imageP;
				total += Math.ceil(imageP);
			}
			if (total) progress /= total;
			
			return progress;
		}
		
		/**
		 * dispatchFinished :: dispatch teh final event to notify any listeners of the finality of the loaders.
		 */
		protected function dispatchFinished():void 
		{
			var progress:Number	= getCompleteProgress();
			if (progress == LoadFactory.PROGRESS_RESET || progress == LoadFactory.PROGRESS_COMPLETE) 
				dispatchEvent(new GraphicFactoryEvent(GraphicFactoryEvent.FINISHED, true, true));
		}
		
		/**
		 * ImageFactoryProgressEventHandler :: event handler to deal with the progress of teh files being loaded.
		 * @param	event	<LoadFactoryProgressEvent>
		 */
		protected function ImageFactoryProgressEventHandler(event:LoadFactoryProgressEvent):void 
		{
			dispatchProgress();
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * ImageFactoryFinishedEventHandler :: event handler to deal with the finished loading of all assets.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function ImageFactoryFinishedEventHandler(event:LoadFactoryEvent):void 
		{
			dispatchFinished();
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * ImageFactoryNewFileEventHandler :: event handler for when a new file is being loaded.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function ImageFactoryNewFileEventHandler(event:LoadFactoryEvent):void 
		{
			dispatchEvent(new GraphicFactoryEvent(GraphicFactoryEvent.NEW_FILE, true, true, event.loader, event.url));
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * ImageFactoryCompleteEventHandler :: event handler to deal with the complete loading of all assets.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function ImageFactoryCompleteEventHandler(event:LoadFactoryEvent):void 
		{
			dispatchEvent(new GraphicFactoryEvent(GraphicFactoryEvent.COMPLETE, true, true, event.loader, event.url));
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * ClassLoaderClassEventHandler :: event handler when the ClassLoader has finished loading of a particular external asset and returned its requested class.
		 * @param	event
		 */
		protected function ClassLoaderClassEventHandler(event:ClassLoaderEvent):void 
		{
			var dispatchCache:ClassDispatchCache	= null;
			for each (dispatchCache in _dispatchIDs) if (!dispatchCache.nulled && dispatchCache.LoaderURL == event.url) break;
			dispatchEvent(new GraphicFactoryEvent(GraphicFactoryEvent.COMPLETE, true, true, dispatchCache.loader, event.url, dispatchCache.DataURL));
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * ClassFactoryProgressEventHandler :: event handler to deal with the progress of teh files being loaded.
		 * @param	event	<LoadFactoryProgressEvent>
		 */
		protected function ClassFactoryProgressEventHandler(event:LoadFactoryProgressEvent):void 
		{
			dispatchProgress();
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * ClassFactoryFinishedEventHandler :: event handler to deal with the finished loading of all assets.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function ClassFactoryFinishedEventHandler(event:LoadFactoryEvent):void 
		{
			dispatchFinished();
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * ClassFactoryNewFileEventHandler :: event handler for when a new file is being loaded.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function ClassFactoryNewFileEventHandler(event:LoadFactoryEvent):void 
		{
			dispatchEvent(new GraphicFactoryEvent(GraphicFactoryEvent.NEW_FILE, true, true, event.loader, event.url));
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * classFactoryCompleteEventHandler :: event handler to deal with the complete loading of all assets.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function ClassFactoryCompleteEventHandler(event:LoadFactoryEvent):void 
		{
			dispatchEvent(new GraphicFactoryEvent(GraphicFactoryEvent.COMPLETE, true, true, event.loader, event.url));
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * LoadFactoryCompleteEventHandler :: event handler to deal with the complete loading of all assets.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function LoadFactoryCompleteEventHandler(event:LoadFactoryEvent):void 
		{
			dispatchEvent(new GraphicFactoryEvent(GraphicFactoryEvent.COMPLETE, true, true, event.loader, event.url));
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * LoadFactoryFinishedEventHandler :: event handler to deal with the finished loading of all assets.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function LoadFactoryFinishedEventHandler(event:LoadFactoryEvent):void 
		{
			_fileProgess = -1;
			(event.target as LoadFactory).reset();
			dispatchFinished();
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * LoadFactoryNewFileEventHandler :: event handler for when a new file is being loaded.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function LoadFactoryNewFileEventHandler(event:LoadFactoryEvent):void 
		{
			dispatchEvent(new GraphicFactoryEvent(GraphicFactoryEvent.NEW_FILE, true, true, event.loader, event.url));
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * LoadFactoryProgressEventHandler :: event handler to deal with the progress of the files being loaded.
		 * @param	event	<LoadFactoryProgressEvent>
		 */
		protected function LoadFactoryProgressEventHandler(event:LoadFactoryProgressEvent):void 
		{
			dispatchProgress();
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * styleSheetCompleteHandler  :: event handler to deal with StyleSheets being loaded in after generation.
		 * @param	event	<StyleSheetFactoryEvent>	the Event dispatched from the StyleSheetFactory.
		 */
		protected function styleSheetCompleteHandler(event:StyleSheetFactoryEvent):void 
		{
			for each (var style:String in _stylesLoaded) if (style == event.id) return;
			_stylesLoaded.push(event.id);
			if (hasEventListener(StyleSheetFactoryEvent.COMPLETE)) dispatchEvent(event.clone());
		}
		
		protected function ImageFactoryErrorEventHandler(event:LoadFactoryEvent):void 
		{
			if (hasEventListener(GraphicFactoryEvent.ERROR)) 
				dispatchEvent(new GraphicFactoryEvent(GraphicFactoryEvent.ERROR, true, true, event.loader, event.loader.storedURL, event.data));
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		protected function ImageFactoryFatalErrorEventHandler(event:LoadFactoryEvent):void 
		{
			if (hasEventListener(GraphicFactoryEvent.FATAL_ERROR)) 
				dispatchEvent(new GraphicFactoryEvent(GraphicFactoryEvent.FATAL_ERROR, true, true, event.loader, event.loader.storedURL, event.data));
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
	}
	
}
import com.vesperopifex.utils.AbstractLoader;

class GraphicCheck 
{
	public static const TEXT_GRAPHIC:String = "text";
	public static const IMAGE_GRAPHIC:String = "image";
	public static const VIDEO_GRAPHIC:String = "video";
	public static const VECTOR_GRAPHIC:String = "vector";
	public static const LIBRARY_GRAPHIC:String = "library";
	public static const CLASS_GRAPHIC:String = "class";
	public static const MASK_GRAPHIC:String = "mask";
	
	/**
	 * GraphicCheck :: Constructor.
	 */
	public function GraphicCheck() 
	{
		
	}
	
	/**
	 * check :: pass a String value to find what kind of constant the visual relates to.
	 * @param	value	<String>	the String value for the object requested.
	 * @return	<String>	One of the constant values associated graphical elements.
	 */
	public static function check(value:String):String 
	{
		var rtn:String = null;
		
		switch (value) 
		{
			case TEXT_GRAPHIC:
				rtn = TEXT_GRAPHIC;
				break;
				
			case IMAGE_GRAPHIC:
				rtn = IMAGE_GRAPHIC;
				break;
				
			case VIDEO_GRAPHIC:
				rtn = VIDEO_GRAPHIC;
				break;
				
			case VECTOR_GRAPHIC:
				rtn = VECTOR_GRAPHIC;
				break;
				
			case LIBRARY_GRAPHIC:
				rtn = LIBRARY_GRAPHIC;
				break;
				
			case CLASS_GRAPHIC:
				rtn = CLASS_GRAPHIC;
				break;
				
			case MASK_GRAPHIC:
				rtn = MASK_GRAPHIC;
				break;
		}
		
		return rtn;
	}
	
}

class ClassDispatchCache 
{
	private var _LoaderURL:String		= null;
	private var _DataURL:String			= null;
	private var _loader:AbstractLoader	= null;
	private var _nulled:Boolean			= false;
	
	public function ClassDispatchCache(LoaderURL:String, DataURL:String, loader:AbstractLoader) 
	{
		_LoaderURL	= LoaderURL;
		_DataURL	= DataURL;
		_loader		= loader;
	}
	
	public function get LoaderURL():String { return _LoaderURL; }
	
	public function get DataURL():String { return _DataURL; }
	
	public function get nulled():Boolean { return _nulled; }
	
	public function set nulled(value:Boolean):void 
	{
		_nulled = value;
	}
	
	public function get loader():AbstractLoader { return _loader; }
	
}

class GeneratorObject extends Object 
{
	private var _type:String		= null;
	private var _method:Function	= null;
	
	public function get type():String { return _type; }
	
	public function get method():Function { return _method; }
	
	public function GeneratorObject(type:String, method:Function) 
	{
		_type	= type;
		_method	= method;
	}
	
}