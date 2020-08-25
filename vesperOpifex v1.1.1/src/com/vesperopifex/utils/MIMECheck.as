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
	import com.vesperopifex.display.AssetLoader;
	import com.vesperopifex.display.video.VideoLoader;
	
	public class MIMECheck extends Object 
	{
		public static const FILE:String		= "file";
		public static const DATA:String		= "data";
		public static const STREAM:String	= "stream";
		public static const EMPTY:String	= "empty";
		
		/**
		 * MIMECheck :: Constructor.
		 */
		public function MIMECheck() 
		{
			
		}
		
		/**
		 * check :: do a check on whether the URL passed is valid and handled by this factory, returning a constant type.
		 * 	Depending on the file type a flash player version check will happen depending on the content requested.
		 * 	if value is not a valid URL and has not MIME type assosiated to it then the passed String is returned.
		 * @param	value	<String>	the URL extension to pass and find whether it is a viable option to load the object.
		 * @return	<String>	valid data types or void, available returns are : 'file', 'data', 'stream', or 'empty'.
		 */
		public static function check(value:String):String 
		{
			var tmp:String					= (value.lastIndexOf(".") > 0)? value.slice(value.lastIndexOf(".") + 1): value;
			var type:PlayerVersionObject	= null;
			var rtn:String 					= EMPTY;
			
			if (rtn == EMPTY) 
			{
				for each (type in AssetLoader.FILE_TYPE) 
				{
					if (tmp == type.string) 
					{
						rtn = FILE;
						break;
					}
				}
			}
			if (rtn == EMPTY) 
			{
				for each (type in DataLoader.FILE_TYPE) 
				{
					if (tmp == type.string) 
					{
						rtn = DATA;
						break;
					}
				}
			}
			if (rtn == EMPTY) 
			{
				for each (type in VideoLoader.FILE_TYPE) 
				{
					if (tmp == type.string && 
						type.version != null && 
						PlayerVersionObject.compareVersions(type.version.split(MinimumPlayerVersion.SEPERATOR))) 
					{
						rtn = STREAM;
						break;
					}
				}
			}
			
			return rtn;
		}
		
	}
	
}