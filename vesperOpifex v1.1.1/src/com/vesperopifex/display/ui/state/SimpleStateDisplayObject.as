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
package com.vesperopifex.display.ui.state 
{
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.display.SimpleInformationPanel;
	import com.vesperopifex.events.GraphicEvent;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import flash.display.DisplayObject;
	
	public class SimpleStateDisplayObject extends SimpleInformationPanel implements IStateDisplayObject 
	{
		public static const ACTIVE:String		= "active";
		public static const INACTIVE:String		= "inactive";
		public static const XML_STATE:String	= "state";
		public static const XML_STATE_ID:String	= "id";
		
		protected var _state:String				= null;
		protected var _previousState:String		= null;
		protected var _availableStates:Object	= new Object();
		protected var _type:String				= null;
		protected var _stateChildren:Array		= new Array();
		
		public function get state():String { return _state; }
		
		/**
		 * state :: a public variable to change the state of the current visual of the visual.
		 * @throws	<ArgumentError>	if the requested state is unavailable.
		 * @throws	<ArgumentError>	if the requested state is the same as the currently selected state.
		 */
		public function set state(value:String):void 
		{
			if (_state == value) return;
			if (Boolean(_availableStates[value])) 
			{
				_previousState = _state;
				_state = value;
				changeState();
			}
		}
		
		public function get type():String { return _type; }
		
		public override function get width():Number 
		{
			if (_state && getState(_state)) return getState(_state).width;
			return NaN;
		}
		
		public override function get height():Number 
		{
			if (_state && getState(_state)) return getState(_state).height;
			return NaN;
		}
		
		/**
		 * StateObject :: Constructor.
		 */
		public function SimpleStateDisplayObject(type:String = null) 
		{
			_type = type;
		}
		
		/**
		 * generateGraphics :: create the graphics for this object.
		 */
		protected override function generateGraphics():void
		{
			if (hasEventListener(GraphicEvent.INIT)) dispatchEvent(new GraphicEvent(GraphicEvent.INIT));
			var item:XML						= null;
			var object:GraphicComponentObject	= null;
			for each (item in _data[XML_STATE]) 
			{
				_stateChildren	= XMLGraphicDisplay.createGraphics(item);
				for each (object in _stateChildren) 
					if (!getState(String(item.@[XML_STATE_ID]))) addState(object.graphic, String(item.@[XML_STATE_ID]));
			}
			applyGraphicDetails();
			addGraphicChildren();
		}
		
		/**
		 * addGraphicChildren :: add the generated graphics and add them to the stage according the their appearance in the XML.
		 */
		protected override function addGraphicChildren(object:GraphicComponentObject = null):void 
		{
			
		}
		
		/**
		 * addState :: add a state to the visual list available to switch between, if there is no currently selected state then the first state passed will be used as the default.
		 * @param	child	<DisplayObject>	the child to be added to the display state list.
		 * @param	state	<String>	the state to which the display state should be associated with.
		 * @return	<DisplayObject>	the child added to the display state list.
		 * @throws	<ArgumentError>	in the event that the state is currently available.
		 */
		public function addState(child:DisplayObject, state:String):DisplayObject 
		{
			if (Boolean(getState(state))) throw new ArgumentError("The state passed is already in use, only one state of any type can be defined at any one time.\nIf you require to replace a state then use the replaceState method");
			else _availableStates[state] = child;
			if (!_state) assignDefaultState(state);
			if (hasEventListener(GraphicEvent.COMPLETE_NEW)) dispatchEvent(new GraphicEvent(GraphicEvent.COMPLETE_NEW));
			return child;
		}
		
		/**
		 * getState :: by passing the state identifier the returning DisplayObject is the associated object with that state if at all there is a state defined otherwise a return of null.
		 * @param	state	<String>	the identifier of the requested state.
		 * @return	<DisplayObject>	the object associated with the state passed or null.
		 */
		public function getState(state:String):DisplayObject 
		{
			if (Boolean(_availableStates[state])) return _availableStates[state] as DisplayObject;
			else return null;
		}
		
		/**
		 * replaceState :: replace a currently available display state wiht the passed child DisplayObject.
		 * @param	child	<DisplayObject>	the visual to replace the requested state association.
		 * @param	state	<String>	the state on which the requested replacement to take action upon.
		 * @return	<DisplayObject>	the visual object which replaced the previous state visual.
		 * @throws	<ArgumentError> in the case that the state does not exist currently.
		 */
		public function replaceState(child:DisplayObject, state:String):DisplayObject 
		{
			if (!Boolean(_availableStates[state])) throw new ArgumentError("The currently selected state does not exist.\nIf you require to add a state to this StateObject then use the addState method.");
			else 
			{
				if (_state == state) 
				{
					removeChild(_availableStates[_state]);
					_availableStates[state]	= child;
					addChild(_availableStates[_state]);
				} else _availableStates[state]	= child;
			}
			return child;
		}
		
		/**
		 * changeState :: passes the currently selected state and changes the visual accordingly.
		 * @usage	Can be overriden to have use of transitions and effects.
		 */
		protected function changeState():void
		{
			if (Boolean(numChildren)) removeChild(_availableStates[_previousState] as DisplayObject);
			addChild(_availableStates[_state] as DisplayObject);
		}
		
		/**
		 * assignDefaultState :: use this method to assign a state if there has been no other state assignments before.
		 * @param	value	<String>	the state with which to assign as the initial default state.
		 * @warning	the requested state has to be available as a state before the assignment as the default.
		 */
		protected function assignDefaultState(value:String):void
		{
			_state = value;
			addChild(_availableStates[_state] as DisplayObject);
		}
		
	}
	
}