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
package com.vesperopifex.data 
{
	import com.vesperopifex.data.Cache;
	import com.vesperopifex.display.AssetLoader;
	import com.vesperopifex.utils.AbstractLoader;
	import flash.system.LoaderContext;
	
	public class AssetCache extends Cache 
	{
		/**
		 * AssetCache :: Constructor
		 */
		public function AssetCache() 
		{
			
		}
		
		/**
		 * retrieveAsset :: get the desired AssetLoader from the Cache determined by the URL of the original asset
		 * @param	url	<String>	URL of the original asset loaded into the flash instance
		 * @return	<AssetLoader>	base Class for all Loader's required for assets
		 */
		public function retrieveAsset(url:String):AbstractLoader 
		{
			return retrieve(url).data as AbstractLoader;
		}
		
		/**
		 * addAsset :: add an asset to the Cache index by the URL of the original asset
		 * @param	url	<String>	URL of the original asset
		 * @param	asset	<AssetLoader>	Loader for the specific asset being loaded in by the corresponding URL
		 * @param	context	<LoaderContext>	Assignment of SWF file specific Classes
		 * @return	<Boolean>	true if the AssetLoader was saved to the Cache
		 */
		public function addAsset(url:String, asset:AbstractLoader, context:LoaderContext = null):Boolean 
		{
			return Boolean(add(url, asset, context));
		}
		
	}
	
}