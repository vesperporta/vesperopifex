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
package com.vesperopifex.text 
{
	import com.vesperopifex.events.StyleSheetFactoryEvent;
	import com.vesperopifex.fonts.FontLoader;
	import com.vesperopifex.text.StyleSheetFactory;
	import com.vesperopifex.utils.ColourFactory;
	import flash.events.EventDispatcher;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class TextFactory extends EventDispatcher 
	{
		public static const XML_STYLE:String							= "style";
		public static const XML_FIELD:String							= "field";
		public static const BOOLEAN_TRUE:String							= "true";
		public static const BOOLEAN_FALSE:String						= "false";
		
		protected static const TEXTFIELDS:Array							= new Array();
		protected static const ATTRIBUTE_ALWAYSSHOWSELECTION:String		= "alwaysShowSelection";
		protected static const ATTRIBUTE_ANTIALIASTYPE:String			= "antiAliasType";
		protected static const ATTRIBUTE_AUTOSIZE:String				= "autoSize";
		protected static const ATTRIBUTE_BACKGROUND:String				= "background";
		protected static const ATTRIBUTE_BACKGROUNDCOLOR:String			= "backgroundColor";
		protected static const ATTRIBUTE_BORDER:String					= "border";
		protected static const ATTRIBUTE_BORDERCOLOR:String				= "borderColor";
		protected static const ATTRIBUTE_CONDENSEWHITE:String			= "condenseWhite";
		protected static const ATTRIBUTE_DISPLAYASPASSWORD:String		= "displayAsPassword";
		protected static const ATTRIBUTE_EMBEDFONTS:String				= "embedFonts";
		protected static const ATTRIBUTE_GRIDFITTYPE:String				= "gridFitType";
		protected static const ATTRIBUTE_HEIGHT:String					= "height";
		protected static const ATTRIBUTE_MAXCHARS:String				= "maxChars";
		protected static const ATTRIBUTE_MOUSEWHEELENABLED:String		= "mouseWheelEnabled";
		protected static const ATTRIBUTE_MULTILINE:String				= "multiline";
		protected static const ATTRIBUTE_RESTRICT:String				= "restrict";
		protected static const ATTRIBUTE_SELECTABLE:String				= "selectable";
		protected static const ATTRIBUTE_SHARPNESS:String				= "sharpness";
		protected static const ATTRIBUTE_TEXTCOLOR:String				= "textColor";
		protected static const ATTRIBUTE_THICKNESS:String				= "thickness";
		protected static const ATTRIBUTE_TYPE:String					= "type";
		protected static const ATTRIBUTE_USERICHTEXTCLIPBOARD:String	= "useRichTextClipboard";
		protected static const ATTRIBUTE_WIDTH:String					= "width";
		protected static const ATTRIBUTE_WORDWRAP:String				= "wordWrap";
		
		protected static const CSS_COLOR:String							= "color";
		protected static const CSS_DISPLAY:String						= "display";
		protected static const CSS_FONT_FAMILY:String					= "fontFamily";
		protected static const CSS_FONT_SIZE:String						= "fontSize";
		protected static const CSS_FONT_STYLE:String					= "fontStyle";
		protected static const CSS_FONT_WEIGHT:String					= "fontWeight";
		protected static const CSS_KERNING:String						= "kerning";
		protected static const CSS_LEADING:String						= "leading";
		protected static const CSS_LETTER_SPACING:String				= "letterSpacing";
		protected static const CSS_MARGIN_LEFT:String					= "marginLeft";
		protected static const CSS_MARGIN_RIGHT:String					= "marginRight";
		protected static const CSS_TEXT_ALIGN:String					= "textAlign";
		protected static const CSS_TEXT_DECORATION:String				= "textDecoration";
		protected static const CSS_TEXT_INDENT:String					= "textIndent";
		protected static const CSS_BLOCK_INDENT:String					= "blockIndent";
		protected static const CSS_BULLET:String						= "bullet";
		
		protected static var COLOUR:ColourFactory						= new ColourFactory();
		protected static var STYLE_SHEET:StyleSheetFactory				= new StyleSheetFactory();
		
		/**
		 * find the styles available on a particular set of XML data.
		 * @param	data	<XML>	the data to search for the StyleSheet identifier.
		 * @return	<Array>	a list of StyleSheet IDs.
		 */
		public static function getStyles(data:XML):Array 
		{
			var rtn:Array	= new Array();
			var item:XML	= null;
			for each (item in data[XML_STYLE]) 
				rtn.push(item);
			for each (item in data.@[XML_STYLE]) 
				rtn.push(item);
			return rtn;
		}
		
		/**
		 * TextFactory :: Constructor.
		 */
		public function TextFactory() 
		{
			super();
			STYLE_SHEET.addEventListener(StyleSheetFactoryEvent.COMPLETE, styleSheetLoadHandler);
		}
		
		/**
		 * generate :: generate a TextField described by the XML data passed.
		 * @param	data	<XML>	data pertaining to the TextField.
		 * @return	<TextField>	the resulting object.
		 */
		public function generate(data:XML):TextField 
		{
			var rtn:TextField		= make(data);
			var style:StyleSheet	= null;
			if (Boolean(data.style.length())) 
			{
				style				= STYLE_SHEET.generate(data.style);
				if (style) 
				{
					if (rtn.type == TextFieldType.INPUT) 
						rtn.defaultTextFormat		= passCSSTextFormat(style, data[XML_FIELD].@[XML_STYLE]);
					if ( rtn.type == TextFieldType.DYNAMIC) 
					{
						if (data[XML_FIELD].@[XML_STYLE].length()) 
							rtn.defaultTextFormat	= passCSSTextFormat(style, data[XML_FIELD].@[XML_STYLE]);
						else 
							rtn.styleSheet			= style;
						rtn.htmlText				= data[XML_FIELD];
					}
				}
			}
			TEXTFIELDS.push(new TextFactoryObject(rtn, data, style));
			return rtn;
		}
		
		/**
		 * make :: manufacture a new TextField with specific attributes from the passed XML.
		 * @param	data	<XML>	data containing the information to create the TextField.
		 * @return	<TextField>	The resulting object from the XML data.
		 */
		protected function make(data:XML):TextField 
		{
			var item:XML		= null;
			var rtn:TextField	= new TextField();
			for each (item in data.field.@*) applyTextFieldAttributes(rtn, String(item.name()), String(item));
			return rtn;
		}
		
		/**
		 * applyTextFieldAttributes :: apply any attributes to the passed TextField as long as the properties on the TextField are available for allocation.
		 * @param	textfield	<TextField>	the field to apply the properties to.
		 * @param	attribute	<String>	the property name to assign a value to.
		 * @param	value		<String>	the value of the property represented in a String object.
		 */
		protected function applyTextFieldAttributes(textfield:TextField, attribute:String, value:String):void
		{
			switch (attribute) 
			{
				
				case ATTRIBUTE_ALWAYSSHOWSELECTION:
					textfield.alwaysShowSelection		= (value == BOOLEAN_TRUE)? true: false;
					break;
					
				case ATTRIBUTE_ANTIALIASTYPE:
					if (value == AntiAliasType.NORMAL || value == AntiAliasType.ADVANCED) 
						textfield.antiAliasType			= value;
					break;
					
				case ATTRIBUTE_AUTOSIZE:
					if (value == TextFieldAutoSize.NONE || value == TextFieldAutoSize.LEFT || value == TextFieldAutoSize.RIGHT || value == TextFieldAutoSize.CENTER) 
						textfield.autoSize				= value;
					break;
					
				case ATTRIBUTE_BACKGROUND:
					textfield.background				= (value == BOOLEAN_TRUE)? true: false;
					break;
					
				case ATTRIBUTE_BACKGROUNDCOLOR:
					textfield.backgroundColor			= COLOUR.generate(value);
					break;
					
				case ATTRIBUTE_BORDER:
					textfield.border					= (value == BOOLEAN_TRUE)? true: false;
					break;
					
				case ATTRIBUTE_BORDERCOLOR:
					textfield.borderColor				= COLOUR.generate(value);
					break;
					
				case ATTRIBUTE_CONDENSEWHITE:
					textfield.condenseWhite				= (value == BOOLEAN_TRUE)? true: false;
					break;
					
				case ATTRIBUTE_DISPLAYASPASSWORD:
					textfield.displayAsPassword			= (value == BOOLEAN_TRUE)? true: false;
					break;
					
				case ATTRIBUTE_EMBEDFONTS:
					textfield.embedFonts				= (value == BOOLEAN_TRUE)? true: false;
					break;
					
				case ATTRIBUTE_GRIDFITTYPE:
					if (value == GridFitType.NONE || value == GridFitType.PIXEL || value == GridFitType.SUBPIXEL) 
						textfield.gridFitType			= value;
					break;
					
				case ATTRIBUTE_HEIGHT:
					textfield.height					= Number(value);
					break;
					
				case ATTRIBUTE_MAXCHARS:
					textfield.maxChars					= Number(value);
					break;
					
				case ATTRIBUTE_MOUSEWHEELENABLED:
					textfield.mouseWheelEnabled			= (value == BOOLEAN_TRUE)? true: false;
					break;
					
				case ATTRIBUTE_MULTILINE:
					textfield.multiline					= (value == BOOLEAN_TRUE)? true: false;
					break;
					
				case ATTRIBUTE_RESTRICT:
					textfield.restrict					= value;
					break;
					
				case ATTRIBUTE_SELECTABLE:
					textfield.selectable				= (value == BOOLEAN_TRUE)? true: false;
					break;
					
				case ATTRIBUTE_SHARPNESS:
					textfield.sharpness					= Number(value);
					break;
					
				case ATTRIBUTE_TEXTCOLOR:
					textfield.textColor					= COLOUR.generate(value);
					break;
					
				case ATTRIBUTE_THICKNESS:
					textfield.thickness					= Number(value);
					break;
					
				case ATTRIBUTE_TYPE:
					if (value == TextFieldType.DYNAMIC || value == TextFieldType.INPUT) 
						textfield.type					= value;
					break;
					
				case ATTRIBUTE_USERICHTEXTCLIPBOARD:
					textfield.useRichTextClipboard		= (value == BOOLEAN_TRUE)? true: false;
					break;
					
				case ATTRIBUTE_WIDTH:
					textfield.width						= Number(value);
					break;
					
				case ATTRIBUTE_WORDWRAP:
					textfield.wordWrap					= (value == BOOLEAN_TRUE)? true: false;
					break;
					
			}
		}
		
		/**
		 * pass a StyleSheet and find a aquainted style residing within and apply the particular style class to a TextFormat and return.
		 * @param	style	<StyleSheet>	the source StyleSheet object from which to find the required attributes.
		 * @param	css_style	<String>	the style class to apply to the TextFormat.
		 * @return	<TextFormat>	the final formating resulting from parsing the CSS data.
		 * 
		 * Compared to the normal Flash CSS markup, there are additional fields passed, see the table below to recognise the extended options:
		 * CSS property		ActionScript property		Usage and supported values
		 * block-indent		blockIndent					Indents the whole paragraph rather than a single line (not tested).
		 * bullet			bullet						placed a bullet point infront of any text of the TextField.
		 */
		protected function passCSSTextFormat(style:StyleSheet, css_style:String):TextFormat 
		{
			var styleClass:String	= "." + css_style;
			var _style:Object		= null;
			for each (var string:String in style.styleNames) 
				if (styleClass == string) 
				{
					_style	= style.getStyle(styleClass);
					break;
				}
			var tFormat:TextFormat	= new TextFormat();
			for (string in _style) 
			{
				switch(string) 
				{
					
					case CSS_COLOR:
						tFormat.color			= uint(_style[string]);
						break;
						
					case CSS_DISPLAY:
						tFormat.display			= String(_style[string]);
						break;
						
					case CSS_FONT_FAMILY:
						tFormat.font			= String(String(_style[string]).split(",")[0]);
						break;
						
					case CSS_FONT_SIZE:
						tFormat.size			= Number(_style[string]);
						break;
						
					case CSS_FONT_STYLE:
						tFormat.italic			= (_style[string] == "italic")? true: false;
						break;
						
					case CSS_FONT_WEIGHT:
						tFormat.bold			= (_style[string] == "bold")? true: false;
						break;
						
					case CSS_KERNING:
						tFormat.kerning			= (_style[string] == "true")? true: false;
						break;
						
					case CSS_LEADING:
						tFormat.leading			= Number(_style[string]);
						break;
						
					case CSS_LETTER_SPACING:
						tFormat.letterSpacing	= Number(_style[string]);
						break;
						
					case CSS_MARGIN_LEFT:
						tFormat.leftMargin		= Number(_style[string]);
						break;
						
					case CSS_MARGIN_RIGHT:
						tFormat.rightMargin		= Number(_style[string]);
						break;
						
					case CSS_TEXT_ALIGN:
						tFormat.align			= String(_style[string]);
						break;
						
					case CSS_TEXT_DECORATION:
						tFormat.underline		= (_style[string] == "underline")? true: false;
						break;
						
					case CSS_TEXT_INDENT:
						tFormat.indent			= Number(_style[string]);
						break;
						
					case CSS_BULLET:
						tFormat.bullet			= (_style[string] == "true")? true: false;
						break;
						
					case CSS_BLOCK_INDENT:
						tFormat.blockIndent		= Number(_style[string]);
						break;
						
				}
			}
			return tFormat;
		}
		
		/**
		 * styleSheetLoadHandler :: event handler when stylesheets complete loading
		 * @param	event	<StyleSheetFactoryEvent>
		 */
		protected function styleSheetLoadHandler(event:StyleSheetFactoryEvent):void 
		{
			var item:XML				= null;
			var field:TextFactoryObject	= null;
			textfieldsLoop: for each (field in TEXTFIELDS) 
			{
				for each(item in field.data[XML_STYLE]) 
				{
					if (item.toString() == event.id) 
					{
						field.field.styleSheet = event.style;
						field.field.htmlText = String(field.data[XML_FIELD]);
						break textfieldsLoop;
					}
				}
			}
			if (hasEventListener(StyleSheetFactoryEvent.COMPLETE)) dispatchEvent(event.clone());
		}
		
	}
	
}

import flash.text.StyleSheet;
import flash.text.TextField;

class TextFactoryObject extends Object 
{
	protected var _field:TextField	= null;
	protected var _data:XML			= null;
	protected var _style:StyleSheet	= null;
	
	public function get field():TextField { return _field; }
	public function set field(value:TextField):void 
	{
		_field = value;
	}
	
	public function get data():XML { return _data; }
	public function set data(value:XML):void 
	{
		_data = value;
	}
	
	public function get style():StyleSheet { return _style; }
	public function set style(value:StyleSheet):void 
	{
		_style = value;
	}
	
	/**
	 * TextFactoryObject :: Constructor.
	 * @param	field	<TextField>
	 * @param	data	<XML>
	 * @param	style	<StyleSheet>
	 */
	public function TextFactoryObject(field:TextField = null, data:XML = null, style:StyleSheet = null) 
	{
		if (field) _field = field;
		if (data) _data = data;
		if (style) _style = style;
	}
	
}