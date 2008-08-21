package hxunit;

class SimpleResponder implements Responder{
	public function new() {	}

	public function execute(value : Result) {
		trace(value);
	}

	public function done() {}
}