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
	
	public class PlayerVersionObject extends Object 
	{
		private var _version:String	= null;
		private var _string:String	= null;
		
		public function get version():String { return _version; }
		
		public function get string():String { return _string; }
		
		public function PlayerVersionObject(value:String, version_:String = null) 
		{
			_string = value;
			if (version_) _version = version_;
			super();
		}
		
		/**
		 * compareVersions :: compare two version Array objects with each other and return whether the compared version is equal or not the available version.
		 * @param	compareVersion	<Array>	an Array object of Numbers which make up the version to be compared.
		 * @param	availableVersion	<Array>	the Array object of the available player version, if this is not passed then the automatically detected version will be used instead.
		 * @return	<Boolean>	true if the version being compared is smaller or equal to the player version being used, or false if the version being compared is larger.
		 */
		public static function compareVersions(compareVersion:Array, availableVersion:Array = null):Boolean 
		{
			var i:uint		= 0;
			var version:Array	= (availableVersion)? availableVersion: Settings.version;
			
			for (i; i < compareVersion.length; i++) 
			{
				if (compareVersion[i] && version[i]) 
				{
					if (Number(compareVersion[i]) > Number(version[i])) return false;
				}
			}
			
			return true;
		}
		
	}
	
}