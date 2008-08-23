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

		for(i in 0...results.length)
			Assert.equals(expected[i], results[i]);
	}

	public function testIsFalse() {
		var tests    = [true, false];
		var expected = [false, true];

		swap();
		for(t in tests)
			Assert.isFalse(t);
		var results = getResults();
		restore();

		for(i in 0...results.length)
			Assert.equals(expected[i], results[i]);
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