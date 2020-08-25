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
	
	public class LanguageObject extends Object 
	{
		public static const PREFERED:String			= "prefered";
		public static const UNKNOWN:String			= "unknown";
		public static const EXTENSION:String		= ".xml";
		public static const LANGUAGE_CODES:Object	= 
			{
				Czech:					"cs",
				Danish:					"da",
				Dutch:					"nl",
				English:				"en",
				Finnish:				"fi",
				French:					"fr",
				German:					"de",
				Hungarian:				"hu",
				Italian:				"it",
				Japanese:				"ja",
				Korean:					"ko",
				Norwegian:				"no",
				OtherUnknown:			"xu",
				Polish:					"pl",
				Portuguese:				"pt",
				Russian:				"ru",
				SimplifiedChinese:		"zh-CN",
				Spanish:				"es",
				Swedish:				"sv",
				TraditionalChinese:		"zh-TW",
				Turkish:				"tr"
			};
		
		protected static var _Default:String		= null;
		
		public static function get Default():String { return _Default; }
		
		protected var _baseURL:String				= null;
		protected var _available:Boolean			= false;
		protected var _siteDefault:Boolean			= false;
		protected var _dictionary:XML				= null;
		protected var _locale:String				= null;
		protected var _url:String					= null;
		protected var _prefered:String				= UNKNOWN;
		protected var _loader:AbstractLoader		= null;
		
		public function get available():Boolean { return _available; }
		
		public function get dictionary():XML { return _dictionary; }
		public function set dictionary(value:XML):void 
		{
			_dictionary	= value;
			_available	= true;
		}
		
		public function get locale():String { return _locale; }
		public function set locale(value:String):void 
		{
			_locale		= value;
		}
		
		public function get url():String { return _url; }
		public function set url(value:String):void 
		{
			_url		= value;
		}
		
		public function get prefered():String { return _prefered; }
		public function set prefered(value:String):void 
		{
			_prefered	= value;
		}
		
		public function get siteDefault():Boolean { return _siteDefault; }
		public function set siteDefault(value:Boolean):void 
		{
			_siteDefault		= value;
		}
		
		public function get baseURL():String { return _baseURL; }
		public function set baseURL(value:String):void 
		{
			_baseURL	= value;
			_url		= _baseURL + _locale + EXTENSION;
		}
		
		public function get loader():AbstractLoader { return _loader; }
		public function set loader(value:AbstractLoader):void 
		{
			_loader		= value;
			_Default	= _locale;
		}
		
		public function LanguageObject(locale:String = null) 
		{
			_locale		= locale;
		}
		
	}
	
}