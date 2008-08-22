package hxunit;

interface Responder {
	function execute(value : TestStatus) : Void;
	function done() : Void;
}