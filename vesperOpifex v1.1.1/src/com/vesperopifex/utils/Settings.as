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
	
	public dynamic class Settings extends Object 
	{
		public static const HEADER:String				=	FRAMEWORK + "-------------------------------\n" +
															"\t@author\t:\t" + AUTHOR + "\n" +
															"\t@url\t:\t" + URL + "\n" +
															"\t@version\t:\t" + VERSION + "\n" +
															"---------------------------------------------";
		public static const AUTHOR:String				= "Laurence Green";
		public static const URL:String					= "http://www.laurencegreen.com/";
		public static const FRAMEWORK:String			= "VesperOpifex::";
		public static const VERSION:String				= "v1.1";
		
		public static const PAGE_DELIMINATOR:String		= "/";
		public static const FLASHVAR_DEEPLINK:String	= "deeplink";
		public static const FLASHVAR_DIRECTORY:String	= "directory";
		public static const FLASHVAR_CONTENT:String		= "content";
		public static const FLASHVAR_LANGUAGE:String	= "language";
		
		protected static var _TITLE_DEFAULT:String		= null;
		protected static var _TITLE_EXTENDED:String		= null;
		protected static var _DEFAULT_LANGUAGE:String	= "en";
		protected static var _LANGUAGE:String			= null;
		protected static var _deeplink:Array			= ["home","main"];
		protected static var _version:Array				= null;
		protected static var _debugMode:Boolean			= true;
		protected static var _flashVariables:Object		= null;
		protected static var _directory:String			= null;
		protected static var _content:String			= null;
		
		public static function get deeplink():Array { return _deeplink; }
		
		public static function set deeplink(value:Array):void 
		{
			_deeplink = value;
		}
		
		public static function get version():Array { return _version; }
		
		public static function set version(value:Array):void 
		{
			_version = value;
		}
		
		public static function get TITLE_DEFAULT():String { return _TITLE_DEFAULT; }
		
		public static function set TITLE_DEFAULT(value:String):void 
		{
			_TITLE_DEFAULT = value;
		}
		
		public static function get TITLE_EXTENDED():String { return _TITLE_EXTENDED; }
		
		public static function set TITLE_EXTENDED(value:String):void 
		{
			_TITLE_EXTENDED = value;
		}
		
		public static function get LANGUAGE():String { return _LANGUAGE; }
		
		public static function set LANGUAGE(value:String):void 
		{
			_LANGUAGE = value;
		}
		
		static public function get DEFAULT_LANGUAGE():String { return _DEFAULT_LANGUAGE; }
		
		static public function get debugMode():Boolean { return _debugMode; }
		
		static public function set debugMode(value:Boolean):void 
		{
			_debugMode = value;
		}
		
		static public function get flashVariables():Object { return _flashVariables; }
		
		static public function set flashVariables(value:Object):void 
		{
			_flashVariables = value;
		}
		
		static public function get directory():String { return _directory; }
		
		static public function set directory(value:String):void 
		{
			_directory = value;
		}
		
		static public function get content():String { return _content; }
		
		static public function set content(value:String):void 
		{
			_content = value;
		}
		
		public function Settings() 
		{
			
		}
		
	}
	
}