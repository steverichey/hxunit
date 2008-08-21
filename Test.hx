package ;

import haxe.xunit.Assert;
import haxe.xunit.AssertionError;
import haxe.Timer;
import haxe.xunit.Result;
import haxe.xunit.Runner;
import haxe.xunit.SimpleResponder;

import test.UnitTestTest;
import test.SyncUnitTestTests;

import haxe.Log;
class Test
{

	

	public function new() {
		Log.trace("start");
		var r:Runner = Runner.getInstance();
		
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