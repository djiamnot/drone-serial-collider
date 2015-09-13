(
SynthDef(\harpsi, { |outbus = 0, freq = 440, amp = 0.1, gate = 1|
    var out;
    out = EnvGen.ar(Env.adsr, gate, doneAction: 2) * (amp*0.7) *
    Pulse.ar(freq, 0.25, 0.75);
    Out.ar(outbus, out ! 2);
}).add;    // see below for more on .add
)

(


)


(
a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
r = [0.2, 0.25, 1.0, 0.333, 0.3, 0.666, 0.75];
o = [48, 60, 72];
Pbind(
    TempoClock.default.tempo = 0.5;
    \instrument, \harpsi,
   \scale, Scale.choose(12, 12).tuning_(Tuning.choose(12)).postln,
    \degree, Prand(
        [ //P, R, I, IR
            Pseq(a),
            Pseq(a.reverse),
            Pseq(12 - a),
            Pseq((12 - a).reverse)
    ], inf),
    \dur, Pseq([Prand([0.25, 0.25, 0.5, 1.0], 7),
        Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
    \amp, Prand([
        Pseries(0.1, 0.1, 5), // cresc
        Pseries(0.9, -0.1, 6), // decresc
        Prand([0.1, 0.3, 0.5, 0.7], 5)
    ], inf)
).play;
)

Tuning.directory
(

~tet = Scale.new(
    #[0, 1, 3, 5, 7, 8, 10],
    12,
    Tuning.new([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]),
    "12tet"
);

~pyto = Scale.new(
    #[0, 1, 3, 5, 7, 8, 10],
    12,
    Tuning.pythagorean,
    "pyto"
);

~just = Scale.new(
    #[0, 1, 3, 5, 7, 8, 10],
    12,
    Tuning.just,
    "just"
);
)
(
a = [0, 1, 2, 11, 10, 9, 5, 4, 3, 6, 7, 8];
r = [0.2, 0.25, 1.0, 0.333, 0.3, 0.666, 0.75];
o = [48, 60, 72];

Pbind(
    TempoClock.default.tempo = 1;
    \instrument, \sins,
    \scale, Scale.choose(12, 12).tuning_(Tuning.choose(12)).postln,
    \degree, Pseq(a, 1),
    \dur, Pseq(r, inf),
    \amp, Prand([
        Pseries(0.1, 0.1, 5), // cresc
        Pseries(0.9, -0.1, 6), // decresc
        Prand([0.1, 0.3, 0.5, 0.7], 5)
    ], inf)
).play;
)



p= Pseq(a).asStream
p.next(())



g = Tuning.choose(12);
g.asString.split($.)[1]
g = Tuning.young
g.size
g.ratios



(
SynthDef("Sin", {
arg freq = 400, amp = 0.5, gate = 1, att = 0.01, sus = 0.5, rel = 0.5;
var snd, env;
env = Env.linen(att, sus, rel, amp).kr(doneAction: 2);
snd = SinOsc.ar(freq: freq, mul: env) ! 2;
Out.ar(0, snd);
}).add;
)

Synth(\Sin);