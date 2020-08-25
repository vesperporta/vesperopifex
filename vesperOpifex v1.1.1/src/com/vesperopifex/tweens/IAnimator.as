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
package com.vesperopifex.tweens 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public interface IAnimator 
	{
		
		/**
		 * animationList :: the currently active animations in progress.
		 * [read]
		 */
		function get animationList():Array;
		
		/**
		 * animateDisplayObject :: generate the available aniamtions described in the XML and make the passed DisplayObject animate to the requirements, and in the limitations of the Tweening class, this is handled by the implimenting Class.
		 * @param	displayObject	<DisplayObject>	the graphical object on which the animation is to be placed upon.
		 * @param	data	<XML>	the data containing all the animation information.
		 * @return	<Boolean>	a value to determin if the aniamtion has successfully been applied to the DisplayObject, true, or not, false.
		 */
		function animateDisplayObject(displayObject:DisplayObject, data:XML):Boolean;
		
		/**
		 * clear :: if there is no DisplayObject passed in as a paramater then all animations of the implementing Class is to stop all aniamtions and remove any reference of such an animation, otherwise if a DisplayObject is passed then the animation, if any, placed upon that object is stopped and removed from the framework.
		 * @param	displayObject	<DisplayObject [default null]>	the object on which to remove current animations.
		 * @return	<Boolean>	a value to determin if any animations where removed from any objects.
		 */
		function clear(displayObject:DisplayObject = null):Boolean;
		
		/**
		 * pause :: stop the current animations on all objects currently in operation if the displayObject is null otherwise stop all animations on the object passed, this method is a temporary pause in animation where the method 'resume' can be employed to start the animations from where they where stopped.
		 * @param	displayObject	<DisplayObject [default null]>	the object on which to stop the animations.
		 * @return	<Boolean>	a value to determin if any animatiosn where stopped or not.
		 */
		function pause(displayObject:DisplayObject = null):Boolean;
		
		/**
		 * resume :: after the use of pause this method can be used to resume the effected animations from their previous tween point.
		 * @param	displayObject	<DisplayObject [default null]>	the object with which to resume the animation.
		 * @return	<Boolean>	a value to determine if there where any animations resumed or not.
		 */
		function resume(displayObject:DisplayObject = null):Boolean;
		
		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener
		 *  receives notification of an event. You can register event listeners on all nodes in the
		 *  display list for a specific type of event, phase, and priority.
		 *
		 * @param type              <String> The type of event.
		 * @param listener          <Function> The listener function that processes the event. This function must accept an event object
		 *                            as its only parameter and must return nothing, as this example shows:
		 *                            function(evt:Event):void
		 *                            The function can have any name.
		 * @param useCapture        <Boolean (default = false)> Determines whether the listener works in the capture phase or the target
		 *                            and bubbling phases. If useCapture is set to true, the
		 *                            listener processes the event only during the capture phase and not in the target or
		 *                            bubbling phase. If useCapture is false, the listener processes the event only
		 *                            during the target or bubbling phase. To listen for the event in all three phases, call
		 *                            addEventListener() twice, once with useCapture set to true,
		 *                            then again with useCapture set to false.
		 * @param priority          <int (default = 0)> The priority level of the event listener. Priorities are designated by a 32-bit integer. The higher the number, the higher the priority. All listeners with priority n are processed before listeners of priority n-1. If two or more listeners share the same priority, they are processed in the order in which they were added. The default priority is 0.
		 * @param useWeakReference  <Boolean (default = false)> Determines whether the reference to the listener is strong or weak. A strong
		 *                            reference (the default) prevents your listener from being garbage-collected. A weak
		 *                            reference does not. Class-level member functions are not subject to garbage
		 *                            collection, so you can set useWeakReference to true for
		 *                            class-level member functions without subjecting them to garbage collection. If you set
		 *                            useWeakReference to true for a listener that is a nested inner
		 *                            function, the function will be garbge-collected and no longer persistent. If you create
		 *                            references to the inner function (save it in another variable) then it is not
		 *                            garbage-collected and stays persistent.
		 */
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		
		/**
		 * Dispatches an event into the event flow. The event target is the
		 *  EventDispatcher object upon which dispatchEvent() is called.
		 *
		 * @param event             <Event> The event object dispatched into the event flow.
		 * @return                  <Boolean> A value of true unless preventDefault() is called on the event,
		 *                            in which case it returns false.
		 */
		function dispatchEvent(event:Event):Boolean;
		
		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type
		 *  of event. This allows you to determine where an EventDispatcher object has altered handling of an event type in the event flow hierarchy. To determine whether
		 *  a specific event type will actually trigger an event listener, use IEventDispatcher.willTrigger().
		 *
		 * @param type              <String> The type of event.
		 * @return                  <Boolean> A value of true if a listener of the specified type is registered; false otherwise.
		 */
		function hasEventListener(type:String):Boolean;
		
		/**
		 * Removes a listener from the EventDispatcher object. If there is no matching listener
		 *  registered with the EventDispatcher object, a call to this method has no effect.
		 *
		 * @param type              <String> The type of event.
		 * @param listener          <Function> The listener object to remove.
		 * @param useCapture        <Boolean (default = false)> Specifies whether the listener was registered for the capture phase or the target and bubbling phases. If the listener was registered for both the capture phase and the target and bubbling phases, two calls to removeEventListener() are required to remove both: one call with useCapture set to true, and another call with useCapture set to false.
		 */
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
		
		/**
		 * Checks whether an event listener is registered with this EventDispatcher object or any of its ancestors for the specified event type. This method returns true if an event listener is triggered during any phase of the event flow when an event of the specified type is dispatched to this EventDispatcher object or any of its descendants.
		 *
		 * @param type              <String> The type of event.
		 * @return                  <Boolean> A value of true if a listener of the specified type will be triggered; false otherwise.
		 */
		function willTrigger(type:String):Boolean;
		
	}
	
}