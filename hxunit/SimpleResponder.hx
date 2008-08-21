package hxunit;

class SimpleResponder implements Responder{
	public function new() {	}

	public function execute(value:Result):Void {
		trace(value);
	}
}