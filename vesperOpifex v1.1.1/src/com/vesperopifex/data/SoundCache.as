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
	import com.vesperopifex.audio.AudioLoader;
	
	public class SoundCache extends Cache 
	{
		
		/**
		 * SoundCache :: Constructor.
		 */
		public function SoundCache() 
		{
			super();
		}
		
		/**
		 * retrieveSound :: find and return a sound already loaded or loading matching the identifier String object passed.
		 * @param	value	<String>	the identifier String passed when adding the Sound object to the cache.
		 * @return	<Sound>	the sound object associated with the identifier passed.
		 */
		public function retrieveSound(value:String):AudioLoader 
		{
			var cacheObject:CacheObject	= retrieve(value);
			var rtn:AudioLoader			= null;
			if (cacheObject) rtn		= cacheObject.data as AudioLoader;
			return rtn;
		}
		
		/**
		 * addSound :: add a sound to the cache for storage and later use.
		 * @param	value	<String>	an identifier String object to recall the object at a later time.
		 * @param	sound	<Sound>	the Sound object to be cached.
		 * @return	<Boolean>	true if the Sound object was saved in the cache successfully and false if not, try a different identifier.
		 */
		public function addSound(value:String, sound:AudioLoader):Boolean 
		{
			var rtn:Boolean		= add(value, sound);
			return rtn;
		}
		
	}
	
}