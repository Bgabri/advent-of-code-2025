using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Float, y:Float};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 09
private typedef Input = A<Vec>;

class Day09 implements Day {
    var input:Input;

    public function new() {}

    public function part1() {
        var max = 0.;
        for (i in 0...input.length) {
            var v1 = input[i];
            var v1 = input[i];
            for (j in i + 1...input.length) {
                var v2 = input[j];
                var a = abs(v1.x - v2.x + 1) * abs(v1.y - v2.y + 1);
                if (a > max) max = a;
            }
        }

        return max;
    }

    function pinside(c:Vec) {
        var out = true;
        var p2 = input[input.length - 1];
        for (p1 in input) {
            var ymin = min(p1.y, p2.y);
            var ymax = max(p1.y, p2.y);
            if (c.y.clamp(ymin, ymax) == c.y) {
                if (c.x == min(p1.x, p2.x)) return true;
                else if (c.x < min(p1.x, p2.x)) {
                    out = !out;
                }
            }
            p2 = p1;
        }
        return !out;
    }

    function eintersect(e1:Vec, e2:Vec) {
        for (i => p1 in input) {
            var p2 = input[(i + 1) % input.length];
            // check if there's a point in between e1 and ew
            var ev = {
                x: e2.x - e1.x,
                y: e2.y - e1.y
            };
            var ec = e1;

            var pv = {
                x: p2.x - p1.x,
                y: p2.y - p1.y
            };
            var pc = p1;

            /**
             * ev t + ec = pv t + pc
             * t = (pc - ec)/(ev-pv)
            **/

            var dc = {
                x: pc.x - ec.x,
                y: pc.y - ec.y
            };

            var dv = {
                x: ev.x - pv.x,
                y: ev.y - pv.y
            };
            if (dv.x == 0) {
                
            }
        }

        return false;
    }

    // 93358 to low
    // 4699609848

    function inside(c11:Vec, c22:Vec) {
        var c12 = {x: c11.x, y: c22.y};
        var c21 = {x: c22.x, y: c11.y};

        return
            pinside(c11) &&
            pinside(c12) &&
            pinside(c22) &&
            pinside(c21) &&

            !eintersect(c11, c12) &&
            !eintersect(c12, c22) &&
            !eintersect(c22, c21) &&
            !eintersect(c21, c11);
    }

    public function part2() {
        var p1:Vec = {x: 3, y: 3};
        var p2:Vec = {x: 3, y: 7};
        var e1:Vec = {x: 3, y: 0};
        var e2:Vec = {x: 3, y: 10};

        var ea = e1.y - e2.y;
        var eb = e2.x - e1.x;
        var ec = e1.x * e2.y - e2.x * e1.y;

        var pa = p1.y - p2.y;
        var pb = p2.x - p1.x;
        var pc = p1.x * p2.y - p2.x * p1.y;

        var x = (eb * pc - pb * ec);
        var y = (ec * pa - pc * ea);

        trace(x, y, (ea * pb - pa * eb));

        var max = 0.;
        // return max;

        for (i in 0...input.length) {
            var v1 = input[i];
            var v1 = input[i];
            for (j in i + 1...input.length) {
                var v2 = input[j];
                var a = abs(v1.x - v2.x + 1) * abs(v1.y - v2.y + 1);
                if (a > max && inside(v1, v2)) max = a;
            }
        }

        return max;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent().split("\n");
        inp = inp.filter(v -> v.length != 0);

        input = inp.map((line) -> {
            var vs = line.split(",").map(Std.parseFloat);
            return {x: vs[0], y: vs[1]};
        });

        return this;
    }
}
