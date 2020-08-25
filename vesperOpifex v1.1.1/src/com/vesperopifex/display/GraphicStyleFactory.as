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
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.display.SpreadMethod;
	import flash.display.LineScaleMode;
	import flash.display.InterpolationMethod;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	public class GraphicStyleFactory extends Object 
	{
		public static const XML_STYLE:String			= "style";
		public static const XML_STYLE_TYPE:String		= "styletype";
		public static const LINE_STYLE:String			= "lineStyle";
		public static const LINE_GRADIENT_STYLE:String	= "gradientLineStyle";
		public static const FILL_STYLE:String			= "fill";
		public static const FILL_GRADIENT_STYLE:String	= "gradientFill";
		public static const FILL_BITMAP_STYLE:String	= "bitmapFill";
		
		private static const ARRAY_DELIMINATOR:String	= ",";
		private static const OBJECT_DELIMINATOR:String	= ":";
		private static const CACHE:BitmapCache			= new BitmapCache();
		
		/**
		 * Constructor
		 */
		public function GraphicStyleFactory() 
		{
			super();
		}
		
		/**
		 * Identify if the styling being requested isavailable
		 * @param	value, String of the styling requested.
		 * @return	Boolean, true is the value passed is a compatible style value.
		 */
		public function styleAvailable(value:String):Boolean 
		{
			var rtn:Boolean = ( value == LINE_STYLE || 
								value == LINE_GRADIENT_STYLE || 
								value == FILL_STYLE || 
								value == FILL_GRADIENT_STYLE || 
								value == FILL_BITMAP_STYLE)? true: false;
			
			return rtn;
		}
		
		/**
		 * identify the type of styling required and apply to the Sprite object passed.
		 * @param	obj, Sprite object for teh styling to take place upon.
		 * @param	data, XML data containing information regarding the styling paramaters.
		 * @return	Sprite, the edited Sprite object passed.
		 */
		public function stylise(obj:Sprite, data:XML):Sprite 
		{
			var type:String = (data.@[XML_STYLE_TYPE].length())? data.@[XML_STYLE_TYPE].toString(): data[XML_STYLE_TYPE].toString();
			
			switch (type) 
			{
				case LINE_STYLE:
					generateLineStyle(obj, data);
					break;
					
				case LINE_GRADIENT_STYLE:
					generateGradientStyle(obj, data);
					break;
					
				case FILL_STYLE:
					generateFillStyle(obj, data);
					break;
					
				case FILL_GRADIENT_STYLE:
					generateGradientStyle(obj, data);
					break;
					
				case FILL_BITMAP_STYLE:
					generateBitmapStyle(obj, data);
					break;
			}
			
			return obj;
		}
		
		/**
		 * Apply a line style specified layed out 
		 * @param	obj, Sprite object for teh styling to take place upon.
		 * @param	data, XML data containing information regarding the styling paramaters.
		 * @return	Sprite, the edited Sprite object passed.
		 */
		private function generateLineStyle(obj:Sprite, data:XML):Sprite 
		{
			var thickness:Number		= NaN;
			var color:uint				= 0;
			var alpha:Number			= 1.0;
			var pixelHinting:Boolean	= false;
			var scaleMode:String		= LineScaleMode.NORMAL;
			var caps:String				= null;
			var joints:String			= null;
			var miterLimit:Number		= 3;
			var str:String				= null;
			
			if (data.@*.length()) 
			{
				if (data.@thickness.length()) thickness = Number(data.@thickness);
				if (data.@color.length()) color = uint(data.@color);
				if (data.@alpha.length()) alpha = Number(data.@alpha);
				if (data.@pixelHinting.length()) pixelHinting = Boolean(data.@pixelHinting);
				if (data.@scaleMode.length()) 
				{
					str = data.@scaleMode.toString();
					if (str == LineScaleMode.HORIZONTAL || 
						str == LineScaleMode.NONE || 
						str == LineScaleMode.NORMAL || 
						str == LineScaleMode.VERTICAL) 
							scaleMode = str;
				}
				if (data.@caps.toString() == CapsStyle.NONE || 
					data.@caps.toString() == CapsStyle.ROUND || 
					data.@caps.toString() == CapsStyle.SQUARE) 
						caps = data.@caps.toString();
				if (data.@joints.toString() == JointStyle.BEVEL || 
					data.@joints.toString() == JointStyle.MITER || 
					data.@joints.toString() == JointStyle.ROUND) 
						joints = data.@joints.toString();
				if (data.@miterLimit.length()) miterLimit = Number(data.@miterLimit);
			} else if (data.children().length()) 
			{
				if (data.thickness.length()) thickness = Number(data.thickness);
				if (data.color.length()) color = uint(data.color);
				if (data.alpha.length()) alpha = Number(data.alpha);
				if (data.pixelHinting.length()) pixelHinting = Boolean(data.pixelHinting);
				if (data.scaleMode.length()) 
				{
					str = data.scaleMode.toString();
					if (str == LineScaleMode.HORIZONTAL || 
						str == LineScaleMode.NONE || 
						str == LineScaleMode.NORMAL || 
						str == LineScaleMode.VERTICAL) 
							scaleMode = str;
				}
				if (data.caps.toString() == CapsStyle.NONE || 
					data.caps.toString() == CapsStyle.ROUND || 
					data.caps.toString() == CapsStyle.SQUARE) 
						caps = data.caps.toString();
				if (data.joints.toString() == JointStyle.BEVEL || 
					data.joints.toString() == JointStyle.MITER || 
					data.joints.toString() == JointStyle.ROUND) 
						joints = data.joints.toString();
				if (data.miterLimit.length()) miterLimit = Number(data.miterLimit);
			}
			
			obj.graphics.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
			
			return obj;
		}
		
		/**
		 * Apply a fill styling to the obj passed.
		 * @param	obj, Sprite object for teh styling to take place upon.
		 * @param	data, XML data containing information regarding the styling paramaters.
		 * @return	Sprite, the edited Sprite object passed.
		 */
		private function generateFillStyle(obj:Sprite, data:XML):Sprite 
		{
			var color:uint = 0;
			var alpha:Number = 1.0;
			
			if (data.@*.length()) 
			{
				if (data.@color.length()) color = uint(data.@color);
				if (data.@alpha.length()) alpha = Number(data.@alpha);
			} else if (data.children().length()) 
			{
				if (data.color.length()) color = uint(data.color);
				if (data.alpha.length()) alpha = Number(data.alpha);
			}
			
			obj.graphics.beginFill(color, alpha);
			
			return obj;
		}
		
		/**
		 * Apply a bitmap fill to the Sprite object passed
		 * @param	obj, Sprite object for teh styling to take place upon.
		 * @param	data, XML data containing information regarding the styling paramaters.
		 * @return	Sprite, the edited Sprite object passed.
		 */
		private function generateBitmapStyle(obj:Sprite, data:XML):Sprite 
		{
			var bitmap:BitmapData	= null;
			var matrix:Matrix		= null;
			var repeat:Boolean		= true;
			var smooth:Boolean		= false;
			var tmpArr:Array		= null;
			var str:String			= null;
			var i:int				= 0;
			
			if (data.@*.length()) 
			{
				if (data.@bitmap.length()) bitmap = CACHE.retrieveImageData(data.@bitmap.toString());
				if (data.@matrix.length()) 
				{
					matrix = new Matrix();
					tmpArr = data.@matrix.toString().split(ARRAY_DELIMINATOR);
					for (i = 0; i < tmpArr.length; i++) 
					{
						tmpArr[i] = (tmpArr[i] as String).split(OBJECT_DELIMINATOR);
						matrix[tmpArr[i][0]] = Number(tmpArr[i][1]);
					}
				}
				if (data.@repeat.length()) repeat = Boolean(data.@repeat);
				if (data.@smooth.length()) smooth = Boolean(data.@smooth);
			} else if (data.children().length()) 
			{
				if (data.bitmap.length()) bitmap = CACHE.retrieveImageData(data.bitmap.toString());
				if (data.matrix.length()) 
				{
					matrix = new Matrix();
					tmpArr = data.matrix.toString().split(ARRAY_DELIMINATOR);
					for (i = 0; i < tmpArr.length; i++) 
					{
						tmpArr[i] = (tmpArr[i] as String).split(OBJECT_DELIMINATOR);
						matrix[tmpArr[i][0]] = Number(tmpArr[i][1]);
					}
				}
				if (data.repeat.length()) repeat = Boolean(data.repeat);
				if (data.smooth.length()) smooth = Boolean(data.smooth);
			}
			
			obj.graphics.beginBitmapFill(bitmap, matrix, repeat, smooth);
			
			return obj;
		}
		/**
		 * Apply a gradient styling to either the line or fill of the Sprite object passed
		 * @param	obj, Sprite object for teh styling to take place upon.
		 * @param	data, XML data containing information regarding the styling paramaters.
		 * @return	Sprite, the edited Sprite object passed.
		 */
		private function generateGradientStyle(obj:Sprite, data:XML):Sprite 
		{
			var type:String					= GradientType.LINEAR;
			var colors:Array				= new Array();
			var alphas:Array				= new Array();
			var ratios:Array				= new Array();
			var matrix:Matrix				= null;
			var spreadMethod:String			= SpreadMethod.PAD;
			var interpolationMethod:String	= InterpolationMethod.RGB;
			var focalPointRatio:Number		= 0;
			var str:String					= null;
			var tmpArr:Array				= null;
			var i:int						= 0;
			
			if (data.@*.length()) 
			{
				if (data.@type.length()) 
				{
					str = data.@type.toString();
					if (str == GradientType.LINEAR || 
						str == GradientType.RADIAL) 
							type = str;
				}
				if (data.@colors.length()) 
				{
					tmpArr = data.@colors.toString().split(ARRAY_DELIMINATOR);
					for (i = 0; i < tmpArr.length; i++) colors[i] = uint(tmpArr[i]);
				}
				if (data.@alphas.length()) 
				{
					tmpArr = data.@alphas.toString().split(ARRAY_DELIMINATOR);
					for (i = 0; i < tmpArr.length; i++) alphas[i] = Number(tmpArr[i]);
				}
				if (data.@ratios.length()) 
				{
					tmpArr = data.@ratios.toString().split(ARRAY_DELIMINATOR);
					for (i = 0; i < tmpArr.length; i++) ratios[i] = Number(tmpArr[i]);
				}
				if (data.@matrix.length()) 
				{
					matrix = new Matrix();
					tmpArr = data.@matrix.toString().split(ARRAY_DELIMINATOR);
					for (i = 0; i < tmpArr.length; i++) Number(tmpArr[i]);
					matrix.createGradientBox(tmpArr[0], tmpArr[1], tmpArr[2], tmpArr[3], tmpArr[4]);
				}
				if (data.@spreadMethod.length()) 
				{
					str = data.@spreadMethod;
					if (str == SpreadMethod.PAD || 
						str == SpreadMethod.REFLECT || 
						str == SpreadMethod.REPEAT)
							spreadMethod = str;
				}
				if (data.@interpolationMethod.length()) 
				{
					str = data.@interpolationMethod;
					if (str == InterpolationMethod.LINEAR_RGB || 
						str == InterpolationMethod.RGB)
							interpolationMethod = str;
				}
				if (data.@focalPointRatio.length()) focalPointRatio = Number(data.@focalPointRatio);
			} else if (data.children().length()) 
			{
				if (data.type.length()) 
				{
					str = data.type.toString();
					if (str == GradientType.LINEAR || 
						str == GradientType.RADIAL) 
							type = str;
				}
				if (data.colors.length()) 
				{
					tmpArr = data.colors.toString().split(ARRAY_DELIMINATOR);
					for (i = 0; i < tmpArr.length; i++) tmpArr[i] = uint(tmpArr[i]);
					colors = tmpArr;
				}
				if (data.alphas.length()) 
				{
					tmpArr = data.alphas.toString().split(ARRAY_DELIMINATOR);
					for (i = 0; i < tmpArr.length; i++) tmpArr[i] = Number(tmpArr[i]);
					alphas = tmpArr;
				}
				if (data.ratios.length()) 
				{
					tmpArr = data.ratios.toString().split(ARRAY_DELIMINATOR);
					for (i = 0; i < tmpArr.length; i++) tmpArr[i] = Number(tmpArr[i]);
					ratios = tmpArr;
				}
				if (data.matrix.length()) 
				{
					matrix = new Matrix();
					tmpArr = data.matrix.toString().split(ARRAY_DELIMINATOR);
					for (i = 0; i < tmpArr.length; i++) Number(tmpArr[i]);
					matrix.createGradientBox(tmpArr[0], tmpArr[1], tmpArr[2], tmpArr[3], tmpArr[4]);
				}
				if (data.spreadMethod.length()) 
				{
					str = data.spreadMethod;
					if (str == SpreadMethod.PAD || 
						str == SpreadMethod.REFLECT || 
						str == SpreadMethod.REPEAT)
							spreadMethod = str;
				}
				if (data.interpolationMethod.length()) 
				{
					str = data.interpolationMethod;
					if (str == InterpolationMethod.LINEAR_RGB || 
						str == InterpolationMethod.RGB)
							interpolationMethod = str;
				}
				if (data.focalPointRatio.length()) focalPointRatio = Number(data.focalPointRatio);
			}
			
			if (data.@[XML_STYLE_TYPE].toString() == LINE_GRADIENT_STYLE) 
				obj.graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			else if (data.@[XML_STYLE_TYPE].toString() == FILL_GRADIENT_STYLE) 
				obj.graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			
			return obj;
		}
		
	}
	
}