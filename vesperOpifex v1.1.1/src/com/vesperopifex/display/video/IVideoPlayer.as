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
package com.vesperopifex.display.video 
{
	import flash.media.SoundTransform;
	
	public interface IVideoPlayer 
	{
		
		function get bufferLength():Number;
		
		function get bufferTime():Number;
		function set bufferTime(value:Number):void;
		
		function get bytesLoaded():uint;
		
		function get bytesTotal():uint;
		
		function get checkPolicyFile():Boolean;
		
		function set checkPolicyFile(value:Boolean):void;
		
		function get client():Object;
		function set client(value:Object):void;
		
		function get currentFPS():Number;
		
		function get liveDelay():Number;
		
		function get objectEncoding():uint;
		
		function get soundTransform():SoundTransform;
		function set soundTransform(value:SoundTransform):void;
		
		function get time():Number;
		
		function connect(command:String = null, ... arguments):void;
		
		function addHeader(operation:String, mustUnderstand:Boolean = false, param:Object = null):void;
		
		function close():void;
		
		function play(name:Object, start:Number = -2, len:Number = -1, reset:Object = true):void;
		
		function receiveAudio(value:Boolean):void;
		
		function receiveVideo(value:Boolean):void;
		
		function receiveVideoFPS(value:Number):void;
		
	}
	
}