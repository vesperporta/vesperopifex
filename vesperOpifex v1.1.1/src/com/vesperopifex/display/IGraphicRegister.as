package com.vesperopifex.display 
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Laurence Green
	 */
	public interface IGraphicRegister 
	{
		
		function get XML_IDENTIFIER():String;
		
		function generateGraphicObject(data:XML):DisplayObject;
		
	}
	
}