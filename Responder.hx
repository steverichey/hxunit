package hxunit.respond;

import hxunit.TestStatus;

interface Responder {
	function execute(status : TestStatus) : Void;
	function start() : Void;
	function done() : Void;
}