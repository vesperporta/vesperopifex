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
package com.vesperopifex.xml 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class RSS2Object extends EventDispatcher 
	{
		public static const RSS_CHANNEL:String		= "channel";
		public static const RSS_ITEM:String			= "item";
		public static const RSS_TITLE:String		= "title";
		public static const RSS_LINK:String			= "link";
		public static const RSS_DESCRIPTION:String	= "description";
		public static const RSS_COPYRIGHT:String	= "copyright";
		public static const RSS_IMAGE:String		= "image";
		public static const RSS_URL:String			= "url";
		public static const RSS_LANGUAGE:String		= "language";
		public static const RSS_AUTHOR:String		= "author";
		public static const RSS_COMMENTS:String		= "comments";
		public static const RSS_ENCLOSURE:String	= "enclosure";
		public static const RSS_PUBDATE:String		= "pubDate";
		
		public static const CHANNEL_TEMPLATE:XML	= <p class="rss-channel"></p>;
		public static const HEADING_1_TEMPLATE:XML	= <p class="rss-h1"></p>;
		public static const HEADING_2_TEMPLATE:XML	= <p class="rss-h2"></p>;
		public static const PARAGRAPH_TEMPLATE:XML	= <p class="rss-p"></p>;
		public static const DATE_TEMPLATE:XML		= <p class="rss-p-date"></p>;
		public static const COMMENTS_TEMPLATE:XML	= <p class="rss-p-comments">Comments</p>;
		public static const IMAGE_TEMPLATE:XML		= <img src="" alt=""></img>;
		public static const LINK_TEMPLATE:XML		= <a href="" target="_blank"></a>;
		public static const NEW_LINE_TEMPLATE:XML	= <br/>;
		public static const MEDIA_TEMPLATE:XML		= <img src="" align="left" hspace="8" vspace="8" checkPolicyFile="true" />;
		public static const ANCHOR_EVENT:String		= "event:";
		
		protected var _feed:XML						= null;
		protected var _html:XML						= <html></html>;
		
		public function get feed():XML { return _feed; }
		public function set feed(value:XML):void 
		{
			_feed = value;
			dispatchEvent(new Event(Event.ADDED, false, true));
		}
		
		public function get html():XML { return _html; }
		
		public function RSS2Object() 
		{
			super();
			addEventListener(Event.ADDED, addedEventHandler);
		}
		
		protected function addedEventHandler(event:Event):void 
		{
			event.stopImmediatePropagation();
			passFeed();
		}
		
		protected function passFeed():void
		{
			if (String(_feed.@version) != "2.0") throw new ArgumentError("RSS feed is not of version 2.0, please extend this Class to deal with more than one version of RSS feed.");
			
			XML.prettyIndent	= -1;
			var data:XML		= _feed.copy();
			var channel:XML		= null;
			var item:XML		= null;
			var channelTmp:XML	= null;
			var itemTmp:XML		= null;
			
			for each (channel in data[RSS_CHANNEL]) 
			{
				channelTmp	= CHANNEL_TEMPLATE.copy();
				addFeedDetails(channel, channelTmp);
				for each (item in channel[RSS_ITEM]) 
				{
					itemTmp	= PARAGRAPH_TEMPLATE.copy();
					addFeedDetails(item, itemTmp);
					channelTmp.appendChild(itemTmp);
				}
				_html.appendChild(channelTmp);
			}
			_html = new XML(_html.children());
		}
		
		protected function addFeedDetails(item:XML, data:XML):XML 
		{
			var tmp:XML	= null;
			
			if (item[RSS_IMAGE].length()) 
			{
				if (item[RSS_IMAGE][RSS_LINK].length()) 
				{
					tmp			= LINK_TEMPLATE.copy();
					tmp.@href	= ANCHOR_EVENT + String(item[RSS_IMAGE][RSS_LINK][0]);
					tmp.appendChild(IMAGE_TEMPLATE.copy());
					data.appendChild(tmp);
					tmp			= tmp.img;
				}else 
				{
					tmp	= IMAGE_TEMPLATE.copy();
					data.appendChild(tmp);
				}
				tmp.@src	= String(item[RSS_IMAGE][RSS_URL][0]);
				tmp.@alt	= String(item[RSS_IMAGE][RSS_TITLE][0]);
			}
			
			if (item[RSS_TITLE].length()) 
			{
				tmp	= (String(item.name()) == RSS_CHANNEL)? HEADING_1_TEMPLATE.copy(): HEADING_2_TEMPLATE.copy();
				if (item[RSS_LINK].length()) 
				{
					tmp.appendChild(LINK_TEMPLATE.copy());
					tmp.a.@href = ANCHOR_EVENT + String(item[RSS_LINK][0]);
					tmp.a.appendChild(String(item[RSS_TITLE][0]));
				} else tmp.appendChild(String(item[RSS_TITLE][0]));
				data.appendChild(tmp);
			}
			
			if (item[RSS_PUBDATE].length()) 
			{
				tmp	= DATE_TEMPLATE.copy();
				tmp.appendChild(String(item[RSS_PUBDATE][0]));
				data.appendChild(tmp);
			}
			
			if (item[RSS_ENCLOSURE].length() && String(item[RSS_ENCLOSURE][0]).indexOf("jpg") != -1 || String(item[RSS_ENCLOSURE][0]).indexOf("gif") != -1 || String(item[RSS_ENCLOSURE][0]).indexOf("swf") != -1) 
			{
				tmp			= MEDIA_TEMPLATE.copy();
				tmp.@src	= String(item[RSS_ENCLOSURE][0]);
				data.appendChild(tmp);
			}
			
			if (item[RSS_DESCRIPTION].length()) 
			{
				tmp	= PARAGRAPH_TEMPLATE.copy();
				tmp.appendChild(String(item[RSS_DESCRIPTION][0]));
				data.appendChild(tmp);
			}
			
			if (item[RSS_COMMENTS].length()) 
			{
				tmp			= LINK_TEMPLATE.copy();
				tmp.@href	= ANCHOR_EVENT + String(item[RSS_COMMENTS][0]);
				tmp.appendChild(COMMENTS_TEMPLATE.copy());
				data.appendChild(tmp);
			}
			
			data.appendChild(NEW_LINE_TEMPLATE.copy());
			data.appendChild(NEW_LINE_TEMPLATE.copy());
			
			return data;
		}
		
	}
	
}