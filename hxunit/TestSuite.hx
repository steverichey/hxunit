﻿package hxunit;

typedef Case = {
	name    : String,
	content : TestContainer
}

class TestSuite {
	var tests       : Dynamic;
	var defaultCase : TestContainer;
	var cases       : Array<Case>;

	public var current(default, null) : Case;
	var index : Int;

	public var length(getLength, null):Int;

	public function getLength():Int {
		return cases.length;
	}

	public function new() {
		unspecifiedNameCount = 0;
		cases = [];
		index = 0;
	}

	public function addCase(value:Dynamic):Void {
		var cl = Type.getClass(value);
		var fields : Array<Dynamic> = Type.getInstanceFields(cl);

		var setup    : Void -> Void = null;
		var teardown : Void -> Void = null;
		//for flash9
		try {
			setup = Reflect.field(value, "setup");
		} catch (e:Dynamic){ }
		try {
			teardown = Reflect.field(value, "teardown");
		} catch (e:Dynamic) { }

		var tests = new TestContainer(value, setup , teardown);

		for ( val in fields ) {
			if ( StringTools.startsWith(val, "test") && Reflect.isFunction(Reflect.field(value, val) )) {
				var wrap = new TestWrapper(Reflect.field(value, val),null,val);
				tests.add( wrap );
			}
		}

		cases.push({
			name    : Type.getClassName(Type.getClass(value)),
			content : tests
		});
	}

	public function addTest(scope : Dynamic, method : Dynamic, ?testName : String, ?setup : Void->Void, ?teardown : Void->Void) {
		testName = testName == null ? getNextDefaultTestName() : testName;
		if (defaultCase == null) {
			defaultCase = new DefaultTestCase(null, setup, teardown);
			cases.push({
				name    : "DefaultTestCase",
				content : defaultCase
			});
		}
		defaultCase.add(new TestWrapper(scope, method , testName));
	}

	var unspecifiedNameCount:Int;
	function getNextDefaultTestName():String {
		unspecifiedNameCount++;
		return "test#" + unspecifiedNameCount;
	}

	public function step(){
		current = cases.pop();
		index++;
	}

	public function hasNext() {
		return (cases.length > 0);
	}
}