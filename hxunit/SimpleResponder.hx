package hxunit;

class SimpleResponder implements Responder{
	public function new() {	}

	public function execute(value : TestStatus) {
		trace(value);
	}

	public function done() {}
}