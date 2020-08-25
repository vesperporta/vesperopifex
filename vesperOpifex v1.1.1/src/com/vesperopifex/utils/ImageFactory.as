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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	public class ImageFactory extends CacheLoadFactory 
	{
		
		public function ImageFactory() 
		{
			
		}
		
		/**
		 * retrieveImage :: return a Bitmap from the Cache indexed using the URL of the asset.
		 * @param	value	<String>	URL of the asset stored in the Cache.
		 * @return	<Bitmap>	Stored Bitmap in the Cache.
		 */
		public function retrieveImage(value:String):Bitmap 
		{
			return new Bitmap(retrieveImageData(value));
		}
		
		/**
		 * retrieveImageData :: return the BitmapData from the Cache indexed using the URL of the original asset.
		 * @param	value	<String>	URL of the asset stored in the Cache.
		 * @return	<BitmapData>	Stored BitmapData in the Cache.
		 */
		public function retrieveImageData(value:String):BitmapData 
		{
			var content:DisplayObject	= search(value);
			var rtn:BitmapData			= null;
			
			if (Boolean(content as AbstractLoader)) rtn = ((content as AbstractLoader).content as Bitmap).bitmapData;
			else if (Boolean(content as Bitmap)) rtn = (content as Bitmap).bitmapData;
			
			return rtn.clone();
		}
		
		/**
		 * addImage :: add a Bitmap to the Cache indexed by the passed URL String.
		 * @param	url	<String>	URL of the asset to index in the Cache.
		 * @param	image	<Bitmap>	Bitmap of the asset to be stored in the Cache.
		 * @return	<Boolean>	true if data has been stored succesfully, false otherwise.
		 */
		public function addImage(url:String, image:Bitmap):Boolean 
		{
			return CACHE.add(url, image.bitmapData);
		}
		
		/**
		 * addImageData :: add a BitmapData to the Cache indexed by the passed URL String.
		 * @param	url	<String>	URL of the asset to index in the Cache.
		 * @param	image	<BitmapData>	BitmapData of the asset to be stored in the Cache.
		 * @return	<Boolean>	true if data has been stored succesfully, false otherwise.
		 */
		public function addImageData(url:String, image:BitmapData):Boolean 
		{
			return CACHE.add(url, image);
		}
		
	}
	
}