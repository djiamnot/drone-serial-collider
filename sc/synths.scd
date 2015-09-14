{LFTri.ar((SinOsc.kr(0.002)+1)*750)}.plot

{SinOsc.ar(100)}.plot
{C}.plot
(
{ var bnq = Array.with(
    SinOsc.ar(100),
    SinOsc.ar(100),
    SinOsc.ar(100),
    SinOsc.ar(100)
    );
    var mix = bnq[0] * bnq[1] * bnq[2] * bnq[3] * 0.1;
    mix;
}.plot;
)

(
{ var bnq = Array.with(
    1-SinOsc.ar(100),
    1-SinOsc.ar(120),
    1-SinOsc.ar(130),
    1-SinOsc.ar(200)
    );
    var mix = bnq[0] * bnq[1] * bnq[2] * bnq[3] * 0.05;
    mix;
}.plot;
)

(
SynthDef(\sins, {
    | freq = 200, dur = 22, amp = 0.75|
    var bnq = Array.with(
        1-SinOsc.ar(freq),
        1-SinOsc.ar((freq * 4) * 1.0533610359546 * (SinOsc.kr(0.01, mul: 0.01)+ 1), mul: 0.6),
        1-SinOsc.ar((freq * 5)  * 1.2541124095491 * (SinOsc.kr(0.01, mul:  0.01) + 1), mul: 0.5),
        1-SinOsc.ar((freq * 6) * 1.8768759933376 *(SinOsc.kr(0.01)-1), mul: 0.01);
    );
    var att, sustain, amplitude, mix, env, envGen, resonance, verb;
    att = dur*0.2;
    sustain = dur;
    amplitude = amp;
    mix = bnq[0] * bnq[1] * bnq[2] * bnq[3] * 0.02;
    env = Env.linen(att, sustain, dur, amplitude, \cub);
    envGen = EnvGen.kr(env, 1, doneAction: 2);
    resonance = Klank.ar(`[
        [(freq*0.001) * 521, (freq*0.001) * 732, (freq*0.001) * 934],  // freqs
		[0.7, 0.45, 0.25],// amps
		[0.8, 0.8, 0.8]   // ring times
		],
        mix);
        verb = (LeakDC.ar(FreeVerb.ar(resonance, 0.7, 1, 0.5, Line.kr(0, 0.75, 0.5))));
    Out.ar(0,(verb*envGen)!2);
}).play;
)

(
SynthDef(\sins2, {
    | freq = 400, att=0.2, systain=1, amp=0.7, dur=0.1|
    var mix = SinOsc.ar(freq);
    var verb = (LeakDC.ar(FreeVerb.ar(mix, 0.7, 1, 0.5, Line.kr(0, 0.75, 0.1))));
    var env = Env.linen(att, 0.3, dur, amp);
    var envGen = EnvGen.kr(env, 1, doneAction: 2);
    Out.ar(0, (mix * envGen)!2);
}).play;
)
(

SynthDef(\metal, {
    var son;
	son = Klank.ar(`[
		[521, 732, 934],  // freqs
		[0.7, 0.45, 0.25],// amps
		[0.8, 0.8, 0.8]   // ring times
		]
	, Impulse.ar(1));
	Out.ar(0, Pan2.ar(son * 0.2));
}).add;
)

(
Klang
)


(
SynthDef(\sins, {
    | freq = 400|
    var bnq = Array.with(
        1-SinOsc.ar(freq),
        1-SinOsc.ar(freq * 1.0533610359546 *(SinOsc.kr(0.01)+ 1)),
        1-SinOsc.ar(freq * 1.2541124095491 * (SinOsc.kr(0.01) + 1)),
        1-SinOsc.ar(freq* 1.8768759933376 *(SinOsc.kr(0.01)-1), mul: 0.5);
    );
    var mix = bnq[0] * bnq[1] * bnq[2] * bnq[3] * 0.02;
    var verb = (LeakDC.ar(FreeVerb.ar(mix, 0.7, 1, 0.5, Line.kr(0, 0.75, 15))));
    Out.ar(0,verb!2);
}).add;
)

Klank

(
SynthDef(\sins, {
    | freq = 400|
    var bnq = Array.fill(3, |n| 1-SinOsc.ar(freq * (n + 7)));
        1-SinOsc.ar(freq),
        1-SinOsc.ar(freq * 1.0533610359546 *(SinOsc.kr(0.01, mul: 0.1)+ 1)),
        1-SinOsc.ar(freq * 1.2541124095491 * (SinOsc.kr(0.01, mul: 0.1) + 1)),
        1-SinOsc.ar(freq* 1.8768759933376 *(SinOsc.kr(0.01)-1), mul: 0.01);
    );
    var mix = bnq[0] * bnq[1] * bnq[2] * bnq[3] * 0.02;
    var verb = (LeakDC.ar(FreeVerb.ar(mix, 0.7, 1, 0.5, Line.kr(0, 0.75, 15))));
    Out.ar(0,verb!2);
}).add;
)

(
SynthDef(\tris, {
var tri = Array.with(
		LFTri.ar((SinOsc.kr(0.001)+1)*1000),
		1-LFTri.ar((SinOsc.kr(0.002)+1)*750),
		1-LFTri.ar(100),
		1-LFTri.ar(55.1),
	);
	var triScale = 0.05;
	var triMix = tri[0] * tri[1] * tri[2] * tri[3] * triScale;
	var verb = LeakDC.ar(FreeVerb.ar(triMix, 0.7, 1, 0.5, Line.kr(0, 0.75, 15)));
    Out.ar([0,1], verb);
}).add;
)

(
SynthDef(\mall,{arg out=0,note, amp = 1;
    var sig=Array.fill(3,{|n| SinOsc.ar(note*(n+1),0,0.3)}).sum;
    var env=EnvGen.kr(Env.perc(0.01,1.2), doneAction:2);
    Out.ar(out, sig*env*amp!2);
}).add;
)

a = Synth(\sins, [freq: 538]);
b = Synth(\tris, [freq: 538]);
m = Synth(\mall, [\note: 238]);
