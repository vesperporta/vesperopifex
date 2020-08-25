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
	
	public class GraphicDrawFactory extends Object 
	{
		public static const TYPE_RECTANGLE:String					= "rectangle";
		public static const TYPE_RECTANGLE_ALTERNATE:String			= "rect";
		public static const TYPE_ROUND_RECTANGLE:String				= "roundrectangle";
		public static const TYPE_ROUND_RECTANGLE_ALTERNATE:String	= "rndrect";
		public static const TYPE_CIRCLE:String						= "circle";
		public static const TYPE_CIRCLE_ALTERNATE:String			= "circ";
		public static const TYPE_ELLIPSE:String						= "ellipse";
		public static const TYPE_ELLIPSE_ALTERNATE:String			= "elli";
		public static const TYPE_TRIANGLE:String					= "triangle";
		public static const TYPE_TRIANGLE_ALTERNATE:String			= "tri";
		public static const TYPE_POLYGON:String						= "polygon";
		public static const TYPE_POLYGON_ALTERNATE:String			= "poly";
		public static const TYPE_POINT:String						= "point";
		public static const TYPE_MOVE_TO:String						= "moveTo";
		public static const TYPE_LINE_TO:String						= "lineTo";
		public static const TYPE_CURVE_TO:String					= "curveTo";
		public static const TYPE_END_FILL:String					= "endFill";
		public static const TYPE_CLEAR:String						= "clear";
		
		public function GraphicDrawFactory() 
		{
			super();
		}
		
		/**
		 * pass a string to find if the available compatability to generate the visual is available
		 * @param	value, String of the required visual generation
		 * @return	Boolean, true if the available string is compatable with the factory
		 */
		public function graphicAvailable(value:String):Boolean 
		{
			var rtn:Boolean = ( value == TYPE_RECTANGLE || 
								value == TYPE_RECTANGLE_ALTERNATE || 
								value == TYPE_ROUND_RECTANGLE || 
								value == TYPE_ROUND_RECTANGLE_ALTERNATE || 
								value == TYPE_CIRCLE || 
								value == TYPE_CIRCLE_ALTERNATE || 
								value == TYPE_ELLIPSE || 
								value == TYPE_ELLIPSE_ALTERNATE || /*
								value == TYPE_TRIANGLE || 
								value == TYPE_TRIANGLE_ALTERNATE || 
								value == TYPE_POLYGON || 
								value == TYPE_POLYGON_ALTERNATE || 
								value == TYPE_POINT || */
								value == TYPE_MOVE_TO || 
								value == TYPE_LINE_TO || 
								value == TYPE_CURVE_TO || 
								value == TYPE_END_FILL || 
								value == TYPE_CLEAR)? true: false;
			
			return rtn;
		}
		
		/**
		 * find the required actions to be taken with the Sprite object passed and take action with specific methods.
		 * @param	obj, Sprite object to use while generating the grphical elements.
		 * @param	data, XML data to transport drawing information to the required method.
		 * @return	Sprite, the modified Sprite object passed.
		 */
		public function generate(obj:Sprite, data:XML):Sprite 
		{
			switch (data.name().toString()) 
			{
				case TYPE_RECTANGLE:
					generateRectangle(obj, data);
					break;
					
				case TYPE_RECTANGLE_ALTERNATE:
					generateRectangle(obj, data);
					break;
					
				case TYPE_ROUND_RECTANGLE:
					generateRoundRectangle(obj, data);
					break;
					
				case TYPE_ROUND_RECTANGLE_ALTERNATE:
					generateRoundRectangle(obj, data);
					break;
					
				case TYPE_CIRCLE:
					generateCircle(obj, data);
					break;
					
				case TYPE_CIRCLE_ALTERNATE:
					generateCircle(obj, data);
					break;
					
				case TYPE_ELLIPSE:
					generateEllipse(obj, data);
					break;
					
				case TYPE_ELLIPSE_ALTERNATE:
					generateEllipse(obj, data);
					break;
					
				case TYPE_TRIANGLE:
					break;
					
				case TYPE_TRIANGLE_ALTERNATE:
					break;
					
				case TYPE_POLYGON:
					break;
					
				case TYPE_POLYGON_ALTERNATE:
					break;
					
				case TYPE_POINT:
					break;
					
				case TYPE_MOVE_TO:
					generateDraw(obj, data);
					break;
					
				case TYPE_LINE_TO:
					generateDraw(obj, data);
					break;
					
				case TYPE_CURVE_TO:
					generateDraw(obj, data);
					break;
					
				case TYPE_END_FILL:
					obj.graphics.endFill();
					break;
					
				case TYPE_CLEAR:
					obj.graphics.clear();
					break;
			}
			
			return obj;
		}
		
		/**
		 * using the Graphics Class of the Sprite passed draw a Rectangle
		 * @param	obj, Sprite object to use while generating the grphical elements.
		 * @param	data, XML data to transport drawing information to the required method.
		 * @return	Sprite, the modified Sprite object passed.
		 */
		private function generateRectangle(obj:Sprite, data:XML):Sprite 
		{
			var x:Number = 0;
			var y:Number = 0;
			var width:Number = 0;
			var height:Number = 0;
			
			if (data.@*.length() > 0) 
			{
				if (data.@x.toString() != "") x = Number(data.@x);
				if (data.@y.toString() != "") y = Number(data.@y);
				if (data.@width.toString() != "") width = Number(data.@width);
				if (data.@height.toString() != "") height = Number(data.@height);
			} else if (data.children().length() > 0) 
			{
				if (data.x.toString() != "") x = Number(data.x);
				if (data.y.toString() != "") y = Number(data.y);
				if (data.width.toString() != "") width = Number(data.width);
				if (data.height.toString() != "") height = Number(data.height);
			}
			
			obj.graphics.drawRect(x, y, width, height);
			
			return obj;
		}
		
		/**
		 * using the Graphics Class of the Sprite passed draw a Round Rectangle
		 * @param	obj, Sprite object to use while generating the grphical elements.
		 * @param	data, XML data to transport drawing information to the required method.
		 * @return	Sprite, the modified Sprite object passed.
		 */
		private function generateRoundRectangle(obj:Sprite, data:XML):Sprite 
		{
			var x:Number = 0;
			var y:Number = 0;
			var width:Number = 0;
			var height:Number = 0;
			var ellipseWidth:Number = 0;
			var ellipseHeight:Number = NaN;
			
			if (data.@*.length() > 0) 
			{
				if (data.@x.toString() != "") x = Number(data.@x);
				if (data.@y.toString() != "") y = Number(data.@y);
				if (data.@width.toString() != "") width = Number(data.@width);
				if (data.@height.toString() != "") height = Number(data.@height);
				if (data.@ellipseWidth.toString() != "") ellipseWidth = Number(data.@ellipseWidth);
				if (data.@ellipseHeight.toString() != "") ellipseHeight = Number(data.@ellipseHeight);
			} else if (data.children().length() > 0) 
			{
				if (data.x.toString() != "") x = Number(data.x);
				if (data.y.toString() != "") y = Number(data.y);
				if (data.width.toString() != "") width = Number(data.width);
				if (data.height.toString() != "") height = Number(data.height);
				if (data.ellipseWidth.toString() != "") ellipseWidth = Number(data.ellipseWidth);
				if (data.ellipseHeight.toString() != "") ellipseHeight = Number(data.ellipseHeight);
			}
			
			obj.graphics.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
			
			return obj;
		}
		
		/**
		 * using the Graphics Class of the Sprite passed draw a Circle
		 * @param	obj, Sprite object to use while generating the grphical elements.
		 * @param	data, XML data to transport drawing information to the required method.
		 * @return	Sprite, the modified Sprite object passed.
		 */
		private function generateCircle(obj:Sprite, data:XML):Sprite 
		{
			var x:Number = 0;
			var y:Number = 0;
			var radius:Number = 0;
			
			if (data.@*.length() > 0) 
			{
				if (data.@x.toString() != "") x = Number(data.@x);
				if (data.@y.toString() != "") y = Number(data.@y);
				if (data.@radius.toString() != "") radius = Number(data.@radius);
			} else if (data.children().length() > 0) 
			{
				if (data.x.toString() != "") x = Number(data.x);
				if (data.y.toString() != "") y = Number(data.y);
				if (data.radius.toString() != "") radius = Number(data.radius);
			}
			
			obj.graphics.drawCircle(x, y, radius);
			
			return obj;
		}
		
		/**
		 * using the Graphics Class of the Sprite passed draw an Ellipse
		 * @param	obj, Sprite object to use while generating the grphical elements.
		 * @param	data, XML data to transport drawing information to the required method.
		 * @return	Sprite, the modified Sprite object passed.
		 */
		private function generateEllipse(obj:Sprite, data:XML):Sprite 
		{
			var x:Number = 0;
			var y:Number = 0;
			var width:Number = 0;
			var height:Number = 0;
			
			if (data.@*.length() > 0) 
			{
				if (data.@x.toString() != "") x = Number(data.@x);
				if (data.@y.toString() != "") y = Number(data.@y);
				if (data.@width.toString() != "") width = Number(data.@width);
				if (data.@height.toString() != "") height = Number(data.@height);
			} else if (data.children().length() > 0) 
			{
				if (data.x.toString() != "") x = Number(data.x);
				if (data.y.toString() != "") y = Number(data.y);
				if (data.width.toString() != "") width = Number(data.width);
				if (data.height.toString() != "") height = Number(data.height);
			}
			
			obj.graphics.drawEllipse(x, y, width, height);
			
			return obj;
		}
		
		/**
		 * using the Graphics Class of the Sprite passed draw a Triangle
		 * @param	obj, Sprite object to use while generating the grphical elements.
		 * @param	data, XML data to transport drawing information to the required method.
		 * @return	Sprite, the modified Sprite object passed.
		 */
		private function generateTriangle(obj:Sprite, data:XML):Sprite 
		{
			return obj;
		}
		
		/**
		 * using the Graphics Class of the Sprite passed draw a Polygon
		 * @param	obj, Sprite object to use while generating the grphical elements.
		 * @param	data, XML data to transport drawing information to the required method.
		 * @return	Sprite, the modified Sprite object passed.
		 */
		private function generatePolygon(obj:Sprite, data:XML):Sprite 
		{
			return obj;
		}
		
		/**
		 * using the Graphics Class of the Sprite passed draw a Ponit (a rectangle of 1 pixel width and height at the designated x and y point)
		 * @param	obj, Sprite object to use while generating the grphical elements.
		 * @param	data, XML data to transport drawing information to the required method.
		 * @return	Sprite, the modified Sprite object passed.
		 */
		private function generatePoint(obj:Sprite, data:XML):Sprite 
		{
			return obj;
		}
		
		/**
		 * using the Graphics Class of the Sprite passed draw using selected Class tools
		 * @param	obj, Sprite object to use while generating the grphical elements.
		 * @param	data, XML data to transport drawing information to the required method.
		 * @return	Sprite, the modified Sprite object passed.
		 */
		private function generateDraw(obj:Sprite, data:XML):Sprite 
		{
			var x:Number = 0;
			var y:Number = 0;
			var anchorX:Number = 0;
			var anchorY:Number = 0;
			
			if (data.@*.length() > 0) 
			{
				if (data.@x.toString() != "") x = Number(data.@x);
				if (data.@y.toString() != "") y = Number(data.@y);
				if (data.@anchorX.toString() != "") anchorX = Number(data.@anchorX);
				if (data.@anchorY.toString() != "") anchorY = Number(data.@anchorY);
			} else if (data.children().length() > 0) 
			{
				if (data.x.toString() != "") x = Number(data.x);
				if (data.y.toString() != "") y = Number(data.y);
				if (data.anchorX.toString() != "") anchorX = Number(data.anchorX);
				if (data.anchorY.toString() != "") anchorY = Number(data.anchorY);
			}
			
			switch (data.name().toString()) 
			{
				case TYPE_MOVE_TO:
					obj.graphics.moveTo(x, y);
					break;
					
				case TYPE_LINE_TO:
					obj.graphics.lineTo(x, y);
					break;
					
				case TYPE_CURVE_TO:
					obj.graphics.curveTo(x, y, anchorX, anchorY);
					break;
			}
			
			return obj;
		}
		
	}
	
}