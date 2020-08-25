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
package com.vesperopifex.display 
{
	import flash.display.Sprite;
	
	public class GraphicSpriteFactory extends Object 
	{
		public static const XML_STYLE:String				= "style";
		public static const XML_TYPE:String					= "type";
		public static const XML_IGNORE:Array				= [GraphicStyleFactory.XML_STYLE, XML_TYPE];
		
		protected static const STYLE:GraphicStyleFactory	= new GraphicStyleFactory();
		protected static const DRAW:GraphicDrawFactory		= new GraphicDrawFactory();
		
		/**
		 * Constructor
		 */
		public function GraphicSpriteFactory() 
		{
			super();
		}
		
		/**
		 * run through all XML nodes to generate the visual required.
		 * @param	data, XMLList of styling and graphic movements to generate a visual.
		 * @return	Sprite, the result of all XML nodes being passed in the XMLList.
		 */
		public function generate(data:XML):Sprite 
		{
			var rtn:Sprite	= new Sprite();
			var item:XML	= null;
			
			if (data[XML_STYLE].length()) 
			{
				for each (item in data[GraphicStyleFactory.XML_STYLE]) 
				{
					if (STYLE.styleAvailable(item.@[GraphicStyleFactory.XML_STYLE_TYPE].toString())) STYLE.stylise(rtn, item);
				}
			}
			
			for each (item in data.children()) 
			{
				if (ignoreName(item.name().toString())) continue;
				if (STYLE.styleAvailable(item.@[GraphicStyleFactory.XML_STYLE_TYPE].toString())) STYLE.stylise(rtn, item);
			}
			
			for each (item in data.children()) 
			{
				if (ignoreName(item.name().toString())) continue;
				if (DRAW.graphicAvailable(item.name().toString())) DRAW.generate(rtn, item);
			}
			
			DRAW.generate(rtn, new XML("<" + GraphicDrawFactory.TYPE_END_FILL + "/>"));
			
			return rtn;
		}
		
		protected function ignoreName(value:String):Boolean 
		{
			var ignore:String	= null;
			
			for each (ignore in XML_IGNORE) 
			{
				if (value == ignore) return true;
			}
			
			return false;
		}
		
	}
	
}