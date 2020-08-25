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
	import flash.display.DisplayObject;
	
	public class SimpleDragButton extends SimpleButton 
	{
		public static const DRAG_HEIGHT:String	= "dragHeight";
		public static const DRAG_WIDTH:String	= "dragWidth";
		public static const DRAG_X:String		= "dragX";
		public static const DRAG_Y:String		= "dragY";
		
		protected var _dragHeight:Number		= NaN;
		protected var _dragWidth:Number			= NaN;
		protected var _dragX:Number				= NaN;
		protected var _dragY:Number				= NaN;
		
		public function get dragHeight():Number { return _dragHeight; }
		public function set dragHeight(value:Number):void 
		{
			_dragHeight = value;
		}
		
		public function get dragWidth():Number { return _dragWidth; }
		public function set dragWidth(value:Number):void 
		{
			_dragWidth = value;
		}
		
		public function get dragX():Number { return _dragX; }
		public function set dragX(value:Number):void 
		{
			_dragX = value;
		}
		
		public function get dragY():Number { return _dragY; }
		public function set dragY(value:Number):void 
		{
			_dragY = value;
		}
		
		/**
		 * SimpleDragButton :: Constructor.
		 * @param	upState	<DisplayObject> object to be placed as the visual for the up state of the button.
		 * @param	overState	<DisplayObject> object to be placed as the visual for the over state of the button.
		 * @param	downState	<DisplayObject> object to be placed as the visual for the down state of the button.
		 * @param	hitTestState	<DisplayObject> object to be placed as the visual for the hit state of the button.
		 */
		public function SimpleDragButton(	upState:DisplayObject = null, 
											overState:DisplayObject = null, 
											downState:DisplayObject = null, 
											hitTestState:DisplayObject = null) 
		{
			super(upState, overState, downState, hitTestState);
		}
		
	}
	
}