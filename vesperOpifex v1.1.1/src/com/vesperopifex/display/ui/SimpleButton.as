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
	import com.vesperopifex.display.GraphicFactory;
	import com.vesperopifex.display.IDataObject;
	import com.vesperopifex.display.IXMLDataObject;
	import com.vesperopifex.display.utils.SimpleButtonStateData;
	import com.vesperopifex.events.StyleSheetFactoryEvent;
	import com.vesperopifex.utils.controllers.PageEventControl;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import fl.motion.Animator;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SimpleButton extends flash.display.SimpleButton implements IXMLDataObject, IDataObject 
	{
		protected static const XML_STATE:String						= "state";
		protected static const XML_APPLICATION:String				= "application";
		protected static const XML_APPLICATION_DELIMINATOR:String	= ",";
		protected static const GRAPHIC_FACTORY:GraphicFactory		= new GraphicFactory();
		
		protected var _data:XML										= null;
		protected var _eventData:XMLList							= null;
		protected var _controller:PageEventControl					= null;
		protected var _stateData:SimpleButtonStateData				= new SimpleButtonStateData();
		protected var _upState:Sprite								= new Sprite();
		protected var _overState:Sprite								= new Sprite();
		protected var _downState:Sprite								= new Sprite();
		protected var _hitTestState:Sprite							= new Sprite();
		
		public function get eventData():XMLList { return _eventData; }
		
		public function get XMLData():XML { return _data; }
		public function set XMLData(value:XML):void 
		{
			_data = value;
			checkEventData(value);
			generateGraphics();
		}
		
		public function get active():Boolean { return mouseEnabled; }
		public function set active(value:Boolean):void 
		{
			mouseEnabled = value;
		}
		
		public function get controller():PageEventControl { return _controller; }
		public function set controller(value:PageEventControl):void 
		{
			_controller = value;
		}
		
		public function get dataUpdate():Object { return null; }
		/**
		 * dataUpdate :: for any data to be submited to this class it checks to see if the Object object is actually an XML object where it will be sent to the protected function xmlUpdate for processing, otherwise the object is delt with on a per Class basis checking the data is valid and assigning the data where required.
		 * @param	value	<Object>	either an Object or XML object containing a particular data set.
		 */
		public function set dataUpdate(value:Object):void 
		{
			if (value is XML) xmlUpdate(value as XML);
		}
		
		/**
		 * SimpleButton :: Constructor.
		 * 	Generate a SimpleButton from the use of XML data.
		 * @param	upState	<DisplayObject> an object for the state of the button when the mouse is outside the hit area.
		 * @param	overState	<DisplayObject> the state for the button when the mouse is within the hit area.
		 * @param	downState	<DisplayObject> the state of the button when the mouse button is pressed while over the hit area.
		 * @param	hitTestState	<DisplayObject> the hit area of the button.
		 */
		public function SimpleButton(	upState:DisplayObject = null, 
										overState:DisplayObject = null, 
										downState:DisplayObject = null, 
										hitTestState:DisplayObject = null) 
		{
			if (Boolean(upState is Sprite)) _upState			= upState as Sprite;
			if (Boolean(overState is Sprite)) _overState		= overState as Sprite;
			if (Boolean(downState is Sprite)) _downState		= downState as Sprite;
			if (Boolean(hitTestState is Sprite)) _hitTestState	= hitTestState as Sprite;
			GRAPHIC_FACTORY.addEventListener(StyleSheetFactoryEvent.COMPLETE, styleSheetCompleteHandler);
			
			super(upState, overState, downState, hitTestState);
		}
		
		/**
		 * styleSheetCompleteHandler :: listern for the GraphicFactory to determin when the TextFields have been updated with a StyleSheet and need recreation.
		 * @param	event	<StyleSheetFactoryEvent>	the Event dispatched from the GraphicFactory to notify the TextFields need recreation.
		 */
		protected function styleSheetCompleteHandler(event:StyleSheetFactoryEvent):void 
		{
			_upState		= new Sprite();
			_overState		= new Sprite();
			_downState		= new Sprite();
			_hitTestState	= new Sprite();
			generateStateGraphics();
		}
		
		/**
		 * xmlUpdate :: a parser which varifies the passed value and assigns data where required.
		 * @param	value	<XML> data containing a particular data set for Class implementation.
		 */
		protected function xmlUpdate(value:XML):void 
		{
			
		}
		
		/**
		 * checkEventData :: find any event context(s) identified in data and apply them.
		 * @param	data	<XML>	data pertaining to the object.
		 */
		protected function checkEventData(data:XML):void 
		{
			var eData:XMLList = PageEventControl.checkEventData(data);
			if (eData) _eventData = eData;
		}
		
		/**
		 * generateGraphics :: pulls all the data together to generate the button states.
		 */
		protected function generateGraphics():void
		{
			parseXMLData();
			generateStateGraphics();
		}
		
		/**
		 * generateStateGraphics :: once all the data is compiled into Array's then the data is pulled appart and the generation of the assets for each state is created and placed on the display stack for each state.
		 */
		protected function generateStateGraphics():void
		{
			generateUpStateGraphics();
			generateOverStateGraphics();
			generateDownStateGraphics();
			generateHitTestStateGraphics();
			
			upState			= _upState;
			overState		= _overState;
			downState		= _downState;
			hitTestState	= _hitTestState;
		}
		
		protected function generateUpStateGraphics():void
		{
			generateStatesGraphics(_upState, _stateData.upData);
		}
		
		protected function generateOverStateGraphics():void
		{
			generateStatesGraphics(_overState, _stateData.overData);
		}
		
		protected function generateDownStateGraphics():void
		{
			generateStatesGraphics(_downState, _stateData.downData);
		}
		
		protected function generateHitTestStateGraphics():void
		{
			generateStatesGraphics(_hitTestState, _stateData.hitTestData);
		}
		
		protected function generateStatesGraphics(displayObject:Sprite, data:Array):void
		{
			var i:int				= 0;
			var item:XML			= null;
			var child:DisplayObject	= null;
			
			for each (item in data) 
			{
				child = GRAPHIC_FACTORY.generate(item);
				displayObject.addChild(child);
			}
			for (i = 0; i < data.length; i++) 
				checkXMLIndex(displayObject, displayObject.getChildAt(i), data[i]);
		}
		
		protected function checkXMLIndex(state:Sprite, child:DisplayObject, data:XML):void 
		{
			XMLGraphicDisplay.checkXMLDisplayIndex(state, child, data);
		}
		
		/**
		 * parseXMLData :: compile the XML data into Array's for use to generate the DisplayObject(s). 
		 */
		protected function parseXMLData():void
		{
			var item:XML		= null;
			var graphicItem:XML	= null;
			var aItem:String	= null;
			
			for each (item in _data[XML_STATE]) 
				for each (aItem in graphicApplication(item[XML_APPLICATION])) 
					for each (graphicItem in item[GraphicFactory.XML_GRAPHIC]) appendGraphicApplication(aItem, graphicItem);
		}
		
		/**
		 * appendGraphicApplication :: depending on the application of the assets to be placed upon the various states the data will be recorded into the corresponding Array(s).
		 * @param	application	<String>	the state on which the graphic asset is to be placed.
		 * @param	data	<XML>	the data associated to the graphic element.
		 */
		protected function appendGraphicApplication(application:String, data:XML):void 
		{
			switch (application) 
			{
				case SimpleButtonStateData.ALL:
					_stateData.upData.push(data);
					_stateData.overData.push(data);
					_stateData.downData.push(data);
					_stateData.hitTestData.push(data);
					break;
					
				case SimpleButtonStateData.UP:
					_stateData.upData.push(data);
					break;
					
				case SimpleButtonStateData.OVER:
					_stateData.overData.push(data);
					break;
					
				case SimpleButtonStateData.DOWN:
					_stateData.downData.push(data);
					break;
					
				case SimpleButtonStateData.HIT_TEST:
					_stateData.hitTestData.push(data);
					break;
			}
		}
		
		/**
		 * graphicApplication :: generates the applications for the elements to be placed on the button, returning an Array of String(s).
		 * @param	data	<XMLList>	the source data for the application(s) of the graphic to be applied to.
		 * @return	<Array> a list of Strings describing which state the particular graphic described should be generated for.
		 */
		protected function graphicApplication(data:XMLList):Array 
		{
			var rtn:Array		= new Array();
			var tArray:Array	= new Array();
			var aItem:String	= null;
			var item:XML		= null;
			
			for each (item in data) 
			{
				tArray = item.toString().split(XML_APPLICATION_DELIMINATOR);
				for each (aItem in tArray) rtn.push(aItem);
			}
			
			return rtn;
		}
		
	}
	
}