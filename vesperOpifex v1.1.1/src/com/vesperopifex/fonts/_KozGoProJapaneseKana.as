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
	import flash.display.Sprite;
	import flash.system.Security;
	
	[SWF(width="100", height="100", backgroundColor="0xffffff", frameRate="30")]
	
	public class _KozGoProJapaneseKana extends Sprite 
	{
		// mxmlc com/vesperopifex/fonts/_KozGoProJapaneseKana.as -output ..\bin\assets\swf\kozgopro-japanese-kana.swf -sp . -use-network=false
		
		[Embed(source = "C:/WINDOWS/Fonts/KozGoPro-Regular.otf", fontName = "_KozGoProRegular", unicodeRange = "U+3000-U+303F,U+3041-U+309F,U+30A0-U+30FF,U+FF61-U+FF9F")]
		public var _KozGoProRegular:Class;
		
		[Embed(source = "C:/WINDOWS/Fonts/KozGoPro-Bold.otf", fontName = "_KozGoProBold", unicodeRange = "U+3000-U+303F,U+3041-U+309F,U+30A0-U+30FF,U+FF61-U+FF9F")]
		public var _FuturaLight:Class;
		
		[Embed(source = "C:/WINDOWS/Fonts/KozGoPro-Light.otf", fontName = "_KozGoProLight", unicodeRange = "U+3000-U+303F,U+3041-U+309F,U+30A0-U+30FF,U+FF61-U+FF9F")]
		public var _KozGoProLight:Class;
		
		[Embed(source = "C:/WINDOWS/Fonts/KozGoPro-Heavy.otf", fontName = "_KozGoProHeavy", unicodeRange = "U+3000-U+303F,U+3041-U+309F,U+30A0-U+30FF,U+FF61-U+FF9F")]
		public var _KozGoProHeavy:Class;
		
		[Embed(source = "C:/WINDOWS/Fonts/KozGoPro-Medium.otf", fontName = "_KozGoProMedium", unicodeRange = "U+3000-U+303F,U+3041-U+309F,U+30A0-U+30FF,U+FF61-U+FF9F")]
		public var _KozGoProMedium:Class;
		
		[Embed(source = "C:/WINDOWS/Fonts/KozGoPro-ExtraLight.otf", fontName = "_KozGoProExtraLight", unicodeRange = "U+3000-U+303F,U+3041-U+309F,U+30A0-U+30FF,U+FF61-U+FF9F")]
		public var _KozGoProExtraLight:Class;
		
		/**
		 * Constructor
		 */
		public function _KozGoProJapaneseKana() 
		{
			trace("ExternalLibraryClass\t:\t" + this);
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}
		
	}
	
}