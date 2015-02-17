// Quneo.ck
// Dexter Shepherd and Eric Heep
// CalArts Music Tech // MTIID4LIFE
// class for communicating with ChucK and a Quneo

// configured for Quneo configuration mode 4
// press the small circle in the top left and 
// select the fourth pad to activate mode 4

public class Quneo { 

    // sliders  ---------------------------------
    8 => int num_sliders;

    // arrays for sliders
    int slider_x[num_sliders];
    int slider_z[num_sliders];
  
    // array for slider x-axis 
    [ 0,  1,  2,  3,  6,  7,  8,  9] @=> int slider_loc_x[];
    // array for slider z-axis
    [12, 13, 14, 15, 18, 19, 20, 21] @=> int slider_loc_z[];

    // circles ----------------------------------
    2 => int num_circles;

    // array for circles
    int circle_r[num_circles];
    int circle_z[num_circles];

    // array for circle r-axis
    [ 4,  5] @=> int circle_loc_r[];
    // array for circle z-axis 
    [16, 17] @=> int circle_loc_z[];

    // pads -------------------------------------
    16 => int num_pads;

    // arrays for pads
    int pad_v[num_pads];
    int pad_z[num_pads];
    int pad_x[num_pads];
    int pad_y[num_pads];

    // array for pad velocity
    [ 0,  1,  2,  3,  4,  5,  6,  7,
      8,  9, 10, 11, 12, 13, 14, 15] @=> int pad_loc_v[];
    // array for pad z-axis
    [23, 26, 29, 32, 35, 38, 41, 44,
     47, 50, 53, 56, 59, 62, 65, 68] @=> int pad_loc_z[];
    // array for pad x-axis
    [24, 27, 30, 33, 36, 39, 42, 45,
     48, 51, 54, 57, 60, 63, 66, 69] @=> int pad_loc_x[];
    // array for pad y-axis
    [25, 28, 31, 34, 37, 40, 43, 46,
     49, 52, 55, 58, 61, 64, 67, 70] @=> int pad_loc_y[];

    // arrows -----------------------------------
    12 => int num_arrows;

    // arrays for arrows 
    int arrow_v[num_arrows];
    int arrow_z[num_arrows];

    // array for arrow velocity
    [11, 12, 13, 14, 15, 16, 
     17, 18, 20, 21, 22, 23] @=> int arrow_loc_v[];
    // array for arrow z-axis
    [71, 72, 73, 74, 75, 76, 
     77, 78, 80, 81, 82, 83] @=> int arrow_loc_z[];
    
    // misc -------------------------------------
    int diamond_v, diamond_z;
    24 => int diamond_loc_v;
    84 => int diamond_loc_z;

    int stop_v, stop_z;
    25 => int stop_loc_v;
    85 => int stop_loc_z;

    int play_v, play_z;
    26 => int play_loc_v;
    86 => int play_loc_z;

    // midi setup -------------------------------
    int port;
    MidiIn in[10];
    MidiOut out[10];
    MidiMsg msgIn;
    MidiMsg msgOut;
    
    for (int i; i < in.cap(); i++) {
        // no print err
        in[i].printerr(0);
        
        // open the device
        if (in[i].open(i)) {
            if (in[i].name() == "QUNEO") {
                i => port;
                <<< "Connected to", in[port].name(), "" >>>;
                out[i].open(i);
            }
        }
        else break;
    } 
    
    spork ~ update();

    // input ------------------------------------
    fun void update() {
        while (true) {
            // waits on midi events
            in[port] => now;
            while (in[port].recv(msgIn)) {
                storeValues(msgIn.data1, msgIn.data2, msgIn.data3);
            }
        }
    }
    
    // convert values
    fun void storeValues(int data1, int data2, int data3) {
        // 128 and 144, trigger/velocity based
        if((data1 == 128 || data1 == 144)) {
            for (int i; i < num_pads; i++) {
                if (data2 == pad_loc_v[i]) {
                    data3 => pad_v[i];
                }
            }
            for (int i; i < num_arrows; i++){
                if (data2 == arrow_loc_v[i]) {
                    data3 => arrow_v[i];
                }
            }
            if (data2 == diamond_loc_v) {
                data3 => diamond_v;
            }
            if (data2 == play_loc_v) { 
                data3 => play_v;
            }
            if (data2 == stop_loc_v) { 
                data3 => stop_v;
            }
        }
        // 176, x, y, and z axes where applicable
        if (data1 == 176) {
            for (int i; i < num_pads; i++) {
                if (data2 == pad_loc_x[i]) {
                    data3 => pad_x[i];
                }
                if (data2 == pad_loc_y[i]) {
                    data3 => pad_y[i];
                }
                if (data2 == pad_loc_z[i]) {
                    data3 => pad_z[i];
                }
            }
            for (int i; i < num_arrows; i++) {
                if (data2 == arrow_loc_z[i]) {
                    data3 => arrow_z[i];
                }
            }
            for (int i; i < num_circles; i++) {
                if (data2 == circle_loc_r[i]) {
                    data3 => circle_r[i];
                }
                if (data2 == circle_loc_z[i]) {
                    data3 => circle_z[i];
                }
            }
            for (int i; i < num_sliders; i++) {
                if (data2 == slider_loc_x[i]) {
                    data3 => slider_x[i];
                }
                if (data2 == slider_loc_z[i]) {
                    data3 => slider_z[i];
                }
            }
            if (data2 == diamond_loc_z) {
                data3 => diamond_z;
            }
            if (data2 == stop_loc_z) {
                data3 => stop_z;
            }
            if (data2 == play_loc_z) {
                data3 => play_z;
            }
        }
    }

    // circle
    fun int circle(int idx) {
        return circle_r[idx];
    }

    fun int circle(int idx, string mode) {
        if (mode == "r") {
            return circle_r[idx];
        }
        if (mode == "z") {
            return circle_z[idx];
        }
    }
    
    // arrow
    fun int arrow(int idx) {
        return arrow_v[idx];
    }

    fun int arrow(int idx, string mode) {
        if (mode == "v") {
            return arrow_v[idx];
        }
        if (mode == "z") {
            return arrow_z[idx];
        }
    }

    // pad
    fun int pad(int idx) {
        return pad_v[idx];
    }
    
    fun int pad(int idx, string mode) {
        if (mode == "v") {
            return pad_v[idx];
        }
        if (mode == "x") {
            return pad_x[idx];
        }
        if (mode == "y") {
            return pad_y[idx];
        }
        if (mode == "z") {
            return pad_z[idx];
        }
    }

    // slider
    fun int slider(int idx) {
        return slider_x[idx];
    }

    fun int slider(int idx, string mode) {
        if (mode == "x") {
            return slider_x[idx];
        }
        if (mode == "z") {
            return slider_z[idx];
        }
    }        

    // diamond
    fun int diamond() {
        return diamond_v;
    }

    fun int diamond(string mode) {
        if (mode == "v") {
            return diamond_v;
        }
        if (mode == "z") {
            return diamond_z;
        }
    }

    // stop
    fun int stop() {
        return stop_v;
    }

    fun int stop(string mode) {
        if (mode == "v") {
            return stop_v;
        }
        if (mode == "z") {
            return stop_z;
        }
    }
   
    // play
    fun int play() {
        return play_v;
    }

    fun int play(string mode) {
        if (mode == "v") {
            return play_v;
        }
        if (mode == "z") {
            return play_z;
        }
    }

    // led out
    fun void led(int type, int num, int vel) {
        type => msgOut.data1;
        num => msgOut.data2;
        vel => msgOut.data3;
        out[port].send(msgOut);
    }
}

Quneo q;

while (true) {
    <<< q.diamond("z") >>>;
    100::ms => now;
}