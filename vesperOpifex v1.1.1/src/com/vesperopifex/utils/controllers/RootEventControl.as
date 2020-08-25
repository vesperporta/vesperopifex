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
	import com.vesperopifex.data.IUXTracking;
	import com.vesperopifex.display.book.GraphicPage;
	import com.vesperopifex.display.book.IChapter;
	import com.vesperopifex.display.book.utils.PageManager;
	import com.vesperopifex.display.book.utils.PageHistory;
	import com.vesperopifex.display.IDataObject;
	import com.vesperopifex.display.IXMLDataObject;
	import com.vesperopifex.events.AnimatorEvent;
	import com.vesperopifex.events.EventContext;
	import com.vesperopifex.events.PageEvent;
	import com.vesperopifex.events.PageManagerEvent;
	import com.vesperopifex.external.ExternalAPI;
	import com.vesperopifex.Root;
	import com.vesperopifex.tweens.XMLAnimation;
	import com.vesperopifex.utils.IBrowserIntegration;
	import com.vesperopifex.utils.QueueFIFO;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	public class RootEventControl extends EventDispatcher 
	{
		public static const DELIMINATOR:String					= ",";
		public static const PAGE_DELIMINATOR:String				= "/";
		public static const ID_DELIMINATOR:String				= "::";
		
		protected static const WINDOW_TARGET:String				= null;
		
		protected var _pageManager:PageManager					= null;
		protected var _listener:GraphicPage						= null;
		protected var _trackDispatcher:IUXTracking				= null;
		protected var _addressDispatcher:IBrowserIntegration	= null;
		protected var _pageQueue:QueueFIFO						= new QueueFIFO();
		
		public function get trackDispatcher():IUXTracking { return _trackDispatcher; }
		public function set trackDispatcher(value:IUXTracking):void 
		{
			_trackDispatcher	= value;
		}
		
		public function get addressDispatcher():IBrowserIntegration { return _addressDispatcher; }
		public function set addressDispatcher(value:IBrowserIntegration):void 
		{
			_addressDispatcher	= value;
			_addressDispatcher.addEventListener(PageEvent.EVENT, eventHandler);
		}
		
		public function get listener():GraphicPage { return _listener; }
		public function set listener(value:GraphicPage):void 
		{
			_listener	= value;
			if (value) assignListener(_listener);
		}
		
		public function get pageManager():PageManager { return _pageManager; }
		public function set pageManager(value:PageManager):void 
		{
			_pageManager	= value;
		}
		
		/**
		 * RootEventControl :: Constructor.
		 * @param	listener	<PageManager>
		 */
		public function RootEventControl(manager:PageManager = null) 
		{
			super();
			if (!manager) return;
			_pageManager	= manager;
		}
		
		/**
		 * assignListener :: setup the listener object to have an event listener placed upon it listening to any PageEvents.
		 * @param	listener	<PageManager>
		 */
		protected function assignListener(listener:GraphicPage):void 
		{
			listener.addEventListener(PageEvent.EVENT, eventHandler);
			listener.addEventListener(PageManagerEvent.OPEN, pageOpenHandler);
		}
		
		/**
		 * eventHandler :: used as a listener function.
		 * @param	event	<PageEvent>
		 */
		protected function eventHandler(event:PageEvent):void 
		{
			if (_pageManager.currentPage.length > 1) eventAction(event);
		}
		
		/**
		 * trackEvent :: when an event is trackable call this function with threlevant information for the trackDispatcher to handle.
		 * @param	value	<String>	the action being performed or the value to send to the tracking object.
		 * @param	... arguments	any arguments afterwards will be sent to the tracker though these are delt with on a per object basis.
		 */
		protected function trackEvent(value:String, ... arguments):void 
		{
			if (_trackDispatcher) _trackDispatcher.track(value, arguments);
		}
		
		/**
		 * addressChangeEvent :: call for any events related to change requests in the active page.
		 * @param	value	<Array>	the value of the page location in an Array object.
		 */
		protected function addressChangeEvent(value:Array):void 
		{
			if (_addressDispatcher) _addressDispatcher.setAddress(value);
		}
		
		/**
		 * pageOpenHandler :: handles the pages opening dispatch, where upon the capture of the event a check to see if there are any queued pages to be opened, is so then those pages will be opened.
		 * @param	event	<PageManagerEvent> the event dispatched from any specific page.
		 */
		protected function pageOpenHandler(event:PageManagerEvent):void 
		{
			if (_pageQueue.length > 1) changePageHandler();
		}
		
		/**
		 * changePageHandler :: a handler to add page changes to a queuing system and return the next available, if any.  If no queue object or page location is found then the root or home page will be opened.
		 * @param	array	<Array>	the location of the age in the heirarchical structure of the site.
		 */
		protected function changePageHandler(array:Array = null):void
		{
			if (array) 
			{
				_pageQueue.add(array);
				if (_pageQueue.length == 1) 
					_pageManager.openPage(array);
				else if (_pageQueue.length > 1 && _pageManager.findPage(_pageQueue.current).isOpen) 
					_pageManager.openPage(_pageQueue.next);
			} else 
			{
				if (_pageQueue.length > 0) 
					_pageManager.openPage(_pageQueue.last);
				else _pageManager.openPage([0]);
			}
		}
		
		/**
		 * eventAction :: the actioning portion of the listener, where all the context and actions are placed together to action upon the information supplied by the passed Event.
		 * @param	event	<PageEvent>
		 */
		protected function eventAction(event:PageEvent):void 
		{
			var context:EventContext	= event.context;
			var array:Array				= null;
			var page:GraphicPage		= null;
			var graphic:DisplayObject	= null;
			var object:Object			= null;
			
			switch (context.context) 
			{
				
				case PageEvent.OPEN_PAGE:
					array	= context.action.split(PAGE_DELIMINATOR);
					trackEvent(context.action, PageEvent.OPEN_PAGE);
					addressChangeEvent(array);
					PageHistory.addEntry(array);
					changePageHandler(array);
					break;
				
				case PageEventControl.CONTEXT_CHANGE_PAGE:
					array	= context.action.split(PAGE_DELIMINATOR);
					trackEvent(context.action, PageEventControl.CONTEXT_CHANGE_PAGE);
					addressChangeEvent(array);
					PageHistory.addEntry(array);
					changePageHandler(array);
					break;
					
				case PageEventControl.CONTEXT_DELETE_PAGE:
					trackEvent(context.action, PageEventControl.CONTEXT_DELETE_PAGE);
					array = context.action.split(PAGE_DELIMINATOR);
					page = _pageManager.findPage(array);
					if (page) 
					{
						if (PAGE_DELIMINATOR + array.join(PAGE_DELIMINATOR) == page.path) 
						{
							page = _pageManager.findPage(array.slice(0, array.length - 1));
							page.removePage(_pageManager.findPage(array));
						}
					}
					break;
					
				case PageEventControl.CONTEXT_NAVIGATE_URL:
					array = context.action.split(DELIMINATOR);
					trackEvent(array[0], PageEventControl.CONTEXT_NAVIGATE_URL);
					navigateToURL(new URLRequest(array[0]), (Boolean(array[1]))? array[1]: WINDOW_TARGET);
					break;
					
				case PageEventControl.CONTEXT_EXTERNAL_INTERFACE:
					array = context.action.split(DELIMINATOR);
					trackEvent(array[0], PageEventControl.CONTEXT_EXTERNAL_INTERFACE, (array.length > 1)? array.slice(1): null);
					if (ExternalAPI.available) ExternalAPI.call(array[0], (array.length > 1)? array.slice(1): null);
					break;
					
				case PageEventControl.CONTEXT_DRAG_PAGE:
					trackEvent(context.action, PageEventControl.CONTEXT_DRAG_PAGE);
					array = context.action.split(PAGE_DELIMINATOR);
					if (event.event.type == MouseEvent.MOUSE_UP) 
					{
						page = _pageManager.findPage(array);
						if (page) page.stopDrag();
					} else if (event.event.type == MouseEvent.MOUSE_DOWN) 
					{
						page = _pageManager.findPage(array);
						if (page) page.startDrag();
					}
					break;
					
				case PageEventControl.CONTEXT_DRAG_OBJECT:
					if (event.target is Sprite) 
					{
						if (event.event.type == MouseEvent.MOUSE_UP) (event.event.currentTarget as Sprite).stopDrag();
						else if (event.event.type == MouseEvent.MOUSE_DOWN) (event.event.currentTarget as Sprite).startDrag();
					}
					break;
					
				case PageEventControl.CONTEXT_HISTORY_BACK:
					array				= PageHistory.back();
					if (array) 
					{
						trackEvent(array.join(PAGE_DELIMINATOR), PageEventControl.CONTEXT_HISTORY_BACK);
						addressChangeEvent(array);
						changePageHandler(array);
					}
					break;
					
				case PageEventControl.CONTEXT_HISTORY_FORWARD:
					array				= PageHistory.forward();
					if (array) 
					{
						trackEvent(array.join(PAGE_DELIMINATOR), PageEventControl.CONTEXT_HISTORY_BACK);
						addressChangeEvent(array);
						changePageHandler(array);
					}
					break;
					
				case PageEventControl.CONTEXT_TEXT_EVENT:
					if (event.event is TextEvent) textEventAction(event.event as TextEvent);
					break;
					
				case PageEventControl.CONTEXT_DATA_UPDATE:
					array	= context.action.split(DELIMINATOR);
					page	= _pageManager.findPage(array[0].split(ID_DELIMINATOR)[0].split(PAGE_DELIMINATOR));
					if (page is GraphicPage) graphic = (page as GraphicPage).findGraphic(array[0].split(ID_DELIMINATOR)[1]);
					if (graphic is IDataObject) object = (graphic as IDataObject).dataUpdate;
					if (object) 
					{
						if (Boolean(array[1])) 
						{
							if (String(array[1]).indexOf(ID_DELIMINATOR) != -1 &&
								String(array[1]).indexOf(ID_DELIMINATOR) < String(array[1]).length - ID_DELIMINATOR.length) 
							{
								array = array[1].split(ID_DELIMINATOR);
								page = _pageManager.findPage(array[0].split(PAGE_DELIMINATOR));
								if (page is GraphicPage) graphic = (page as GraphicPage).findGraphic(array[1]);
								if (graphic is IDataObject) (graphic as IDataObject).dataUpdate = object;
							} else 
							{
								if (String(array[1]).indexOf(ID_DELIMINATOR) > -1) 
									array[1] = String(array[1]).slice(0, String(array[1]).indexOf(ID_DELIMINATOR));
								page = _pageManager.findPage(array[1]);
								array = (page is IChapter)? _pageManager.createStructure(page as IChapter): [page];
								propegateData(array, object);
							}
						} else 
						{
							array = _pageManager.createStructure();
							propegateData(array, object);
						}
					}
					break;
					
				case PageEventControl.CONTEXT_FULLSCREEN_TOGGLE:
					if (_pageManager.stage.displayState == StageDisplayState.FULL_SCREEN) 
						_pageManager.stage.displayState	= StageDisplayState.NORMAL;
					else 
						_pageManager.stage.displayState	= StageDisplayState.FULL_SCREEN;
					break;
					
				case PageEventControl.CONTEXT_DISPLAY_FULLSCREEN:
					_pageManager.stage.displayState	= StageDisplayState.FULL_SCREEN;
					break;
					
				case PageEventControl.CONTEXT_DISPLAY_NORMAL:
					_pageManager.stage.displayState	= StageDisplayState.NORMAL;
					break;
					
			}
		}
		
		/**
		 * propegateData :: recurse through the portion of hierarchy passed to the method and if the graphic object on those pages are IDataObjects then update the data on that IDataObject.
		 * @param	hierarchy	<Array>	a structure of pages layed out in a multi layered Array object.
		 * @param	data	<Object>	this can be construde of any data type which is acceptable by targeted graphic object(s).
		 */
		protected function propegateData(hierarchy:Array, data:Object):void 
		{
			var array:Array	= null;
			var i:uint		= 0;
			var j:uint		= 0;
			
			for (i; i < hierarchy.length; i++) 
			{
				if (hierarchy[i] is GraphicPage) array = (hierarchy[i] as GraphicPage).graphicChildren;
				else if (hierarchy[i] is Array) propegateData(hierarchy[i], data);
				if (array.length) 
				{
					for (j; j < array.length; j++) 
						if (array[j] is IDataObject) 
							(array[j] as IDataObject).dataUpdate = data;
				}
			}
		}
		
		/**
		 * textEventAction :: For dispatched TextEvent(s), this will deal with almost all of the available functionality above though is limited to the resources of a single line of text.  If further action is required then a PageEvent is manufactured and passed back to the 'eventAction' method.
		 * @param	event	<TextEvent>
		 */
		protected function textEventAction(event:TextEvent):void 
		{
			var array:Array					= event.text.split(DELIMINATOR);
			var eventContext:EventContext	= null;
			var eventDispatched:Event		= new Event("empty", false, true);
			var pageEvent:PageEvent			= null;
			var objName:String				= "TextField";
			
			switch (array[0]) 
			{
				
				case PageEventControl.CONTEXT_CHANGE_PAGE:
					eventContext = new EventContext(objName, 
													PageEventControl.CONTEXT_CHANGE_PAGE, 
													array[1], 
													null, 
													"nullEvent");
					break;
					
				case PageEventControl.CONTEXT_DELETE_PAGE:
					eventContext = new EventContext(objName, 
													PageEventControl.CONTEXT_DELETE_PAGE, 
													array[1], 
													null, 
													"nullEvent");
					break;
					
				case PageEventControl.CONTEXT_NAVIGATE_URL:
					eventContext = new EventContext(objName, 
													PageEventControl.CONTEXT_NAVIGATE_URL, 
													array.slice(1).join(DELIMINATOR), 
													null, 
													"nullEvent");
					break;
					
				case PageEventControl.CONTEXT_EXTERNAL_INTERFACE:
					eventContext = new EventContext(objName, 
													PageEventControl.CONTEXT_EXTERNAL_INTERFACE, 
													array.slice(1).join(DELIMINATOR), 
													null, 
													"nullEvent");
					break;
					
				case PageEventControl.CONTEXT_HISTORY_BACK:
					eventContext = new EventContext(objName, 
													PageEventControl.CONTEXT_HISTORY_BACK, 
													null, 
													null, 
													"nullEvent");
					break;
					
				case PageEventControl.CONTEXT_HISTORY_FORWARD:
					eventContext = new EventContext(objName, 
													PageEventControl.CONTEXT_HISTORY_FORWARD, 
													null, 
													null, 
													"nullEvent");
					break;
					
				default:
					eventContext = new EventContext(objName, 
													PageEventControl.CONTEXT_NAVIGATE_URL, 
													array[0], 
													null, 
													"nullEvent");
					break;
					
			}
			
			pageEvent = new PageEvent(	objName, 
										false, 
										true, 
										eventDispatched, 
										eventContext);
			if (_pageManager.currentPage.length > 1) eventAction(pageEvent);
		}
		
	}
	
}