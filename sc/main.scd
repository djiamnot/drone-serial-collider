Server.supernova;
o = Server.local.options;
o.numOutputBusChannels = 2;
//o.memSize = 2**20;
o.blockSize = 1024;
s.reboot;
s.makeGui;
s.meter;


// instrument 1
(
SynthDef(\sins, {
    | freq = 200, dur = 22, amp = 0.75|
    var bnq = Array.with(
        1-SinOsc.ar(freq, mul: 0.7),
        1-SinOsc.ar((freq * 4) * 1.0533610359546 * (SinOsc.kr(0.01, mul: 0.01)+ 1), mul: 0.6),
        1-SinOsc.ar((freq * 5)  * 1.2541124095491 * (SinOsc.kr(0.01, mul:  0.01) + 1), mul: 0.5),
        1-SinOsc.ar((freq * 6) * 1.8768759933376 *(SinOsc.kr(0.01)-1), mul: 0.02);
    );
    var att, sustain, amplitude, mix, env, envGen, resonance, verb;
    att = dur*0.2;
    sustain = dur;
    amplitude = amp;
    mix = bnq[0] + bnq[1] + bnq[2] + bnq[3] * 0.01;
    env = Env.linen(att, sustain, dur, amplitude, \cub);
    envGen = EnvGen.kr(env, 1, doneAction: 2);
    resonance = Klank.ar(`[
        [(freq*0.001) * 521, (freq*0.001) * 732, (freq*0.001) * 934],  // freqs
		[0.7, 0.45, 0.25],// amps
		[0.8, 0.8, 0.8]   // ring times
		],
        mix);
        verb = FreeVerb.ar(resonance, 0.7, 1, 0.5, Line.kr(0, 0.6, 0.5, mul: 0.7));
    (LeakDC.ar(Out.ar(0,(verb*envGen)!2)));
}).add;
)


// score
(
~original = [0, 1, 2, 11, 10, 9, 5, 4, 3, 6, 7, 8];
~retrograde = ~original.reverse;
~inversion = 12-~original;
~retroInversion = ~inversion.reverse;
~rows = [~original, ~retrograde, ~inversion, ~retroInversion];
r = [5.2, 5.25, 7.0, 5.333, 5.3, 6.666, 5.75];
o = [48, 60, 72];
~scale = Scale.choose(12, 12).tuning_(Tuning.choose(12)).postln;
~dynamics = [
        Pseries(0.1, 0.1, 5), // cresc
        Pseries(0.6, -0.1, 6), // decresc
        Prand([0.1, 0.3, 0.5, 0.6], 5)
    ];

~bass = Pbind(
    TempoClock.default.tempo = 0.5.rand;
    \instrument, \sins,
    \scale, ~scale,
    \degree, Pseq(~rows.choose + [-18, -12].choose.postln, 1),
   // \type, Pwrand([\note, \rest], [0.9, 0.1], inf),
    \dur, Pseq(r.scramble, inf),
    \amp, Prand(~dynamics, inf)
);

~mid1 = Pbind(
    TempoClock.default.tempo = 0.5.rand;
    \instrument, \sins,
    \scale, ~scale,
    \degree, Pseq(~rows.choose + [-6, -3, 0, 3].choose.postln, 1),
    \type, Pwrand([\note, \rest], [0.9, 0.1], inf),
    \dur, Pseq(r.scramble, inf),
    \amp, Prand(~dynamics, inf)
);

~mid2 = Pbind(
    TempoClock.default.tempo = 0.5.rand;
    \instrument, \sins,
    \scale, ~scale,
    \degree, Pseq(~rows.choose + [0, 3, 6].choose.postln, 1),
    //\type, Pwrand([\note, \rest], [0.9, 0.1], inf),
    \dur, Pseq(r.scramble, inf),
    \amp, Prand(~dynamics, inf)
);

~hi = Pbind(
    TempoClock.default.tempo = 0.5.rand;
    \instrument, \sins,
    \scale, ~scale,
    \degree, Pseq(~rows.choose + [6, 10, 12].choose.postln, 1),
    \type, Pwrand([\note, \rest], [0.8, 0.2], inf),
    \dur, Pseq(r.scramble, inf),
    \amp, Prand(~dynamics, inf)
);

~t1 = Ppar([~bass, ~mid1, ~mid2, ~hi]);
~t2 = Ppar([~mid2, ~hi, ~mid1]);
~t3 = Ppar([~bass, ~mid1, ~mid2, ~hi]);

Ppar([
    Pseq([~t1, ~t1, ~t3]),
    Pseq([~t3, ~t2, ~t1]),
    Pseq([~t1,~t3, ~t2]),
    Pseq([~t2, ~t2, ~t3]),
    Pseq([~t1, ~t1, ~t2]),
    Pseq([~t2, ~t1, ~t1]),
    Pseq([~t1, ~t2, ~t2]),
    Pseq([~t2, ~t2, ~t3])
]).play;
)
0.7.rand
// unused
(
Pbind(
    TempoClock.default.tempo = 0.5;
    \instrument, \sins,
    \scale, ~scale,
    \degree, Pseq(a + [-12, -6, -3, 0, 3, 6, 12].choose.postln, 1),
    \dur, Pseq(r, inf),
    \amp, Prand([
        Pseries(0.1, 0.1, 5), // cresc
        Pseries(0.75, -0.1, 6), // decresc
        Prand([0.1, 0.3, 0.5, 0.7], 5)
    ], inf)
).play;
)

'tm-2015-09-15T02:19:24.w64' - young

Ardour:
mark1 - mean4
mark2 - unused
mark3 - pythogorean - unused
mark4 - pythagorean
makr6 - kirnberger - unused
mark7- young
