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
	import com.vesperopifex.utils.Settings;
	import flash.events.EventDispatcher;
	
	public class XMLCustomParser extends EventDispatcher 
	{
		public static const HTML_PARAGRAPH:String			= "p";
		public static const HTML_HEADING_1:String			= "h1";
		public static const HTML_HEADING_2:String			= "h2";
		public static const HTML_HEADING_3:String			= "h3";
		public static const HTML_HEADING_4:String			= "h4";
		public static const HTML_HEADING_5:String			= "h5";
		public static const HTML_HEADING_6:String			= "h6";
		public static const HTML_SPAN:String				= "span";
		public static const HTML_UNORDERED_LIST:String		= "ul";
		public static const HTML_ORDERED_LIST:String		= "ol";
		public static const HTML_LIST_ITEM:String			= "li";
		public static const HTML_DEFINITION_LIST:String		= "dl";
		public static const HTML_DEFINITION_TITLE:String	= "dt";
		public static const HTML_DEFINITION_ITEM:String		= "dd";
		public static const HTML_FORM:String				= "form";
		public static const HTML_INPUT:String				= "input";
		public static const HTML_TABLE:String				= "table";
		public static const HTML_TABLE_ROW:String			= "tr";
		public static const HTML_TABLE_HEADING:String		= "th";
		public static const HTML_TABLE_CELL:String			= "td";
		public static const HTML_IMAGE:String				= "img";
		
		public static const DEFAULT_ID:String				= "auto-id-";
		
		public static const XML_TEXT_OBJECT_DEBUG:XML		=	<graphic type="text">
																	<field  autoSize="left" embedFonts="true"/>
																	<style><![CDATA[../../layout/css/normaltext.css]]></style>
																</graphic>;
		public static const XML_TEXT_OBJECT:XML				=	<graphic type="text">
																	<field  autoSize="left" embedFonts="true"/>
																	<style><![CDATA[layout/css/normaltext.css]]></style>
																</graphic>;
		public static const XML_IMAGE_OBJECT:XML			=	<graphic type="image" url=""/>;
		public static const XML_CELL_OBJECT:XML				=	<cell></cell>;
		
		protected static const XML_GRAPHIC_CHILDREN:Array	= ["page", "content", "graphic", "state", "table", "cell"];
		
		/**
		 * do a set of custom passing to the XML object.
		 * @param	data	<XML>	the data required for the passing of the custom parser.
		 * @return	<XML>	 the resultant data object from the custom parsing.
		 */
		public static function parseXMLData(data:XML):XML 
		{
			return convertHTMLObjects(data);
		}
		
		/**
		 * take the common language of HTML and convert the generic objects into usable data sets for generation within the framework.
		 * @param	data	<XML>	the data to pass and convert HTML data objects into XML data which can be read by the framework.
		 * @return	<XML>	the resulting XML from the convertion of any elements within the recieved data object.
		 */
		protected static function convertHTMLObjects(data:XML):XML 
		{
			var parent:String	= null;
			var item:XML		= null;
			var list:XMLList	= null;
			var replace:XML		= null;
			for each (parent in XML_GRAPHIC_CHILDREN) 
			{
				for each (item in data..*[parent].children()) 
				{
					switch (String(item.name())) 
					{
						
						case HTML_PARAGRAPH:
							replaceTextFieldData(item);
							break;
							
						case HTML_HEADING_1:
							replaceTextFieldData(item);
							break;
							
						case HTML_HEADING_2:
							replaceTextFieldData(item);
							break;
							
						case HTML_HEADING_3:
							replaceTextFieldData(item);
							break;
							
						case HTML_HEADING_4:
							replaceTextFieldData(item);
							break;
							
						case HTML_HEADING_5:
							replaceTextFieldData(item);
							break;
							
						case HTML_HEADING_6:
							replaceTextFieldData(item);
							break;
							
						case HTML_SPAN:
							replaceTextFieldData(item);
							break;
							
						case HTML_UNORDERED_LIST:
							replaceTextFieldData(item);
							break;
							
						case HTML_ORDERED_LIST:
							replaceTextFieldData(item);
							break;
							
						case HTML_DEFINITION_LIST:
							replaceTextFieldData(item);
							break;
							
						case HTML_IMAGE:
							replaceImageData(item);
							break;
							
						case HTML_TABLE:
							if (Boolean(item[HTML_TABLE_ROW].length()) && int(item.@rows) < item[HTML_TABLE_ROW].length()) 
								item.@rows	= item[HTML_TABLE_ROW].length();
							break;
							
						case HTML_TABLE_ROW:
							var tblItem:XML	= null;
							var prt:XML		= item.parent();
							if (int(prt.@columns) < item.children().length()) prt.@columns	= item.children().length();
							for each (tblItem in generateTableCell(item.copy()).children()) prt.appendChild(tblItem);
							item			= null;
							break;
							
						case HTML_FORM:
							// generate a form from something, be it a normal SimlpeInformationPanel os a sub class.
							break;
							
						case HTML_INPUT:
							// load in any extra information for the use of UI objects, these UI elements should be interchangeable through some form of registry process.
							// have a single SWF library load with all the default form objects, and if there are overriding objects then use them.
							// this should only be implemented if a form element is present.
							// all form elements are to be placed into one file like a normal library file.
							break;
							
					}
				}
			}
			return data;
		}
		
		/**
		 * apply the data from one transmition object and pass the extra data over to the recieving object.
		 * @param	data	<Object>	either an XML or XMLList object to transfer data over the replacement paramater.
		 * @param	replacement	<XML>	the default XML data to generate the TextField data.
		 * @return	<XML>	the resulting data object from the transfer of information.
		 */
		protected static function replaceTextFieldData(data:XML):XML 
		{
			var _data:XML			= data.copy();
			var _replicate:XML		= (Settings.debugMode)? XML_TEXT_OBJECT_DEBUG.copy(): XML_TEXT_OBJECT.copy();
			var item:XML			= null;
			data.setName("graphic");
			appendID(data);
			data.setChildren(_replicate.children());
			allocateAttributes(_replicate, data);
			appendID(data);
			var resetIndent:int		= XML.prettyIndent;
			XML.prettyIndent		= 0;
			(_data.toXMLString().indexOf("<![CDATA[") == -1)? data.field.setChildren(XML("<![CDATA[" + _data.toXMLString() + "]]>")): data.field.setChildren(XML(_data.toXMLString()));
			XML.prettyIndent		= resetIndent;
			return data;
		}
		
		/**
		 * pass through all available cells in the table element and convert them into cells associated to this framework.
		 * @param	data	<XML>	the data object containing the table information, this is normally the row data.
		 * @return	<XML>	the resulting data from the convertion.
		 */
		protected static function generateTableCell(data:XML):XML 
		{
			var item:XML	= null;
			for each (item in data.children()) 
				if (String(item.name()) == HTML_TABLE_HEADING || String(item.name()) == HTML_TABLE_CELL) 
					item.setName("cell");
			return convertHTMLObjects(data);
		}
		
		/**
		 * do a simple set of transfering data from one set of data to another.
		 * @param	data	<XML>	the data set to take the appropriate data from.
		 * @param	replacement	<XML> the recieving object for the data being transfered.
		 * @return	<XML> the resulting data object from the transfer of data.
		 */
		protected static function replaceImageData(data:XML):XML 
		{
			var _data:XML	= data.copy();
			var _replicate:XML		= XML_IMAGE_OBJECT.copy();
			data.setName("graphic");
			appendID(data);
			if (Boolean(_replicate.children().length())) data.setChildren(_replicate.children());
			allocateAttributes(_replicate, data);
			data.@url				= _data.@src;
			return data;
		}
		
		/**
		 * pass through the available attributes on the data element and duplicate these attributes to the resipricating allocation paramater.
		 * @param	data	<XML>	the object to take the attributes from.
		 * @param	allocation	<XML>	the object to assign the attributes to.
		 */
		protected static function allocateAttributes(data:XML, allocation:XML):void 
		{
			var att:XML	= null;
			for each (att in data.attributes()) 
				if (!allocation.@[String(att.name())].length()) 
				{
					switch (String(att.name())) 
					{
						case "src":
							allocation.@url						= String(att);
							break;
						default:
							allocation.@[String(att.name())]	= att;
							break;
					}
				}
		}
		
		protected static function appendID(data:XML):void 
		{
			if (!Boolean(data.@id.length())) data.@id	= DEFAULT_ID + String(Math.random()).slice(2);
		}
		
		/**
		 * Constructor.
		 */
		public function XMLCustomParser() 
		{
			super();
		}
		
	}
	
}