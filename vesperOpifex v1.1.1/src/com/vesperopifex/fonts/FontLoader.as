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
package com.vesperopifex.fonts 
{
	import com.vesperopifex.utils.AbstractLoader;
	import com.vesperopifex.utils.ClassFactory;
	import com.vesperopifex.utils.ClassLoader;
	import com.vesperopifex.utils.LoadContext;
	import com.vesperopifex.utils.Settings;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.text.Font;
	
	public class FontLoader extends ClassLoader 
	{
		public static const LANGUAGE_CODE:String	= "<LanguageCode/>";
		public static const FONT_DELIMINATOR:String	= ",";
		
		protected static var _fonts:Array			= new Array();
		protected static var _loadingFonts:Array	= new Array();
		
		/**
		 * embededFonts :: find all the fonts registered with the current player.
		 * @param	enumerateDeviceFonts	<Boolean>	to enumerate device fonts <code>true</code> or to just enumerate the System embeded fonts <code>false</code>.
		 * @return	<Array>	a list of all fonts determined by the 'enumerateDeviceFonts' Boolean.
		 */
		public static function embededFonts(enumerateDeviceFonts:Boolean = false):Array 
		{
			return Font.enumerateFonts(enumerateDeviceFonts);
		}
		
		/**
		 * FontLoader :: Constructor.
		 * @param	mode	<String>	the LoadFactory indication of queuing loaders.
		 */
		public function FontLoader(mode:String = MULTI_MODE) 
		{
			super(mode);
		}
		
		/**
		 * load :: pass in a string which holds the url for the swf resource and the class names of the fonts.
		 * @param	value	<String>	the url and class names of the fonts required.
		 * @param	context	<LoaderContext>	the context in which to load the swf file into the corresponding domain(s).
		 * @return	<AbstractLoader>
		 * 
		 * @example	load("http://example.domain.com/example.swf::Arial,Tahoma", null);
		 */
		public override function load(value:String, context:LoaderContext = null, enforcedType:String = null):AbstractLoader 
		{
			var loader:AbstractLoader	= null;
			var url:String				= null;
			var baseURL:String			= null;
			var listRequiredFonts:Array	= null;
			var requiredString:String	= null;
			
			url							= ClassLoader.getURL(value);
			baseURL						= value.slice(0, value.lastIndexOf(ClassFactory.CLASS_DELIMINATOR) + 
											ClassFactory.CLASS_DELIMINATOR.length);
			listRequiredFonts			= value.slice(value.lastIndexOf(ClassFactory.CLASS_DELIMINATOR) + 
											ClassFactory.CLASS_DELIMINATOR.length).split(FONT_DELIMINATOR);
			
			for each (requiredString in listRequiredFonts) 
			{
				requiredString	= baseURL + requiredString;
				_loadingFonts.push(requiredString);
			}
			
			if (listRequiredFonts.length) 
			{
				loader = super.load(url, context, enforcedType);
				if (loader.loadCompleted) registerFonts(loader);
			}
			
			return loader;
		}
		
		/**
		 * loaderCompleteHandler :: once the swf file has completed loading then the font is registered in the current domain for local usage.
		 * @param	event	<Event>
		 */
		protected override function loaderCompleteHandler(event:Event):void 
		{
			var loader:AbstractLoader	= event.target as AbstractLoader;
			registerFonts(loader);
			super.loaderCompleteHandler(event);
		}
		
		/**
		 * registerFonts :: register the currently loaded font(s) into the available embeded font list.
		 * @param	loader	<AbstractLoader>	the currently loading SWF file containing the fonts
		 * @example	registerFont("http://example.domain.com/example.swf::font library::[font name],[font_n name]");
		 */
		protected function registerFonts(loader:AbstractLoader):void 
		{
			var url:String				= loader.storedURL;
			var item:String				= null;
			var registerFontName:String	= null;
			var classLibrary:String		= null;
			var regFont:Class			= null;
			var font:String				= null;
			var fontRegistered:Boolean	= false;
			var fontItem:Font			= null;
			
			for each (item in _loadingFonts) 
			{
				if (item && item.indexOf(url) == 0) 
				{
					registerFontName	= item.slice(item.lastIndexOf(ClassFactory.CLASS_DELIMINATOR) + ClassFactory.CLASS_DELIMINATOR.length);
					classLibrary		= item.slice(item.indexOf(ClassFactory.CLASS_DELIMINATOR) + ClassFactory.CLASS_DELIMINATOR.length, item.indexOf(registerFontName) - ClassFactory.CLASS_DELIMINATOR.length);
					regFont	= CLASS_FACTORY.retrieveAsClassObject(registerFontName, loader, classLibrary);
					if (regFont) 
					{
						for each (font in _fonts) 
							if (font == item) 
							{
								fontRegistered	= true;
								break;
							}
						if (!fontRegistered) 
						{
							Font.registerFont(regFont);
							_fonts.push(regFont);
							item	= null;
							//trace(Settings.FRAMEWORK + "\tFont Registered::\t" + registerFontName);
						}
					}
				}
			}
			for each (fontItem in embededFonts()) trace(Settings.FRAMEWORK + "Registered Font ::\t" + fontItem.fontName);
		}
		
	}
	
}