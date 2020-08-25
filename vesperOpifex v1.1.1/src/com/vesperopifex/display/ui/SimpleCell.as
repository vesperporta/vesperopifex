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
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.display.GraphicFactory;
	import com.vesperopifex.display.IXMLDataObject;
	import com.vesperopifex.display.SimpleInformationPanel;
	import com.vesperopifex.events.GraphicEvent;
	import com.vesperopifex.events.GraphicFactoryEvent;
	import com.vesperopifex.events.SimpleTableEvent;
	import com.vesperopifex.events.StyleSheetFactoryEvent;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class SimpleCell extends SimpleInformationPanel 
	{
		public static const XML_NODE:String			= "cell";
		public static const XML_DEFAULT:XML			= <cell></cell>;
		
		private static var _count:int				= 0;
		
		public static var REGISTERED:Boolean		= GraphicFactory.registerGenerator(XML_NODE, generateCell);
		
		protected var _width:Number					= NaN;
		protected var _height:Number				= NaN;
		protected var _childrenWidth:Number			= NaN;
		protected var _childrenHeight:Number		= NaN;
		protected var _spanRows:int					= 1;
		protected var _spanColumns:int				= 1;
		protected var _align:String					= SimpleCellAlign.CENTER;
		protected var _stretch:String				= SimpleCellStretch.NONE;
		protected var _rounded:Number				= 0;
		protected var _background:Boolean			= false;
		protected var _backgroundColor:uint			= 0xFFFFFF;
		protected var _backgroundAlpha:Number		= 1;
		protected var _border:Boolean				= false;
		protected var _borderColor:uint				= 0x000000;
		protected var _borderAlpha:Number			= 1;
		protected var _borderWidth:Number			= 1;
		protected var _backgroundObject:Sprite		= null;
		protected var _id:String					= null;
		protected var _relativePosition:Boolean		= false;
		protected var _finishedGeneration:Boolean	= false;
		
		public function get rounded():Number { return _rounded; }
		public function set rounded(value:Number):void 
		{
			_rounded = value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get stretch():String { return _stretch; }
		public function set stretch(value:String):void 
		{
			if (value != SimpleCellStretch.BOTH || 
				value != SimpleCellStretch.HEIGHT || 
				value != SimpleCellStretch.NONE || 
				value != SimpleCellStretch.WIDTH || 
				value != SimpleCellStretch.WIDTH_HEIGHT) 
					return;
			_stretch = value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get align():String { return _align; }
		public function set align(value:String):void 
		{
			if (value != SimpleCellAlign.BOTTOM || 
				value != SimpleCellAlign.BOTTOM_LEFT || 
				value != SimpleCellAlign.BOTTOM_RIGHT || 
				value != SimpleCellAlign.CENTER || 
				value != SimpleCellAlign.LEFT || 
				value != SimpleCellAlign.RIGHT || 
				value != SimpleCellAlign.TOP || 
				value != SimpleCellAlign.TOP_LEFT || 
				value != SimpleCellAlign.TOP_RIGHT) 
					return;
			_align = value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get id():String { return _id; }
		
		public override function get width():Number { return findWidth(); }
		public override function set width(value:Number):void 
		{
			_width	= value;
			if (_finishedGeneration) updateCell();
		}
		
		public override function get height():Number { return findHeight(); }
		public override function set height(value:Number):void 
		{
			_height	= value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get spanRows():int { return _spanRows; }
		public function set spanRows(value:int):void 
		{
			_spanRows = value;
		}
		
		public function get spanColumns():int { return _spanColumns; }
		public function set spanColumns(value:int):void 
		{
			_spanColumns = value;
		}
		
		public function get background():Boolean { return _background; }
		public function set background(value:Boolean):void 
		{
			_background = value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get border():Boolean { return _border; }
		public function set border(value:Boolean):void 
		{
			_border = value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void 
		{
			_backgroundColor = value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get borderColor():uint { return _borderColor; }
		public function set borderColor(value:uint):void 
		{
			_borderColor = value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get backgroundAlpha():Number { return _backgroundAlpha; }
		public function set backgroundAlpha(value:Number):void 
		{
			_backgroundAlpha = value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get borderAlpha():Number { return _borderAlpha; }
		public function set borderAlpha(value:Number):void 
		{
			_borderAlpha = value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get borderWidth():Number { return _borderWidth; }
		public function set borderWidth(value:Number):void 
		{
			_borderWidth = value;
			if (_finishedGeneration) updateCell();
		}
		
		public function get relativePosition():Boolean { return _relativePosition; }
		public function set relativePosition(value:Boolean):void 
		{
			for each (var object:GraphicComponentObject in _children) 
			{
				object.graphic.x	= 0;
				object.graphic.y	= 0;
			}
			applyGraphicDetails();
			_relativePosition = value;
			if (_finishedGeneration) updateCell();
		}
		
		/**
		 * Generate itself for implementation into the GraphicFactory generator, for on the fly creation without the requirement to be hand coded into the GraphicFactory Class.
		 * @param	data	<XML>	the data pertaining to the generation of the Class.
		 * @return	<DisplayObject>	the resulting object to be passed back for further actioning.
		 */
		public static function generateCell(data:XML):DisplayObject 
		{
			return new SimpleCell() as DisplayObject;
		}
		
		/**
		 * find the width of this SimpleCell either from the assigned width attribute, from the _childrenWidth or by passing through all avialbale children and finding the highest width.
		 * @return	<Number>	the width of this SimpleCell
		 */
		protected function findWidth():Number 
		{
			var rtn:Number	= 0;
			if (_width) rtn	= _width;
			else if (_childrenWidth) 
				rtn			= _childrenWidth;
			else 
			{
				for each (var object:GraphicComponentObject in _children) 
					if (rtn < object.graphic.width) 
						rtn	= object.graphic.width;
			}
			return rtn;
		}
		
		/**
		 * find the height of this SimpleCell either from the assigned height attribute, from the _childrenHeight or by passing through all avialbale children and finding the highest height.
		 * @return	<Number>	the height of this SimpleCell
		 */
		protected function findHeight():Number 
		{
			var rtn:Number		= 0;
			if (_height) rtn	= _height;
			else if (_childrenHeight) 
				rtn				= _childrenHeight;
			else 
			{
				for each (var object:GraphicComponentObject in _children) 
					if (rtn < object.graphic.height) 
						rtn		= object.graphic.height;
			}
			return rtn;
		}
		
		/**
		 * SimpleCell :: Constructor.
		 * @param	contents	<GraphicComponentObject>	An optional paramater to automatically add a graphical child to the display stack.
		 */
		public function SimpleCell(contents:GraphicComponentObject = null) 
		{
			_id	= String(_count++);
			super();
			if (contents) addGraphic(contents);
		}
		
		/**
		 * generateGraphics :: create the graphics for this object.
		 */
		protected override function generateGraphics():void
		{
			super.generateGraphics();
			for each (var object:GraphicComponentObject in _children) 
				if (object.graphic is IXMLDataObject) 
				{
					object.graphic.addEventListener(GraphicEvent.COMPLETE, graphicCompleteNewHandler);
					object.graphic.addEventListener(GraphicEvent.COMPLETE_NEW, graphicCompleteNewHandler);
				}
		}
		
		/**
		 * generateGraphics :: create the outstanding graphics for this object.
		 */
		protected override function generateWaitingGraphics():void
		{
			super.generateWaitingGraphics();
			for each (var object:GraphicComponentObject in _children) 
				if (object.graphic is IXMLDataObject) 
				{
					if (!object.graphic.hasEventListener(GraphicEvent.COMPLETE)) object.graphic.addEventListener(GraphicEvent.COMPLETE, graphicCompleteNewHandler);
					if (!object.graphic.hasEventListener(GraphicEvent.COMPLETE_NEW)) object.graphic.addEventListener(GraphicEvent.COMPLETE_NEW, graphicCompleteNewHandler);
				}
		}
		
		/**
		 * Add a graphical element to this cell and handle the positioning as described by the SimpleCell.
		 * @param	child	<GraphicComponentObject>	the graphical element being add to the cell.
		 * @return	<GraphicComponentObject>	the graphical element added to the cell.
		 */
		public function addGraphic(child:GraphicComponentObject):GraphicComponentObject 
		{
			_children.push(child);
			if (child.graphic is IXMLDataObject) child.graphic.addEventListener(GraphicEvent.COMPLETE_NEW, graphicCompleteNewHandler);
			child.graphic.addEventListener(Event.ADDED_TO_STAGE, graphicAddedHandler);
			addChild(child.graphic);
			return child;
		}
		
		/**
		 * pass data to generate a single graphical object.
		 * @param data	<XML>	the data pertaining to the generation of a graphical object.
		 * @return	<GraphicComponentObject>	the resulting object from the generation of the graphic.
		 */		
		public function addXMLGraphic(data:XML):GraphicComponentObject 
		{
			XMLGraphicDisplay.FACTORY.addEventListener(GraphicFactoryEvent.FINISHED, addGraphicFactoryFinishedHandler);
			var object:GraphicComponentObject	= processGraphicalObject(XMLGraphicDisplay.createGraphic(data));
			object.graphic.addEventListener(Event.ADDED_TO_STAGE, graphicAddedHandler);
			_children.push(object);
			addGraphicChildren(object);
			applyGraphicDetails(object);
			applyContextEvents(object);
			applyMaskSprites(object);
			return object;
		}
		
		protected function addGraphicFactoryFinishedHandler(event:GraphicFactoryEvent):void 
		{
			XMLGraphicDisplay.FACTORY.removeEventListener(GraphicFactoryEvent.FINISHED, addGraphicFactoryFinishedHandler);
		}
		
		/**
		 * when the directly added child has been added to the stage, dispatch the required calls to setup the positioning within the table.
		 * @param	event	<Event>	the event dispatched from the DisplayObject when added to the stage.
		 */
		protected function graphicAddedHandler(event:Event):void 
		{
			(event.target as DisplayObject).removeEventListener(Event.ADDED_TO_STAGE, graphicAddedHandler);
			dispatchEvent(new GraphicEvent(GraphicEvent.COMPLETE));
			finishedGraphicGeneration();
		}
		
		/**
		 * when a graphic has generated a new graphic internally to that instance this handler is called to update the positioning of teh table.
		 * @param	event	<GraphicEvent>	the event dispatched from the graphic generator.
		 */
		protected function graphicCompleteNewHandler(event:GraphicEvent):void 
		{
			(event.target as IEventDispatcher).removeEventListener(GraphicEvent.COMPLETE, graphicCompleteNewHandler);
			(event.target as IEventDispatcher).removeEventListener(GraphicEvent.COMPLETE_NEW, graphicCompleteNewHandler);
			if (event.cancelable) event.stopImmediatePropagation();
			updateCell();
			_finishedGeneration	= true;
			dispatchEvent(new GraphicEvent(GraphicEvent.COMPLETE));
		}
		
		/**
		 * add all the finishing parts to the generated graphics.
		 */
		protected override function finishedGraphicGeneration():void 
		{
			super.finishedGraphicGeneration();
			_finishedGeneration	= true;
			updateCell();
			if (hasEventListener(SimpleTableEvent.CELL_UPDATE)) dispatchEvent(new SimpleTableEvent(SimpleTableEvent.CELL_UPDATE));
		}
		
		/**
		 * styleSheetCompleteHandler :: handler for new StyleSheets being loaded in, now have to recreate the TextFields for display.
		 * @param	event	<StyleSheetFactoryEvent> event dispatched from the StyleSheet loader.
		 */
		protected override function styleSheetCompleteHandler(event:StyleSheetFactoryEvent):void 
		{
			super.styleSheetCompleteHandler(event);
			updateCell();
			if (hasEventListener(SimpleTableEvent.CELL_UPDATE)) dispatchEvent(new SimpleTableEvent(SimpleTableEvent.CELL_UPDATE));
		}
		
		/**
		 * Position, scale all graphical elements inside this SimpleCell and generate an optional background if required.
		 */
		protected function updateCell():void 
		{
			var value:Number					= 0;
			var object:GraphicComponentObject	= null;
			// assign the width of this SimpleCell
			for each (object in _children) 
			{
				object.graphic.scaleX			= 1;
				if (object.graphic.width > value) 
					value						= object.graphic.width;
			}
			if (value != _childrenWidth) 
				_childrenWidth					= value;
			// assign the height of this SimpleCell
			value								= 0;
			for each (object in _children) 
			{
				object.graphic.scaleY			= 1;
				if (object.graphic.height > value) 
					value						= object.graphic.height;
			}
			if (value != _childrenHeight) 
				_childrenHeight					= value;
			// make sure the SimpleCell has been proportioned to the correct width and height.
			stretchContents();
			alignContents();
			if (_background) generateBackground();
		}
		
		/**
		 * Stretching of all graphical elements with in the SimpleCell will be stretched to the property 'stretch'.
		 */
		protected function stretchContents():void 
		{
			var object:GraphicComponentObject	= null;
			for each (object in _children) 
			{
				switch (_stretch) 
				{
					
					case SimpleCellStretch.BOTH:
						if (_width) object.graphic.width	= _width;
						if (_height) object.graphic.height	= _height;
						break;
						
					case SimpleCellStretch.HEIGHT:
						if (_height) object.graphic.height	= _height;
						break;
						
					case SimpleCellStretch.NONE:
						if (_width) object.graphic.scaleX	= 1;
						if (_height) object.graphic.scaleY	= 1;
						break;
						
					case SimpleCellStretch.WIDTH:
						if (_width) object.graphic.width	= _width;
						break;
						
					case SimpleCellStretch.WIDTH_HEIGHT:
						if (_width) object.graphic.width	= _width;
						if (_height) object.graphic.height	= _height;
						break;
						
				}
			}
		}
		
		/**
		 * Align the graphical elements of this cell to the required position.
		 */
		protected function alignContents():void 
		{
			var object:GraphicComponentObject	= null;
			for each (object in _children) 
			{
				applyGraphicDetails(object);
				switch (_align) 
				{
					
					case SimpleCellAlign.BOTTOM:
						if (_width > object.graphic.width) object.graphic.x		= _width - (object.graphic.width / 2) + ((_relativePosition)? object.graphic.x: 0);
						if (_height > object.graphic.height) object.graphic.y	= _height - object.graphic.height + ((_relativePosition)? object.graphic.y: 0);
						break;
						
					case SimpleCellAlign.BOTTOM_LEFT:
						if (_width > object.graphic.width) object.graphic.x		= (_relativePosition)? object.graphic.x: 0;
						if (_height > object.graphic.height) object.graphic.y	= _height - object.graphic.height + ((_relativePosition)? object.graphic.y: 0);
						break;
						
					case SimpleCellAlign.BOTTOM_RIGHT:
						if (_width > object.graphic.width) object.graphic.x		= _width - object.graphic.width + ((_relativePosition)? object.graphic.x: 0);
						if (_height > object.graphic.height) object.graphic.y	= _height - object.graphic.height + ((_relativePosition)? object.graphic.y: 0);
						break;
						
					case SimpleCellAlign.CENTER:
						if (_width > object.graphic.width) object.graphic.x		= _width - (object.graphic.width / 2) + ((_relativePosition)? object.graphic.x: 0);
						if (_height > object.graphic.height) object.graphic.y	= _height - (object.graphic.height / 2) + ((_relativePosition)? object.graphic.y: 0);
						break;
						
					case SimpleCellAlign.LEFT:
						if (_width > object.graphic.width) object.graphic.x		= (_relativePosition)? object.graphic.x: 0;
						if (_height > object.graphic.height) object.graphic.y	= _height - (object.graphic.height / 2) + ((_relativePosition)? object.graphic.y: 0);
						break;
						
					case SimpleCellAlign.RIGHT:
						if (_width > object.graphic.width) object.graphic.x		= _width - object.graphic.width + ((_relativePosition)? object.graphic.x: 0);
						if (_height > object.graphic.height) object.graphic.y	= _height - (object.graphic.height / 2) + ((_relativePosition)? object.graphic.y: 0);
						break;
						
					case SimpleCellAlign.TOP:
						if (_width > object.graphic.width) object.graphic.x		= _width - (object.graphic.width / 2) + ((_relativePosition)? object.graphic.x: 0);
						if (_height > object.graphic.height) object.graphic.y	= (_relativePosition)? object.graphic.y: 0;
						break;
						
					case SimpleCellAlign.TOP_LEFT:
						if (_width > object.graphic.width) object.graphic.x		= (_relativePosition)? object.graphic.x: 0;
						if (_height > object.graphic.height) object.graphic.y	= (_relativePosition)? object.graphic.y: 0;
						break;
						
					case SimpleCellAlign.TOP_RIGHT:
						if (_width > object.graphic.width) object.graphic.x		= _width - object.graphic.width + ((_relativePosition)? object.graphic.x: 0);
						if (_height > object.graphic.height) object.graphic.y	= (_relativePosition)? object.graphic.y: 0;
						break;
						
					case SimpleCellAlign.NONE:
						break;
						
				}
			}
		}
		
		/**
		 * Generate the optional background and update its properties, width, height, color and rounding of corners.
		 */
		protected function generateBackground():void 
		{
			if (!_backgroundObject) _backgroundObject	= new Sprite();
			var wid:Number	= (_width)? _width: width;
			var hei:Number	= (_height)? _height: height;
			_backgroundObject.graphics.beginFill(_backgroundColor, _backgroundAlpha);
			_backgroundObject.graphics.lineStyle(_borderWidth, _borderColor, _borderAlpha);
			_backgroundObject.graphics.drawRoundRect(0, 0, wid, hei, _rounded);
			if (!getChildIndex(_backgroundObject)) addChildAt(_backgroundObject, 0);
		}
		
	}
	
}