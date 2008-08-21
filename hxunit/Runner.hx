package hxunit;

import hxunit.DefaultTestCase;
import hxunit.AssertionError;
import hxunit.DefaultTestSuite;
import haxe.Timer;

class Runner {

	public var suites(default, null):Array<TestSuite>;
	var defaultTestSuite:DefaultTestSuite;
	public var resultHandler(default, null):ResultHandler;
	public var timer:Timer;

	static var instance:Runner;

	public function new() {
		suites = new Array();

		resultHandler = new ResultHandler();
	}

	public function addTest(scope:Dynamic,method:Void -> Void,?name:String):Void {
		if (defaultTestSuite == null) {
			defaultTestSuite = new DefaultTestSuite();
			suites.push(defaultTestSuite);
		}
		defaultTestSuite.addTest(scope,method,name);
	}

	public function addCase(value:Dynamic):Void {

		if (defaultTestSuite == null) {
			defaultTestSuite = new DefaultTestSuite();
			suites.push(defaultTestSuite);
		}
		//fails
		defaultTestSuite.addCase(value);
	}

	public function addSuite(value:TestSuite):Void {
		suites.push(value);
	}

	var tests:Array < Void -> Void > ;
	var setup:Void -> Void;
	var teardown:Void -> Void;

	var testIterator:Iterator<TestWrapper>;

	var suite:TestSuite;
	var suiteIterator:Iterator<TestSuite>;

	public var status(default,null):TestStatus;

	public function update(value:AssertionError) {
		var e = new TestError();

		e.error = value;
		e.message = value.message;

		status.addError(e);
	}


	public function run(?value:Dynamic):Void {
		isRunning = true;
		//TODO implement dynamic testing;
		if (suites.length == 0) {
			throw "No tests found";
		}else {
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
		}else {
			onSuiteEnd();
		}
	}

	function onSuiteEnd() {
		if (suiteIterator.hasNext()) {
			suite = suiteIterator.next();
			runSuite();
		}else {
			onRunnerEnd();
		}
	}

	function runCase() {
		var cl = Type.getClass(suite.current.content);
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
		status.suiteName = Type.getClassName(Type.getClass(suite));
		status.classname = Type.getClassName(Type.getClass(suite.current.content.scope));
		status.methodName = method.name;

		//TODO setup;

		var te = null;

		try {
			if (Std.is(method.test, String)) {
				Reflect.field(suite.current.content.scope, method.test)();
			} else {
				Reflect.callMethod(suite.current.content.scope, method.test,new Array());
			}

		} catch (e:Dynamic) {
			var msg = "";
			if (Reflect.field(e,"message") != null) {
				msg = e.message;
			} else if (Std.is(e, String)) {
				msg = e;
			}

			te = new AssertionError(Cause.error,e);

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
			update(new AssertionError(Cause.warning, "Test does not make assertion"));
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

		resultHandler.addResult(status.result);

		if (testIterator.hasNext()) {
			runTest(testIterator.next());
		} else {
			onCaseEnd();
		}

	}

	public var timeoutTime:Int;
	function setTimeoutHandler(timeout:Int) {
		#if (neko || php) error;
		#else
		var thiz = this;
		timer = new Timer(timeout);
		timer.run = onTimeout;
		#end
	}

	function onTimeout():Void {
		status.done = true;
		update( new AssertionError(Cause.failure, "Test timed out") );
		respond();
	}

	public var isRunning(default, null):Bool;
}