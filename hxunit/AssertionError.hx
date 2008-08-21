package hxunit;

import haxe.PosInfos;

enum Cause {
	warning;
	error;
	failure;
}

class AssertionError {

	public var cause:Cause;
	public var posInfos:PosInfos;
	public var message:String;

	public function new(cause:Cause,msg:String,?p:PosInfos) {
		this.cause = cause;
		this.message = msg;
		this.posInfos = p;
	}

}