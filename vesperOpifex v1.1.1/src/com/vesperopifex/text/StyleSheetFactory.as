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
package com.vesperopifex.text 
{
	import com.vesperopifex.data.Cache;
	import com.vesperopifex.events.LoadFactoryEvent;
	import com.vesperopifex.events.StyleSheetFactoryEvent;
	import com.vesperopifex.utils.AbstractLoader;
	import com.vesperopifex.utils.CacheLoadFactory;
	import com.vesperopifex.utils.DataLoader;
	import com.vesperopifex.utils.LoadFactory;
	import com.vesperopifex.utils.Settings;
	import com.vesperopifex.utils.StringValidation;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	
	public class StyleSheetFactory extends EventDispatcher 
	{
		public static const STYLE_SHEET:StyleSheet		= new StyleSheet();
		public static const ENFORCED_LOAD:String		= "css";
		
		protected static const LOADER:CacheLoadFactory	= new CacheLoadFactory();
		
		/**
		 * StyleSheetFactory :: Constructor.
		 */
		public function StyleSheetFactory() 
		{
			super();
			LOADER.addEventListener(LoadFactoryEvent.COMPLETE, styleLoadCompleteHandler);
		}
		
		/**
		 * generate :: generate any and all StyleSheets required from the XMLList passed.
		 * @param	data	<XMLList>	the data list to generate the StyleSheets from.
		 * @return	<StyleSheet>	from all the CSS data a single StyleSheet is returned with any new informaiton from multiple sources overwriting the old values.
		 */
		public function generate(data:XMLList):StyleSheet 
		{
			var loader:AbstractLoader		= null;
			var item:XML					= null;
			if (Boolean(data.@id.length()) && Settings.LANGUAGE != Settings.DEFAULT_LANGUAGE) 
			{
				for each (item in data) 
					if (String(item.@id) == Settings.LANGUAGE) 
						return loadStyleSheet(item);
			}
			for each (item in data) 
				if (String(item.@id) == Settings.DEFAULT_LANGUAGE || !Boolean(item.@id.length())) 
					return loadStyleSheet(item);
			return null;
		}
		
		/**
		 * load the selected CSS document to implement into the StyleSheet.
		 * @param	data	<XML>	the data pertaining to the URL of the CSS document to load.
		 * @return	<StyleSheet>	the StyleSheet to apply to a specific TextField.
		 */
		protected function loadStyleSheet(data:XML):StyleSheet 
		{
			var rtn:StyleSheet			= null;
			var loader:AbstractLoader	= null;
			loader						= LOADER.search(String(data));
			if (!loader) 
				loader					= LOADER.load(String(data), null, ENFORCED_LOAD);
			if (loader.loadCompleted) 
			{
				rtn						= new StyleSheet();
				rtn.parseCSS(loader.data);
				STYLE_SHEET.parseCSS(loader.data);
			}
			return rtn;
		}
		
		/**
		 * styleLoadCompleteHandler :: handler for when a CSS file is loaded.
		 * @param	event	<LoadFactoryEvent> event dispatched from the loading factory.
		 */
		protected function styleLoadCompleteHandler(event:LoadFactoryEvent):void 
		{
			event.stopImmediatePropagation();
			var loader:AbstractLoader	= event.loader;
			var style:StyleSheet		= new StyleSheet();
			style.parseCSS(loader.data);
			dispatchEvent(new StyleSheetFactoryEvent(StyleSheetFactoryEvent.COMPLETE, false, true, style, loader.storedURL));
		}
		
	}
	
}