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
	import com.vesperopifex.audio.AudioManager;
	import com.vesperopifex.display.accessibility.GraphicAccessibility;
	import com.vesperopifex.display.book.GraphicPage;
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.display.GraphicFactory;
	import com.vesperopifex.display.IXMLDataObject;
	import com.vesperopifex.display.video.VideoLoader;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	public class XMLGraphicDisplay extends Object 
	{
		public static const FACTORY:GraphicFactory			= new GraphicFactory();
		public static const XML_GRAPHIC:String				= "graphic";
		public static const XML_ID:String					= "id";
		public static const XML_MASK_ID:String				= "mask";
		public static const XML_CACHE_AS_BITMAP:String		= "cacheAsBitmap";
		public static const XML_DISPLAY_INDEX:String		= "displayindex";
		public static const XML_CLASS_TYPE:String			= "classtype";
		public static const XML_TOP_DISPLAY_INDEX:String	= "top";
		public static const XML_SRC:String					= "src";
		public static const DISPLAY_STACK_LIMIT:int			= int.MAX_VALUE;
		
		/**
		 * XMLGraphicDisplay :: Constructor.
		 */
		public function XMLGraphicDisplay() 
		{
			
		}
		
		/**
		 * find the number of children available to be generated as graphical objects and return the total number as an int object.
		 * @param	data	<XML>	the data pertaining to the graphical children.
		 * @return	<int>	the number of graphical objects available to be generated.
		 */
		public static function countGraphicChildren(data:XML):int 
		{
			return findGraphicXMLChildren(data).length();
		}
		
		/**
		 * createGraphics :: passing a block of XML data with graphical element specifications to generate the visual elements.
		 * @param	data	<XML>	data block to pass specifying the visual elements DisplayObjects.
		 * @return	<Array>	an Array object of all the objects created encapsulated in GraphicComponentObject(s).
		 */
		public static function createGraphics(data:XML):Array 
		{
			var rtn:Array						= new Array();
			var childIndex:int					= 0;
			var item:XML						= null;
			for each (item in findGraphicXMLChildren(data)) 
			{
				rtn.push(createGraphic(item, childIndex));
				childIndex++;
			}
			return rtn;
		}
		
		/**
		 * passing a block of XML data with graphical element specifications to generate the visual elements.
		 * @param	data	<XML>	data block to pass specifying the visual DisplayObject.
		 * @return	<GraphicComponentObject>	The object created encapsulated in a GraphicComponentObject.
		 */
		public static function createGraphic(data:XML, displayIndex:Number = NaN):GraphicComponentObject 
		{
			if (String(data.name()) != GraphicFactory.XML_GRAPHIC && !FACTORY.registeredXMLIdentifier(data)) return null;
			var graphic:DisplayObject			= FACTORY.generate(data);
			var gObject:GraphicComponentObject	= new GraphicComponentObject(graphic, (displayIndex)? displayIndex: 0, data);
			AudioManager.checkGraphicAudioEvents(gObject);
			return gObject;
		}
		
		/**
		 * passing all the children to find if the child XML block can be generated into a DisplayObject.
		 * @param	data	<XML>	the data block to be passed to find the graphical data.
		 * @return	<XMLList>	a list of XML objects which can be generated into DispalyObjects.
		 */
		protected static function findGraphicXMLChildren(data:XML):XMLList 
		{
			var rtn:XML			= <data></data>;
			var item:XML		= null;
			var contentItem:XML	= null;
			for each (item in data.children()) 
			{
				if (String(item.name()) == GraphicFactory.XML_CONTENT) 
					for each (contentItem in findGraphicXMLChildren(item)) 
						rtn.appendChild(contentItem);
				if (String(item.name()) == GraphicFactory.XML_GRAPHIC) 
					rtn.appendChild(item);
				if (FACTORY.registeredXMLIdentifier(item)) 
					rtn.appendChild(item);
			}
			return rtn.children();
		}
		
		/**
		 * findXMLDisplayIndex :: when passed a block of XML data, a variable on that data is found and returned in the form of a display index.
		 * @param	data	<XML>	data to pass for the display index of the assosiated object.
		 * @return	<int>	the resulting display index from the xml data.
		 */
		public static function findXMLDisplayIndex(data:XML):int 
		{
			var rtn:int = -1;
			
			if (data.@[XML_DISPLAY_INDEX].length()) 
			{
				if (data.@[XML_DISPLAY_INDEX] == XML_TOP_DISPLAY_INDEX) rtn = DISPLAY_STACK_LIMIT;
				else rtn = int(data.@[XML_DISPLAY_INDEX]);
			}
			
			return rtn;
		}
		
		/**
		 * checkXMLDisplayIndex :: pass a set of XML data with an assosiated DisplayObject to sort the display index on the containers display stack.
		 * @param	container	<DisplayObjectContainer>	the object to contain the child DisplayObject.
		 * @param	child	<DisplayObject>	the child to sort and find the display index from the XML data.
		 * @param	data	<XML>	data assosiated with the child DisplayObject to find the display index.
		 */
		public static function checkXMLDisplayIndex(container:DisplayObjectContainer, child:DisplayObject, data:XML):void 
		{
			if (container == child) return;
			var index:int = 0;
			
			index = (data)? findXMLDisplayIndex(data): DISPLAY_STACK_LIMIT;
			if (index != -1) 
			{
				container.removeChild(child);
				if (container.numChildren) 
				{
					if (index == DISPLAY_STACK_LIMIT) container.addChild(child);
					else 
					{
						if (index < container.numChildren) container.addChildAt(child, index);
						else container.addChild(child);
					}
				} else container.addChild(child);
			}
		}
		
		/**
		 * applyMaskSprites :: apply mask described in the XML data passed to the method.
		 * @param	maskObject	<GraphicComponentObject>	the mask to be applied to the graphic objects passed in the Array.
		 * @param	displayList	<Array>	an Array object of display obejects.
		 */
		public static function applyMaskSprites(maskObject:GraphicComponentObject, displayList:Array):void 
		{
			var item:XML							= null;
			var cacheAsBitmap:Boolean				= false;
			var displayObj:GraphicComponentObject	= null;
			
			if (maskObject.data.@[XML_CACHE_AS_BITMAP].length()) cacheAsBitmap = Boolean(maskObject.data.@[XML_CACHE_AS_BITMAP]);
			maskObject.graphic.cacheAsBitmap = cacheAsBitmap;
			
			for each (item in maskObject.data[XML_MASK_ID]) 
			{
				for each (displayObj in displayList) 
				{
					if (displayObj.data.@[XML_ID].toString() == item.toString()) 
					{
						if (cacheAsBitmap) displayObj.graphic.cacheAsBitmap = cacheAsBitmap;
						displayObj.graphic.mask = maskObject.graphic;
					}
				}
			}
		}
		
		/**
		 * applyGraphicDetails :: for each child stored for addition ot this component, apply any attributes from the XML to the object.
		 */
		public static function applyGraphicDetails(object:GraphicComponentObject):void
		{
			if (!object || !object.data || !object.graphic || !Boolean(object.data.attributes().length())) return;
			var graphic:DisplayObject	= object.graphic;
			var itemName:String			= null;
			var item:XML				= null;
			for each (item in object.data.attributes()) 
			{
				itemName = String(item.name());
				switch (itemName) 
				{
					
					case GraphicFactory.XML_DEFINITION:
						// do nothing as the 'definition' XML attribute is not an attribute for any DisplayObject.
						break;
						
					case GraphicFactory.XML_ENFORCED:
						// do nothing as the 'enforced' XML attribute is not an attribute for any DisplayObject.
						break;
						
					case GraphicFactory.XML_LIBRARY_CLASS:
						// do nothing as the 'libraryClass' XML attribute is not an attribute for any DisplayObject.
						break;
						
					case GraphicFactory.XML_CLASS:
						// do nothing as the 'class' XML attribute is not an attribute for any DisplayObject.
						break;
						
					case GraphicFactory.XML_ID:
						try 
						{
							graphic.name = String(item);
						} catch (error:Error) 
						{
							trace("Name not applied to object : " + graphic);
						}
						break;
						
					case GraphicFactory.XML_TYPE:
						// do nothing as the 'type' XML attribute is not an attribute for any DisplayObject.
						break;
						
					case GraphicFactory.XML_URL:
						// do nothing as the 'url' XML attribute is not an attribute for any DisplayObject.
						break;
						
					case GraphicFactory.XML_URL_CLASS:
						// do nothing as the 'urlClass' XML attribute is not an attribute for any DisplayObject.
						break;
						
					case XML_CLASS_TYPE:
						// do nothing as the 'classtype' XML attribute is not an attribute for any DisplayObject.
						break;
						
					case XML_DISPLAY_INDEX:
						// do nothing as the 'displayindex' XML attribute is not an attribute for any DisplayObject.
						break;
						
					case XML_SRC:
						// do nothing as the 'displayindex' XML attribute is not an attribute for any DisplayObject.
						break;
						
					default:
						// attempt to type the value.
						switch (String(item)) 
						{
							
							case ValueType.FALSE:
								graphic[itemName] = false;
								break;
								
							case ValueType.INFINITY:
								graphic[itemName] = Infinity;
								break;
								
							case ValueType.NAN:
								graphic[itemName] = NaN;
								break;
								
							case ValueType.NULL:
								graphic[itemName] = null;
								break;
								
							case ValueType.TRUE:
								graphic[itemName] = true;
								break;
								
							case ValueType.UNDEFINED:
								graphic[itemName] = undefined;
								break;
								
							default:
								if (String(item).indexOf(ValueType.UINT_INDEX) > -1) 
									graphic[itemName] = uint(item);
								else if (Boolean(Number(item))) 
									graphic[itemName] = Number(item);
								else 
									graphic[itemName] = String(item);
								break;
								
						}
						break;
						
				}
			}
			if (GraphicAccessibility.findAccessibilityData(object.data)) GraphicAccessibility.generateProperties(object);
			if (Boolean(graphic is IXMLDataObject)) (graphic as IXMLDataObject).XMLData	= object.data;
		}
		
		/**
		 * checkAsLoader :: checks to see if the passed child is a loader and returns a Boolean value true if it is a loader class otherwise false.
		 * @param	child	<DisplayObject> any DisplayObject can be passed to test if it is a loader class.
		 * @return	<Boolean>	returns true if the passed child is a loader or false if it is not.
		 */
		public static function checkAsLoader(child:DisplayObject):Boolean 
		{
			var rtn:Boolean = false;
			try 
			{
				rtn = Boolean(child as AbstractLoader);
			} catch (error:Error) 
			{
				return false;
			}
			return rtn;
		}
		
		/**
		 * checkAsLoader :: checks to see if the passed child is a loader and returns a Boolean value true if it is a loader class otherwise false.
		 * @param	child	<DisplayObject> any DisplayObject can be passed to test if it is a loader class.
		 * @return	<Boolean>	returns true if the passed child is a loader or false if it is not.
		 */
		public static function checkAsVideo(child:DisplayObject):Boolean 
		{
			var rtn:Boolean = false;
			try 
			{
				rtn = Boolean(child as VideoLoader);
			} catch (error:Error) 
			{
				return false;
			}
			return rtn;
		}
		
		/**
		 * checkLoaded :: checks if child passed is a loading asset and finds if the data loaded is the total amount for the asset.
		 * @param	child	<DisplayObject>	a visual Object which can be comprised of anything.
		 * @return	<Boolean>	if the DisplayObject is a loader and the bytes loaded is not equal to the total bytes for the asset then true is returned, if the loaded bytes equal the total then false is returned, and if the child is not a loader at all then false is returned.
		 */
		public static function checkLoaded(child:DisplayObject):Boolean 
		{
			var loader:AbstractLoader = null;
			try 
			{
				loader = child as AbstractLoader;
			} catch (error:Error) 
			{
				return false;
			}
			return loader.loadCompleted;
		}
		
		/**
		 * recreateTextFields :: pass through all elements of the Array object passed and determin which DisplayObjects are to be recreated in terms of being a TextField, regenerate the TextField object and pass back the Array of objects.
		 * @param	objectArray	<Array>	the object containing all graphical elements to test and recreate if the Class definition is a textField.
		 * @return	<Array>	the updated Array object which contain all the unmodified DisplayObject's and the newly created TextFields.
		 */
		public static function recreateDisplayObjects(objectsArray:Array):Array 
		{
			var object:GraphicComponentObject	= null;
			for each (object in objectsArray) 
				if (object.graphic is TextField) 
					object						= recreateDisplayObject(object);
			return objectsArray;
		}
		
		/**
		 * recreateTextFields :: pass through all elements of the Array object passed and determin which DisplayObjects are to be recreated in terms of being a TextField, regenerate the TextField object and pass back the Array of objects.
		 * @param	objectArray	<Array>	the object containing all graphical elements to test and recreate if the Class definition is a textField.
		 * @return	<Array>	the updated Array object which contain all the unmodified DisplayObject's and the newly created TextFields.
		 */
		public static function recreateDisplayObject(object:GraphicComponentObject):GraphicComponentObject 
		{
			return new GraphicComponentObject(FACTORY.generate(object.data), object.index, object.data);
		}
		
	}
	
}

class ValueType 
{
	public static const TRUE:String			= "true";
	public static const FALSE:String		= "false";
	public static const NULL:String			= "null";
	public static const NAN:String			= "nan";
	public static const INFINITY:String		= "infinity";
	public static const UNDEFINED:String	= "undefined";
	public static const UINT_INDEX:String	= "0x";
	
	public function ValueType() 
	{
		
	}
	
}