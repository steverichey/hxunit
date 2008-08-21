package hxunit;

import haxe.PosInfos;
import hxunit.AssertionError;

class TestError {
	public var error:Dynamic;
	public var stack:String;
	public var message:String;
	public var posInfos:PosInfos;

	public var level(getLevel,null):Int;

	function getLevel() {
		if (Std.is(error, AssertionError)) {
			switch (error.cause) {
				case Cause.Warning:
					return WARNING;
				case Cause.Error:
					return ERROR;
				case Cause.Failure:
					return FAILURE;
			}
		}
		return ERROR;
	}
	public static inline var WARNING : Int = 0;
	public static inline var ERROR   : Int = 1;
	public static inline var FAILURE : Int = 2;

	public function new() {	}

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