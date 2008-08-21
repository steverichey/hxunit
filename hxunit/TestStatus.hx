/*
 * Copyright (c) 2005, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package hxunit;

import haxe.Stack;
import hxunit.Result;
import haxe.PosInfos;

class TestStatus {
	public var isAsync : Bool;
	public var called  : Bool;

	public var hasAssertation : Bool;
	public var time : Int;
	public var done : Bool;

	public var success(isSuccess, null):Bool;
	function isSuccess() {
		return (errors.length == 0);
	}

	var errors : Array<TestError>;
	public function addError(value:TestError) {
		errors.push(value);
	}

	public var suiteName  : String;
	public var classname  : String;
	public var methodName : String;

	public function new() {
		errors = new Array();
		done   = false;
		called = false;
	}

	public var result(getResult, null):Result;
	function getResult():Result {
		if (!done) throw "test incomplete";
		var result = new Result();
		result.suiteName  = suiteName;
		result.className  = classname;
		result.methodName = methodName;

		var mostSeriousError : TestError = null;

		if (success) {
			result.status = Status.Success;
		} else {
			if (errors != null){
				for (e in errors) {
					if ( mostSeriousError == null || e.level > mostSeriousError.level) {
						mostSeriousError = e;
					}
					result.addError(e);
				}
				switch(mostSeriousError.level) {
					case TestError.WARNING:
					result.status = Status.Warning;
					case TestError.ERROR:
					result.status = Status.Error;
					case TestError.FAILURE:
					result.status = Status.Failure;
				}
			}
		}
		return result;
	}

	public function toString():String {
		return " [" + suiteName + "::" + classname + "::" + methodName + "] " + ( hasAssertation == true ? "asserts" : "" ) + " " + ( isAsync ? "async" : "" ) + " " + ( done ? success ? "OK" : "FAIL" : "PENDING" ) + " " + errors;
	}
}
