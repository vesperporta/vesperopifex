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
package com.vesperopifex.utils 
{
	
	public class StringValidation extends Object 
	{
		
		public function StringValidation() 
		{
			
		}
		
		/**
		 * validateEmail :: pass an email address to validate if the given String is a well formed email address.
		 * @param	value	<String>	the String object to pass the regular expression upon.
		 * @return	<Boolean>	if the String is found to contain the regular expression then true otherwise false.
		 */
		public static function validateEmail(value:String):Boolean 
		{
			var expression:RegExp = /^((\"[^\"\f\n\r\t\v\b]+\")|([\w\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}]+(\.[\w\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}]+)*))@((\[(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))\])|(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))|((([A-Za-z0-9\-])+\.)+[A-Za-z\-]+))$/;
			return expression.test(value);
		}
		
		/**
		 * validateURL :: pass a String object to test it and validate with a Boolean value, true is returned if correct otherwise false.
		 * @param	value	<String>	the given String object to test the regular expression against.
		 * @return	<Boolean>	if the given String is a valide URL then true is returned, false if not valide.
		 */
		public static function validateURL(value:String):Boolean 
		{
			var expression:RegExp = /((ht|f)tp(s?)\:\/\/|~\/|\/)?([-\w\.]+)+(:\d+)?(:\w+)?(@\d+)?(@\w+)?([-\w\.]+)(\/([\w\/_\.]*(\?\S+)?)?)?/;
			return expression.test(value);
		}
		
		public static function validateDate(value:String):Boolean 
		{
			var expression:RegExp = /^((((0?[1-9]|[12]\d|3[01])[\.\-\/](0?[13578]|1[02])[\.\-\/]((1[6-9]|[2-9]\d)?\d{2}))|((0?[1-9]|[12]\d|30)[\.\-\/](0?[13456789]|1[012])[\.\-\/]((1[6-9]|[2-9]\d)?\d{2}))|((0?[1-9]|1\d|2[0-8])[\.\-\/]0?2[\.\-\/]((1[6-9]|[2-9]\d)?\d{2}))|(29[\.\-\/]0?2[\.\-\/]((1[6-9]|[2-9]\d)?(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)|00)))|(((0[1-9]|[12]\d|3[01])(0[13578]|1[02])((1[6-9]|[2-9]\d)?\d{2}))|((0[1-9]|[12]\d|30)(0[13456789]|1[012])((1[6-9]|[2-9]\d)?\d{2}))|((0[1-9]|1\d|2[0-8])02((1[6-9]|[2-9]\d)?\d{2}))|(2902((1[6-9]|[2-9]\d)?(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)|00))))$/;
			return expression.test(value);
		}
		
		/**
		 * validatePhoneNumber :: validates a UK phone numbers
		 * @param	value	<String>	the given String object to test the regular expression against.
		 * @return	<Boolean>	if the given String is a valide number then true is returned, false if not valide.
		 */
		public static function validatePhoneNumber(value:String):Boolean 
		{
			var expression:RegExp = /^(\+44\s?7\d{3}|\(?07\d{3}\)?)\s?\d{3}\s?\d{3}$/;
			return expression.test(value);
		}
		
	}
	
}