Server.supernova;
o = Server.local.options;
o.numOutputBusChannels = 2;
//o.memSize = 2**20;
o.blockSize = 128;
s.reboot;
s.makeGui;
s.meter;

(
SynthDef.new(\pluck, {  | t_trig=1, c1 = 1, c3=20, fb = 2, note = #[60, 1, 0.5]  |   // note: pitch force incidence
	var env,inp,son;
	var freq = note[0].midicps;
	var amp = note[1];
	var pos = note[2] * 0.5; // unitVal * positionRange
	var hfqLoss= c3 + (1-amp)*c3*2;  // add more dampening when amplitude gets low
	var idecay = c1 +  (1-amp)*c1;  //  reduce decay when amplitude gets low


	//SendTrig.kr(Impulse.kr(1), 0, amp);
	env = Env.perc(0.005,0.01,1,0);
    inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,t_trig, doneAction: 2);

	// note:  "gate" arg fixed to constant of 1, to keep plugin alive, "relase" arg not used:
    son = DWGPluckedStiff.ar(freq, 10, 1 ,pos,idecay,hfqLoss,inp, 1 , fb);
    Out.ar([0,1], son);
	//son;   // make sure this is last, so the sound is returned
}).add;
)

(
a = Scale.new(
    #[0, 1, 3, 5, 7, 8, 10],
    12,
    Tuning.new([0, 0.75, 2, 3.5, 4, 5, 6, 7, 8, 9, 10, 11]),
    "Custom"
);

c = Synth(\pluck);
c.set(\note, [60, 0.2, 0.1], \t_trig, 1);


Pbind(
    \instrument, \pluck,
    \scale ,a,
    \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
    \trig, 1,
    //\pan , Pwhite(-1,1),
).play;

)


SynthDef(\harpsi, { |outbus = 0, freq = 440, amp = 0.1, gate = 1|
    var out;
    out = EnvGen.ar(Env.adsr, gate, doneAction: 2) * amp *
        Pulse.ar(freq, 0.25, 0.75);
    Out.ar(outbus, out ! 2);
}).add;    // see below for more on .add

p = Pbind(
    \instrument, \harpsi,
    \degree, Pseq([], inf),
    \dur, 0.125
).asStream;

p.next(())


