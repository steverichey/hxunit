package hxunit;

class CompositeResponder implements Responder {
	var responders : Array<Responder>;

	public function new() {
		responders = [];
	}

	public function addResponder(value : Responder) {
		responders.push(value);
	}

	public function removeResponder(value : Responder) {
		responders.remove(value);
	}

	public function execute(value : TestStatus) {
		for (responder in responders) {
			responder.execute(value);
		}
	}

	public function done() {
		for (responder in responders) {
			responder.done();
		}
	}
}