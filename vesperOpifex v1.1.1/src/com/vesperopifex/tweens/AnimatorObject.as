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
	
	public class AnimatorObject extends Object 
	{
		private var _name:String		= null;
		private var _animator:IAnimator	= null;
		
		/**
		 * name :: the QName of teh XML node to identify a set of XML nodes with the animator.
		 * [read]
		 * @return	<String>	the QName of the required XML nodes in a String format.
		 */
		public function get name():String { return _name; }
		
		/**
		 * animator :: the animation class to be passed the animation information.
		 * [read]
		 * @return	<IAnimator>	the animator to pass the data to to generate the available tweening animation.
		 */
		public function get animator():IAnimator { return _animator; }
		
		/**
		 * AnimatorObject :: Constructor, a container to hold the information regarding the various animators available.
		 * @param	name	<String>	the QName of the XML node to identify with the IAnimator.
		 * @param	animator	<IAnimator>	an interface to allow generic functionality to call various animation methods on particular classes.
		 */
		public function AnimatorObject(name:String, animator:IAnimator) 
		{
			_name		= name;
			_animator	= animator;
		}
		
	}
	
}