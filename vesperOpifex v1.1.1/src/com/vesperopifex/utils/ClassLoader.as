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
	import com.vesperopifex.data.AssetCache;
	import com.vesperopifex.display.AssetLoader;
	import com.vesperopifex.display.classes.Library;
	import com.vesperopifex.events.ClassLoaderEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	
	public class ClassLoader extends CacheLoadFactory 
	{
		public static const FILE_EXTENSION:String			= ".swf";
		public static const FILE_TYPE:Object				= 
		{
			swf: "swf"
		};
		
		protected static const CLASS_FACTORY:ClassFactory	= new ClassFactory();
		
		protected var _classes:Array						= new Array();
		
		/**
		 * ClassLoader :: Constructor.
		 * @param	mode	<String>
		 */
		public function ClassLoader(mode:String = MULTI_MODE) 
		{
			super(mode);
		}
		
		public static function getURL(value:String):String 
		{
			if (value.indexOf(FILE_EXTENSION) != -1) return value.slice(0, value.indexOf(FILE_EXTENSION) + FILE_EXTENSION.length);
			//else if (value.indexOf(ClassFactory.CLASS_DELIMINATOR) > 0) return value.slice(0, value.indexOf(ClassFactory.CLASS_DELIMINATOR));
			else return null;
		}
		
		/**
		 * retrieveClass :: find and return the class as a Class described by the String value passed.
		 * @param	value	<String>	the SWF files url and the name of the class as a String, deliminated by ClassFactory.CLASS_DELIMINATOR.
		 * @return	<Class>	the retrieved class from the applicationDomain of the loaded SWF file.
		 * @example	<String>	folder-directory/file-resource.swf::com.example.RequiredClass
		 */
		public function retrieveClass(value:String):Class 
		{
			var rtn:Class			= null;
			var url:String			= null;
			var classAr:Array		= null;
			
			if (value.search(ClassFactory.CLASS_DELIMINATOR) != -1) 
			{
				url		= value.slice(0, value.search(ClassFactory.CLASS_DELIMINATOR));
				classAr	= value.slice(url.length + ClassFactory.CLASS_DELIMINATOR.length).split(ClassFactory.CLASS_DELIMINATOR);
				
				var loader:AbstractLoader = search(url);
				rtn = CLASS_FACTORY.retrieveAsClassObject((classAr[1])? classAr[1]: classAr[0], loader, (classAr[1])? classAr[0]: null);
			}
			
			return rtn;
		}
		
		/**
		 * retrieveDisplayObjectContainer :: find and return the class as a DisplayObjectContainer described by the String value passed.
		 * @param	value	<String>	the SWF files url and the name of the class as a String, deliminated by ClassFactory.CLASS_DELIMINATOR.
		 * @return	<DisplayObjectContainer>	the retrieved class from the applicationDomain of the loaded SWF file.
		 */
		public function retrieveDisplayObjectContainer(value:String):DisplayObjectContainer 
		{
			var rtn:DisplayObjectContainer	= null;
			var url:String					= null;
			var classAr:Array				= null;
			
			if (value.search(ClassFactory.CLASS_DELIMINATOR) != -1) 
			{
				url		= value.slice(0, value.search(ClassFactory.CLASS_DELIMINATOR));
				classAr	= value.slice(url.length + ClassFactory.CLASS_DELIMINATOR.length).split(ClassFactory.CLASS_DELIMINATOR);
				
				var loader:AbstractLoader = search(url);
				rtn = CLASS_FACTORY.retrieveAsDisplayObjectContainer((classAr[1])? classAr[1]: classAr[0], loader, (classAr[1])? classAr[0]: null);
			}
			
			return rtn;
		}
		
		/**
		 * retrieveDisplayObject :: find and return the class as a DisplayObject described by the String value passed.
		 * @param	value	<String>	the SWF files url and the name of the class as a String, deliminated by ClassFactory.CLASS_DELIMINATOR.
		 * @return	<DisplayObject>	the retrieved class from the applicationDomain of the loaded SWF file.
		 */
		public function retrieveDisplayObject(value:String):DisplayObject 
		{
			var rtn:DisplayObject	= null;
			var url:String			= null;
			var classAr:Array		= null;
			
			if (value.search(ClassFactory.CLASS_DELIMINATOR) != -1) 
			{
				url		= value.slice(0, value.search(ClassFactory.CLASS_DELIMINATOR));
				classAr	= value.slice(url.length + ClassFactory.CLASS_DELIMINATOR.length).split(ClassFactory.CLASS_DELIMINATOR);
				
				var loader:AbstractLoader = search(url);
				rtn = CLASS_FACTORY.retrieveAsDisplayObject((classAr[1])? classAr[1]: classAr[0], loader, (classAr[1])? classAr[0]: null);
			}
			
			return rtn;
		}
		
		/**
		 * retrieveClassObject :: find and return the class as a DisplayObject described by the String value passed.
		 * @param	value	<String>	the SWF files url and the name of the class as a String, deliminated by ClassFactory.CLASS_DELIMINATOR.
		 * @return	<Class>	the retrieved class from the applicationDomain of the loaded SWF file.
		 */
		public function retrieveClassObject(value:String):Class 
		{
			var rtn:Class		= null;
			var url:String		= null;
			var classAr:Array	= null;
			
			if (value.search(ClassFactory.CLASS_DELIMINATOR) != -1) 
			{
				url		= value.slice(0, value.search(ClassFactory.CLASS_DELIMINATOR));
				classAr	= value.slice(url.length + ClassFactory.CLASS_DELIMINATOR.length).split(ClassFactory.CLASS_DELIMINATOR);
				
				var loader:AbstractLoader = search(url);
				rtn = CLASS_FACTORY.retrieveAsClassObject((classAr[1])? classAr[1]: classAr[0], loader, (classAr[1])? classAr[0]: null);
			}
			
			return rtn;
		}
		
		/**
		 * loaderCompleteHandler :: once the swf file has completed loading an event is dispatch with the class.
		 * @param	event	<Event>
		 */
		protected override function loaderCompleteHandler(event:Event):void 
		{
			var loader:AbstractLoader	= event.target as AbstractLoader;
			var url:String				= loader.contentLoaderInfo.url;
			var $class:Class			= null;
			
			super.loaderCompleteHandler(event);
			
			for each (var c:Array in _classes) 
			{
				if (url == new URLRequest(c[0]).url) 
				{
					url = c[0] + ClassFactory.CLASS_DELIMINATOR + c[1];
					dispatchEvent(new ClassLoaderEvent(ClassLoaderEvent.CLASS, true, true, retrieveClass(url), loader.storedURL));
				}
			}
		}
		
	}
	
}