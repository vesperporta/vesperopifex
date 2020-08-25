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
package com.vesperopifex.xml 
{
	import com.vesperopifex.events.LoadFactoryProgressEvent;
	import com.vesperopifex.events.XMLFactoryProgressEvent;
	import com.vesperopifex.utils.CacheLoadFactory;
	import com.vesperopifex.utils.DataLoader;
	import com.vesperopifex.utils.LanguageObject;
	import com.vesperopifex.utils.LoadFactory;
	import com.vesperopifex.utils.AbstractLoader;
	import com.vesperopifex.utils.Settings;
	import com.vesperopifex.xml.XMLCompile;
	import com.vesperopifex.events.LoadFactoryEvent;
	import com.vesperopifex.events.XMLCompileEvent;
	import com.vesperopifex.events.XMLFactoryEvent;
	import flash.system.Capabilities;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	
	public class XMLFactory extends EventDispatcher 
	{
		public static const DEFAULT_URI:String				= "../xml/directory.dev.xml";	// change for differing default directory.
		static public const DEFAULT_LANGUAGE:String			= "en";							// change for default language selection.
		public static const ENFORCE_TYPE:String				= "xml";
		public static const XML_EXTENSION:String			= ".xml";
		public static const XML_ENFORCE:String				= "enforce";
		public static const XML_PERSISTENT:String			= "persistent";
		public static const XML_DIRECTORY:String			= "directory";
		public static const XML_BASE:String					= "base";
		public static const XML_DEFAULT:String				= "default";
		public static const XML_DICTIONARY:String			= "dictionary";
		public static const XML_DICTIONARY_PREFERED:String	= "prefered";
		public static const XML_DICTIONARY_UNKNOWN:String	= "unknown";
		public static const XML_LIB:String					= "xmlLib";
		public static const XML_CONTENT:String				= "content";
		public static const XML_ANIMATION:String			= "animation";
		
		protected static var files:Array					= new Array();
		
		protected var XMLCompiler:XMLCompile				= new XMLCompile();
		protected var XMLLoader:CacheLoadFactory			= new CacheLoadFactory(LoadFactory.SINGLE_MODE);
		protected var _languages:Array						= new Array();
		protected var _progress:Number						= 0;
		protected var _language:String						= DEFAULT_LANGUAGE;
		protected var _dictionary:LanguageObject			= null;
		protected var _preferedDictionary:LanguageObject	= null;
		protected var _data:XML								= null;
		protected var _directory:XML						= null;
		protected var _directoryURL:String					= null;
		protected var _content:XML							= null;
		protected var _contentURL:String					= null;
		protected var _systemLanguage:String				= null;
		
		/**
		 * get data :: returns the compiled data.
		 * @return	<XML>
		 */
		public function get data():XML { return _data; }
		
		/**
		 * get directory :: retrieve the currently used directory XML.
		 * @return	<XML>
		 */
		public function get directory():XML { return _directory; }
		
		/**
		 * get dictionary :: retrieve the currently used dictionary url.
		 * @return	<String>
		 */
		public function get dictionary():String { return _dictionary.locale; }
		
		/**
		 * set dictionary :: assign a new dictionary to the data allotments, check if the dictionary is already available and recompile the XML.
		 * @param	<String>	either the locale indentifier or teh url to the required dictionary.
		 */
		public function set dictionary(value:String):void 
		{
			var tmpLang:LanguageObject	= new LanguageObject();
			var language:LanguageObject	= null;
			var available:Boolean		= false;
			var pair:Array				= null;
			if (value.indexOf(XML_EXTENSION) == -1) 
			{
				tmpLang.locale	= value;
				tmpLang.baseURL = _languages[0].baseURL;
			} else tmpLang.url	= value;
			if (tmpLang.url != _dictionary.url) 
			{
				for each (language in _languages) 
				{
					if (language.url == tmpLang.url) 
					{
						language.loader	= XMLLoader.load(language.url, null, ENFORCE_TYPE);
						_dictionary	= language;
						break;
					}
				}
				for each (pair in files) if (pair[0] == _dictionary.url) available	= true;
				if (!available) files.push([_dictionary.url, _dictionary.loader]);
				if (_dictionary.loader.loadCompleted) compileXMLData();
				else 
				{
					XMLLoader.addEventListener(LoadFactoryProgressEvent.PROGRESS, dictionaryLoadProgressHandler);
					XMLLoader.addEventListener(LoadFactoryEvent.COMPLETE, dictionaryLoadCompleteHandler);
				}
			}
		}
		
		/**
		 * languages :: will return an Array of Object's with the available languages (Object.lang) and the preference (Object.preference) of that language.  Preferences are: LanguageObject.PREFERED and LanguageObject.UNKNOWN.
		 * @return	<Array>
		 */
		public function get languages():Array { return _languages; }
		
		/**
		 * language :: return the currently used language code
		 * @return	<String>
		 */
		public function get language():String { return _language; }
		
		/**
		 * progress :: the current progress in loading of data.
		 * @return	<Number>	a value from 0 to 1.
		 */
		public function get progress():Number { return _progress; }
		
		/**
		 * XMLFactory :: load in xml through the use of a directory document.
		 */
		public function XMLFactory() 
		{
			_systemLanguage	= Capabilities.language;
		}
		
		/**
		 * pass the content file to load
		 * @param	value	<String>
		 */
		public function loadContent(value:String = null):void 
		{
			_contentURL	= value;
			XMLLoader.addEventListener(LoadFactoryProgressEvent.PROGRESS, contentLoadProgressHandler);
			XMLLoader.addEventListener(LoadFactoryEvent.COMPLETE, contentLoadCompleteHandler);
			XMLLoader.load(_contentURL, null, ENFORCE_TYPE);
		}
		
		protected function contentLoadProgressHandler(event:LoadFactoryProgressEvent):void 
		{
			if (event.loader.storedURL != _contentURL) return;
			dispatchEvent(new XMLFactoryProgressEvent(XMLFactoryProgressEvent.PROGRESS, false, false, event.loader, event.url, event.progress));
		}
		
		protected function contentLoadCompleteHandler(event:LoadFactoryEvent):void 
		{
			if (event.loader.storedURL != _contentURL) return;
			XMLLoader.removeEventListener(LoadFactoryProgressEvent.PROGRESS, contentLoadProgressHandler);
			XMLLoader.removeEventListener(LoadFactoryEvent.COMPLETE, contentLoadCompleteHandler);
			_content	= new XML(event.loader.data);
			dispatchEvent(new XMLFactoryEvent(XMLFactoryEvent.COMPILE, false, false, _content, event.loader.storedURL));
		}
		
		/**
		 * pass the directory file to load
		 * @param	value	<String>
		 */
		public function loadDirectory(value:String = null, language:String = null):void 
		{
			if (language) _preferedDictionary	= new LanguageObject(language);
			else _preferedDictionary	= new LanguageObject(DEFAULT_LANGUAGE);
			Settings.LANGUAGE	= _preferedDictionary.locale;
			XMLLoader.addEventListener(LoadFactoryProgressEvent.PROGRESS, directoryLoadProgressHandler);
			XMLLoader.addEventListener(LoadFactoryEvent.COMPLETE, directoryLoadCompleteHandler);
			_directoryURL = (value)? value: DEFAULT_URI;
			XMLLoader.load(_directoryURL, null, ENFORCE_TYPE);
		}
		
		/**
		 * directoryLoadProgressHandler :: loading of the initial directory of XML files
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function directoryLoadProgressHandler(event:LoadFactoryProgressEvent):void 
		{
			if (event.loader.storedURL != _directoryURL) return;
			dispatchEvent(new XMLFactoryProgressEvent(XMLFactoryProgressEvent.PROGRESS, false, false, event.loader, event.url, event.progress));
		}
		
		/**
		 * directoryLoadCompleteHandler :: once the directory has loaded run through all files and queue them up for loading
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function directoryLoadCompleteHandler(event:LoadFactoryEvent):void 
		{
			if (event.loader.storedURL != _directoryURL) return;
			XMLLoader.removeEventListener(LoadFactoryEvent.COMPLETE, directoryLoadCompleteHandler);
			XMLLoader.removeEventListener(LoadFactoryProgressEvent.PROGRESS, directoryLoadProgressHandler);
			
			_directory		= new XML(event.loader.data);
			dispatchEvent(new XMLFactoryEvent(XMLFactoryEvent.DIRECTORY, false, false, _directory));
			
			XMLLoader.mode	= LoadFactory.MULTI_MODE;
			XMLLoader.addEventListener(LoadFactoryEvent.COMPLETE, loadCompleteHandler);
			XMLLoader.addEventListener(LoadFactoryEvent.FINISHED, loadFinishedHandler);
			XMLLoader.addEventListener(LoadFactoryProgressEvent.PROGRESS, loadProgressHandler);
			loadFiles();
		}
		
		/**
		 * loadFiles :: find all available files to load and compile, checking if there is a dictionary file and adding the dictionary to the load list in turn.
		 */
		protected function loadFiles():void
		{
			var item:XML				= null;
			var dictAvailable:Boolean	= false;
			for each (item in _directory.children()) 
			{
				if (Boolean(item.@active)) 
				{
					if (String(item.name()) != XML_DICTIONARY) 
						dictAvailable	= true;
					if (String(item.name()) != XML_DICTIONARY && !checkFileExists(item)) 
						files.push([String(item), XMLLoader.load(String(item), null, (item.@[XML_ENFORCE].length())? String(item.@[XML_ENFORCE]): ENFORCE_TYPE)]);
				}
			}
			if (dictAvailable) loadDictionary();
		}
		
		/**
		 * loadDictionary :: pass the available languages on the system through a series of checks where each in turn check to see if the language is available in the directory XML marking that the language is available for use.
		 * 	1.	specifically chosen language, through flashvars or coded.
		 * 	2.	from the Capabilities of the machine itself.
		 * 	3.	the first available 'default' language.
		 * 	4.	the first available language.
		 */
		protected function loadDictionary():void
		{
			var item:XML				= null;
			var dict_loc:String			= null;
			var language:LanguageObject	= null;
			
			for each (item in _directory.children()) if (String(item.name()) == XML_DICTIONARY && String(item.@type) == XML_BASE) dict_loc	= item;
			for each (item in _directory.children()) 
			{
				if (Boolean(item.@active) && String(item.name()) == XML_DICTIONARY) 
				{
					if (String(item.@type) == XML_BASE) continue;
					language			= new LanguageObject(item);
					language.baseURL	= dict_loc;
					if (_preferedDictionary && _preferedDictionary.locale == language.locale) language.prefered	= LanguageObject.PREFERED;
					else if (!_preferedDictionary) 
					{
						if (_systemLanguage && String(item) == _systemLanguage) language.prefered	= LanguageObject.PREFERED;
						if (String(item.@type) == XML_DEFAULT) language.siteDefault	= true;
					}
					_languages.push(language);
				}
			}
			for each (language in _languages) if (language.prefered == LanguageObject.PREFERED) _dictionary	= language;
			if (!_dictionary) for each (language in _languages) if (language.locale == _systemLanguage) _dictionary	= language;
			if (!_dictionary) for each (language in _languages) if (language.siteDefault) _dictionary	= language;
			if (!_dictionary) _dictionary	= _languages[0] as LanguageObject;
			_language			= _dictionary.locale;
			_dictionary.loader	= XMLLoader.load(_dictionary.url, null, ENFORCE_TYPE);
			
			if (!checkFileExists(_dictionary.url)) files.push([_dictionary.url, _dictionary.loader]);
			dispatchEvent(new XMLFactoryProgressEvent(XMLFactoryProgressEvent.PROGRESS, false, false, _dictionary.loader, _dictionary.url));
		}
		
		/**
		 * checkFileExists :: run through all available files and return true if the files URL if found in the list otherwise false if not found.
		 * @param	value	<String>	the value to check against in the list.
		 * @return	<Boolean>	determined if the value passed is found in the list of loaded files.
		 */
		protected function checkFileExists(value:String):Boolean 
		{
			for each (var item:Array in files) if (item[0] == value) return true;
			return false;
		}
		
		/**
		 * dictionaryLoadCompleteHandler :: when the new dictionary has been loaded into the factory compile the data.
		 * 		check through the dictionary to see if there is any information regarding fonts to register into the system.
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function dictionaryLoadCompleteHandler(event:LoadFactoryEvent):void 
		{
			XMLLoader.removeEventListener(LoadFactoryProgressEvent.PROGRESS, dictionaryLoadProgressHandler);
			XMLLoader.removeEventListener(LoadFactoryEvent.COMPLETE, dictionaryLoadCompleteHandler);
			compileXMLData();
		}
		
		/**
		 * dictionaryLoadProgressHandler :: progress of the currently loading dictionary
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function dictionaryLoadProgressHandler(event:LoadFactoryProgressEvent):void 
		{
			_progress = event.progress;
			dispatchEvent(new XMLFactoryProgressEvent(XMLFactoryProgressEvent.PROGRESS, false, false, event.loader, event.url, event.progress));
		}
		
		/**
		 * loadProgressHandler :: progress of all xml documents being loaded
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function loadProgressHandler(event:LoadFactoryProgressEvent):void 
		{
			_progress = event.progress;
			dispatchEvent(new XMLFactoryProgressEvent(XMLFactoryProgressEvent.PROGRESS, false, false, event.loader, event.url, event.progress));
		}
		
		/**
		 * loadCompleteHandler :: handler for when all XML has been loaded into Cache
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function loadCompleteHandler(event:LoadFactoryEvent):void 
		{
			dispatchEvent(new XMLFactoryEvent(XMLFactoryEvent.COMPLETE, false, false, new XML(event.loader.data)));
		}
		
		/**
		 * loadFinishedHandler :: handler for when all files have been finished loading
		 * @param	event	<LoadFactoryEvent>
		 */
		protected function loadFinishedHandler(event:LoadFactoryEvent):void 
		{
			XMLLoader.removeEventListener(LoadFactoryEvent.COMPLETE, loadCompleteHandler);
			XMLLoader.removeEventListener(LoadFactoryProgressEvent.PROGRESS, loadProgressHandler);
			dispatchEvent(new XMLFactoryEvent(XMLFactoryEvent.COMPLETE));
			compileXMLData();
		}
		
		/**
		 * compileXMLData :: taking all the available files loaded compile the XML together to generate one piece of data.
		 */
		protected function compileXMLData():void 
		{
			XMLCompiler.addEventListener(XMLCompileEvent.COMPLETE, compileCompleteHandler);
			appendCompileFiles();
			XMLCompiler.compile();
		}
		
		/**
		 * appendCompileFiles :: add any files loaded into the cache to the XMLCompiler.
		 */
		protected function appendCompileFiles():void 
		{
			var item:XML	= null;
			var pair:Array	= null;
			
			for each (pair in files) 
			{
				if (pair[0] == _dictionary.url) 
				{
					XMLCompiler.add(pair[1], XML_DICTIONARY);
					continue;
				}
				for each (item in _directory.children()) 
					if (pair[0] == String(item)) 
						XMLCompiler.add(pair[1], String(item.name()));
			}
		}
		
		/**
		 * compileCompleteHandler :: once all data has been compiled into one document with all references corrected
		 * @param	event	<XMLCompileEvent>
		 */
		protected function compileCompleteHandler(event:XMLCompileEvent):void 
		{
			XMLCompiler.removeEventListener(XMLCompileEvent.COMPLETE, compileCompleteHandler);
			_data = event.data;
			dispatchEvent(new XMLFactoryEvent(XMLFactoryEvent.COMPILE, false, false, _data));
		}
		
	}
	
}