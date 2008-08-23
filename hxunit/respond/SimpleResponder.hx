package hxunit.respond;

import hxunit.TestStatus;

class SimpleResponder implements Responder{
	public function new() {	}

	public function execute(status : TestStatus) {
		trace(status);
	}

	public function start() {}
	public function done() {}
}