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
package com.vesperopifex.display.ui 
{
	import com.vesperopifex.display.IXMLDataObject;
	import flash.display.Sprite;
	
	public class SimpleMenu extends Sprite implements IXMLDataObject 
	{
		protected var _data:XML			= null;
		protected var _eventData:XML	= null;
		
		public function get eventData():XML { return _eventData; }
		
		public function get XMLData():XML { return _data; }
		public function set XMLData(value:XML):void 
		{
			_data = value;
		}
		
		/**
		 * SimpleMenu :: Constructor. A simplistic menu system where all interactive objects are kept in an organised visual array with a common spacer between them.
		 */
		public function SimpleMenu() 
		{
			super();
		}
		
		/**
		 * dataUpdate :: for any data to be submited to this class it checks to see if the Object object is actually an XML object where it will be sent to the protected function xmlUpdate for processing, otherwise the object is delt with on a per Class basis checking the data is valid and assigning the data where required.
		 * @param	value	<Object>	either an Object or XML object containing a particular data set.
		 */
		public function dataUpdate(value:Object):void 
		{
			if (value is XML) xmlUpdate(value as XML);
		}
		
		/**
		 * xmlUpdate :: a parser which varifies the passed value and assigns data where required.
		 * @param	value	<XML> data containing a particular data set for Class implementation.
		 */
		protected function xmlUpdate(value:XML):void 
		{
			
		}
		
	}
	
}