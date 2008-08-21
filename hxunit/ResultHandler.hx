package hxunit;

import haxe.Log;

class ResultHandler {

	var responders:Array<Responder>;
	var contents:Array<Result>;

	public function new() {
		contents = new Array();
		responders = new Array();
	}
	public function addResponder(value:Responder) {
		responders.push(value);
	}
	public function removeResponder(value:Responder) {
		responders.remove(value);
	}
	public function addResult(value:Result) {
		contents.push(value);
		send(value);
	}
	function send(value:Result) {
		for (responder in responders) {
			responder.execute(value);
		}
	}

}