﻿/**
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
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class _Arial extends Sprite 
	{
		// mxmlc com/vesperopifex/fonts/_Arial.as -output ..\bin\assets\swf\arial-latin.swf -sp . -use-network=false
		
		[Embed(source = "C:/WINDOWS/Fonts/ARIAL.TTF", fontName = "_Arial", unicodeRange = "U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E")]
		public var _Arial:Class;
		
		/**
		 * Constructor
		 */
		public function _Arial() 
		{
			trace("ExternalLibraryClass\t:\t" + this);
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}
		
	}
	
}