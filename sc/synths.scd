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
    | freq = 400, att = 0.2, amp = 0.7, release = 0.1|
    var bnq = Array.with(
        1-SinOsc.ar(freq),
        1-SinOsc.ar(freq * 1.0533610359546 *(SinOsc.kr(0.01)+ 1)),
        1-SinOsc.ar(freq * 1.2541124095491 * (SinOsc.kr(0.01) + 1)),
        1-SinOsc.ar(freq* 1.8768759933376 *(SinOsc.kr(0.01)-1), mul: 0.5);
    );
    var mix = bnq[0] * bnq[1] * bnq[2] * bnq[3] * 0.02;
    var verb = (LeakDC.ar(FreeVerb.ar(mix, 0.7, 1, 0.5, Line.kr(0, 0.75, 15))));
    var env = Env.adsr(att, release, amp);
    var envGen = EnvGen.kr(env, 1, doneAction: 2);
    var resonance = CombC.ar(verb, 0.01, 0.01, 0.2);
    Out.ar(0,(resonance*envGen)!2);
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
