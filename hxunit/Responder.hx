package hxunit;

interface Responder {
	function execute(status : TestStatus) : Void;
	function start() : Void;
	function done() : Void;
}