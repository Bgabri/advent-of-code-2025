import haxe.Int64;

using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Int, y:Int};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 07
private typedef Input = AA<String>;

class Day07 implements Day {
    var input:Input;

    public function new() {}

    public function part1() {
        var total = 0;

        var prev = input.shift().map(c -> c == "S" ? "|" : ".");

        for (l in input) {
            for (i => c in l) {
                if (prev[i] != '|') continue;
                if (c == '.') l[i] = '|';
                if (c == '^') {
                    if (l[i - 1] == '.') l[i - 1] = '|';
                    if (l[i + 1] == '.') l[i + 1] = '|';
                    total++;
                }
            }
            prev = l;
        }

        return total;
    }

    public function part2() {
        var prev = input.shift().map(c -> Int64.ofInt(c == "S" ? 1 : 0));

        for (l in input) {
            var cw = l.map(_ -> Int64.ofInt(0));
            for (i => c in l) {
                if (prev[i] == 0) continue;
                if (c == '.') cw[i] += prev[i];
                if (c == '^') {
                    if (l[i - 1] == '.') cw[i - 1] += prev[i];
                    if (l[i + 1] == '.') cw[i + 1] += prev[i];
                }
            }
            prev = cw;
        }

        return prev.fold((i, r) -> i + r, 0);
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent();

        input = inp.split("\n").map(l -> l.split(""));
        input = input.filter(v -> v.length != 0);

        return this;
    }
}
