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
	import com.vesperopifex.events.XMLCompileEvent;
	import com.vesperopifex.utils.AbstractLoader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class XMLCompile extends EventDispatcher 
	{
		protected static const XML_LIB:String				= "xmlLib";
		protected static const XML_LIB_COMPLETE:String		= "xmlitem";
		protected static const EMPTY_ELEMENT:String			= "null_information";
		protected static const DICT_LIB:String				= "dictLib";
		protected static const DICT_LIB_OPEN:String			= "<dictLib>";
		protected static const DICT_LIB_CLOSE:String		= "</dictLib>";
		protected static const XML_LIB_ITEM:String			= "item";
		protected static const CONTENT_LIB_ITEM:String		= "graphic";
		protected static const XML_SYSTEM_ITEM:String		= "system";
		protected static const XML_FONT_ITEM:String			= "font";
		protected static const FILE_TYPE_CONTENT:String		= XMLFactory.XML_CONTENT;
		protected static const FILE_TYPE_LIBRARY:String		= XMLFactory.XML_LIB;
		protected static const FILE_TYPE_DICTIONARY:String	= XMLFactory.XML_DICTIONARY;
		protected static const FILE_TYPE_ANIMATION:String	= XMLFactory.XML_ANIMATION;
		
		protected var files:Array							= new Array();
		protected var content:Array							= new Array();
		protected var _content:XML							= <content></content>;
		protected var library:Array							= new Array();
		protected var _library:XML							= <library></library>;
		protected var dictionary:Array						= new Array();
		protected var _dictionary:XML						= <dictionary></dictionary>;
		protected var animation:Array						= new Array();
		protected var _animation:XML						= <animation></animation>;
		protected var data:Array							= new Array();
		protected var _data:XML								= <data></data>;
		
		/**
		 * XMLCompile :: Constructor.
		 */
		public function XMLCompile() 
		{
			super();
		}
		
		/**
		 * add :: include a set of data for the compiler to work with.
		 * @param	loader	<AbstractLoader>	data loader object to get information from.
		 * @param	type	<String>	identifying marker on what type of data is being passed into the compiler.
		 */
		public function add(loader:AbstractLoader, type:String):void 
		{
			files.push([loader, type]);
		}
		
		/**
		 * compile :: taking all the information added to the list and arrange it in a way that is useable.
		 * 	according to the layout specified in the frameworks XML construction.
		 * @internal	This function essencially de-centralizes the compilation, thus removing the need for syncronous processing of large XML documents which require some formidable time to complete depending on the size of the XML documents loaded and compiled.
		 */
		public function compile():void 
		{
			addEventListener(XMLCompileEvent.COMPILE_CONTENT, compileEventHandler);
			dispatchEvent(new XMLCompileEvent(XMLCompileEvent.COMPILE_CONTENT, false, true));
		}
		
		/**
		 * compileEventHandler :: an event handler to capture the event dispatched from this class to start the compilation of the added XML into one XML document.
		 * @param	event	<XMLCompileEvent>	an internally used event which removes the requirement for syncronous processing and handles the relevant information in its own requirements.
		 */
		protected function compileEventHandler(event:XMLCompileEvent):void 
		{
			removeEventListener(XMLCompileEvent.COMPILE_CONTENT, compileEventHandler);
			event.stopImmediatePropagation();
			
			collateAvailableData();
			checkLibraryReferences();
			removeItemReferences(_content);
			checkAnimationData(_content);
			_content	= checkDictionaryReferences(_content);
			checkDictionaryFonts(_content, _dictionary);
			XMLCustomParser.parseXMLData(_content);
			dispatchEvent(new XMLCompileEvent(XMLCompileEvent.COMPLETE, false, false, _content));
		}
		
		/**
		 * checkAnimationData :: method to find and apply any and all animation data to a set of XML data passed into the method.
		 * @param	data	<XML>	data requiring the need of animation data.
		 */
		protected function checkAnimationData(data:XML):void
		{
			data.appendChild(_animation);
		}
		
		/**
		 * collateAvailableData :: group together all data pertaining to their individual type.
		 */
		protected function collateAvailableData():void 
		{
			var g_child:XML	= null;
			var child:XML	= null;
			
			// collate all dictionary references into one data node
			for each (child in getData(FILE_TYPE_DICTIONARY)) 
				for each (g_child in child.children()) 
					_dictionary.appendChild(g_child);
			
			// collate all animation references into one data node
			for each (child in getData(FILE_TYPE_ANIMATION)) 
				for each (g_child in child.children()) 
					_animation.appendChild(g_child);
			
			// collate all the library data into one data node
			for each (child in getData(FILE_TYPE_LIBRARY)) 
				for each (g_child in child.children()) 
					_library.appendChild(g_child);
			
			// collate all content into one data node
			for each (child in getData(FILE_TYPE_CONTENT)) 
				for each (g_child in child.children()) 
					_content.appendChild(g_child);
		}
		
		/**
		 * removeItemReferences :: rename any XMLNode with the name assigned to XML_LIB_ITEM with the name assigned to CONTENT_LIB_ITEM,  which will allow the XMLNode to be picked up and used as a graphic element within the framework.
		 * @param	data	<XML>	data to find the naming references and rename to the required name.
		 */
		protected function removeItemReferences(data:XML):void
		{
			for each (var item:XML in data..*) 
				if (item.name() && item.name().toString() == XML_LIB_ITEM) 
					item.setName(CONTENT_LIB_ITEM);
		}
		
		/**
		 * checkDictionaryReferences :: check for references in simple data nodes if there are references to any dictionary XML objects.
		 * @param	data	<XMLList>	a list of nodes to search through for dictionary references.
		 * @return	<XMLList>	the edited data nodes from the original, not a copy.
		 */
		protected function checkDictionaryReferences(data:XML):XML 
		{
			var str:String		= "";
			var tmpStr:String	= data.toXMLString();
			var txtArray:Array	= tmpStr.split(DICT_LIB_OPEN);
			var dictName:String	= null;
			var item:XML		= null;
			
			for each (tmpStr in txtArray) 
			{
				if (tmpStr.indexOf(DICT_LIB_CLOSE) != -1) 
				{
					dictName	= tmpStr.slice(0, tmpStr.indexOf(DICT_LIB_CLOSE));
					for each (item in _dictionary.children()) 
						if (String(item.@id) == dictName) 
							str	+= String(item);
					if (tmpStr.length > tmpStr.indexOf(DICT_LIB_CLOSE) + DICT_LIB_CLOSE.length) 
						str	+= tmpStr.slice(tmpStr.indexOf(DICT_LIB_CLOSE) + DICT_LIB_CLOSE.length);
				} else str	+= tmpStr;
			}
			return new XML(str);
		}
		
		/**
		 * checkDictionaryFonts :: run through the dictionary XML data passed and append any entries for fonts to the system node in the data XML passed, if there is no system node in the data XML then a failure will instance.
		 * @param	data	<XML>	the data upon which to append any extra font loading.
		 * @param	dictionary	<XML>	the dictionary to find the font nodes on.
		 */
		protected function checkDictionaryFonts(data:XML, dictionary:XML):void 
		{
			if (data[XML_SYSTEM_ITEM].length()) 
			{
				var font:XML	= null;
				var item:XML	= null;
				for each (font in dictionary[XML_FONT_ITEM]) 
				{
					if (font.@id.length()) 
					{
						for each (item in data[XML_SYSTEM_ITEM][XML_FONT_ITEM]) 
							if (item.@id.length() && String(item.@id) == String(font.@id)) 
								item.setChildren(font.children());
					} else data[XML_SYSTEM_ITEM].appendChild(item);
				}
			}
		}
		
		/**
		 * checkLibraryReferences :: run through all XML to replace any references to the library with the library data chunk.
		 */
		protected function checkLibraryReferences():void 
		{
			checkLibReferences(_library);
			checkLibReferences(_content);
		}
		
		/**
		 * checkLibReferences :: recurse through all the data passed and replace any references to a library id with the library data.
		 * @param	data	<XML>	the data to recurse through to find the library id(s).
		 * @return	<XML>	the resulting data with all library id(s) replaced with the data chunks in the library.
		 */
		protected function checkLibReferences(data:XML):XML 
		{
			var item:XML		= null;
			var pass:Boolean	= false;
			
			for each (item in data..*) 
			{
				if (item[XML_LIB].length()) 
				{
					pass = true;
					break;
				}
			}
			
			if (pass) 
			{
				data = passLibraryReferences(data);
				data = checkLibReferences(data);
			}
			
			return data;
		}
		
		/**
		 * passLibraryReferences :: check thrpough the passed data nodes and replace any references to the XML library with the library node.
		 * @param	data	<XMLList>	the data nodes to check through for references in a given library list.
		 * @param	lib	<XMLList>	the libarary to compare the references to.
		 * @return	<XMLList>	the edited data nodes from the original, not a copy.
		 */
		protected function passLibraryReferences($data:XML, $lib:XML = null):XML 
		{
			var lib:XML = ($lib)? $lib: _library.copy();
			var item:XML;
			var ref:XML;
			var match:String;
			
			for each (item in $data.children()) 
			{
				if (item.hasComplexContent())
				{
					if (item[XML_LIB].length() && item[XML_LIB].children().length()) 
					{
						for each (ref in lib.children()) 
						{
							if (ref.@id == item[XML_LIB][0]) 
							{
								mergeNodes(item, ref);
								item[XML_LIB][0].setName(XML_LIB_COMPLETE);
								break;
							}
						}
					} else item = passLibraryReferences(item, lib);
				}
			}
			
			return $data;
		}
		
		/**
		 * mergeNodes :: taking a set of comparative data nodes and a library node, merge the two to form  one set oof data, where all nodes that do not match or unrecognisable between the two are added to the comparative data and returned.
		 * @param	data	<XML>	a data node to compare to the library data node.
		 * @param	lib		<XML>	a data node to employ into the comparative data.
		 * @return	<XML>	the resulting data after all nodes have been merged and compaired.
		 */
		protected function mergeNodes($data:XML, $lib:XML):XML 
		{
			var lib:XML				= $lib.copy();
			var ref:XML				= null;
			
			var data:XML			= null;
			var dataRef:XML			= null;
			var dataName:String		= null;
			
			var attr:XML			= null;
			var attrName:String		= null;
			
			var append:Boolean		= false;
			var appendName:String	= EMPTY_ELEMENT;
			
			for each (data in $data.children()) 
			{
				// for each child node of data
				dataName = data.name();
				if (lib[dataName].length()) 
				{
					// if the library has (a) node(s) of the same name
					for each (ref in lib[dataName]) 
					{
						// for each reference of that named node
						if (ref.@*.length()) 
						{
							// if there are attributes there is supporting data
							for each (attr in ref.@*) 
							{
								// for all attributes in the library reference
								attrName = attr.name();
								if (!data.@[attrName].length()) data.@[attrName] = attr;
							}
							
							if (data.@id == ref.@id && ref.hasComplexContent() && data.hasComplexContent()) 
							{
								// if the original and library referances have the same 'id'
								data = mergeNodes(data, ref); // merge nodes
							}
						}
					}
				}
			}
			
			for each (ref in lib.children()) 
			{
				// for each child node of lib
				dataName = ref.name();
				if (!$data[dataName].length()) 
				{
					// there is no node in data with the current library name
					appendName = dataName; // store node name
					$data.appendChild(ref);	// append node
				} else if (appendName != EMPTY_ELEMENT) 
				{
					// check that there is not duplication or overriding
					for each (data in $data[dataName]) 
					{
						if (data.@* != ref.@* && !data.@id.length()) append = true; // check that attributes do not match and no id on data
						else if (data.@id != ref.@id) append = true; // check for non-matching id attributes
						else if (!data.@* || !ref.@*) append = true; // check if there are attributes at all
						else 
						{
							// stop otherwise
							append = false;
							break;
						}
					}
				} else 
				{
					// if the library has (a) node(s) of the same name
					for each (data in $data[dataName]) 
					{
						if (data.@id != ref.@id) append = true; // check if the id's do not match
						else if (!data.@id.length()) append = true; // check if there is an id at all
						else 
						{
							// stop otherwise
							append = false;
							break;
						}
					}
					appendName = EMPTY_ELEMENT; // reset stored name
				}
				
				if (append) 
				{
					// if conditions are met and 'append' is true append the XML to '$data'
					append = false;
					$data.appendChild(ref);
				}
			}
			
			return $data;
		}
		
		/**
		 * getData :: return all data stored pertaining to a certain type.
		 * @param	type	<String>	an identifyer for a particular data set.
		 * @return	<Array>	a list of all data available for the required data type.
		 */
		private function getData(type:String):Array 
		{
			var rtn:Array = new Array();
			for each (var pair:Array in files) 
				if (type == pair[1]) 
					rtn.push(new XML((pair[0] is AbstractLoader)? pair[0].data: pair[0]));
			return rtn;
		}
		
		/**
		 * setData :: replace an existing set of data with a new set of data.
		 * @param	original	<XML>	the originating data node to find.
		 * @param	replace		<XML>	the replacement data of the original.
		 * @return	<XML>	the replacement data node.
		 */
		private function setData(original:XML, replace:XML):XML 
		{
			for each (var pair:Array in files) 
			{
				if (pair[0] is AbstractLoader && original == pair[0].data) pair[0] = replace;
				else if (original == pair[0]) pair[0] = replace;
			}
			return replace;
		}
		
	}
	
}