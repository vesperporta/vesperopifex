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
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.vesperopifex.events.EventContext;
	import com.vesperopifex.events.PageEvent;
	import com.vesperopifex.utils.controllers.PageEventControl;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class SWFAddressObject extends Sprite implements IBrowserIntegration 
	{
		public static const DELIMINATOR:String	= "/";
		
		protected var _currentPage:String		= null;
		protected var _requestPage:String		= null;
		
		public function SWFAddressObject() 
		{
			SWFAddress.addEventListener(SWFAddressEvent.INIT, addressInitEventHandler);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, addressEventHandler);
		}
		
		/**
		 * setAddress :: change the address in the browsers address bar.
		 * @param	value	<Array>	an Array object of pages referencing the current page open.
		 */
		public function setAddress(value:Array):void 
		{
			_requestPage	= value.join(DELIMINATOR);
			if (_currentPage == _requestPage) return;
			_currentPage	= _requestPage;
			SWFAddress.setValue(_requestPage);
		}
		
		/**
		 * historyBack :: use the browser integration to go back in the browsers history.
		 */
		public function historyBack():void 
		{
			SWFAddress.back();
		}
		
		/**
		 * historyForward :: use the browser integration to go forward in the browsers history.
		 */
		public function historyForward():void 
		{
			SWFAddress.forward();
		}
		
		/**
		 * addressInitEventHandler :: upon the SWFAddress initiation handle the event.
		 * @param	event	<SWFAddressEvent>
		 */
		protected function addressInitEventHandler(event:SWFAddressEvent):void 
		{
			Settings.TITLE_DEFAULT	= SWFAddress.getTitle();
			var deeplink:String		= event.pathNames.join(DELIMINATOR);
			dispatchPageChange(deeplink);
			
			var title:String	= Settings.TITLE_DEFAULT;
			if (Settings.TITLE_EXTENDED) title	+= Settings.TITLE_EXTENDED;
			SWFAddress.setTitle(title);
		}
		
		/**
		 * addressEventHandler :: when the address is changed through the swfAddress this Event handler gets called.
		 * @param	event	<SWFAddressEvent>
		 */
		protected function addressEventHandler(event:SWFAddressEvent):void 
		{
			Settings.TITLE_EXTENDED	= " :: " + event.path;
			var deeplink:String		= event.pathNames.join(DELIMINATOR);
			dispatchPageChange(deeplink);
			
			SWFAddress.setTitle(event.pathNames.join(DELIMINATOR));
			var title:String	= Settings.TITLE_DEFAULT;
			if (Settings.TITLE_EXTENDED) title	+= Settings.TITLE_EXTENDED;
			SWFAddress.setTitle(title);
		}
		
		/**
		 * dispatchPageChange :: using the page path, dispatch a PageEvent to target the application to that location.
		 * @param	path	<String>	the String value of the pages with '/' deliminiated values.
		 */
		protected function dispatchPageChange(path:String):void 
		{
			var pageEvent:PageEvent = new PageEvent(	PageEvent.EVENT, 
														false, 
														true, 
														new Event("empty", false, true), 
														new EventContext(	PageEvent.EVENT, 
																			PageEventControl.CONTEXT_CHANGE_PAGE, 
																			path, 
																			null, 
																			"nullEvent"));
			dispatchEvent(pageEvent);
		}
		
	}
	
}