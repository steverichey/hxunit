package hxunit;

import hxunit.AssertionResult;
import hxunit.respond.StandardResponder;
import hxunit.respond.Responder;
import haxe.Timer;

class Runner {
	
	/*
		Constructor
	*/
	public function new() {
		suites = [];
		this.responder = new StandardResponder();
	}
	
	/*
		Public Variables
	*/
	public var status(default, null) : TestStatus;
	public var suites(default, null) : Array<TestSuite>;
	public var responder : Responder;
	
	/*
		Private Variables
	*/
	var defaultTestSuite : TestSuite;
	var method : TestWrapper;
	var testIterator : Iterator<TestWrapper>;
	var suite : TestSuite;
	var suiteIterator : Iterator<TestSuite>;
	var timer : Timer;
	
	
	/*
		Methods
	*/
	public function addTest(scope : Dynamic, method : String, ?name : String) {
		if (defaultTestSuite == null) {
			defaultTestSuite = new TestSuite();
			suites.push(defaultTestSuite);
		}
		defaultTestSuite.addTest(scope, method, name);
	}

	public function addCase(value : Dynamic) {
		if (defaultTestSuite == null) {
			defaultTestSuite = new TestSuite();
			suites.push(defaultTestSuite);
		}
		//fails
		defaultTestSuite.addCase(value);
	}

	public function addSuite(suite : TestSuite) {
		suites.push(suite);
	}



	public function update(result : AssertionResult) {
		status.addResult(result);
	}


	public function run() {
		isRunning = true;
		//TODO implement dynamic testing;
		if (suites.length == 0) {
			throw "No tests found";
		} else {
			responder.start();
			Assert.runner = this;
			suiteIterator = suites.iterator();
			suite = suiteIterator.next();
			runSuite();
		}
	}

	function onRunnerEnd() {
		isRunning = false;
		responder.done();
		Assert.runner = null;
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
		method = testIterator.next();
		runTest();
	}

	function onCaseEnd() {
		if (suite.hasNext()) {
			suite.step();
			runCase();
		} else {
			onSuiteEnd();
		}
	}

	function runTest() {
		status = new TestStatus();
		status.suiteName  = Type.getClassName(Type.getClass(suite));
		status.className  = Type.getClassName(Type.getClass(suite.current.content.scope));
		status.methodName = method.name;
		
		var te = null;

		var setupok = true;
		try {
			if(method.setup != null) Reflect.callMethod(method.scope, Reflect.field(method.scope, method.setup), []);
		} catch(e : Dynamic) {
			setupok = false;
			te = Error({
				message : "setup error",
				error   : e
			});
		}

		var methodok = true;
		
		if(setupok) {
			try {
				Reflect.callMethod(method.scope, Reflect.field(method.scope, method.test), []);
			} catch (e : Dynamic) {
				te = Error(e);
				methodok = false;
			}
			status.called = true;
		}
		
		if (!status.isAsync && methodok == true){
			try {
				if(method.teardown != null) Reflect.callMethod(method.scope, Reflect.field(method.scope, method.teardown), []);
			} catch (e : Dynamic) {
				update(Error(e));
			}
		}
		
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
		}else {
			try {
				if (method.teardown != null) Reflect.callMethod(method.scope, Reflect.field(method.scope, method.teardown), []);
			} catch (e : Dynamic) {
				update(Error("teardown error"));
			}
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
			method = testIterator.next();
			runTest();
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