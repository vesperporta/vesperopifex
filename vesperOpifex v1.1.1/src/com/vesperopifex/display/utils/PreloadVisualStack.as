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
package com.vesperopifex.display.utils 
{
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.display.ui.SimpleTable;
	import com.vesperopifex.events.GraphicEvent;
	import com.vesperopifex.events.PreloadStackEvent;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import flash.display.DisplayObject;
	
	public class PreloadVisualStack extends SimpleTable 
	{
		public static const XML_PRELOAD_VISUAL_STACK:String	= "preloadvisualstack";
		
		public var PreloadingVisual:Class					= PreloadVisual;
		
		/**
		 * Constructor.
		 */
		public function PreloadVisualStack() 
		{
			super();
			_columns	= 1;
			_rows = int.MAX_VALUE;
			padding	= 10;
		}
		
		/**
		 * create the graphics for this object.
		 */
		protected override function generateGraphics():void
		{
			if (_rows == int.MAX_VALUE && _columns == 1) rows	= XMLGraphicDisplay.countGraphicChildren(_data);
			super.generateGraphics();
		}
		
		public function update(fraction:Number, id:String):void 
		{
			var graphic:DisplayObject	= findGraphicChild(id);
			if (!graphic) return;
			if (graphic is IPreloadVisual) (graphic as IPreloadVisual).fraction	= fraction;
		}
		
		public function remove(data:XML = null):void 
		{
			
		}
		
	}
	
}

import com.vesperopifex.display.utils.IPreloadVisual;

class StackObject extends Object 
{
	private var _visual:IPreloadVisual	= null;
	private var _id:String				= null;
	
	public function StackObject(visual:IPreloadVisual, id:String) 
	{
		_visual	= visual;
		_id		= id;
	}
	
	public function get id():String { return _id; }
	
	public function get visual():IPreloadVisual { return _visual; }
	
}