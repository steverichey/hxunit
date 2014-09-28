package hxunit;

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

	public var length(get, null):Int;

	public function get_length():Int {
		return cases.length;
	}

	public function new() {
		unspecifiedNameCount = 0;
		cases = [];
		index = 0;
	}

	public function addCase(value : Dynamic):Void {
		var cl = Type.getClass(value);
		var fields : Array<Dynamic> = Type.getInstanceFields(cl);

		var setup    = Reflect.hasField(value, "setup")    && Reflect.isFunction(Reflect.field(value, "setup"))    ? "setup"    : null;
		var teardown = Reflect.hasField(value, "teardown") && Reflect.isFunction(Reflect.field(value, "teardown")) ? "teardown" : null;

		var tests = new TestContainer(value, setup, teardown);

		for ( val in fields ) {
			if ( StringTools.startsWith(val, "test") && Reflect.isFunction(Reflect.field(value, val) )) {
				var wrap = new TestWrapper(value, val, val, setup, teardown);
				tests.add( wrap );
			}
		}

		cases.push({
			name    : Type.getClassName(Type.getClass(value)),
			content : tests
		});
	}

	public function addTest(scope : Dynamic, method : String, ?testName : String, ?setup : String, ?teardown : String) {
		testName = testName == null ? getNextDefaultTestName() : testName;
		if (defaultCase == null) {
			//TODO what did I do here?
			//defaultCase = new TestCase(null, setup, teardown);
			cases.push({
				name    : "DefaultTestCase",
				content : defaultCase
			});
		}
		defaultCase.add(new TestWrapper(scope, method, testName, setup, teardown));
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