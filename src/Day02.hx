import haxe.Int64;

using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {s:String, e:String};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 02
private typedef Input = A<Vec>;

class Day02 implements Day {
    var input:Input;

    public function new() {}

    public function part1() {
        var total:Float = 0;
        for (id in input) {
            var smin = id.s.substr(0, id.s.length.div(2));
            if (id.s.length <= 1) {
                smin = id.s;
            }
            var smax = "";
            if (id.e.length % 2 == 1) {
                smax = "9".repeat(id.e.length.div(2) + 1);
            } else {
                var se_h0 = id.e.substr(0, id.e.length.div(2));
                var se_h1 = id.e.substr(id.e.length.div(2));
                if (Std.parseInt(se_h0) < Std.parseInt(se_h1)) {
                    smax = se_h1;
                } else {
                    smax = se_h0;
                }
            }

            var min = Std.parseInt(smin);
            var max = Std.parseInt(smax);

            var s = Std.parseFloat(id.s);
            var e = Std.parseFloat(id.e);
            for (x in min...max + 1) {
                var xx = pow(10, floor(log(x) / log(10) + 1)) * x + x;
                if (s <= xx && xx <= e) {
                    total += xx;
                }
            }
        }
        return total;
    }

    public function part2() {
        var total:Float = 0;
        for (id in input) {
            var s = Std.parseFloat(id.s);
            var e = Std.parseFloat(id.e);
            for (x in 0...floor(e - s) +1) {
                var x = x + s;
                var ds = floor(log(x) / log(10) + 1);
                if (ds % 2 != 0) continue;
                var h0 = floor(x / (pow(10, ds / 2)));
                var h1 = floor(x - (h0 * pow(10, ds / 2)));
                if (h0 == h1) total += x;
            }
        }
        return total;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent();

        var w = ~/\s/g;
        inp = w.replace(inp, "");
        input = inp.split(",").map(s -> {
            var r = s.split("-");
            return {
                s: r[0],
                e: r[1]
            }
        });

        return this;
    }
}
