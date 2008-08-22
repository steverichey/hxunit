﻿import hxunit.Assert;

import test.UnitTestTest;
import test.SyncUnitTestTests;

class Test {
	static function main() {
#if php
		if(!php.Lib.isCli())
			php.Lib.print("<pre>");
#elseif neko
		if(neko.Web.isModNeko)
			neko.Lib.print("<pre>");
#end
		var r = Assert.runner;

		r.addCase( new UnitTestTest() );
		r.addCase( new SyncUnitTestTests() );
		//r.addCase( new RunnerTest() );

		r.run();
	}
}