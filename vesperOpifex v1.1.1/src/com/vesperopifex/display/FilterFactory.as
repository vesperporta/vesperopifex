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
	import com.vesperopifex.data.BitmapCache;
	import com.vesperopifex.utils.ImageFactory;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Point;
	
	public class FilterFactory 
	{
		public static const DELIMINATOR:String				= ",";
		public static const XML_FILTER:String				= "filter";
		public static const XML_FILTER_ID:String			= "id";
		public static const BEVEL_FILTER:String				= "Bevel";
		public static const BLUR_FILTER:String				= "Blur";
		public static const COLOR_MATRIX_FILTER:String		= "ColorMatrix";
		public static const CONVOLUTION_FILTER:String		= "Convolution";
		public static const DISPLACEMENT_MAP_FILTER:String	= "DisplacementMap";
		public static const DROP_SHADOW_FILTER:String		= "DropShadow";
		public static const GLOW_FILTER:String				= "Glow";
		public static const GRADIENT_BEVEL_FILTER:String	= "GradientBevel";
		public static const GRADIET_GLOW_FILTER:String		= "GradientGlow";
		
		protected var IMAGE_FACTORY:ImageFactory	= new ImageFactory();
		
		public function FilterFactory() 
		{
			
		}
		
		public static function checkFilters(data:XML):Boolean 
		{
			if (data[XML_FILTER].length()) return true;
			else return false;
		}
		
		public function generate(data:XML):Array 
		{
			var rtn:Array	= new Array();
			var item:XML	= null;
			
			for each (item in data[XML_FILTER]) rtn.push(generateFilter(item));
			
			return rtn;
		}
		
		protected function generateFilter(data:XML):BitmapFilter 
		{
			var rtn:BitmapFilter	= generateFilterType(data);
			if (rtn) 
			{
				generateNodeProperties(rtn, data);
				generateAttributeProperties(rtn, data);
			}
			return rtn;
		}
		
		protected function generateFilterType(data:XML):BitmapFilter 
		{
			var rtn:BitmapFilter	= null;
			var type:String			= null;
			
			if (data[XML_FILTER_ID].length()) type = data[XML_FILTER_ID];
			else if (data.@[XML_FILTER_ID].length()) type = data.@[XML_FILTER_ID];
			
			switch (type) 
			{
				case BEVEL_FILTER:
					rtn = new BevelFilter();
					break;
				case BLUR_FILTER:
					rtn = new BlurFilter();
					break;
				case COLOR_MATRIX_FILTER:
					rtn = new ColorMatrixFilter();
					break;
				case CONVOLUTION_FILTER:
					rtn = new ConvolutionFilter();
					break;
				case DISPLACEMENT_MAP_FILTER:
					rtn = new DisplacementMapFilter();
					break;
				case DROP_SHADOW_FILTER:
					rtn = new DropShadowFilter();
					break;
				case GLOW_FILTER:
					rtn = new GlowFilter();
					break;
				case GRADIENT_BEVEL_FILTER:
					rtn = new GradientBevelFilter();
					break;
				case GRADIET_GLOW_FILTER:
					rtn = new GradientGlowFilter();
					break;
			}
			
			return rtn;
		}
		
		protected function generateNodeProperties(filter:BitmapFilter, data:XML):BitmapFilter 
		{
			var rtn:BitmapFilter	= filter;
			var item:XML			= null;
			var name:String			= null;
			
			if (data.children().length()) 
			{
				for each (item in data.children()) 
				{
					name = item.name().toString();
					generateFilterProperty(rtn, name, item.toString());
				}
			}
			
			return rtn;
		}
		
		protected function generateAttributeProperties(filter:BitmapFilter, data:XML):BitmapFilter 
		{
			var rtn:BitmapFilter	= filter;
			var item:XML			= null;
			var name:String			= null;
			
			if (data.@*.length()) 
			{
				for each (item in data.@*) 
				{
					name = item.name().toString();
					generateFilterProperty(rtn, name, item.toString());
				}
			}
			
			return rtn;
		}
		
		protected function generateFilterProperty(filter:BitmapFilter, name:String, value:String):BitmapFilter 
		{
			var tmpArr:Array	= null;
			
			switch (name) 
			{
				case "alpha":
					filter[name] = Number(value);
					break;
					
				case "alphas":
					filter[name] = value.split(DELIMINATOR);
					break;
					
				case "angle":
					filter[name] = Number(value);
					break;
					
				case "bias":
					filter[name] = Number(value);
					break;
					
				case "blurX":
					filter[name] = Number(value);
					break;
					
				case "blurY":
					filter[name] = Number(value);
					break;
					
				case "clamp":
					filter[name] = Boolean(value);
					break;
					
				case "color":
					filter[name] = uint(value);
					break;
					
				case "colors":
					filter[name] = value.split(DELIMINATOR);
					break;
					
				case "componentX":
					filter[name] = uint(value);
					break;
					
				case "componentY":
					filter[name] = uint(value);
					break;
					
				case "distance":
					filter[name] = Number(value);
					break;
					
				case "divisor":
					filter[name] = Number(value);
					break;
					
				case "hideObject":
					filter[name] = Boolean(value);
					break;
					
				case "highlightAlpha":
					filter[name] = Number(value);
					break;
					
				case "highlightColor":
					filter[name] = uint(value);
					break;
					
				case "inner":
					filter[name] = Boolean(value);
					break;
					
				case "knockout":
					filter[name] = Boolean(value);
					break;
					
				case "mapBitmap":
					filter[name] = IMAGE_FACTORY.retrieveImageData(value);
					break;
					
				case "mapPoint":
					tmpArr = value.split(DELIMINATOR);
					filter[name] = new Point(tmpArr[0], tmpArr[1]);
					break;
					
				case "matrix":
					filter[name] = value.split(DELIMINATOR);
					break;
					
				case "matrixX":
					filter[name] = Number(value);
					break;
					
				case "matrixY":
					filter[name] = Number(value);
					break;
					
				case "mode":
					if (value == DisplacementMapFilterMode.CLAMP || 
						value == DisplacementMapFilterMode.COLOR || 
						value == DisplacementMapFilterMode.IGNORE || 
						value == DisplacementMapFilterMode.WRAP) 
							filter[name] = value;
					break;
					
				case "preserveAlpha":
					filter[name] = Boolean(value);
					break;
					
				case "quality":
					if (value == BitmapFilterQuality.HIGH.toString() || 
						value == BitmapFilterQuality.LOW.toString() || 
						value == BitmapFilterQuality.MEDIUM.toString()) 
							filter[name] = int(value);
					break;
					
				case "ratios":
					filter[name] = value.split(DELIMINATOR);
					break;
					
				case "scaleX":
					filter[name] = Number(value);
					break;
					
				case "scaleY":
					filter[name] = Number(value);
					break;
					
				case "shadowAlpha":
					filter[name] = Number(value);
					break;
					
				case "shadowColor":
					filter[name] = uint(value);
					break;
					
				case "strength":
					filter[name] = Number(value);
					break;
					
				case "type":
					if (value == BitmapFilterType.FULL || 
						value == BitmapFilterType.INNER || 
						value == BitmapFilterType.OUTER) 
							filter[name] = value;
					break;
			}
			
			return filter;
		}
		
	}
	
}