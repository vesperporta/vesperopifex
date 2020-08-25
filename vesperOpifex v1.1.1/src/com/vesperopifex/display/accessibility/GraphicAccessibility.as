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
package com.vesperopifex.display.accessibility 
{
	import com.vesperopifex.display.GraphicComponentObject;
	import flash.accessibility.Accessibility;
	import flash.display.DisplayObject;
	
	public class GraphicAccessibility extends DisplayObject 
	{
		public static const XML_ACCESSIBILITY:String			= "accessibility";
		public static const XML_DESCRIPTION:String				= "description";
		public static const XML_FORCESIMPLE:String				= "forcesimple";
		public static const XML_NAME:String						= "name";
		public static const XML_NOAUTOLABELING:String			= "noautolabeling";
		public static const XML_SHORTCUT:String					= "shortcut";
		public static const XML_SILENT:String					= "silent";
		
		protected static const ACCESSIBILITY_ENABLE:Boolean		= true;
		protected static const ACCESSIBILITY_DISABLE:Boolean	= false;
		
		/**
		 * GraphicAccessibility :: Constructor.
		 */
		public function GraphicAccessibility() 
		{
			
		}
		
		/**
		 * update :: update all Accessibility properties.
		 */
		public static function update():void 
		{
			Accessibility.updateProperties();
		}
		
		/**
		 * enable :: enable all Accessibility properties on the current graphical object.
		 */
		public static function enable(gObject:GraphicComponentObject):void 
		{
			if (findAccessibilityData(gObject.data)) gObject.graphic.accessibilityProperties.silent = ACCESSIBILITY_ENABLE;
		}
		
		/**
		 * disable :: disable all Accessibility properties on the current graphical object.
		 */
		public static function disable(gObject:GraphicComponentObject):void 
		{
			if (findAccessibilityData(gObject.data)) gObject.graphic.accessibilityProperties.silent = ACCESSIBILITY_DISABLE;
		}
		
		/**
		 * generateProperties :: find in the data passed if there are accessibility options embedded into the XML and apply them to the graphic object.
		 * @param	gObject	<GraphicComponentObject>	Generic object containing the graphic object and data.
		 */
		public static function generateProperties(gObject:GraphicComponentObject):void 
		{
			var item:XML				= null;
			var data:XML				= findAccessibilityData(gObject.data);
			var graphic:DisplayObject	= gObject.graphic;
			
			if (data) 
			{
				for each (item in data..*) 
					if (validateData(item)) 
						graphic.accessibilityProperties[item.name().toString()] = item.toString();
			} else 
			{
				if (item.@id.length())
					graphic.accessibilityProperties.name = item.@id.toString();
			}
			
			update();
		}
		
		/**
		 * findAccessibilityData :: loop through all the available data and find the data which cooresponds to the Accessibility options.
		 * @param	data	<XML>	data containing paramaters for the accessibility.
		 * @return	<XML>	the data containing the required data.
		 */
		public static function findAccessibilityData(data:XML):XML 
		{
			var item:XML	= null;
			
			for each (item in data..*) 
				if (Boolean(item.name()) && item.name().toString() == XML_ACCESSIBILITY) 
					return item.copy();
			
			return null;
		}
		
		/**
		 * validateData :: check that the data passed corelates to the required fields.
		 * @param	data	<XML>	data to validate.
		 * @return	<Boolean>	true if data passed is correct, false otherwise.

		 */
		protected static function validateData(data:XML):Boolean 
		{
			var name:String	= String(data.name());
			
			if (data.hasComplexContent()) return false;
			if (name == XML_DESCRIPTION || 
				name == XML_FORCESIMPLE || 
				name == XML_NAME || 
				name == XML_NOAUTOLABELING || 
				name == XML_SHORTCUT || 
				name == XML_SILENT) 
					return true;
			else return false;
		}
		
	}
	
}
