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
package com.vesperopifex.display 
{
	import com.vesperopifex.display.ui.IScrollerDisplayObject;
	import com.vesperopifex.display.ui.SimpleScrollBar;
	import com.vesperopifex.events.GraphicEvent;
	import com.vesperopifex.events.LoadFactoryEvent;
	import com.vesperopifex.events.ScrollerDisplayObjectEvent;
	import com.vesperopifex.events.StyleSheetFactoryEvent;
	import com.vesperopifex.utils.AbstractLoader;
	import com.vesperopifex.utils.CacheLoadFactory;
	import com.vesperopifex.xml.RSS2Object;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	// mxmlc com\vesperopifex\display\RSSDisplayObject.as -output RSSDisplayObject.swf -sp . -use-network=false
	
	public class RSSDisplayObject extends SimpleInformationPanel 
	{
		public static const XML_FEED:String							= "feed";
		public static const XML_HTML_TEMPLATE:String				= "htmlbody";
		public static const XML_HTML_TEXTFIELD:String				= "html-textfield";
		public static const XML_SCROLL_TEXTFIELD:String				= "scroll-textfield";
		public static const XML_SCROLL_TEXTFIELD_VERTICAL:String	= "scroll-textfield-vertical";
		public static const XML_SCROLL_TEXTFIELD_HORIZONTAL:String	= "scroll-textfield-horizontal";
		
		protected var _textfield:TextField							= null;
		protected var _verticalScroller:IScrollerDisplayObject		= null;
		protected var _horizontalScroller:IScrollerDisplayObject	= null;
		protected var _LOAD_FACTORY:CacheLoadFactory				= new CacheLoadFactory();
		protected var _feed:String									= null;
		protected var _htmlTemplate:XML								= null;
		protected var _rssObject:RSS2Object							= new RSS2Object();
		
		public function get feed():String { return _feed; }
		public function set feed(value:String):void 
		{
			_feed = value;
			displayFeed(value);
		}
		
		/**
		 * RSSDisplayObject :: Constructor.
		 */
		public function RSSDisplayObject() 
		{
			super();
			_LOAD_FACTORY.addEventListener(LoadFactoryEvent.COMPLETE, feedLoadCompleteHandler);
			addEventListener(GraphicEvent.COMPLETE_NEW, newGraphicHandler);
		}
		
		/**
		 * feedLoadCompleteHandler :: handler to deal with the loading of a new RSS feed.
		 * @param	event	<LoadFactoryEvent> the event dispatched from the loader factory.
		 */
		protected function feedLoadCompleteHandler(event:LoadFactoryEvent):void 
		{
			if (event.url == _feed) 
			{
				styleSheetCompleteHandler(new StyleSheetFactoryEvent(StyleSheetFactoryEvent.COMPLETE));
				displayFeed(_feed);
			}
		}
		
		/**
		 * passXMLData :: pass the data already obtained in _data and do any actions required.
		 */
		protected override function passXMLData():void
		{
			var item:XML				= null;
			var enforceType:String		= null;
			if (_data[GraphicFactory.XML_ENFORCED].length()) 
				enforceType				= String(_data[GraphicFactory.XML_ENFORCED]);
			if (_data.@[GraphicFactory.XML_ENFORCED].length()) 
				enforceType				= String(_data.@[GraphicFactory.XML_ENFORCED]);
			var loader:AbstractLoader	= null;
			if (_data[XML_FEED].length()) 
			{
				for each (item in _data[XML_FEED]) 
				{
					loader				= _LOAD_FACTORY.load(String(item), null, enforceType);
					if (!_feed) _feed	= String(item);
					if (loader.loadCompleted && _feed) displayFeed(_feed, enforceType);
				}
			} else if (_data.@[XML_FEED].length()) 
			{
				loader					= _LOAD_FACTORY.load(String(_data.@[XML_FEED]), null, enforceType);
				if (!_feed) _feed		= String(_data.@[XML_FEED]);
				if (loader.loadCompleted && _feed) displayFeed(_feed, enforceType);
			}
			if (_data[XML_HTML_TEMPLATE].length()) 
				for each (item in _data[XML_HTML_TEMPLATE]) 
					_htmlTemplate		= item;
		}
		
		/**
		 * displayFeed :: according to the URL the feed related to the String will be displayed, if there is no extension to the rss feed then the enforced paramater should be used to detail what kind of loader should be used.
		 * @param	value	<String>	the URL of the feed to read.
		 * @param	enforced	<String>	the extension of the feed if there is no file extension in the URL.
		 * @return	<Boolean>	the value determined on whether the feed is displayed or loaded correctly otherwise false if the feed was not loaded or displayed.
		 */
		protected function displayFeed(value:String, enforced:String = null):Boolean 
		{
			var loader:AbstractLoader								= _LOAD_FACTORY.load(value, null, enforced);
			var gObject:GraphicComponentObject						= null;
			if (loader) 
			{
				if (!loader.loadCompleted) return false;
				_rssObject.feed										= new XML(loader.data);
				gObject												= findGraphicComponentObject(XML_HTML_TEXTFIELD);
				removeGraphicByName(XML_HTML_TEXTFIELD);
				gObject.data.field.setChildren(_rssObject.html);
				gObject.graphic										= null;
				generateNewGraphic(gObject);
				if (_verticalScroller) _verticalScroller.scroll		= 0;
				if (_horizontalScroller) _horizontalScroller.scroll	= 0;
				return true;
			}
			return false;
		}
		
		protected function newGraphicHandler(event:GraphicEvent):void 
		{
			findDisplayAssets();
			if (_verticalScroller) _verticalScroller.maxScroll		= _textfield.maxScrollV;
			if (_horizontalScroller) _horizontalScroller.maxScroll	= _textfield.maxScrollH;
		}
		
		/**
		 * generateGraphics :: create the graphics for this object.
		 */
		protected override function generateGraphics():void
		{
			super.generateGraphics();
			findDisplayAssets();
		}
		
		/**
		 * findDisplayAssets :: loop through all children and find the assets which are matched with public static variables XML_HTML_TEXTFIELD and XML_SCROLL_TEXTFIELD, which determin the TextField and IScrollerDisplayObject to be used as long as the class types for each are of the respective class types.
		 */
		protected function findDisplayAssets():void 
		{
			var item:GraphicComponentObject	= null;
			for each (item in _children) 
			{
				switch (String(item.data.@id)) 
				{
					
					case XML_HTML_TEXTFIELD:
						if (item.graphic is TextField) assignTextField(item.graphic as TextField);
						break;
						
					case XML_SCROLL_TEXTFIELD:
						if (item.graphic is IScrollerDisplayObject) assignVerticalScroller(item.graphic as IScrollerDisplayObject);
						break;
						
					case XML_SCROLL_TEXTFIELD_VERTICAL:
						if (item.graphic is IScrollerDisplayObject) assignVerticalScroller(item.graphic as IScrollerDisplayObject);
						break;
						
					case XML_SCROLL_TEXTFIELD_HORIZONTAL:
						if (item.graphic is IScrollerDisplayObject) assignHorizontalScroller(item.graphic as IScrollerDisplayObject);
						break;
						
				}
			}
		}
		
		/**
		 * assignTextField :: assign the text field to be the container for the HtmlText.
		 * @param	value	<TextField>	the text field to be used to display the RSS feed.
		 */
		protected function assignTextField(value:TextField):void 
		{
			_textfield	= value;
			_textfield.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelEventHandler);
			_textfield.addEventListener(TextEvent.LINK, textLinkEventHandler);
		}
		
		/**
		 * textLinkEventHandler :: handle any clicks from the blog reader and determin actions to be taken.  This handler can be removed or unused due to the RootEventControl handling any external clicks from graphical elements.
		 * @param	event
		 */
		protected function textLinkEventHandler(event:TextEvent):void 
		{
			
		}
		
		/**
		 * assignVerticalScroller :: assign the scroller to be used to control the text scrolling, applying event listeners where nessesary.
		 * @param	value	<IScrollerDisplayObject>	the scroller object to assign listeners and to control the text field.
		 */
		protected function assignVerticalScroller(value:IScrollerDisplayObject):void 
		{
			_verticalScroller			= value;
			_verticalScroller.position	= SimpleScrollBar.POSITION_VERTICAL;
			_verticalScroller.addEventListener(ScrollerDisplayObjectEvent.SCROLL, scrollVerticalUpdateEventHandler);
		}
		
		/**
		 * assignHorizontalScroller :: assign the scroller to be used to control the text scrolling, applying event listeners where nessesary.
		 * @param	value	<IScrollerDisplayObject>	the scroller object to assign listeners and to control the text field.
		 */
		protected function assignHorizontalScroller(value:IScrollerDisplayObject):void 
		{
			_horizontalScroller				= value;
			_horizontalScroller.position	= SimpleScrollBar.POSITION_HORIZONTAL;
			_horizontalScroller.addEventListener(ScrollerDisplayObjectEvent.SCROLL, scrollHorizontalUpdateEventHandler);
		}
		
		/**
		 * scrollVerticalUpdateEventHandler :: listener for the Event dispatched from the vertical scroller and assign the scroll value to the TextField().scrollV allocated for RSS use.
		 * @param	event	<ScrollerDisplayObjectEvent>	the event dispatched from the DisplayObject.
		 */
		protected function scrollVerticalUpdateEventHandler(event:ScrollerDisplayObjectEvent):void 
		{
			_textfield.scrollV	= event.scroll;
		}
		
		/**
		 * scrollHorizontalUpdateEventHandler :: listener for the Event dispatched from the horizontal scroller and assign the scroll value to the TextField().scrollH allocated for RSS use.
		 * @param	event	<ScrollerDisplayObjectEvent>	the event dispatched from the DisplayObject.
		 */
		protected function scrollHorizontalUpdateEventHandler(event:ScrollerDisplayObjectEvent):void 
		{
			_textfield.scrollH	= event.scroll;
		}
		
		/**
		 * mouseWheelEventHandler :: Event listener for when the mouse_wheel is been used upon the TextFiled and update the vertical scroller with the new scrollV value.
		 * @param	event	<MouseEvent>	the Event dispatched from the TextField.
		 */
		protected function mouseWheelEventHandler(event:MouseEvent):void 
		{
			if (_verticalScroller) _verticalScroller.scroll		= _textfield.scrollV;
		}
		
	}
	
}