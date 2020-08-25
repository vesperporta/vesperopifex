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
	import com.vesperopifex.display.SimpleInformationPanel;
	import com.vesperopifex.display.ui.state.IStateDisplayObject;
	import com.vesperopifex.display.ui.state.SimpleStateDisplayObject;
	import com.vesperopifex.events.ScrollerDisplayObjectEvent;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class SimpleScrollBar extends SimpleInformationPanel implements IScrollerDisplayObject 
	{
		public static const POSITION_HORIZONTAL:String						= "scroll-position-horizontal";
		public static const POSITION_VERTICAL:String						= "scroll-position-vertical";
		public static const XML_BACKGROUND_ACTIVE:String					= "background-active";
		public static const XML_BACKGROUND_INACTIVE:String					= "background-inactive";
		public static const XML_SCRUB_ACTIVE:String							= "scrub-active";
		public static const XML_SCRUB_INACTIVE:String						= "scrub-inactive";
		public static const XML_SCROLL_UP_ACTIVE:String						= "scroll-up-active";
		public static const XML_SCROLL_UP_INACTIVE:String					= "scroll-up-inactive";
		public static const XML_SCROLL_DOWN_ACTIVE:String					= "scroll-down-active";
		public static const XML_SCROLL_DOWN_INACTIVE:String					= "scroll-down-inactive";
		public static const XML_SCROLL_UP_JUMP_ACTIVE:String				= "scroll-up-end-active";
		public static const XML_SCROLL_UP_JUMP_INACTIVE:String				= "scroll-up-end-inactive";
		public static const XML_SCROLL_DOWN_JUMP_ACTIVE:String				= "scroll-down-end-active";
		public static const XML_SCROLL_DOWN_JUMP_INACTIVE:String			= "scroll-down-end-inactive";
		
		protected var _backgroundStateObject:SimpleStateDisplayObject		= null;
		protected var _scrubStateObject:SimpleStateDisplayObject			= null;
		protected var _scrollUpStateObject:SimpleStateDisplayObject			= null;
		protected var _scrollDownStateObject:SimpleStateDisplayObject		= null;
		protected var _scrollUpJumpStateObject:SimpleStateDisplayObject		= null;
		protected var _scrollDownJumpStateObject:SimpleStateDisplayObject	= null;
		protected var _width:Number											= 0;
		protected var _height:Number										= 0;
		protected var _position:String										= POSITION_VERTICAL;
		protected var _maxScroll:int										= 0;
		protected var _scroll:int											= 0;
		protected var _scrubMinX:Number										= 0;
		protected var _scrubMaxX:Number										= 0;
		protected var _scrubMinY:Number										= 0;
		protected var _scrubMaxY:Number										= 0;
		protected var _scrollSpeed:int										= 1;
		
		/**
		 * public property height : Number
		 * Indicates the height of the display object, in pixels. The height is calculated based on the bounds of the content of the background display object.
		 */
		public override function set height(value:Number):void 
		{
			_height	= value;
			if (_backgroundStateObject) 
			{
				var state:DisplayObject	= null;
				state	= _backgroundStateObject.getState(SimpleStateDisplayObject.ACTIVE);
				if (state) state.height	= value;
				state	= _backgroundStateObject.getState(SimpleStateDisplayObject.INACTIVE);
				if (state) state.height	= value;
			}
		}
		
		/**
		 * public property width : Number
		 * Indicates the width of the display object, in pixels. The width is calculated based on the bounds of the content of the background display object.
		 */
		public override function set width(value:Number):void 
		{
			_width	= value;
			if (_backgroundStateObject) 
			{
				var state:DisplayObject	= null;
				state	= _backgroundStateObject.getState(SimpleStateDisplayObject.ACTIVE);
				if (state) state.width	= value;
				state	= _backgroundStateObject.getState(SimpleStateDisplayObject.INACTIVE);
				if (state) state.width	= value;
			}
		}
		
		public function get position():String { return _position; }
		public function set position(value:String):void 
		{
			if (_position != value && value == POSITION_HORIZONTAL || value == POSITION_VERTICAL) 
				_position	= value;
		}
		
		public function get maxScroll():int { return _maxScroll; }
		public function set maxScroll(value:int):void 
		{
			_maxScroll	= value;
			active		= true;
		}
		
		public function get scroll():int { return _scroll; }
		public function set scroll(value:int):void 
		{
			if (_scroll != value) 
			{
				_scroll = value;
				calculateScrub();
			}
			
		}
		
		public function get scrollSpeed():int { return _scrollSpeed; }
		public function set scrollSpeed(value:int):void 
		{
			_scrollSpeed = value;
		}
		
		/**
		 * SimpleScrollBar :: Constructor.
		 */
		public function SimpleScrollBar() 
		{
			mouseEnabled	= true;
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelEventHandler);
		}
		
		/**
		 * assignChildActivity :: find all children which implement IXMLDataObject class and assign the current availability of the panel to the children.
		 */
		protected override function assignChildActivity():void
		{
			switch (_active) 
			{
				
				case true:
					if (_backgroundStateObject)		_backgroundStateObject.state		= SimpleStateDisplayObject.ACTIVE;
					if (_scrubStateObject)			_scrubStateObject.state				= SimpleStateDisplayObject.ACTIVE;
					if (_scrollUpStateObject)		_scrollUpStateObject.state			= SimpleStateDisplayObject.ACTIVE;
					if (_scrollDownStateObject)		_scrollDownStateObject.state		= SimpleStateDisplayObject.ACTIVE;
					if (_scrollUpJumpStateObject)	_scrollUpJumpStateObject.state		= SimpleStateDisplayObject.ACTIVE;
					if (_scrollDownJumpStateObject)	_scrollDownJumpStateObject.state	= SimpleStateDisplayObject.ACTIVE;
					break;
					
				case false:
					if (_backgroundStateObject)		_backgroundStateObject.state		= SimpleStateDisplayObject.INACTIVE;
					if (_scrubStateObject)			_scrubStateObject.state				= SimpleStateDisplayObject.INACTIVE;
					if (_scrollUpStateObject)		_scrollUpStateObject.state			= SimpleStateDisplayObject.INACTIVE;
					if (_scrollDownStateObject)		_scrollDownStateObject.state		= SimpleStateDisplayObject.INACTIVE;
					if (_scrollUpJumpStateObject)	_scrollUpJumpStateObject.state		= SimpleStateDisplayObject.INACTIVE;
					if (_scrollDownJumpStateObject)	_scrollDownJumpStateObject.state	= SimpleStateDisplayObject.INACTIVE;
					break;
					
			}
		}
		
		/**
		 * generateGraphics :: create the graphics for this object.
		 */
		protected override function generateGraphics():void
		{
			super.generateGraphics();
		}
		
		/**
		 * addGraphicChildren :: add the generated graphics and add them to the stage according the their appearance in the XML.
		 */
		protected override function addGraphicChildren(object:GraphicComponentObject = null):void 
		{
			if (object) 
			{
				addDisplayObject(object);
				return;
			}
			for each (object in _children) addDisplayObject(object);
			if (_maxScroll == 0) active	= false;
		}
		
		/**
		 * addDisplayObject :: add a set of Data and DisplayObject to the scroll bar in order to assertain the location required for the DisplayObject and the functionality.
		 * @param	value	<GraphicComponentObject>	Object class containing the data for the object and the DisplayObject for addition.
		 * @return	<DisplayObject>	the object added to the display stack for rendering, if it is not added then null is returned.
		 */
		public function addDisplayObject(value:GraphicComponentObject):DisplayObject 
		{
			return	findDisplayObjectAvailability(value.graphic, String(value.data.@id));
		}
		
		/**
		 * mouseWheelEventHandler :: listener for the MouseEvent.MOUSE_WHEEL Event dispatched and stop the propegation of this Event, in turn dispatch a ScrollerDisplayObjectEvent with the current scroll value.
		 * @param	event	<MouseEvent>	the dispatched Event from the DisplayObject onwhich the mouse_wheel was done.
		 */
		protected function mouseWheelEventHandler(event:MouseEvent):void 
		{
			event.stopImmediatePropagation();
			dispatchEvent(new ScrollerDisplayObjectEvent(ScrollerDisplayObjectEvent.SCROLL, true, true, _scroll));
		}
		
		/**
		 * calculateScroll :: take the position of the scrub DisplayObject and calculate the position of the scroll vvalue in relation to the maxScroll assigned and dispatch a ScrollerDisplayObjectEvent with that relevant scroll value.
		 */
		protected function calculateScroll():void 
		{
			var scrubPosition:Number	= NaN;
			var scrubDistance:Number	= NaN;
			switch (_position) 
			{
				
				case POSITION_HORIZONTAL:
					scrubPosition	= _scrubStateObject.x - _scrubMinX;
					scrubDistance	= _scrubMaxX;
					break;
					
				case POSITION_VERTICAL:
					scrubPosition	= _scrubStateObject.y - _scrubMinY;
					scrubDistance	= _scrubMaxY;
					break;
				
			}
			_scroll	= int(Math.round(scrubPosition / scrubDistance * _maxScroll));
			dispatchEvent(new ScrollerDisplayObjectEvent(ScrollerDisplayObjectEvent.SCROLL, true, true, _scroll));
		}
		
		/**
		 * calculateScrub :: taking the current scroll value and finding the relevant position for the scrub DisplayObject to be positioned.
		 */
		protected function calculateScrub():void 
		{
			var scrubPosition:Number	= NaN;
			switch (_position) 
			{
				
				case POSITION_HORIZONTAL:
					_scrubStateObject.x	= ((scroll / maxScroll) * _scrubMaxX) + _scrubMinX;
					break;
					
				case POSITION_VERTICAL:
					_scrubStateObject.y	= ((scroll / maxScroll) * _scrubMaxY) + _scrubMinY;
					break;
				
			}
		}
		
		/**
		 * calculateMouseScrub :: taking the position passed and using it to update the scroll value of the scrub DisplayObject.
		 * @param	mousePosition	<Number>	the position on which to calculate the position of the scroll.
		 */
		protected function calculateMouseScrub(mousePosition:Number):void 
		{
			var scrubPosition:Number	= mousePosition;
			var scrubDistance:Number	= NaN;
			switch (_position) 
			{
				
				case POSITION_HORIZONTAL:
					scrubDistance	= _scrubMaxX;
					break;
					
				case POSITION_VERTICAL:
					scrubDistance	= _scrubMaxY;
					break;
				
			}
			scroll	= int(Math.round((scrubPosition / scrubDistance) * _maxScroll));
		}
		
		/**
		 * findDisplayObjectAvailability :: assertain if the DisplayObject is required and add it to the specific SimpleStateDisplayObject in order for functionality to take place.
		 * @param	child	<DisplayObject>	the visual child to add to the SimpleStateDisplayObject.
		 * @param	id		<String>	the identifier with which to determin the purpose of the DisplayObject.
		 * @return	<DisplayObject>	the object added to the SimpleStateDisplayObject.
		 */
		protected function findDisplayObjectAvailability(child:DisplayObject, id:String):DisplayObject 
		{
			var rtn:DisplayObject	= null;
			switch (id) 
			{
				
				case XML_BACKGROUND_ACTIVE:
					if (!_backgroundStateObject) initBackgroundStateObject();
					rtn	= _backgroundStateObject.addState(child, SimpleStateDisplayObject.ACTIVE);
					break;
					
				case XML_BACKGROUND_INACTIVE:
					if (!_backgroundStateObject) initBackgroundStateObject();
					rtn	= _backgroundStateObject.addState(child, SimpleStateDisplayObject.INACTIVE);
					break;
					
				case XML_SCRUB_ACTIVE:
					if (!_scrubStateObject) initScrubStateObject();
					_scrubMinX			= Number(child[SimpleDragButton.DRAG_X]);
					_scrubMinY			= Number(child[SimpleDragButton.DRAG_Y]);
					_scrubMaxX			= Number(child[SimpleDragButton.DRAG_WIDTH]);
					_scrubMaxY			= Number(child[SimpleDragButton.DRAG_HEIGHT]);
					_scrubStateObject.x	= _scrubMinX;
					_scrubStateObject.y	= _scrubMinY;
					rtn	= _scrubStateObject.addState(child, SimpleStateDisplayObject.ACTIVE);
					break;
					
				case XML_SCRUB_INACTIVE:
					if (!_scrubStateObject) initScrubStateObject();
					rtn	= _scrubStateObject.addState(child, SimpleStateDisplayObject.INACTIVE);
					break;
					
				case XML_SCROLL_UP_ACTIVE:
					if (!_scrollUpStateObject) initScrollUpStateObject();
					rtn	= _scrollUpStateObject.addState(child, SimpleStateDisplayObject.ACTIVE);
					break;
					
				case XML_SCROLL_UP_INACTIVE:
					if (!_scrollUpStateObject) initScrollUpStateObject();
					rtn	= _scrollUpStateObject.addState(child, SimpleStateDisplayObject.INACTIVE);
					break;
					
				case XML_SCROLL_DOWN_ACTIVE:
					if (!_scrollDownStateObject) initScrollDownStateObject();
					rtn	= _scrollDownStateObject.addState(child, SimpleStateDisplayObject.ACTIVE);
					break;
					
				case XML_SCROLL_DOWN_INACTIVE:
					if (!_scrollDownStateObject) initScrollDownStateObject();
					rtn	= _scrollDownStateObject.addState(child, SimpleStateDisplayObject.INACTIVE);
					break;
					
				case XML_SCROLL_UP_JUMP_ACTIVE:
					if (!_scrollUpJumpStateObject) initScrollUpJumpStateObject();
					rtn	= _scrollUpJumpStateObject.addState(child, SimpleStateDisplayObject.ACTIVE);
					break;
					
				case XML_SCROLL_UP_JUMP_INACTIVE:
					if (!_scrollUpJumpStateObject) initScrollUpJumpStateObject();
					rtn	= _scrollUpJumpStateObject.addState(child, SimpleStateDisplayObject.INACTIVE);
					break;
					
				case XML_SCROLL_DOWN_JUMP_ACTIVE:
					if (!_scrollDownJumpStateObject) initScrollDownJumpStateObject();
					rtn	= _scrollDownJumpStateObject.addState(child, SimpleStateDisplayObject.ACTIVE);
					break;
					
				case XML_SCROLL_DOWN_JUMP_INACTIVE:
					if (!_scrollDownJumpStateObject) initScrollDownJumpStateObject();
					rtn	= _scrollDownJumpStateObject.addState(child, SimpleStateDisplayObject.INACTIVE);
					break;
					
			}
			return rtn;
		}
		
		/**
		 * initScrollDownJumpStateObject :: create a SimpleStateDisplayObject object and assign the relevant listeners to the object.
		 */
		protected function initScrubStateObject():void
		{
			_scrubStateObject					= new SimpleStateDisplayObject();
			addChild(_scrubStateObject);
			_scrubStateObject.addEventListener(MouseEvent.MOUSE_DOWN, scrubMouseDownHandler);
			_scrubStateObject.addEventListener(MouseEvent.MOUSE_UP, scrubMouseUpHandler);
		}
		
		/**
		 * scrubMouseUpHandler :: listener for the mouse_up Event dispatched from the DisplayObject and dragging is stopped of the relevate DisplayObject.
		 * @param	event	<MouseEvent>	the Event dispatched from the DisplayObject when the mouse is released up.
		 */
		protected function scrubMouseUpHandler(event:MouseEvent):void 
		{
			if (_active) 
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrubMouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, scrubMouseUpHandler);
				_scrubStateObject.stopDrag();
			}
		}
		
		/**
		 * scrubMouseDownHandler :: listener for the mouse_down Event dispatched from the DisplayObject and dragging of the DisplayObject initiates updating the scroll value.
		 * @param	event	<MouseEvent>	the Event dispatched from the DisplayObject when the mouse is pressed down.
		 */
		protected function scrubMouseDownHandler(event:MouseEvent):void 
		{
			if (_active) 
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, scrubMouseMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, scrubMouseUpHandler);
				_scrubStateObject.startDrag(true, new Rectangle(_scrubMinX, _scrubMinY, _scrubMaxX, _scrubMaxY));
				calculateScroll();
			}
		}
		
		/**
		 * scrubMouseMoveHandler :: the position of the sruc DisplayObject is located and a new scroll value is calculated.
		 * @param	event	<MouseEvent>	the Event dispatched from the DisplayObject when the mouse is moved.
		 */
		protected function scrubMouseMoveHandler(event:MouseEvent):void 
		{
			if (_active) calculateScroll();
		}
		
		/**
		 * initScrollDownJumpStateObject :: create a SimpleStateDisplayObject object and assign the relevant listeners to the object.
		 */
		protected function initBackgroundStateObject():void
		{
			_backgroundStateObject			= new SimpleStateDisplayObject();
			addChildAt(_backgroundStateObject, 0);
			_backgroundStateObject.addEventListener(MouseEvent.MOUSE_DOWN, backgroundMouseDownHandler);
		}
		
		/**
		 * backgroundMouseDownHandler :: when the background DisplayObject dispatches a mouse_down Event the position of the scrub DisplayObject is calculated according to the position of the mouseX and mouseY depending on the positioning of the scroll bar, horizontal or vertical, and then normal scrubbing get initiated.
		 * @param	event	<MouseEvent>	the Event dispatched from the DisplayObject.
		 */
		protected function backgroundMouseDownHandler(event:MouseEvent):void 
		{
			if (_active) 
			{
				var mousePosition:Number	= NaN;
				switch (_position) 
				{
					
					case POSITION_HORIZONTAL:
						mousePosition	= event.localX;
						break;
						
					case POSITION_VERTICAL:
						mousePosition	= event.localY;
						break;
					
				}
				calculateMouseScrub(mousePosition);
				scrubMouseDownHandler(event);
				calculateScroll();
			}
		}
		
		/**
		 * initScrollUpStateObject :: create a SimpleStateDisplayObject object and assign the relevant listeners to the object.
		 */
		protected function initScrollUpStateObject():void
		{
			_scrollUpStateObject		= new SimpleStateDisplayObject();
			addChild(_scrollUpStateObject);
			_scrollUpStateObject.addEventListener(MouseEvent.MOUSE_DOWN, scrollUpMouseDownHandler);
			_scrollUpStateObject.addEventListener(MouseEvent.MOUSE_UP, scrollUpMouseUpHandler);
		}
		
		/**
		 * scrollUpMouseUpHandler :: when the scrollUp DisplayObject dispatches a mouse_up Event the enter_frame listener is removed from the object.
		 * @param	event	<MouseEvent>	the Event dispatched from the DisplayObject.
		 */
		protected function scrollUpMouseUpHandler(event:MouseEvent):void 
		{
			if (_active) 
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, scrollUpMouseUpHandler);
				_scrollUpStateObject.removeEventListener(Event.ENTER_FRAME, scrollUpEnterFrameHandler);
			}
		}
		
		/**
		 * scrollUpMouseDownHandler :: when the scrollUp DisplayObject dispatches a mouse_down Event the object is listened to for enter_frame.
		 * @param	event	<MouseEvent>	the Event dispatched from the DisplayObject.
		 */
		protected function scrollUpMouseDownHandler(event:MouseEvent):void 
		{
			if (_active) 
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, scrollUpMouseUpHandler);
				_scrollUpStateObject.addEventListener(Event.ENTER_FRAME, scrollUpEnterFrameHandler);
			}
		}
		
		/**
		 * scrollUpEnterFrameHandler :: on each dispatch of an enter_frame Event the scroll is amended with the scroll speed towards the minimum scroll available 0.
		 * @param	event	<Event>	the Event dispatched from the DisplayObject.
		 */
		protected function scrollUpEnterFrameHandler(event:Event):void 
		{
			if (_active) 
			{
				if (scroll >= scrollSpeed) scroll -= scrollSpeed;
				else scroll	= 0;
				calculateScroll();
			}
		}
		
		/**
		 * initScrollDownStateObject :: create a SimpleStateDisplayObject object and assign the relevant listeners to the object.
		 */
		protected function initScrollDownStateObject():void
		{
			_scrollDownStateObject		= new SimpleStateDisplayObject();
			addChild(_scrollDownStateObject);
			_scrollDownStateObject.addEventListener(MouseEvent.MOUSE_DOWN, scrollDownMouseDownHandler);
			_scrollDownStateObject.addEventListener(MouseEvent.MOUSE_UP, scrollDownMouseUpHandler);
		}
		
		/**
		 * scrollDownMouseUpHandler :: when the scrollDown DisplayObject dispatches a mouse_up Event the enter_frame listener is removed from the object.
		 * @param	event	<MouseEvent>	the Event dispatched from the DisplayObject.
		 */
		protected function scrollDownMouseUpHandler(event:MouseEvent):void 
		{
			if (_active) 
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, scrollDownMouseUpHandler);
				_scrollDownStateObject.removeEventListener(Event.ENTER_FRAME, scrollDownEnterFrameHandler);
			}
		}
		
		/**
		 * scrollDownMouseDownHandler :: when the scrollDown DisplayObject dispatches a mouse_down Event the object is listened to for enter_frame.
		 * @param	event	<MouseEvent>	the Event dispatched from the DisplayObject.
		 */
		protected function scrollDownMouseDownHandler(event:MouseEvent):void 
		{
			if (_active) 
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, scrollDownMouseUpHandler);
				_scrollDownStateObject.addEventListener(Event.ENTER_FRAME, scrollDownEnterFrameHandler);
			}
		}
		
		/**
		 * scrollDownEnterFrameHandler :: on each dispatch of an enter_frame Event the scroll is amended with the scroll speed towards the maximum scroll available.
		 * @param	event	<Event>	the Event dispatched from the DisplayObject.
		 */
		protected function scrollDownEnterFrameHandler(event:Event):void 
		{
			if (_active) 
			{
				if (scroll <= maxScroll - scrollSpeed) scroll += scrollSpeed;
				else scroll	= maxScroll;
				calculateScroll();
			}
		}
		
		/**
		 * initScrollUpJumpStateObject :: create a SimpleStateDisplayObject object and assign the relevant listeners to the object.
		 */
		protected function initScrollUpJumpStateObject():void
		{
			_scrollUpJumpStateObject	= new SimpleStateDisplayObject();
			addChild(_scrollUpJumpStateObject);
			_scrollUpJumpStateObject.addEventListener(MouseEvent.CLICK, scrollUpJumpClickHandler);
		}
		
		/**
		 * scrollUpJumpClickHandler :: when the scrollUpJump button dispatches a click Event scroll is set to the minimum 0.
		 * @param	event	<MouseEvent>	the Event dispatched from the DisplayObject.
		 */
		protected function scrollUpJumpClickHandler(event:MouseEvent):void 
		{
			if (_active) 
			{
				scroll	= 0;
				calculateScroll();
			}
		}
		
		/**
		 * initScrollDownJumpStateObject :: create a SimpleStateDisplayObject object and assign the relevant listeners to the object.
		 */
		protected function initScrollDownJumpStateObject():void
		{
			_scrollDownJumpStateObject	= new SimpleStateDisplayObject();
			addChild(_scrollDownJumpStateObject);
			_scrollDownJumpStateObject.addEventListener(MouseEvent.CLICK, scrollDownJumpClickHandler);
		}
		
		/**
		 * scrollDownJumpClickHandler :: when the scrollDownJump button dispatches a click Event scroll is set to the maximum.
		 * @param	event	<MouseEvent>	the Event dispatched from the DisplayObject.
		 */
		protected function scrollDownJumpClickHandler(event:MouseEvent):void 
		{
			if (_active) 
			{
				scroll	= maxScroll;
				calculateScroll();
			}
		}
		
	}
	
}