package hxunit;

import hxunit.DefaultTestCase;
import hxunit.AssertionResult;
import hxunit.DefaultTestSuite;
import haxe.Timer;

class Runner {
	var defaultTestSuite : DefaultTestSuite;
	public var suites(default, null) : Array<TestSuite>;
	public var responder : Responder;
	public var timer : Timer;

	static var instance : Runner;

	public function new() {
		suites = [];
		this.responder = new SimpleResponder();
	}

	public function addTest(scope : Dynamic, method : Void->Void, ?name : String) {
		if (defaultTestSuite == null) {
			defaultTestSuite = new DefaultTestSuite();
			suites.push(defaultTestSuite);
		}
		defaultTestSuite.addTest(scope,method,name);
	}

	public function addCase(value : Dynamic) {

		if (defaultTestSuite == null) {
			defaultTestSuite = new DefaultTestSuite();
			suites.push(defaultTestSuite);
		}
		//fails
		defaultTestSuite.addCase(value);
	}

	public function addSuite(suite : TestSuite) {
		suites.push(suite);
	}

	var tests    : Array<Void->Void> ;
	var setup    : Void->Void;
	var teardown : Void->Void;

	var testIterator : Iterator<TestWrapper>;

	var suite : TestSuite;
	var suiteIterator : Iterator<TestSuite>;

	public var status(default, null) : TestStatus;

	public function update(result : AssertionResult) {
		status.addResult(result);
	}


	public function run(?value : Dynamic) {
		isRunning = true;
		//TODO implement dynamic testing;
		if (suites.length == 0) {
			throw "No tests found";
		} else {
			suiteIterator = suites.iterator();
			suite = suiteIterator.next();
			runSuite();
		}
	}

	function onRunnerEnd() {
		isRunning = false;

	}

	function runSuite() {
		if (suite.hasNext()) {
			suite.step();
			runCase();
		} else {
			onSuiteEnd();
		}
	}

	function onSuiteEnd() {
		if (suiteIterator.hasNext()) {
			suite = suiteIterator.next();
			runSuite();
		} else {
			onRunnerEnd();
		}
	}

	function runCase() {
		testIterator = suite.current.content.iterator();
		runTest(testIterator.next());
	}

	function onCaseEnd() {
		if (suite.hasNext()) {
			suite.step();
			runCase();
		} else {
			onSuiteEnd();
		}
	}

	function runTest(method:TestWrapper) {
		status = new TestStatus();
		status.suiteName  = Type.getClassName(Type.getClass(suite));
		status.classname  = Type.getClassName(Type.getClass(suite.current.content.scope));
		status.methodName = method.name;

		//TODO setup;

		var te = null;

		try {
			if (Std.is(method.test, String)) {
				Reflect.field(suite.current.content.scope, method.test)();
			} else {
				Reflect.callMethod(suite.current.content.scope, method.test, []);
			}
		} catch (e : Dynamic) {
			var msg = "";
			if (Reflect.field(e,"message") != null) {
				msg = e.message;
			} else if (Std.is(e, String)) {
				msg = e;
			}
			te = Error(e);
		}
		status.called = true;
		if (!status.isAsync){
			respond(te);
		} else if (status.done == false){
			setTimeoutHandler(status.time);
		} else {
			respond(te);
		}
	}

	public function respond(?e:Dynamic) {
		if (e != null) {
			update(e);
		}

		if (!status.isAsync) {
			status.done = true;
		}

		if (!status.hasAssertation) {
			update(Warning("Test does not make assertion"));
		}

		if (status.done) {
			onTestEnd();
		}
	}

	public function onTestEnd() {
		#if (neko || php)
		#else
		if (timer != null) timer.stop();
		#end

		responder.execute(status);

		if (testIterator.hasNext()) {
			runTest(testIterator.next());
		} else {
			onCaseEnd();
		}

	}

	public var timeoutTime : Int;
	function setTimeoutHandler(timeout : Int) {
		#if (neko || php)
		#else
		timer = new Timer(timeout);
		timer.run = onTimeout;
		#end
	}

	function onTimeout():Void {
		status.done = true;
		update(Failure("Test timed out", null));
		respond();
	}

	public var isRunning(default, null):Bool;
}