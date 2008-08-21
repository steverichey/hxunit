/**
* ...
* @author $(DefaultUser)
*/

package haxe.xunit;

import haxe.PosInfos;
import haxe.xunit.AssertionError;

class TestError {

	public var error:Dynamic;
	public var stack:String;
	public var message:String;
	public var posInfos:PosInfos;
	
	public var level(getLevel,null):Int;
	
	function getLevel() {
		if (Std.is(error, AssertionError)) {
			switch (error.cause) {
				case Cause.warning:
					return WARNING;
				case Cause.error:
					return ERROR;
				case Cause.failure:
					return FAILURE;
			}
		}
		return ERROR;
	}
	public static var WARNING:Int = 0;
	public static var ERROR:Int = 1;
	public static var FAILURE:Int = 2;
	
	public function new() {
		
	}
	
	public function toString() {
		var buf = "";
		switch(getLevel()) {
			case WARNING:
			buf += "W";
			case ERROR:
			buf += "E";
			case FAILURE:
			buf += "F";
		}
		//	buf += ": " + message.toString();
		return buf;
	}
	
}