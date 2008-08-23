import hxunit.respond.SimpleResponder;
import hxunit.Runner;
import test.FrameworkSuite;

import test.UnitTestTest;
import test.SyncUnitTestTests;
import test.AssertTest;

class Test {
	static function main() {
#if php
		if(!php.Lib.isCli())
			php.Lib.print("<pre>");
#elseif neko
		if(neko.Web.isModNeko)
			neko.Lib.print("<pre>");
#end
		var r = new Runner();

		r.addCase( new UnitTestTest() );
		//r.addCase( new SyncUnitTestTests() );
		r.addCase( new AssertTest() );
		//r.addSuite( new FrameworkSuite());
		
		//r.responder = new SimpleResponder();
		r.run();
	}
}