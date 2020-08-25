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
	import com.vesperopifex.display.video.IVideoControl;
	import com.vesperopifex.events.GraphicEvent;
	import com.vesperopifex.events.GraphicFactoryEvent;
	import com.vesperopifex.events.GraphicFactoryProgressEvent;
	import com.vesperopifex.events.StyleSheetFactoryEvent;
	import com.vesperopifex.utils.AbstractLoader;
	import com.vesperopifex.utils.controllers.PageEventControl;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	
	public class SimpleInformationPanel extends Sprite implements IXMLDataObject, IDataObject 
	{
		protected var _active:Boolean							= false;
		protected var _controller:PageEventControl				= null;
		protected var _data:XML									= null;
		protected var _eventData:XMLList						= null;
		protected var _children:Array							= new Array();
		protected var _waitingChildren:Array					= new Array();
		protected var _maskChildren:Array						= new Array();
		protected var _loadedAssets:int							= 0;
		protected var _loader:DisplayObject						= null; // todo: once the loading stack is complete apply the interface here.
		
		public function get eventData():XMLList { return _eventData; }
		
		/**
		 * data :: the generic variable to assign data to on initialisation.
		 */
		public function get XMLData():XML { return _data; }
		public function set XMLData(value:XML):void 
		{
			if (_data) return;
			if (value) 
			{
				_data	= value;
				generateGraphics();
				passXMLData();
			}
		}
		
		public function get controller():PageEventControl { return _controller; }
		public function set controller(value:PageEventControl):void 
		{
			_controller = value;
		}
		
		/**
		 * active :: assign whether this class is avilable for interaction and try to pass the variable onto children created.
		 */
		public function get active():Boolean { return _active; }
		public function set active(value:Boolean):void 
		{
			_active = value;
			assignChildActivity();
		}
		
		public function get dataUpdate():Object { return null; }
		/**
		 * dataUpdate :: for any data to be submited to this class it checks to see if the Object object is actually an XML object where it will be sent to the protected function xmlUpdate for processing, otherwise the object is delt with on a per Class basis checking the data is valid and assigning the data where required.
		 * @param	value	<Object>	either an Object or XML object containing a particular data set.
		 */
		public function set dataUpdate(value:Object):void 
		{
			if (value is XML) dataXMLUpdate(value as XML);
			else dataObjectUpdate(value);
		}
		
		/**
		 * SimpleInformationPanel :: Constructor.
		 */
		public function SimpleInformationPanel() 
		{
			super();
			XMLGraphicDisplay.FACTORY.addEventListener(GraphicFactoryEvent.FINISHED, graphicFactoryFinishedHandler);
			XMLGraphicDisplay.FACTORY.addEventListener(GraphicFactoryEvent.COMPLETE, graphicFactoryCompleteHandler);
			XMLGraphicDisplay.FACTORY.addEventListener(GraphicFactoryEvent.NEW_FILE, graphicFactoryNewFileHandler);
			XMLGraphicDisplay.FACTORY.addEventListener(GraphicFactoryEvent.ERROR, graphicFactoryErrorHandler);
			XMLGraphicDisplay.FACTORY.addEventListener(GraphicFactoryEvent.FATAL_ERROR, graphicFactoryFatalErrorHandler);
			XMLGraphicDisplay.FACTORY.addEventListener(GraphicFactoryProgressEvent.PROGRESS, graphicFactoryProgressHandler);
			XMLGraphicDisplay.FACTORY.addEventListener(StyleSheetFactoryEvent.COMPLETE, styleSheetCompleteHandler);
		}
		
		/**
		 *pass through all child objects and return whether the GraphicComponentObject is a child of this object.
		 * @param object	<GraphicComponentObject>	the object to check for being a child.
		 * @return	<Boolean>	true if the object is a child of this DisplayObject and false if not.
		 */		
		public function findGraphicObject(object:GraphicComponentObject):Boolean 
		{
			for each (var child:GraphicComponentObject in _children) 
				if (child.data == object.data) 
					return true;
			return false;
		}
		
		/**
		 * apply a loader visual to represent the amount of data loaded compared to the total
		 */
		protected function addLoaderVisual():void 
		{
			// add pre-loader symbol here
		}
		
		/**
		 * remove any loading visuals.
		 */
		protected function removeLoaderVisual():void 
		{
			// remove pre-loader symbol here
		}
		
		/**
		 * removeGraphics :: remove all Component classes from this GraphicChapter's render list and clear the _pageArray.
		 */
		protected function removeGraphics():void 
		{
			for each (var object:GraphicComponentObject in _children) 
			{
				_controller.removeEventListeners(object.graphic);
				removeChild(object.graphic);
			}
			_children	= new Array();
		}
		
		/**
		 * removeGraphicByComponentObject :: remove a graphic component from the display list and the graphic array by the GraphicComponentObject.
		 * @param	object	<GraphicComponentObject>	remove the DisplayObject with this GraphicComponentObject object.
		 */
		protected function removeGraphicByComponentObject(object:GraphicComponentObject):void 
		{
			var child:GraphicComponentObject	= null;
			for (var i:int = 0; i < _children.length; i++) 
			{
				child							= _children[i] as GraphicComponentObject;
				if (child.graphic != object.graphic) continue;
				_controller.removeEventListeners(object.graphic);
				removeChild(object.graphic);
				_children.splice(i, 1);
				return;
			}
		}
		
		/**
		 * removeGraphicByName :: remove a graphic component from the display list and the graphic array by named ID, displayName.
		 * @param	displayName	<String>	remove the DisplayObject with this String object.
		 */
		protected function removeGraphicByName(displayName:String):void 
		{
			var child:GraphicComponentObject	= null;
			for (var i:int = 0; i < _children.length; i++)  
			{
				child	= _children[i] as GraphicComponentObject;
				if (child.data.@id == displayName) 
				{
					_controller.removeEventListeners(child.graphic);
					try 
					{
						removeChild(child.graphic);
						trace("DisplayObject Removed\t::\t" + displayName);
					} catch (error:Error) 
					{
						child.graphic.addEventListener(Event.ADDED, removeGraphicByEventHandler);
					}
					_children.splice(i, 1);
				}
			}
		}
		
		/**
		 * removeGraphicByEventHandler :: an Event handler for when a graphic is not instanced on the stage while removal was tried, this is to catch the addition of the DisplayObject to the display stack and remove it.
		 * @param	event	<Event>	dispatched event from the DisplayObject once it has been added to the display stack.
		 */
		protected function removeGraphicByEventHandler(event:Event):void 
		{
			var target:DisplayObject	= event.target as DisplayObject;
			target.removeEventListener(Event.ADDED, removeGraphicByEventHandler);
			var child:GraphicComponentObject	= null;
			for (var i:int = 0; i < _children.length; i++)  
			{
				child	= _children[i] as GraphicComponentObject;
				if (child.graphic == target) 
				{
					try 
					{
						removeChild(target);
						trace("DisplayObject Removed\t::\t" + child.data.@id);
					} catch (error:Error) 
					{
						trace("DisplayObject unable to be removed\t::\t" + child.data.@id);
					}
					_children.splice(i, 1);
					return;
				}
			}
		}
		
		/**
		 * assignChildActivity :: find all children which implement IXMLDataObject class and assign the current availability of the panel to the children.
		 */
		protected function assignChildActivity():void
		{
			for each (var object:GraphicComponentObject in _children) 
				if (object.graphic is IXMLDataObject && object.graphic != this) 
					(object.graphic as IXMLDataObject).active	= _active;
		}
		
		/**
		 * passXMLData :: pass the data already obtained in _data and do any actions required.
		 */
		protected function passXMLData():void
		{
			
		}
		
		/**
		 * dataXMLUpdate :: a parser which varifies the passed value and assigns data where required.
		 * @param	value	<XML> data containing a particular data set for Class implementation.
		 */
		protected function dataXMLUpdate(value:XML):void 
		{
			
		}
		
		/**
		 * dataObjectUpdate :: a passer which varifies the passed data and object for internal use.
		 * @param	value	<Object>	the data object to be passed as an Object.
		 */
		protected function dataObjectUpdate(value:Object):void
		{
			
		}
		
		/**
		 * create the graphics for this object.
		 */
		protected function generateGraphics():void
		{
			if (hasEventListener(GraphicEvent.INIT)) dispatchEvent(new GraphicEvent(GraphicEvent.INIT));
			addLoaderVisual();
			for each (var object:GraphicComponentObject in XMLGraphicDisplay.createGraphics(_data)) 
				if (Boolean(object = processGraphicalObject(object))) 
					_children.push(object);
			if (!Boolean(_waitingChildren.length)) finishedGraphicGeneration();
		}
		
		/**
		 * create the outstanding graphics for this object.
		 */
		protected function generateWaitingGraphics():void
		{
			if (!Boolean(_waitingChildren.length)) 
			{
				finishedGraphicGeneration();
				return;
			}
			var object:GraphicComponentObject	= null;
			for each (object in _waitingChildren) 
			{
				processGraphicalObject(XMLGraphicDisplay.createGraphic(object.data));
				_children.push(object);
			}
			_waitingChildren = new Array();
			finishedGraphicGeneration();
		}
		
		/**
		 * apply the generalised attributes tot he graphic object generated.
		 */
		protected function processGraphicalObject(object:GraphicComponentObject):GraphicComponentObject 
		{
			if (!object) return null;
			if (XMLGraphicDisplay.checkAsVideo(object.graphic)) (object.graphic as IVideoControl).listenTo = this as IEventDispatcher;
			else if (XMLGraphicDisplay.checkAsLoader(object.graphic) && !XMLGraphicDisplay.checkLoaded(object.graphic)) 
			{
				_waitingChildren.push(object);
				return null;
			}
			if (object.graphic is MaskSprite) _maskChildren.push(object);
			if (object.graphic is IXMLDataObject) 
			{
				var xmlDataObject:IXMLDataObject	= object.graphic as IXMLDataObject;
				xmlDataObject.XMLData				= object.data;
				if (!_controller) _controller		= new PageEventControl(this);
				xmlDataObject.controller			= _controller;
			}
			return object;
		}
		
		/**
		 * for any child being attributed to a mask then the data for that mask will have to be passed again to find the IDs of all the objects to mask.
		 * 	upon the special attribute of teh mask XML data of cacheAsBitmap then all elements listed within the mask will be cached as bitmap.
		 */
		protected function applyMaskSprites(object:GraphicComponentObject = null):void
		{
			if (object) 
			{
				XMLGraphicDisplay.applyMaskSprites(object, _children);
				return;
			}
			for each (object in _maskChildren) XMLGraphicDisplay.applyMaskSprites(object, _children);
		}
		
		/**
		 * add all the finishing parts to the generated graphics.
		 */
		protected function finishedGraphicGeneration():void 
		{
			applyGraphicDetails();
			applyContextEvents();
			applyMaskSprites();
			addGraphicChildren();
			removeLoaderVisual();
		}
		
		/**
		 * applyContextEvents :: using the PageEventControl apply any event listeners to the display object.
		 */
		protected function applyContextEvents(object:GraphicComponentObject = null):void 
		{
			if (!_controller) return;
			if (object) 
			{
				_controller.checkEvents(object.graphic, object.data);
				return;
			}
			for each (object in _children) _controller.checkEvents(object.graphic, object.data);
		}
		
		/**
		 * create the graphic from the object passed.
		 */
		protected function generateNewGraphic(value:GraphicComponentObject):GraphicComponentObject 
		{
			if (hasEventListener(GraphicEvent.INIT_NEW)) dispatchEvent(new GraphicEvent(GraphicEvent.INIT_NEW));
			var newObj:GraphicComponentObject	= XMLGraphicDisplay.createGraphics(new XML(<data></data>).appendChild(value.data))[0];
			_children.push(newObj);
			processGraphicalObject(newObj);
			applyGraphicDetails(newObj);
			applyContextEvents(newObj);
			addGraphicChildren(newObj);
			return newObj;
		}
		
		/**
		 * for each child stored for addition ot this component, apply any attributes from the XML to the object.
		 */
		protected function applyGraphicDetails(object:GraphicComponentObject = null):void 
		{
			if (object) 
				XMLGraphicDisplay.applyGraphicDetails(object);
			else 
				for each (object in _children) 
					XMLGraphicDisplay.applyGraphicDetails(object);
		}
		
		/**
		 * addGraphicChildren :: add the generated graphics and add them to the stage according the their appearance in the XML.
		 */
		protected function addGraphicChildren(object:GraphicComponentObject = null):void 
		{
			if (object) 
			{
				if (object.index >= 0 && object.index < numChildren) addChildAt(object.graphic, object.index);
				else addChild(object.graphic);
				if (hasEventListener(GraphicEvent.COMPLETE_NEW)) dispatchEvent(new GraphicEvent(GraphicEvent.COMPLETE_NEW));
				return;
			}
			for each (object in _children) 
			{
				if (object.graphic == this) continue;
				if (object.index >= 0 && object.index < numChildren) addChildAt(object.graphic, object.index);
				else addChild(object.graphic);
			}
			checkGraphicXMLIndex();
		}
		
		/**
		 * checkGraphicXMLIndex :: check through all the graphic on the GraphicComponent and make sure the display index is correct for all graphical objects.
		 */
		protected function checkGraphicXMLIndex():void 
		{
			for each (var obj:GraphicComponentObject in _children) XMLGraphicDisplay.checkXMLDisplayIndex(this, obj.graphic, obj.data);
			if (hasEventListener(GraphicEvent.COMPLETE)) dispatchEvent(new GraphicEvent(GraphicEvent.COMPLETE));
		}
		
		/**
		 * findGraphicChild :: pass through all the child graphics and return the DisplayObject which match the name with the value passed.
		 * @param	value	<String>	the value with which to search for a child on the display stack.
		 * @return	<DisplayObject>	the relevant child object with the name as the value passed, if no child object is found then null.
		 */
		protected function findGraphicChild(value:String):DisplayObject 
		{
			var object:GraphicComponentObject	= findGraphicComponentObject(value);
			if (!object) return null;
			return object.graphic;
		}
		
		/**
		 * findGraphicChild :: pass through all the child graphics and return the DisplayObject which match the name with the value passed.
		 * @param	value	<String>	the value with which to search for a child on the display stack.
		 * @return	<DisplayObject>	the relevant child object with the name as the value passed, if no child object is found then null.
		 */
		protected function findGraphicComponentObject(value:String):GraphicComponentObject 
		{
			for each (var obj:GraphicComponentObject in _children) 
				if (String(obj.data.@[XMLGraphicDisplay.XML_ID]) == value) 
					return obj;
			return null;
		}
		
		/**
		 * handle any loading of assets and re-generation of assets other than a TextField.
		 * @param	event	<GraphicFactoryEvent>	The event dispatched from the GraphicFactory.
		 */
		protected function graphicFactoryFinishedHandler(event:GraphicFactoryEvent):void 
		{
			if (Boolean(_waitingChildren.length)) generateWaitingGraphics();
			if (event.cancelable) event.stopPropagation();
		}
		
		/**
		 * handle any loading of assets and re-generation of assets other than a TextField, this method is now only an indication of when a file has been completed in loading.
		 * @param	event	<GraphicFactoryEvent>	The event dispatched from the GraphicFactory.
		 */
		protected function graphicFactoryCompleteHandler(event:GraphicFactoryEvent):void 
		{
			if (event.cancelable) event.stopPropagation();
		}
		
		/**
		 * captured to handle any and all new files being loaded by the GraphicFactory.
		 * @param	event	<GraphicFactoryEvent>	the event dispatched from the Graphicactory upon a new fle beginning transfer.
		 */
		protected function graphicFactoryNewFileHandler(event:GraphicFactoryEvent):void 
		{
			if (event.cancelable) event.stopPropagation();
		}
		
		/**
		 * handler to deal with the loading of files from the GraphicFactory, when data is downloaded then this event is dispatched and processed.
		 * @param	event	<GraphicFactoryProgressEvent>	the event dispatched from the GraphicFactory upon loading file progress.
		 */
		protected function graphicFactoryProgressHandler(event:GraphicFactoryProgressEvent):void 
		{
			// handle loading progress of objects here.
			if (event.cancelable) event.stopPropagation();
		}
		
		/**
		 * capture errors of loading files, upon this action the item will be removed from the display list and the continuation of displaying the remaining graphics proceeds.
		 * @param	event	<GraphicFactoryEvent>	the event derived from the error.
		 */
		protected function graphicFactoryErrorHandler(event:GraphicFactoryEvent):void 
		{
			var object:GraphicComponentObject	= null;
			var waiting:GraphicComponentObject	= null;
			var i:int							= 0;
			for (i = 0; i < _waitingChildren.length; i++) 
			{
				waiting	= _waitingChildren[i] as GraphicComponentObject;
				if (!waiting) continue;
				if (waiting.graphic == event.loader) 
				{
					_waitingChildren.splice(i, 1);
					for each (object in _children) 
						if (object.graphic == waiting.graphic) 
							object	= null;
					if (event.cancelable) event.stopImmediatePropagation();
				}
			}
			if (!Boolean(_waitingChildren.length)) finishedGraphicGeneration();
		}
		
		/**
		 * upon a security error all waiting graphics will be forgone and the continuation of the displaying of the current graphics will proceed.
		 * @param	event	<GraphicFactoryEvent>	the event derived from the error.
		 */
		protected function graphicFactoryFatalErrorHandler(event:GraphicFactoryEvent):void 
		{
			_waitingChildren	= new Array();
			generateWaitingGraphics();
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * styleSheetCompleteHandler :: handler for new StyleSheets being loaded in, now have to recreate the TextFields for display.
		 * @param	event	<StyleSheetFactoryEvent> event dispatched from the StyleSheet loader.
		 */
		protected function styleSheetCompleteHandler(event:StyleSheetFactoryEvent):void 
		{
			if (event.cancelable) event.stopPropagation();
			var object:GraphicComponentObject	= null;
			for (var i:int = 0; i < _children.length; i++) 
			{
				object	= _children[i] as GraphicComponentObject;
				if (!object || !(object.graphic is TextField)) continue;
				try 
				{
					removeChild(object.graphic);
				} catch (error:Error) 
				{
					trace(object.graphic + " NOT removed from display stack, not a child of this " + this);
				}
				trace(object.graphic + " Recreated[StyleSheet]\t::\t" + object.data.@id);
				object	= XMLGraphicDisplay.createGraphic(object.data)
				_children.splice(i, 1, object);
				addGraphicChildren(object);
				applyGraphicDetails(object);
				applyContextEvents(object);
				applyMaskSprites(object);
			}
			checkGraphicXMLIndex();
		}
		
	}
	
}