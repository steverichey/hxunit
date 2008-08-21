package ;

import hxunit.Assert;
import hxunit.AssertionError;
import haxe.Timer;
import hxunit.Result;
import hxunit.Runner;
import hxunit.SimpleResponder;

import test.UnitTestTest;
import test.SyncUnitTestTests;

import haxe.Log;
class Test {

	public function new() {
#if php
		if(!php.Lib.isCli())
			php.Lib.print("<pre>");
#elseif neko
		if(neko.Web.isModNeko)
			neko.Lib.print("<pre>");
#end
		Log.trace("start");
		var r:Runner = Assert.runner;

		r.resultHandler.addResponder(new SimpleResponder());

		r.addCase( new UnitTestTest() );
		r.addCase( new SyncUnitTestTests() );
		//r.addCase( new RunnerTest() );

		r.run();
	}
	static var m:Test;

	static function main() {
		m = new Test();
	}
}