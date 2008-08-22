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
import haxe.PosInfos;
import hxunit.AssertionResult;

class TestStatus {
	public var isAsync : Bool;
	public var called  : Bool;

	public var hasAssertation(default, null) : Bool;
	public var time : Int;
	public var done : Bool;

	public var success(isSuccess, null):Bool;
	function isSuccess() {
		for(result in results) {
			switch(result) {
				case Success(_): continue;
				default : return false;
			}
		}
		return true;
	}

	var results : Array<AssertionResult>;
	public function addResult(result : AssertionResult) {
		results.push(result);
		hasAssertation = true;
	}

	public var suiteName  : String;
	public var classname  : String;
	public var methodName : String;

	public function new() {
		results = [];
		done    = false;
		called  = false;
	}

	public function toString():String {
		var out = "";
		for(result in results) {
			switch(result) {
				case Failure(_, _) : out += 'F';
				case Error(_)      : out += 'E';
				case Warning(_)    : out += 'W';
				case Success(_)    : out += 'S';
			}
		}
		return out + " [" + suiteName + "::" + classname + "::" + methodName + "]" + (hasAssertation ? " assertions " + results.length : "" ) + ( isAsync ? " async" : "" ) + ( done ? " DONE" : " PENDING" );
	}
}
