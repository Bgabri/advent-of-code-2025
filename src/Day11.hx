import haxe.Int64;

using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Int, y:Int};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 11
private typedef Input = Map<String, A<String>>;

class Day11 implements Day {
    var input:Input;

    public function new() {}

    public function part1():Int {
        var queue = ["you"];
        var steps:Map<String, Int> = [];
        steps["you"] = 1;
        input["out"] = [];

        // this technically only works for topo sorted graphs
        while (!queue.empty()) {
            var c = queue.shift();
            var s = steps[c];
            for (n in input[c]) {
                if (!steps.exists(n)) {
                    steps[n] = 0;
                    queue.push(n);
                }
                steps[n] += s;
            }
        }

        return steps["out"];
    }

    function traverse(c:String, end:String, v:Map<String, Int64>):Int64 {
        if (c == end) return 1;
        if (v.exists(c)) return v[c];
        
        var t:Int64 = 0;
        for (n in input[c]) {
            t += traverse(n, end, v);
        }
        v[c] = t;
        return t;
    }

    public function part2() {
        input["out"] = [];
        var s_f = traverse("svr", "fft", []);
        var s_d = traverse("svr", "dac", []);

        var d_f = traverse("dac", "fft", []);
        var f_d = traverse("fft", "dac", []);

        var d_o = traverse("dac", "out", []);
        var f_o = traverse("fft", "out", []);

        return s_f * f_d * d_o + s_d * d_f * f_o;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent().split("\n");
        inp = inp.filter(v -> v.length != 0);

        input = [];
        for (line in inp) {
            var vs = line.split(" ");
            var k = vs.shift().substr(0, 3);
            input[k] = vs;
        }

        return this;
    }
}
