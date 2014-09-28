package test;

import hxunit.Assert;
import hxunit.AssertionResult;
import hxunit.Runner;

class AssertTest {
	var src : Runner;
	public function new() {
		src = null;
	}

	public function testIsTrue() {
		var tests    = [true, false];
		var expected = [true, false];

		swap();
		for(t in tests)
			Assert.isTrue(t);
		var results = getResults();
		restore();

		compareResults(expected, results);
	}

	public function testIsFalse() {
		var tests    = [true, false];
		var expected = [false, true];

		swap();
		for(t in tests)
			Assert.isFalse(t);
		var results = getResults();
		restore();

		compareResults(expected, results);
	}

	public function testIsNull() {
		var tests:Array<Dynamic>    = [null, "string", 0.1,   0,     0.0,   -1,    this ];
		var expected:Array<Bool>  = [true, false,    false, false, false, false, false];

		swap();
		for(t in tests)
			Assert.isNull(t);
		var results = getResults();
		restore();

		compareResults(expected, results);
	}

	public function testNotNull() {
		var tests:Array<Dynamic>    = [null,  "string", 0.1,  0,    0.0,  -1,   this];
		var expected = [false, true,     true, true, true, true, true];

		swap();
		for(t in tests)
			Assert.notNull(t);
		var results = getResults();
		restore();

		compareResults(expected, results);
	}

	public function testIs() {
		var tests:Array<Dynamic>    = ["string", 0.1,   1,    "string", 0.1,    0,    ];
		var params:Array<Dynamic>   = [String,   Float, Int,  Int,      String, String];
		var expected = [true,     true,  true, false,    false,  false ];

		swap();
		for(i in 0...tests.length)
			Assert.is(tests[i], params[i]);
		var results = getResults();
		restore();

		compareResults(expected, results);
	}

	public function testEquals() {
		var tests:Array<Dynamic>    = ["string", "a",   1,    1,     0.1,  0.1,   null, null,  1   ];
		var params:Array<Dynamic>   = ["string", "b",   1,    0,     0.1,  0.0,   null, 1,     1.0 ];
		var expected = [true,     false, true, false, true, false, true, false, true];

		swap();
		for(i in 0...tests.length)
			Assert.equals(tests[i], params[i]);
		var results = getResults();
		restore();

		compareResults(expected, results);
	}

	public function testFloatEquals() {
		var tests    = [1,    1,     0.1,  0.1,   1    ];
		var params   = [1,    0,     0.1,  0.0,   1.0  ];
		var expected = [true, false, true, false, true];

		swap();
		for(i in 0...tests.length)
			Assert.floatEquals(tests[i], params[i]);
		var results = getResults();
		restore();

		compareResults(expected, results);
	}

	public function testRaises() {
		var fs = function() throw "a";
		var fi = function() throw 1;
		var tests    = [fs,      fi,      fs,     fi,   fs,    fi];
		var params:Array<Dynamic>   = [Dynamic, Dynamic, String, Int,  Int,   String];
		var expected = [true,    true,    true,   true, false, false ];

		swap();
		for(i in 0...tests.length)
			Assert.raises(tests[i], params[i]);
		var results = getResults();
		restore();

		compareResults(expected, results);
	}

	public function testAsync() {

	}

	function compareResults(expected : Array<Bool>, results : Array<Bool>) {
		for(i in 0...results.length)
			Assert.equals(expected[i], results[i], "failure at index #" + i);
	}

	function swap() {
		src = Assert.runner;
		Assert.runner = new TestRunner();
	}

	function restore() {
		Assert.runner = src;
	}

	function getResults() {
		return cast(Assert.runner, TestRunner).asserts;
	}
}

private class TestRunner extends Runner {
	public var asserts : Array<Bool>;
	public function new() {
		super();
		asserts = [];
	}

	override function update(result : AssertionResult) {
		switch(result) {
			case Success(_) : asserts.push(true);
			default         : asserts.push(false);
		}
	}
}