import haxe.Int64;

import bglib.utils.Graph;

import haxe.Int32;

using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Int, y:Int};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 08
private typedef Input = A<Vec3>;
private typedef E = {d:Int64, i:Int, j:Int};

class Day08 implements Day {
    var input:Input;
    var max = 999999999;

    public function new() {}

    public function part1() {
        var d2s:A<E> = [];
        for (i => v1 in input) {
            for (j in i + 1...input.length) {
                var v2 = input[j];
                var dx:Int64 = v1.x - v2.x;
                var dy:Int64 = v1.y - v2.y;
                var dz:Int64 = v1.z - v2.z;
                var d2:Int64 = dx * dx + dy * dy + dz * dz;
                d2s.push({d: d2, i: i, j: j});
            }
        }
        d2s.sort((v1, v2) -> Int64.ucompare(v1.d, v2.d));

        var circuits:AA<Int> = [];
        var cluq = [for (_ in 0...input.length) -1];

        for (i in 0...1000) {
            var e = d2s[i];

            if (cluq[e.i] == -1 && cluq[e.j] == -1) {
                circuits.push([e.i, e.j]);
                cluq[e.i] = circuits.length - 1;
                cluq[e.j] = circuits.length - 1;
            } else {
                if (cluq[e.i] == -1) {
                    cluq[e.i] = cluq[e.j];
                    circuits[cluq[e.j]].push(e.i);
                }
                if (cluq[e.j] == -1) {
                    cluq[e.j] = cluq[e.i];
                    circuits[cluq[e.i]].push(e.j);
                }
                if (cluq[e.i] != cluq[e.j]) {
                    circuits[cluq[e.i]].concatenated(circuits[cluq[e.j]]);
                    var i = cluq[e.j];
                    for (v in circuits[cluq[e.j]]) {
                        cluq[v] = cluq[e.i];
                    }
                    circuits[i] = [];
                }
            }
        }

        var ls = circuits.map(c -> c.length);
        ls.sort((a, b) -> b - a);
        return ls[0] * ls[1] * ls[2];
    }

    public function part2() {
        var d2s:A<E> = [];
        for (i => v1 in input) {
            for (j in i + 1...input.length) {
                var v2 = input[j];
                var dx:Int64 = v1.x - v2.x;
                var dy:Int64 = v1.y - v2.y;
                var dz:Int64 = v1.z - v2.z;
                var d2:Int64 = dx * dx + dy * dy + dz * dz;
                d2s.push({d: d2, i: i, j: j});
            }
        }
        d2s.sort((v1, v2) -> Int64.ucompare(v1.d, v2.d));

        var circuits:AA<Int> = [];
        var cluq = [for (_ in 0...input.length) -1];

        var end:E = null;
        for (i in 0...d2s.length) {
            var e = d2s[i];

            if (cluq[e.i] == -1 && cluq[e.j] == -1) {
                circuits.push([e.i, e.j]);
                cluq[e.i] = circuits.length - 1;
                cluq[e.j] = circuits.length - 1;
            } else {
                if (cluq[e.i] == -1) {
                    cluq[e.i] = cluq[e.j];
                    circuits[cluq[e.j]].push(e.i);
                }
                if (cluq[e.j] == -1) {
                    cluq[e.j] = cluq[e.i];
                    circuits[cluq[e.i]].push(e.j);
                }
                if (cluq[e.i] != cluq[e.j]) {
                    circuits[cluq[e.i]].concatenated(circuits[cluq[e.j]]);
                    var i = cluq[e.j];
                    for (v in circuits[cluq[e.j]]) {
                        cluq[v] = cluq[e.i];
                    }
                    circuits[i] = [];
                }
                if (circuits[cluq[e.i]].length == cluq.length) {
                    end = e;
                    break;
                }
            }
        }

        var x1:Int64 = input[end.i].x;
        var x2:Int64 = input[end.j].x;
        return x1 * x2;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent().split("\n");
        inp = inp.filter(v -> v.length != 0);

        input = inp.map((line) -> {
            var vs = line.split(",").map(Std.parseInt);
            return {x: vs[0], y: vs[1], z: vs[2]};
        });

        return this;
    }
}
