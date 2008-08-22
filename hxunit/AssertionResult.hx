package hxunit;

import haxe.PosInfos;

enum AssertionResult {
	Success(pos : PosInfos);
	Failure(msg : String, pos : PosInfos);
	Error  (e : Dynamic);
	Warning(msg : String);
}