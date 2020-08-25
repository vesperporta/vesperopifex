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
package com.vesperopifex.utils.controllers 
{
	import com.vesperopifex.events.DataEvent;
	import com.vesperopifex.events.EventContext;
	import com.vesperopifex.events.PageEvent;
	import com.vesperopifex.events.PageManagerEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	public class PageEventControl extends EventDispatcher 
	{
		public static const XML_DATA_NODE:String					= "eventdata";
		public static const XML_CONTEXT_NODE:String					= "context";
		public static const XML_EVENT_NODE:String					= "event";
		public static const XML_EVENT_ID:String						= "id";
		public static const XML_EVENT_ACTION:String					= "action";
		public static const XML_EVENT_CONTEXT:String				= "context";
		
		public static const CONTEXT_CHANGE_PAGE:String				= "changePage";
		public static const CONTEXT_DELETE_PAGE:String				= "deletePage";
		public static const CONTEXT_NAVIGATE_URL:String				= "navigateToURL";
		public static const CONTEXT_EXTERNAL_INTERFACE:String		= "externalInterface";
		public static const CONTEXT_DRAG_PAGE:String				= "dragPage";
		public static const CONTEXT_DRAG_OBJECT:String				= "dragObject";
		public static const CONTEXT_ANIMATION_OPEN:String			= "animateOpen";
		public static const CONTEXT_ANIMATION_CLOSE:String			= "animateClose";
		public static const CONTEXT_TEXT_EVENT:String				= "textevent";
		public static const CONTEXT_HISTORY_BACK:String				= "historyback";
		public static const CONTEXT_HISTORY_FORWARD:String			= "historyforward";
		public static const CONTEXT_DATA_UPDATE:String				= "dataupdate";
		public static const CONTEXT_FULLSCREEN_TOGGLE:String		= "fullscreenToggle";
		public static const CONTEXT_DISPLAY_FULLSCREEN:String		= "displayFullscreen";
		public static const CONTEXT_DISPLAY_NORMAL:String			= "displayNormal";
		
		protected var _eventObjects:Array							= new Array();
		protected var _componentDispatcher:EventDispatcher			= null;
		
		/**
		 * PageEventControl :: Constructor.
		 */
		public function PageEventControl(dispatcher:EventDispatcher) 
		{
			_componentDispatcher = dispatcher;
		}
		
		/**
		 * checkEventData :: returns an XMLList of the available data for event context(s), this can also be used to validate for any event context(s)
		 * @param	data	<XML>	data pertaining to the object requesting event validation.
		 * @return	<XMLList>	a list of all events data.
		 */
		public static function checkEventData(data:XML):XMLList 
		{
			if (!data) return null;
			var rtn:XML		= <events></events>;
			var item:XML	= null;
			for each (item in data[XML_DATA_NODE][XML_CONTEXT_NODE]) 
				rtn.appendChild(item);
			for each (item in data[XML_EVENT_NODE]) 
				rtn.appendChild(item);
			if (rtn.children().length()) return rtn.children();
			else return null;
		}
		
		/**
		 * checkEvents :: assigns event listeners to particular objects dependent on the data passed to the method.
		 * @param	object	<DisplayObject>	the EventDispatcher to listen to for particular dispatched events.
		 * @param	data	<XML>	data pertaining to the EventDispatcher.
		 */
		public function checkEvents(object:DisplayObject, data:XML):void 
		{
			var item:XML					= null;
			var contexts:Array				= null;
			var contextList:XMLList			= checkEventData(data);
			var eventState:String			= null;
			for each (item in contextList) 
			{
				if (String(item.name()) == XML_EVENT_NODE) 
					for each (eventState in parseContext(item.@[XML_EVENT_CONTEXT])) 
						assignListener(new EventContext(	object.name, 
															String(item.@[XML_EVENT_CONTEXT]), 
															(item.@[XML_EVENT_ID].length())? item.@[XML_EVENT_ID]: item.@[XML_EVENT_ACTION], 
															object, 
															eventState));
				else if (String(item.name()) == XML_CONTEXT_NODE) 
					for each (eventState in parseContext(item)) 
						assignListener(new EventContext(	object.name, 
															item, 
															(item.@[XML_EVENT_ID].length())? item.@[XML_EVENT_ID]: item.@[XML_EVENT_ACTION], 
															object, 
															eventState));
			}
		}
		
		/**
		 * remove the associated listeners for the required display object passed.
		 * @param	object	<DisplayObject>	 the object required to have the event listeners removed from.
		 */
		public function removeEventListeners(object:DisplayObject):void 
		{
			var eventContext:EventContext	= null;
			for (var i:int = 0; i < _eventObjects.length; i++) 
			{
				eventContext				= _eventObjects[i] as EventContext;
				if (eventContext.displayChild == object && parseListener(eventContext).hasEventListener(eventContext.event)) 
				{
					parseListener(eventContext).removeEventListener(eventContext.event, eventHandler);
					_eventObjects.splice(i, 1);
				}
			}
		}
		
		/**
		 * assignListener :: depending on the eventContext passed the assigned event is listened to on the targeted EventDispatcher.
		 * @param	eventContext	<EventContext>	An object containing information regarding the context and action to be taken from a particular Event being dispatched from a registered EventDispatcher.
		 */
		protected function assignListener(eventContext:EventContext):void 
		{
			parseListener(eventContext).addEventListener(eventContext.event, eventHandler);
			_eventObjects.push(eventContext);
		}
		
		/**
		 * eventHandler :: handler for any events dispatched and assigned to look for from particular EventDispatcher(s).
		 * @param	event	<Event>	Any event dispatched from an EventDispatcher registered to listen to.
		 */
		protected function eventHandler(event:Event):void 
		{
			var name:String			= event.target.name;
			var item:EventContext	= null;
			for each (item in _eventObjects) if (item.name == name && item.event == event.type) break;
			_componentDispatcher.dispatchEvent(new PageEvent(PageEvent.EVENT, true, false, event, item));
		}
		
		/**
		 * parseListener :: pass the events context and get the returned EventDispatcher which would be associated to the event being requested.
		 * @param	context	<EventContext>	the events contextual data.
		 * @return	<EventDispatcher>	the dispatcher for the required event.
		 */
		protected function parseListener(context:EventContext):EventDispatcher 
		{
			var rtn:EventDispatcher = null;
			switch (context.context) 
			{
				
				case CONTEXT_ANIMATION_OPEN:
					rtn = _componentDispatcher as EventDispatcher;
					break;
					
				case CONTEXT_ANIMATION_CLOSE:
					rtn = _componentDispatcher as EventDispatcher;
					break;
					
				default:
					rtn = context.displayChild as EventDispatcher;
					break;
					
			}
			return rtn;
		}
		
		/**
		 * parseContext :: using the String value to determin the context of the event to listen for, return the events to add a listener to the EventDispatcher.
		 * @param	value	<String>	the string value to be used as the context of the events.
		 * @return	<Array>	a group of String values denoting what events to listen to.
		 */
		protected function parseContext(value:String):Array 
		{
			var rtn:Array	= null;
			
			switch (value) 
			{
				
				case PageEvent.OPEN_PAGE:
					rtn	= [PageEvent.OPEN_PAGE];
					break;
				
				case CONTEXT_CHANGE_PAGE:
					rtn = [MouseEvent.CLICK];
					break;
					
				case CONTEXT_DELETE_PAGE:
					rtn = [MouseEvent.CLICK];
					break;
					
				case CONTEXT_NAVIGATE_URL:
					rtn = [MouseEvent.CLICK];
					break;
					
				case CONTEXT_EXTERNAL_INTERFACE:
					rtn = [MouseEvent.CLICK];
					break;
					
				case CONTEXT_DRAG_PAGE:
					rtn = [MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_UP];
					break;
					
				case CONTEXT_DRAG_OBJECT:
					rtn = [MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_UP];
					break;
					
				case CONTEXT_ANIMATION_OPEN:
					rtn = [PageManagerEvent.OPEN_ANIMATION];
					break;
					
				case CONTEXT_ANIMATION_CLOSE:
					rtn = [PageManagerEvent.CLOSE_ANIMATION];
					break;
					
				case CONTEXT_TEXT_EVENT:
					rtn = [TextEvent.LINK];
					break;
					
				case CONTEXT_HISTORY_BACK:
					rtn = [MouseEvent.CLICK];
					break;
					
				case CONTEXT_HISTORY_FORWARD:
					rtn = [MouseEvent.CLICK];
					break;
					
				case CONTEXT_DATA_UPDATE:
					rtn = [DataEvent.DATA_UPDATE];
					break;
					
				case CONTEXT_FULLSCREEN_TOGGLE:
					rtn = [MouseEvent.CLICK];
					break;
					
				case CONTEXT_DISPLAY_FULLSCREEN:
					rtn = [MouseEvent.CLICK];
					break;
					
				case CONTEXT_DISPLAY_NORMAL:
					rtn = [MouseEvent.CLICK];
					break;
					
			}
			
			return rtn;
		}
		
	}
	
}