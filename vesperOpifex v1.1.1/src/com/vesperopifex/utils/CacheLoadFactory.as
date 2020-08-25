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
	import flash.events.IEventDispatcher;
	import flash.system.LoaderContext;
	
	public class CacheLoadFactory extends LoadFactory 
	{
		protected static const CACHE:Cache = new Cache();
		
		/**
		 * CacheLoadFactory :: Constructor
		 */
		public function CacheLoadFactory(mode:String = MULTI_MODE) 
		{
			super(mode);
		}
		
		/**
		 * search :: retrieve data from the Cache if available otherwise will return null.
		 * @param	url	<String>	the url used to load the asset into the flash instance
		 * @return	<AssetLoader>	generic typing of an asset loader
		 */
		public function search(url:String):AbstractLoader 
		{
			return (CACHE.search(url))? CACHE.retrieve(url).data as AbstractLoader: null;
		}
		
		/**
		 * load in a particular URL with optionally a LoaderContext when loading external swf files.
		 * @param	value		<String> URL of resource to load into the movie.
		 * @param	context		<LoaderContext> When load swf files use this option to allow access to the external swf's Classes.
		 * @return	<AbstractLoader> the base class of all loaders generated.
		 */
		public override function load(value:String, context:LoaderContext = null, enforcedType:String = null):AbstractLoader 
		{
			var loaded:Boolean			= CACHE.search(value);
			var loader:AbstractLoader	= null;
			
			if (loaded) 
			{
				loader = CACHE.retrieve(value).data as AbstractLoader;
				if (!loader.loadCompleted) 
				{
					loader = LoaderType(value, context, enforcedType);
					CACHE.add(value, loader, context);
				}
			} else if (StringValidation.validateURL(value)) 
			{
				loader = LoaderType(value, context, enforcedType);
				CACHE.add(value, loader, context);
			}
			
			return loader;
		}
		
	}
	
}