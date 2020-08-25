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
	
	public class ColourFactory 
	{
		public static const CHARACTER_CODES:Object = 
		{
			0: 48, 
			1: 49, 
			2: 50, 
			3: 51, 
			4: 52, 
			5: 53, 
			6: 54, 
			7: 55, 
			8: 56, 
			9: 57, 
			A: 65, 
			B: 66, 
			C: 67, 
			D: 68, 
			E: 69, 
			F: 70, 
			Z: 90
		};
		public static const HEX_PREFIX:String	= "0x";
		public static const BLACK:uint			= 0x000000;
		
		private static const COLOURS:Array		= new Array();
		private static const UNNAMED:String		= "unnamed_colour_";
		
		/**
		 * ColourFactory :: Constructor.
		 */
		public function ColourFactory() 
		{
			
		}
		
		/**
		 * generate :: take a String value in either a 6 or 3 length hexadecimal encoded number
		 * 	with or without the prefix of '0x' to be converted into a true HEX formated Number.
		 * @param	value	<String>	Hex value of the Number.
		 * @param	title	<String>	The name of the passed Number.
		 * @return	<Number>	Final formated Number.
		 */
		public function generate(value:String, title:String = null):Number 
		{
			var rtn:Number;
			var charCode:uint;
			var char:String;
			var bRtn:String = "";
			var tmp:String;
			
			if (value.search("0x") == 0) tmp = value.slice(2);
			if (value.search("#") == 0) tmp = value.slice(1);
			
			tmp.toUpperCase();
			
			if (tmp.length < 4) 
			{
				for each (char in tmp) bRtn += char + char;
			} else if (tmp.length < 6) return BLACK;
			
			for (var i:int = 0; i < bRtn.length; i++) 
			{
				charCode = bRtn.charCodeAt(i);
				// 0-9 = 48-57
				if (charCode < CHARACTER_CODES["0"] || charCode > CHARACTER_CODES["9"]) 
				{
					// A-F = 65-70
					if (charCode < CHARACTER_CODES.A || charCode > CHARACTER_CODES.F) 
					{
						// G-Z = 71-90
						if (charCode > CHARACTER_CODES.F && charCode <= CHARACTER_CODES.Z) 
						{
							// convert to F
							charCode = 70;
							bRtn = bRtn.slice(0, i) + String.fromCharCode(charCode) + bRtn.slice(i + 1);
						}
					}
					// any other characters have no reference in a scale from 0 to 15
				}
			}
			
			rtn = Number(HEX_PREFIX + bRtn);
			addColour(rtn, title);
			return rtn;
		}
		
		/**
		 * addColour :: for future reference to a colour.
		 * 	this class can be extended to deal with named String requests for Number colour values.
		 * @param	value	<Number>	The value of the colour.
		 * @param	title	<String>	the name of the new colour.
		 */
		private function addColour(value:Number, title:String = null):void 
		{
			var exist:Boolean = false;
			
			for each (var pair:Object in COLOURS) 
			{
				if (pair[0] == value) exist = true;
				else title = UNNAMED + COLOURS.length;
			}
			
			if (!exist) COLOURS.push([value, title]);
		}
		
	}
	
}