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

	public function execute(status : TestStatus) {
		for (responder in responders) {
			responder.execute(status);
		}
	}

	public function start() {
		for (responder in responders) {
			responder.start();
		}
	}

	public function done() {
		for (responder in responders) {
			responder.done();
		}
	}
}