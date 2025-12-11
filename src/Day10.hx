using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Int, y:Int};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef Machine = {l:String, b:Array<Array<Int>>, j:Array<Int>};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 10
private typedef Input = AA<Int>;
private typedef Node = {w:Int, v:Bool};

class Day10 implements Day {
    var input:A<Machine>;

    public function new() {}

    function config(start:Int, goal:Int, buttons:A<Int>) {
        var map:Map<Int, Node> = [];

        map[start] = {w: 0, v: false};

        while (true) {
            var min:Int = -1;
            for (k => n in map) {
                if (n.v) continue;
                if (min == -1) min = k;
                if (n.w < map[min].w) min = k;
            }

            if (min == -1) throw "goal not found";
            if (min == goal) return map[min].w;

            map[min].v = true;
            var mask = min;

            for (b in buttons) {
                var next = mask ^ b;
                var weight = map[min].w + 1;
                if (map.exists(next)) {
                    if (weight < map[next].w) map[next].w = weight;
                } else {
                    map[next] = {
                        w: weight,
                        v: false
                    }
                }
            }
        }

        return map[goal].w;
    }

    public function part1() {
        var total = 0;

        for (m in input) {
            var mask = 0;
            for (i => v in m.l) {
                if (v != "#".code) continue;
                mask |= 1 << i;
            }
            var buttons:A<Int> = [];
            for (b in m.b) {
                var bmask = 0;
                for (v in b) {
                    bmask |= 1 << v;
                }
                buttons.push(bmask);
            }
            total += config(0, mask, buttons);
        }

        return total;
    }

    function key(v:A<Int>) {
        var k = 0;
        for (i => n in v) {
            k += k * (i + 123) * 123 + (n + 1) * 222;
        }
        return k;
    }

    function config2(start:A<Int>, goal:A<Int>, buttons:AA<Int>) {
        var map:Map<Int, {w:Int, v:Bool, k:A<Int>}> = [];

        map[key(start)] = {w: 0, v: false, k: start};

        var goalKey = key(goal);

        while (true) {
            var min:Int = -1;
            for (k => n in map) {
                if (n.v) continue;
                if (min == -1) min = k;
                if (n.w < map[min].w) min = k;
            }

            if (min == -1) throw "goal not found";
            if (min == goalKey) return map[min].w;

            map[min].v = true;
            var mask = map[min].k;

            for (b in buttons) {
                var next = mask.copy();
                for (i in b)
                    next[i]++;
                var next_key = key(next);
                var weight = map[min].w + 1;
                if (map.exists(next_key)) {
                    if (weight < map[next_key].w) {
                        map[next_key].w = weight;
                        map[next_key].k = next;
                    }
                } else {
                    map[next_key] = {
                        w: weight,
                        v: false,
                        k: next
                    }
                }
            }
        }

        return map[key(goal)].w;
        return 0;
    }

    public function part2() {
        var total = 0;

        for (i => m in input) {
            var start = m.j.map(_ -> 0);
            var n = config2(start, m.j, m.b);
            total += n;
            trace(i, n);
        }

        return total;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent().split("\n");
        inp = inp.filter(v -> v.length != 0);

        var reg = ~/\[(.*)\]\s(\(.*\))\s\{(.*)\}/;
        input = inp.map(l -> {
            reg.match(l);

            return {
                l: reg.matched(1),
                b: reg.matched(2)
                    .split(" ")
                    .map(
                        v -> v.substr(1, v.length - 2)
                            .split(",")
                            .map(Std.parseInt)),
                j: reg.matched(3)
                    .split(",")
                    .map(Std.parseInt)};
        });
        return this;
    }
}
