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
	import com.vesperopifex.display.IDataObject;
	import com.vesperopifex.events.DataEvent;
	import flash.events.MouseEvent;
	
	public class DataButton extends SimpleButton implements IDataObject 
	{
		protected var _dataUpdate:Object	= { string: "test-object" };
		
		public override function get dataUpdate():Object { return _dataUpdate; }
		public override function set dataUpdate(value:Object):void 
		{
			_dataUpdate	= value;
		}
		
		public function DataButton() 
		{
			addEventListener(MouseEvent.CLICK, clickEventHandler);
		}
		
		protected function clickEventHandler(event:MouseEvent):void 
		{
			dispatchEvent(new DataEvent(DataEvent.DATA_UPDATE, true, false, String("test-data") as Object));
		}
		
	}
	
}