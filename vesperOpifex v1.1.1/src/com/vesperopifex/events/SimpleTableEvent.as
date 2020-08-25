package com.vesperopifex.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SimpleTableEvent extends Event 
	{
		public static const TABLE_UPDATE:String	= "table_update";
		public static const CELL_UPDATE:String	= "cell_update";
		
		public function SimpleTableEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event 
		{
			return new SimpleTableEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String 
		{
			return formatToString("SimpleTableEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}